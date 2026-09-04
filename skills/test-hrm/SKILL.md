---
name: test-hrm
description: Använd när du ska starta HRM från en feature-workspace, verifiera en feature i browsern, eller köra HRM:s tester. Gäller Flex.Net.Web, Nova.Api och NovaFrontend.
---

Hectors egen instans kör från `main/` på standardportarna (Flex.Net.Web
56866, Nova.Api 7293, NovaFrontend 5173). Rör den inte och anta inte att den
kör din feature. Allt du startar startar du själv, från feature-workspacen, på
egna portar, och stoppar när du är klar.

## Kör testerna

Kör aldrig hela sviten. Kör alltid de här två (samma som Hectors
`Flex.Net/run_hectors_tests.sh`), plus de testprojekt som PR:en rör.

```
export DOTNET_ROOT=$HOME/.dotnet PATH=$HOME/.dotnet:$PATH
cd Flex.Net
dotnet test FlexHrm.AiModule.Tests --property:WarningLevel=0
dotnet test Flex.Net.UnitTests --property:WarningLevel=0 --filter \
  "FullyQualifiedName=Flex.Net.UnitTests.Common.Utf8BomTests.Alla_filer_har_utf8_bom | FullyQualifiedName=Flex.Net.UnitTests.Common.ThemeLessTests.Alla_färger_ska_definieras_i_Color_less_och_sättas_i_Theme_less"
```

Relevanta testprojekt hittar du på modulnamnet: rör PR:en `FlexHrm.<Modul>`
kör du `Flex.Net/FlexHrm.<Modul>.Tests`. Rör den Nova.Api kör du
`FlexHrm.Nova.Api.Tests`. `Flex.Net.UnitTests` och `Flex.Net.IntegrationTests`
är stora, kör dem bara med `--filter` på de klasser du ändrat i. Rör aldrig
`Flex.Net.EndToEndTests`. Hoppa över sidomenytesterna.

Frontend-tester finns i `NovaFrontend` och `Flex.Net/Flex.Net.Web`, kolla
`scripts` i respektive `package.json`. Kör med Linux-node först i PATH
(`PATH=$HOME/.nvm/versions/node/v22.16.0/bin:$PATH`), `npm` i PATH är
annars Windows-fnm.

## Starta HRM från WSL

Alla i bakgrunden, logga till scratchpad. `ASPNETCORE_URLS` styr Kestrel och
vinner över `launchSettings.json`, så använd den i stället för
`--launch-profile`. Förslag: Web 56876/56877, Nova.Api 7393, Vite 5273. Är
någon upptagen (`ss -ltnp`), ta nästa tiotal.

```
export DOTNET_ROOT=$HOME/.dotnet PATH=$HOME/.dotnet:$PATH ASPNETCORE_ENVIRONMENT=Development
# Flex.Net.Web (https://localhost:56876)
cd Flex.Net/Flex.Net.Web && ASPNETCORE_URLS='https://localhost:56876;http://localhost:56877' \
  dotnet run --no-launch-profile \
  --property:AllowMissingPrunePackageData=true --property:NuGetAudit=false
# Nova.Api (https://localhost:7393). getdocument-steget failar från WSL, stäng av det.
cd Flex.Net/FlexHrm.Nova.Api && ASPNETCORE_URLS='https://localhost:7393' \
  dotnet run --no-launch-profile \
  --property:AllowMissingPrunePackageData=true --property:NuGetAudit=false \
  --property:OpenApiGenerateDocumentsOnBuild=false
# NovaFrontend (http://localhost:5273), proxar /nova/api till Nova.Api-porten ovan
cd NovaFrontend && VITE_NOVA_API_BASE=https://localhost:7393 \
  PATH=$HOME/.nvm/versions/node/v22.16.0/bin:$PATH npx vite --port 5273 --strictPort
```

Frontend-bundlen för Flex.Net.Web byggs separat med `npm run build` i
`Flex.Net.Web`, med Linux-node först i PATH. `dotnet run` bygger den inte.
Har du ändrat något i chatbotens frontend, eller annan TypeScript/CSS i
Flex.Net.Web, måste du köra `npm run build` innan du testar, annars testar
du den gamla bundlen och ser inte din ändring. Vänta på porten med en
`until curl ...; do sleep 2; done` i bakgrunden.

Forms-login funkar på vilken port som helst. OIDC-redirect och
Skatteverket-inloggning gör det inte (redirect-URI:n är registrerad på
56866), så de kan inte testas från en egen instans.

Stoppa det du startat när du är klar.

## Inloggning

Flex.Net.Web har forms-login på roten när OIDC är av. Fälten heter
`Kundinstans`, `Anvandarnamn`, `Losenord`, knappen är `#LoginButton`.
Logga in som `DEMO.CEO` med tomt lösenord. Är `Kundinstans` tom och krävs,
använd `FLEX1`. Redirecten till Home sker via JS efter att login-sidan
svarat, så `networkidle` räcker inte, vänta på att url:en lämnar `/Login`.

Nova (NovaFrontend) behöver ingen inloggning lokalt. Nova.Api kör med
`debug-auth.json` (symlinkad av `setup_worktree`) och identifierar alla
requests som DEMO.CEO.

Två overlays blockerar klick i en ny browser-context. Web: chatbotens
intro.js-tour ("Vad undrar du över?"). Nova: cookie-bannern `#CookieBanner`.
Klicka bort dem eller göm dem med CSS innan du börjar.

## Verifiera i browsern

Navigera med `browser_navigate`, läs sidan med `browser_snapshot`, klicka med
`browser_click`. Gör det med ögonen öppna: att ett anrop inte kastade betyder
inte att featuren funkar. Ta en skärmdump av slutläget och läs den.

MCP:n läser bara filer under katalogen sessionen startade i (i HRM: den
feature-workspace du står i) och dess `.playwright-mcp/`. Lägg skärmdumpar
under `<workspace>/.playwright-mcp/<slug>/`. I HRM är `.playwright-mcp/`
exkluderad via `master/.git/info/exclude`, så inget hamnar i @ av misstag.

Funkar inte featuren, rapportera det med skärmdumpen. Gå inte vidare till
story eller PR på trasig kod.

## Chatboten (Flexie)

Gäller båda klienterna, web-widgeten och Flexie-panelen i Nova.

- Fråga riktig backend, inte msw-mocken. `npm run dev:mock` ger slumpdata från
  OpenAPI-specen och kan inte strömma ett svar.
- Boten är en riktig modell, så be om exakt det svar du behöver:
  `Svara bara med exakt den här raden: Läs mer i [knowledge base](https://www.google.com/search?q=flexhrm)`
  har gett rätt svar varje gång.
- Kontrollera att meddelandet faktiskt gick iväg innan du väntar på svaret.
  Web: `#chatbotMessages .user-message` finns. Nova: användarbubblan syns.
  Skicka-knappen kan vara disabled tills SignalR/SSE är uppe i en ny context,
  så klicka igen efter en sekund om inget hände. Utan den kollen väntar du
  90 s på ett svar som aldrig kommer.
- Svaret tar 3 till 10 s. `waitFor` på det element du behöver med
  `timeout: 90000`, sen 1 s paus så strömningen hinner klart.
- Web-selektorer: `#chatbotToggle`, `#chatbotInput`, `#chatbotSendBtn`,
  `#chatbotMessages .bot-message`. Nova: knappen `AI-assistent`, textrutan
  `Meddelandefält`, knappen `Skicka meddelande`.
- Flikar som "Öppna länk" öppnar ligger kvar i MCP:ns browser. Stäng dem.

## Smoke test: "testa att chatboten fortfarande funkar"

Här är några förslag på vad du kan göra om du "bara ska testa så att chatboten funkar".
Det är främst när ändringen är något som inte borde synas men i teorin skulle kunna sabba chatboten.

- Be den registrera sjukfrånvaro åt dig hela nästa vecka och se till att du får upp rätt bekträftelsedialog och att den går att acceptera.
- Ställ en fråga till den, typ "Hur reggar man frånvaro" och se till så att den korrekt söker i dokumentationen.
- Om pr:et rör nåt annat så ska du såklart testa att det funkar istället/också.

Gör det alltid i web, du kan skippa nova eftersom den inte är i prod än (om du inte specifikt också ändrade i Nova, testa i så fall den också)

Ska det in i ett PR spelas det in med `record-demo`, klipp så att acceptansen
och botens kvittens är med i slutet.

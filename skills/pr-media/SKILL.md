---
name: pr-media
description: Använd när användaren vill ha en demovideo, gif eller skärmdumpar av en feature till ett PR, eller när create-pr hittar UI-ändringar i diffen.
---

Spela in en kort demo av featuren med Playwright-MCP:n, gör en gif, pusha den
till orphan-branchen `pr-media` och länka den i PR-beskrivningen.

Gif, inte mp4. GitHub kan bara bädda in video som laddats upp via webben, och
det går inte från CLI. En gif i samma privata repo renderas för alla med
access till repot och autospelar i PR-flödet.

## Var filer får ligga

MCP:n läser bara filer under katalogen sessionen startade i (i HRM: den
feature-workspace du står i) och dess `.playwright-mcp/`. Lägg allt per
feature i

```
<workspace>/.playwright-mcp/pr-media/<slug>/
├── record.js     inspelningsscriptet
├── *.webm        råvideo från Playwright
├── demo.gif
└── *.png         skärmdumpar och verifieringsframes
```

I HRM är `.playwright-mcp/` exkluderad via `master/.git/info/exclude`, så
inget hamnar i @ av misstag. Filer utanför workspacen (t.ex.
`~/work/HRM/.playwright-mcp`) kan MCP:n inte läsa.

## Flöde

1. **Starta en egen instans av appen.** Standardportarna (Flex.Net.Web
   56866, Nova.Api 7293, NovaFrontend 5173) tillhör Hectors egen körning från
   `main/`. Rör den inte och anta inte att den kör din feature. Starta i
   stället från feature-workspacen på egna portar enligt "Starta HRM från WSL"
   nedan, och sätt `BASE_URL` i `record.js` till din port. Kolla med
   `ss -ltnp` att porten du väljer är ledig innan du startar.

2. **Utforska först, spela in sen.** Navigera med `browser_navigate` och
   `browser_snapshot` i MCP:ns vanliga sida tills du vet exakt vilka steg och
   selektorer som visar featuren. Utforskandet ska inte vara med i videon.
   Gör utforskningen i samma slags context som inspelningen (egen context,
   samma login-väg), annars upptäcker du context-beroende fel först i tagning
   tre.

3. **Skriv `record.js`** från `scripts/record.template.js`. Fyll i `OUT`,
   `BASE_URL`, `NEEDS_LOGIN` och stegen i `demo()`. Kör med
   `browser_run_code_unsafe` och `filename` satt till scriptets absoluta sökväg.
   Scriptet skapar en egen browser-context med `recordVideo`. Login sker i
   samma context (se varför under "Inloggning") och scriptet returnerar
   `demoStartSec`, tiden när `demo()` började. Den klipps bort i steg 5.

4. **Verifiera med ögonen.** Scriptet returnerar sökvägen till webm:en. Gör en
   kontaktkarta över de sista tio sekunderna och läs bilden:
   `ffmpeg -y -v error -sseof -10 -i <webm> -vf "fps=1,scale=640:-1,tile=5x2" -frames:v 1 sheet.png`.
   Då ser du hela slutsekvensen i en bild, inte en slumpad frame. Svart ruta,
   fel sida, kvarstående laddningssnurra eller en dialog som aldrig dyker upp
   betyder gör om. Lita inte på att inspelningen lyckades bara för att koden
   inte kastade. Misslyckas scriptet: plocka sista framen
   (`ffmpeg -sseof -1 -i <webm> -frames:v 1 last.png`) innan du gissar varför.

5. **Gif:** `scripts/to-gif.sh <webm> demo.gif <demoStartSec>`.
   Startargumentet klipper bort login och dödtid i början. Sikta på under 3 MB.

6. **Publicera:** `scripts/publish.sh <slug> demo.gif [fler filer]`.
   Pushar till `pr-media`, städar bort allt äldre än 7 dagar, och skriver ut
   färdiga markdown-rader på stdout. Branchen skrivs om till en enda commit
   varje gång, så repot växer inte av gamla klipp. Slug-mappen ersätts helt:
   publicerar du om en fil måste alla filer som ska finnas kvar med i samma
   anrop.

7. **Länka i PR:en.** Lägg raderna under en `## Demo`-rubrik i beskrivningen,
   med en mening om vad man ser. `gh pr edit <nr> --body-file ...` från
   `~/work/HRM/master` med `GH_TOKEN=$(gh auth token --user HectorVisma)`.

## Inloggning i HRM

Flex.Net.Web har forms-login på roten när OIDC är av. Fälten heter
`Kundinstans`, `Anvandarnamn`, `Losenord`, knappen är `#LoginButton`.
Logga in som `DEMO.CEO` med tomt lösenord. Är `Kundinstans` tom och krävs,
använd `FLEX1`. Mallen gör det här när `NEEDS_LOGIN` är sant.

Två saker mallen redan hanterar, rör dem inte:

- Redirecten till Home sker via JS efter att login-sidan svarat, så
  `networkidle` räcker inte. Mallen väntar på att url:en lämnar `/Login`.
- Login sker i den inspelade contexten, inte i en separat context med
  `storageState`. Cookies följer med via storageState men SignalR-strömmen
  (chatbotens svar) nådde aldrig fram i en sådan context. Dödtiden klipps
  med `demoStartSec` i stället.

Nova (NovaFrontend) behöver ingen inloggning lokalt. Nova.Api kör med
`debug-auth.json` (symlinkad av `setup_worktree`) och identifierar alla
requests som DEMO.CEO. Cookie-bannern (`#CookieBanner`) överlever inte
storageState, mallen gömmer den med CSS.

## Testa chatboten (Flexie)

Gäller båda klienterna, web-widgeten och Flexie-panelen i Nova.

- Fråga riktig backend, inte msw-mocken. `npm run dev:mock` ger slumpdata från
  OpenAPI-specen och kan inte strömma ett svar.
- Boten är en riktig modell, så be om exakt det svar klippet behöver:
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
- Flikar som "Öppna länk" öppnar ligger kvar i MCP:ns browser. Mallen stänger
  dem i `finally`.

## Smoke test: "testa att chatboten fortfarande funkar"

Ber användaren bara om det, utan att peka på en specifik feature, är klippet
alltid samma. Kör web-widgeten i Flex.Net.Web, inte Nova. Be Flexie skapa en
sjukfrånvaroansökan för hela nästa vecka, vänta in förslaget och acceptera
det i videon. Det övar hela kedjan: strömmat svar, verktygsanrop, och
bekräftelse tillbaka till boten. Skriv prompten på svenska, ungefär
"Skapa en sjukfrånvaroansökan för hela nästa vecka", och klipp så att
acceptansen och botens kvittens är med i slutet.

## Starta HRM från WSL

Kör Hector inget och du behöver apparna, så här startar de från en
feature-workspace. Alla i bakgrunden, logga till scratchpad.

Kör alltid på andra portar än standard, så att inspelningen inte krockar med
en instans Hector redan har igång. `ASPNETCORE_URLS` styr Kestrel och vinner
över `launchSettings.json`, så använd den i stället för `--launch-profile`.
Förslag: Web 56876/56877, Nova.Api 7393, Vite 5273. Är någon upptagen
(`ss -ltnp`), ta nästa tiotal.

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

Forms-login funkar på vilken port som helst. OIDC-redirect och
Skatteverket-inloggning gör det inte (redirect-URI:n är registrerad på
56866), så de kan inte demas från en egen instans. Cookies är inget problem,
inspelningen kör i en egen browser-context.

Frontend-bundlen för Flex.Net.Web byggs separat med `npm run build` i
`Flex.Net.Web`, med Linux-node först i PATH (`npm` i PATH är Windows-fnm).
Vänta på porten med en `until curl ...; do sleep 2; done` i bakgrunden.
Stoppa det du startat när du är klar.

## Bra klipp

- 5 till 20 sekunder. Visa en sak. Två features är två klipp.
- 1280x720. Mallen sätter både viewport och videostorlek.
- `pressSequentially` med 25-60 ms delay när text skrivs, annars ser
  tittaren bara att fältet plötsligt är fyllt. Kortare delay för långa prompter.
- 500-1000 ms paus efter varje handling så resultatet hinner synas.
- Avsluta med 1-2 sekunder stilla på slutläget.
- Skärmdumpar av enskilda komponenter med `locator.screenshot()` när en
  stillbild säger mer än rörelse, till exempel en ny kolumn i en tabell.

## Sandboxen

`run_code_unsafe` kör i MCP-processen utan `process`, `require` eller
relativa sökvägar. Allt måste vara absoluta sökvägar. `page.context().browser()`
finns och används för att skapa nya contexts. Videon skrivs klart först vid
`ctx.close()`, glöm inte den.

## Länkarna dör efter 7 dagar

Städningen tar bort mappar daterade äldre än 7 dagar. Ligger PR:en öppen
längre än så, kör steg 6 igen så flyttas klippet fram.

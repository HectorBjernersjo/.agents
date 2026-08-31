---
name: record-demo
description: Använd när du ska spela in en kort demovideo eller ta skärmdumpar av en feature i HRM med Playwright-MCP:n och göra en gif. Publiceringen till PR:et gör pr-media.
---

Spela in en kort demo av featuren med Playwright-MCP:n och gör en gif av den.
Appen ska redan köra från din feature-workspace på egna portar, se
`test-hrm` för hur du startar den och loggar in.

## Var filer får ligga

MCP:n läser bara filer under katalogen sessionen startade i och dess
`.playwright-mcp/`. Lägg allt per feature i

```
<workspace>/.playwright-mcp/pr-media/<slug>/
├── record.js     inspelningsscriptet
├── *.webm        råvideo från Playwright
├── demo.gif
└── *.png         skärmdumpar och verifieringsframes
```

Filer utanför workspacen (t.ex. `~/work/HRM/.playwright-mcp`) kan MCP:n
inte läsa.

## Flöde

1. **Utforska först, spela in sen.** Navigera med `browser_navigate` och
   `browser_snapshot` i MCP:ns vanliga sida tills du vet exakt vilka steg och
   selektorer som visar featuren. Utforskandet ska inte vara med i videon.
   Gör utforskningen i samma slags context som inspelningen (egen context,
   samma login-väg), annars upptäcker du context-beroende fel först i tagning
   tre.

2. **Skriv `record.js`** från `scripts/record.template.js`. Fyll i `OUT`,
   `BASE_URL` (din port, inte Hectors), `NEEDS_LOGIN` och stegen i `demo()`.
   Kör med `browser_run_code_unsafe` och `filename` satt till scriptets
   absoluta sökväg. Scriptet skapar en egen browser-context med
   `recordVideo`, loggar in i samma context och returnerar `demoStartSec`,
   tiden när `demo()` började. Den klipps bort i steg 4.

3. **Verifiera med ögonen.** Scriptet returnerar sökvägen till webm:en. Gör en
   kontaktkarta över de sista tio sekunderna och läs bilden:
   `ffmpeg -y -v error -sseof -10 -i <webm> -vf "fps=1,scale=640:-1,tile=5x2" -frames:v 1 sheet.png`.
   Då ser du hela slutsekvensen i en bild, inte en slumpad frame. Svart ruta,
   fel sida, kvarstående laddningssnurra eller en dialog som aldrig dyker upp
   betyder gör om. Lita inte på att inspelningen lyckades bara för att koden
   inte kastade. Misslyckas scriptet: plocka sista framen
   (`ffmpeg -sseof -1 -i <webm> -frames:v 1 last.png`) innan du gissar varför.

4. **Gif:** `scripts/to-gif.sh <webm> demo.gif <demoStartSec>`.
   Startargumentet klipper bort login och dödtid i början. Sikta på under 3 MB.

5. **Publicera** med `pr-media`.

## Två saker mallen redan hanterar, rör dem inte

- Redirecten till Home efter login sker via JS, så `networkidle` räcker
  inte. Mallen väntar på att url:en lämnar `/Login`.
- Login sker i den inspelade contexten, inte i en separat context med
  `storageState`. Cookies följer med via storageState men SignalR-strömmen
  (chatbotens svar) nådde aldrig fram i en sådan context. Dödtiden klipps
  med `demoStartSec` i stället.
- Mallen gömmer cookie-bannern i Nova och intro.js-overlayen i Web med CSS,
  båda överlever storageState och blockerar klick.
- Flikar som "Öppna länk" öppnar stängs i `finally`.

## Bra klipp

- 5 till 20 sekunder. Visa en sak. Två features är två klipp.
- 1280x720. Mallen sätter både viewport och videostorlek.
- `pressSequentially` med 25-60 ms delay när text skrivs, annars ser
  tittaren bara att fältet plötsligt är fyllt. Kortare delay för långa prompter.
- 500-1000 ms paus efter varje handling så resultatet hinner synas.
- Avsluta med 1-2 sekunder stilla på slutläget.
- Skärmdumpar av enskilda komponenter med `locator.screenshot()` när en
  stillbild säger mer än rörelse, till exempel en ny kolumn i en tabell.
- Chatboten: selektorer, väntetider och hur du får ett förutsägbart svar står
  i `test-hrm`.

## Sandboxen

`run_code_unsafe` kör i MCP-processen utan `process`, `require` eller
relativa sökvägar. Allt måste vara absoluta sökvägar. `page.context().browser()`
finns och används för att skapa nya contexts. Videon skrivs klart först vid
`ctx.close()`, glöm inte den.

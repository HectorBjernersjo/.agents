---
name: review-monster
description: Kör flera reviewer-subagenter parallellt för att reviewa aktuell PR och hanterar uppföljande svar på review-findings
disable-model-invocation: true
---

Använd den här filstrukturen för PR-reviews:

```text
docs/prs/
├── _review-index/
│   └── ignored-findings.jsonl
└── <branch-slug>/
    ├── review.html
    ├── review-data.js
    └── reviews/
        └── review-001/
            ├── architecture/
            │   └── report.md
            ├── bug/
            │   └── report.md
            ├── code-standard/
            │   └── report.md
            ├── naming/
            │   └── report.md
            ├── simplification/
            │   └── report.md
            ├── nitpick/
            │   └── report.md
            └── slop/
                └── report.md
```

`review-data.js` är sanningskällan för den aktuella PR-reviewen. `review.html` är en statisk vy som kopieras från den här skillens `template.html`.
`docs/prs/_review-index/ignored-findings.jsonl` är ett append-only historiskt sökindex över ignorerade findings från alla PR:er.

Filen `review-data.js` måste vara strikt JSON-kompatibel JavaScript:

```js
window.reviewData = {
  "review": {
    "title": "PR Review",
    "branchSlug": "<branch-slug>",
    "reviewId": "<review-id>",
    "generatedAt": "<iso-8601 timestamp>",
    "sourcePath": "docs/prs/<branch-slug>/review.html",
    "baseRef": "origin/master",
    "agents": [
      "bug-reviewer",
      "code-standard-reviewer",
      "naming-reviewer",
      "simplification-reviewer",
      "nitpick-reviewer",
      "slop-reviewer"
    ]
  },
  "findings": []
};
```

Ta bara med `"architecture-reviewer"` i `review.agents` när den faktiskt kördes.

Använd citerade objektnycklar, inga kommentarer och inga avslutande kommatecken inuti objektet, så att agenter kan parsa filen genom att strippa `window.reviewData =` och det avslutande semikolonet.

Rader i det historiska indexet över ignorerade findings måste vara ett JSON-objekt per rad:

```json
{"event":"ignored","ignoredBy":"human","pr":"<branch-slug>","findingId":3,"files":["src/foo.ts"],"fingerprint":"bug-reviewer:src/foo.ts:null-user-id","agents":["bug-reviewer"],"title":"...","problem":"...","ignoreReason":"...","ignoredAt":"2026-06-26T08:04:00Z"}
```

Använd `ignored-findings.jsonl` för att hitta kandidater bland tidigare ignorerade findings, och verifiera sedan att det nya findingen faktiskt handlar om samma sak innan du undertrycker det.

## Steg 1
Om det finns ocommittade ändringar (förutom i package.json och liknande filer som inte alls hör till den här PR:en), säg åt användaren att committa dem innan du fortsätter, så att `git diff origin/master...` fungerar som det ska.

## Steg 2
Ta fram `<branch-slug>` från aktuell git-branch genom att ignorera `users/<username>` (om det är en del av branch-namnet) och bara använda resten för att skapa en slug.

Om `docs/work/` har en mapp som matchar den sluggen, läs dess `spec.md` och den ticket som implementeras först, och skicka med deras sökvägar till reviewing-agenterna. Findings ska bedömas mot vad arbetet var tänkt att göra. `/land` tar bort den här PR:ens review-artefakter när arbetet mergats.
Hämta filerna i aktuell PR med `git diff --name-only origin/master...`.

Innan du startar reviewers, leta efter tidigare ignorerade findings som nämner någon av filerna i aktuell PR:

- Sök i första hand i `docs/prs/_review-index/ignored-findings.jsonl` efter exakta repo-relativa sökvägar från aktuell PR.
- Varje matchande JSONL-rad är en kandidat för tidigare ignorering.
- Eftersom indexet är append-only, använd senaste eventet för samma `pr`, `findingId` och `fingerprint` för att avgöra om en tidigare ignorering fortfarande gäller.
- När du senare sammanställer nya findings, undertryck ett finding bara när det tydligt handlar om samma sak som en tidigare ignorering: överlappande `files`, samma eller liknande `agents` eller kategori, och matchande `fingerprint` eller i stort sett matchande `title`/`problem`.

## Steg 3
Skapa nästa nollutfyllda review-mapp under `docs/prs/<branch-slug>/reviews/` (`review-001`, `review-002`, ...).
Varje reviewing-agent skriver sin egen kompletta rapport till `<agent-name>/report.md`.

## Steg 4
Reviewerna är inte egna agenttyper. Varje reviewer är en färdig prompt i den här skillens `reviewers/`-mapp, och du startar en `general-purpose`-subagent per reviewer med den prompten:

| reviewer | prompt |
|---|---|
| bug-reviewer | `reviewers/bug.md` |
| code-standard-reviewer | `reviewers/code-standard.md` |
| naming-reviewer | `reviewers/naming.md` |
| simplification-reviewer | `reviewers/simplification.md` |
| nitpick-reviewer | `reviewers/nitpick.md` |
| slop-reviewer | `reviewers/slop.md` |
| architecture-reviewer | `reviewers/architecture.md` (bara vid arkitekturtröskeln nedan) |
| footgun-reviewer | `reviewers/footgun.md` (startas inte som default) |

Subagentens prompt ska vara exakt:

```text
Läs `<absolut sökväg till skillen>/reviewers/<fil>` och följ den.
<branch-slug> = <värde>
<review-id> = <värde>
<architecture-steps-dir> = <absolut sökväg till skillen>/references/architecture-reviewer   (bara för architecture-reviewer)
go
```

Säg inget mer till subagenterna än det.
Spawna alla i samma anrop, inte en i taget. Och gör dem blockerande.

Avgör om PR:en är stor nog för `architecture-reviewer`. Hoppa över den som default.

Kör `architecture-reviewer` bara när PR:en tydligt har bred arkitekturell påverkan, till exempel:

- Den lägger till mer än 400 icke-genererade rader.
- Den gör betydande arkitekturella ändringar i befintliga kontrakt eller flöden.
- Den introducerar eller kopplar om ett någorlunda stort feature-flöde.

Små lokala fixar, ändringar som bara rör tester, omdöpningar, formatering, textändringar och avgränsade refactors ska inte köra `architecture-reviewer`.

## Steg 5
När alla reviewers är klara, sammanställ deras findings i `docs/prs/<branch-slug>/review-data.js` och kopiera den här skillens `template.html` till `docs/prs/<branch-slug>/review.html`.
Se till att alla agenters punkter kommer med i den slutliga sammanställningen.
Om flera agenter pekar på exakt samma problem, slå ihop det till en punkt i tabellen. Du kan fortfarande beskriva agenternas respektive lösning i beskrivningen.
Och välj exakt en lösning som du tycker är bäst att lägga som föreslagen fix.
När du skriver alla findings till review-data.js, översätt dom till svenska, och använd ett simpelt språk, undvik jargong och förutsätt inte att användaren har så bra koll på kodbasen.

Om `docs/prs/<branch-slug>/review-data.js` redan finns, läs den innan du skriver över den och bevara review-tillståndet från den befintliga `findings`-arrayen:

- Matcha befintliga findings mot nya findings via stabil identitet: använd i första hand samma `id` om det tydligt är samma finding, annars matcha på titel plus plats/problem.
- Bevara `status` och `ignoreReason` för matchade findings.
- Behåll befintliga findings med `status: "implemented"`, `status: "ignored-by-human"` eller `status: "ignored-by-ai"` även om de inte längre finns i de senaste agentrapporterna, så att reviewen på PR-nivå behåller sin historik över lösta och ignorerade findings.

Varje finding måste innehålla:

- `id`: indexnummer
- `fingerprint`: stabil sträng för samma underliggande problem över flera review-körningar, byggd av agent/kategori, primär fil och normaliserat problemnamn
- `severity`: `High`, `Medium` eller `Low`
- `needsHumanCheck`: tal från 1 till 10. Se ### Guide för needs human check för hur du rankar.
- `status`: `pending`, `implemented`, `ignored-by-human` eller `ignored-by-ai`. Nya findings får `pending` som default.
- `ignoreReason`: krävs när status börjar med `ignored`; utelämna eller lämna tom annars.
- `title`: kort beskrivning
- `problem`: en användbar problemsammanfattning i ett stycke som visas direkt i tabellen, så att läsaren oftast inte behöver fälla ut raden
- `description`: den fullständiga originalbeskrivningen från agentrapporterna, med Markdown och kodblock bevarade
- `fix`: den fullständiga föreslagna fixen, med Markdown och kodblock bevarade
- `location`: lista med platser om tillämpligt, helst som en array av strängar så att varje plats renderas på egen rad
- `files`: repo-relativa sökvägar till filer som berörs av findingen, utan radnummer, till exempel `["src/foo.ts"]`
- `agents`: alla agenter som hittade problemet

Skriv dem i ordning efter severity, högst först. Bevara Markdown och kodblock i `description` och `fix` så att mallen kan rendera dem korrekt.

## Steg 6
Som sista review-steg, läs den här skillens `COMMENT-FILTER.md` och tillämpa den på de färdiga findingsen en i taget.

När steg 6 är klart och `review-data.js` och `review.html` är skrivna, ge användaren en sökväg till `review.html` som går att öppna direkt i webbläsaren. Gör den inte till en länk, ge den exakta sökvägen så att den går att kopiera.
Se till att sökvägen fungerar i användarens miljö:

- Om du kör i WSL och användaren troligen öppnar filen från en Windows-webbläsare, kör `wslpath -w "<absolute-path-to-review.html>"` och ge den resulterande `\\wsl.localhost\...`-UNC-sökvägen i ett vanligt kopierbart textblock. Ge inte bara en Linux-URL som `file:///home/...` i det fallet.
- Annars, ge en lämplig `file://`-URL eller absolut sökväg för aktuellt OS.
- Om det är en symlink, ge sökvägen till den kanoniska filen.

## Svara på review-findings
När användaren senare svarar på findings från en genererad review, läs den här skillens `RESPOND-TO-REVIEW.md` och följ den.

### Guide för needs human check
Låga tal betyder att agenten i teorin skulle vara bekväm med att implementera fixen utan att fråga användaren.
Höga tal betyder att findingen kan kräva mänskligt omdöme eftersom agenten är mindre säker på att den stämmer.
Saker att tänka på när du sätter "Needs human check"-poängen:
- Om problemet fanns sedan tidigare ska poängen vara högre.
- Om det kan ligga utanför scope för den här PR:en ska den vara högre (åtminstone om det är en större ändring).
- Om det bara eller mest rör kod från den här PR:en ska den vara lägre.
- Större ändringar ska vara högre och mindre ändringar lägre.
- Om det kan finnas en medveten anledning till nuvarande beteende ska den vara högre.
- Om det finns många möjliga fixar på ett problem och du inte är säker på att den här är bäst.

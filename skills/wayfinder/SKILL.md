---
name: wayfinder
description: Planera en enorm arbetsinsats, större än vad en agentsession kan hålla i huvudet, som en delad karta av beslutstickets under docs/work/, och lös dem en i taget tills vägen till destinationen är klar.
disable-model-invocation: true
---

En lös idé har dykt upp. För stor för en agentsession, och insvept i dimma: vägen härifrån till **destinationen** syns inte ännu. Wayfinding handlar om att hitta den vägen, inte om att rusa mot destinationen. Den här skillen ritar vägen som en **delad karta** av markdownfiler i repot, och betar sedan av dess **beslutstickets**, frågor vars lösning är ett beslut, inte bitar av ett bygge som ska utföras, en i taget tills rutten är klar.

Destinationen varierar från insats till insats, och att namnge den är det första steget i kartläggningen. Den formar varje ticket. Det kan vara en spec att lämna över och iterera på, ett beslut att låsa innan planeringen börjar, eller en ändring som görs på plats, som en migrering av en datastruktur. Kartan är domänagnostisk. Ingenjörsarbete, kursinnehåll, vad som helst som passar formen.

## Planera, gör inte

Wayfinder är **planering** som standard: varje ticket löser ett beslut, och kartan är klar när vägen är klar, inget kvar att besluta innan någon går och gör grejen. Suget att bara göra jobbet är oftast signalen på att du nått kartans kant och att det är dags att lämna över. En insats kan skriva över detta i sina **Notes** och ta med utförande in i själva kartan, men utan det producerar du beslut, inte leverabler.

## Referera med namn

Varje karta och ticket har ett **namn**, sin titel. I allt som människan läser, berättande text, kartans Decisions-so-far, refererar du till det med det namnet, aldrig med ett naket nummer eller en slug. En vägg av `04, 05, 06` är oläslig; namn läses på en blick. Numret och sökvägen försvinner inte, ett namn omsluter sin länk, men de åker _inuti_ namnet och står aldrig i dess ställe.

## Kartan

Om repot har `docs/agents/issue-tracker.md` beskriver dess wayfinding-avsnitt var kartan och dess tickets bor, och ersätter fil- och sökvägsreglerna nedan. Rollerna (karta, ticket, blocking, frontier, claim, resolve) är desamma oavsett bärare.

Annars är kartan en enda markdownfil på `docs/work/<effort-slug>/map.md`, den kanoniska artefakten. Dess tickets är filer bredvid den i samma katalog.

Kartan är ett **index**, inte ett lager. Den listar besluten som fattats och pekar på de tickets som håller detaljerna. Ett beslut lever på exakt ett ställe, sin ticket, så kartan upprepar det aldrig, den sammanfattar bara och länkar.

**Wayfinding-operationer:**

- **Map**: `docs/work/<effort-slug>/map.md`, kroppen med Destination / Notes / Decisions-so-far / Fog.
- **Ticket**: `docs/work/<effort-slug>/<NN>-<slug>.md`, numrerade från `01`, med frågan i kroppen. En `Type:`-rad anger tickettypen (`research`/`prototype`/`grilling`/`task`); en `Status:`-rad anger `open`/`claimed`/`resolved`.
- **Blocking**: en `Blocked by: NN, NN`-rad nära toppen. En ticket är oblockerad när varje ticket den listar är `resolved`.
- **Frontier**: skanna insatsens katalog efter tickets som är `open` och oblockerade; lägst nummer vinner.
- **Claim**: sätt `Status: claimed` och spara innan något arbete.
- **Resolve**: lägg till svaret under en `## Answer`-rubrik, sätt `Status: resolved`, och lägg sedan till en kontextpekare i kartans Decisions-so-far i `map.md`.

Beslutstickets är **inte** byggtickets, så de följer inte regeln radera-vid-merge som resten av `docs/work/` gör. Svaret *är* artefakten, så en löst ticket stannar kvar tills hela insatsen landar. Byggtickets som kommer ur den här kartan lever i `docs/work/<effort-slug>/<feature-slug>/tickets/` och raderas när de mergas.

### Kartans kropp

Hela kartan i låg upplösning, laddad en gång per session. Öppna tickets listas **inte**. De är öppna ticketfiler bredvid kartan och hittas genom att skanna katalogen.

```markdown
## Destination

<what reaching the end of this map looks like — the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; skills every session should consult; standing preferences for this effort>

## Decisions so far

<!-- the index — one line per resolved ticket: enough to judge relevance, then zoom the link for the detail the ticket holds -->

- [<resolved ticket title>](link) — <one-line gist of the answer>

## Not yet specified

<!-- see "Fog of war": in-scope fog you can't ticket yet; graduates as the frontier advances -->

## Out of scope

<!-- see "Out of scope": work ruled beyond the destination; closed, never graduates -->
```

### Tickets

Varje ticket är en fil bredvid kartan; dess nummer och slug är dess identitet. Kroppen är frågan, dimensionerad för en agentsession på 100K tokens:

```markdown
Type: <research | prototype | grilling | task>
Status: open
Blocked by: <NN, NN — omit the line if none>

## Question

<the decision or investigation this ticket resolves>
```

Varje ticket anger sin typ i `Type:`-raden, en av `research`, `prototype`, `grilling`, `task` (se [Tickettyper](#tickettyper)).

En session **claimar** en ticket genom att sätta `Status: claimed`, **först**, innan något arbete, så att samtidiga sessioner hoppar över den. Den statusen _är_ claimen: en `open` ticket är oclaimad.

Blockering är `Blocked by: NN, NN`-raden. En ticket är **oblockerad** när varje ticket som blockerar den är `resolved`; **frontier** är de öppna, oblockerade ticketsen, kanten av det kända.

Svaret är inte en del av kroppen. Det skrivs in vid lösning (se [Jobba igenom kartan](#jobba-igenom-kartan)). Tillgångar som skapas medan en ticket löses länkas från ticketen, klistras inte in.

## Tickettyper

Varje ticket är antingen **HITL**, human in the loop, jobbad _tillsammans med_ en människa som talar för sig själv, eller **AFK**, driven av agenten ensam. En HITL-ticket löses bara genom det levande utbytet; agenten ersätter aldrig människans sida av det (en grilling-agent som svarar på sina egna frågor har brutit mot detta).

- **Research** (AFK): Läsa dokumentation, tredjeparts-API:er eller lokala resurser som kunskapsbaser för att få fram ett faktum ett beslut väntar på. Löses av en `/research`-**subagent**. Använd när kunskap utanför den aktuella arbetskatalogen krävs.
- **Prototype** (HITL): Höj diskussionens upplösning genom att göra en billig, grov, konkret artefakt att reagera på. En outline, ett grovt utkast, en stub, eller UI/logik-kod via /prototype-skillen. Länkar prototypen som en tillgång. Använd när "hur ska det se ut" eller "hur ska det bete sig" är nyckelfrågan.
- **Grilling** (HITL): Samtal. Standardfallet. Anropa alltid skillsen /grilling och /domain-modeling.
- **Task** (HITL eller AFK): Manuellt arbete som måste ske innan ett _beslut_ kan fattas. Inget att besluta, prototypa eller researcha, men diskussionen är blockerad tills det är gjort. Registrera sig för en tjänst så att dess API kan bedömas, ordna åtkomst, flytta data så att dess form kan ses. Det här är den enda typen som _gör_ istället för att besluta, och den förtjänar sin plats genom att avblockera ett beslut, inte genom att leverera destinationen. Agenten driver den själv där den kan (AFK); annars ger den människan en exakt checklista (HITL). Löst när arbetet är gjort; svaret anger vad som gjordes och eventuella fakta (var credentials finns, nya URL:er, antal rader) som senare tickets beror på.

## Fog of war

Kartan är _avsiktligt_ ofullständig: rita inte det du inte kan se ännu. Bortom de levande ticketsen ligger **fog of war**, den suddiga bilden av beslut och undersökningar du kan se kommer men inte kan sätta fingret på ännu, eftersom de hänger på frågor som fortfarande är öppna. Att lösa en ticket skingrar dimman framför den, och det som nu går att specificera graderas upp till nya tickets. En i taget, tills vägen till destinationen är klar och inga tickets återstår.

Kartans sektion **Not yet specified** är där den suddiga bilden skrivs ner: den misstänkta frågan, området att komma tillbaka till. Det är den oupptäckta fronten _mot_ destinationen. Allt här är i scope, bara inte skarpt nog att bli en ticket. Skriv så löst eller så utförligt som bilden tillåter; det fungerar också som en vägvisare för kollegor som läser vart insatsen är på väg.

**Dimma eller ticket?** Testet är om du kan formulera frågan exakt nu, _inte_ om du kan besvara den nu.

- **Ticket när** frågan redan är skarp, även om den är blockerad och du inte kan agera på den ännu.
- **Not yet specified när** du inte kan formulera den så skarpt ännu. Skiva inte upp dimman i ticketstora bitar i förväg: den är grövre än en ticket, och en fläck kan bli flera tickets, eller ingen alls, när fronten når den.

**Not yet specified** utesluter det som redan är beslutat (Decisions so far), det som redan är en levande ticket, och det som är out of scope (nästa sektion).

## Out of scope

Dimma samlas bara _mot_ destinationen. Destinationen fixerar scopet, så arbete bortom den är **out of scope**. Det är inte dimma, och det hör inte hemma i **Not yet specified**. Det får sin egen sektion **Out of scope** på kartan: arbete du medvetet uteslutit ur _den här_ insatsen. Scope, inte skärpa, är det som landar det här.

Out of scope-arbete graderas aldrig upp, fronten stannar vid destinationen, så det kommer bara tillbaka om destinationen ritas om, och då som en ny insats, inte en återupptagning.

Att förklara något out of scope är en scopinghandling, inte ett steg på rutten. När en ticket som redan finns visar sig ligga bortom destinationen, felaktigt inskopad vid kartläggningen eller avslöjad av en lösning, **stäng den**. Sätt `Status: resolved` med out of scope-motiveringen som dess `## Answer`, så att den otvetydigt är borta från fronten, och lämna en rad i sektionen **Out of scope**: sammanfattningen plus varför den är out of scope, med länk till den stängda ticketen. Den hålls utanför **Decisions so far**, som beskriver den rutt som faktiskt gåtts. En scopegräns är inte ett steg på den.

## Anrop

Två lägen. Oavsett vilket, **lös aldrig mer än en ticket per session**, med undantag för research-tickets.

### Rita kartan

Användaren anropar med en lös idé.

1. **Namnge destinationen.** Kör en `/grilling`- och `/domain-modeling`-session för att sätta fingret på vad den här kartan letar sig fram till, specen, beslutet eller ändringen. Destinationen fixerar scopet, så den avgörs först.
2. **Kartlägg fronten.** Grilla igen, **breddförst** den här gången: sprid ut över hela utrymmet istället för djupt på en enda tråd, och få fram de öppna besluten och de första stegen som går att ta nu. **Om detta inte ger någon dimma**, om vägen till destinationen redan är klar och hela resan liten nog för en session, behöver du ingen karta. Stanna och fråga användaren hur den vill gå vidare.
3. **Skapa kartan** (`docs/work/<effort-slug>/map.md`): Destination och Notes ifyllda, Decisions-so-far tom, dimman skissad i **Not yet specified**. Om en mapp `docs/work/<slug>/` redan finns för den här idén, en grilling och kanske en spec som visade sig vara större än en feature, lägg kartan där istället för att starta en ny mapp, och flytta ner eventuella befintliga `spec.md` och `tickets/` till en `<feature-slug>/`-undermapp.
4. **Skapa de tickets du kan specificera nu** som filer bredvid kartan, och koppla `Blocked by:`-kanter medan du går. Filnamnens nummer är id:n, så kanter kan referera till dem direkt. Kopplingen sorterar dem i fronten och de blockerade; allt du inte kan specificera ännu stannar i dimman, sektionen **Not yet specified**.
5. **Starta research-subagenterna.** För varje `research`-ticket du just skapade, snurra upp en `/research`-subagent som löser den parallellt och fångar sina fynd på en slit-och-släng-branch `research/<name>` med en kontextpekare från ticketen.
6. Stanna. Kartläggning är en sessions arbete; den löser inget för hand.

### Jobba igenom kartan

Användaren anropar med en karta (en sökväg eller ett insatsnamn). En ticket är **valfri**. Utan en väljer du nästa beslut, inte användaren.

1. Ladda **kartan**, lågupplösningsvyn, inte varje ticketkropp.
2. Välj ticket. Om användaren namngav en, använd den. Annars ta den första ticketen i fronten i ordning. **Claima den**: sätt `Status: claimed` innan något arbete.
3. Lös den. **Zooma vid behov**: hämta hela kroppen av valfri relaterad eller stängd ticket på begäran; anropa de skills som `## Notes`-blocket nämner. Vid tvekan, använd `/grilling` och `/domain-modeling`.
4. Skriv in lösningen: lägg till svaret under en `## Answer`-rubrik, sätt `Status: resolved`, och **lägg till en kontextpekare** i kartans Decisions-so-far.
5. Lägg till nya tickets som dykt upp (skapa, koppla sedan); gradera upp den dimma svaret gjort specificerbar, och rensa varje uppgraderad fläck från **Not yet specified** så att den bara lever som sin nya ticket. Om svaret avslöjar att en ticket, den här eller en annan, ligger bortom destinationen, **förklara den out of scope** istället för att lösa den på rutten. Om beslutet ogiltigförklarar andra delar av kartan, uppdatera eller radera de ticketsen.

Användaren kan köra oblockerade tickets parallellt, så räkna med att andra sessioner redigerar kartans filer samtidigt.

### Landa kartan

När fronten är tom och destinationen nådd lämnar kartan över till bygget: kör `/to-spec` per feature insatsen producerat, var och en skriver till `docs/work/<effort-slug>/<feature-slug>/spec.md`, sedan `/to-tickets` bredvid. När den sista featurens tickets är mergade och borta graderar `/land` upp kartans beslut till ADR:er och raderar hela insatsmappen.

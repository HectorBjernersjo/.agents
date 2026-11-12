---
name: create-pr
description: Använd när användaren ber dig skapa ett PR eller flera PR:s
---

Användaren vill skapa upp ett PR från det de har byggt.

Feature-stackarna ligger direkt på master och tweaks-committen (base) kommer
in via merge i working copyn, så ett PR är bara ett segment av stacken:
bookmark på segmentets sista change + push. Ingen duplicering, inget jj-pr.

- Diffen för hela featuren: `jj diff -r 'trunk()..(@- ~ base)' --git`
  (feature-heden är @:s förälder minus base). För ett enskilt segment:
  `jj diff -r '<föregående segment-head>..<segment-head>' --git`.
  Diffa aldrig @ själv, den är merge-committen med base.
  (git-CLI:t finns bara i master.)

## Branch + push
1. `jj bookmark set <branch-namn> -r <segment-head>`. Hoppa över om
   bookmarken redan sitter rätt.
2. `jj fix -s 'roots(master@origin..<segment-head>)'` så att filerna behåller
   radsluten de har i master (verktyget `eol-keep`, ligger i repo-configen).
3. `jj git push --bookmark <branch-namn>`

Kalla branchen för users/hebj01/{din feature}. Hör PR:et till en Linear-issue börjar featurens slug med issuens id, `users/hebj01/ai-123-<slug>`, se `~/work/HRM/AGENTS.md`.

Uppdateringar av ett befintligt PR kräver ingen bookmark-hantering: squasha
in i stackens changes (bookmarken följer med när changen skrivs om), kör
`jj fix` som ovan och sen `jj git push --bookmark <branch-namn>` igen.

## Skapa PR:et
Skapa PR:et med gh cli:t, gör den som en draft och ge användaren en länk.
Sätt ingen reviewer och ingen Employee-tagg. `babysit-pr` lägger på båda
först när testerna är gröna och alla trådar är resolvade, utom när PR:et
ändrar en pipeline. Då sätts ingen av dem.

## PR description
Innehåller diffen synliga UI-ändringar, spela in med `record-demo` och publicera med `pr-media`, som lägger gif:en under `## Demo` i beskrivningen.

Fokusera på varför jag har gjort det som det är, inte så mycket på exakt vad som har ändrats.
Om PR:et är något lite större eller där det annars är aktuellt kan du även beskriva flödet som man behöver förstå i PR:et.
Håll den kortfattad och så simpel att förså som möjligt, du behöver inte ta med varenda ändring.
PR-descriptionen ska vara på svenska, den kan ofta vara rätt lik user story-descriptionen, men kanske med lite mer tekniska detaljer där det är relevant.

Avsluta PR-descriptionen med en rad som både länkar och stänger work itemet i Azure DevOps när PR:et mergas:

- User story: `Closed AB#{id}`
- Bug: `Fixes AB#{id}`

Nyckelordet måste stå direkt före referensen. Bara `AB#{id}` skapar en länk men flyttar inget, och `Fixes user story AB#{id}` blir också bara en länk. Ett nyckelord gäller bara den första referensen efter det, så flera work items får varsitt: `Closed AB#1, Closed AB#2`. Övergången sker först när PR:et mergas till master, så i en stack är det bara det som till slut går in i master som stänger något.

Hör PR:et till en Linear-issue, lägg till `Closes AI-{nr}` på samma rad, `Closed AB#12345, Closes AI-123`. Linear kopplar redan PR:et via id:t i branchnamnet, men raden gör kopplingen även när branchen saknar id:t.

Om du någon gång ska uppdatera pr descriptionen. Kolla först om jag eller nån annan har ändrat på den sen du satte den så du inte skriver över något.

Id:t kommer från `ado-create-story` om `/create-user-story` kördes nyss i samma session, annars fråga användaren efter det.

Exempel på för lång pr description:

```markdown
Varför

IntegrationTests .NET föll på #30148 (ett rent TypeScript/CSS-PR) med

FlexHrm.AiModule.Tests.Chatbot.ChatbotServiceFlowTests.AcceptToolConfirmation_Waits_For_Open_RejectToolConfirmation_Stream_Instead_Of_Returning_Busy
System.InvalidOperationException : Generation is already registered for conversation ...

Det är inte ett flakigt test utan en riktig bugg i konversationslåset, som bara råkar synas som flakighet.
Mekanismen

Låset är två kolumner på ChatbotConversation-raden, LockToken och LockedUntilUtc. ConversationLock sätter dem med en bulk-update via UpdateBuilder, som går rakt mot databasen och inte rör entiteten i NHibernate-sessionen. Men ChatbotService laddar konversationen innan låset tas, så entiteten i minnet har fortfarande LockToken = null.

När genereringen sen lägger till ett meddelande sätter AddMessage UtcTimeLastMessage, entiteten blir dirty, och nästa FlushAsync skriver en UPDATE på raden. ChatbotConversationMap hade ingen DynamicUpdate(), så UPDATE:n skriver alla kolumner från minnet, inklusive LockToken = NULL. Låset är släppt i databasen medan genereringen fortfarande kör och är registrerad i ConversationGenerationCancellation.

I testet pollar Accept låset var 100 ms. Landar en poll i fönstret mellan den flushen och att reject-strömmen disposar sin registrering tar Accept låset, anropar Register och smäller. I produktion är det värre: ett nytt SendMessage kan ta låset mitt i en pågående generering. På samma server blir det ett 500 i stället för ConversationBusy, på en annan server (registret är in-process) kör två genereringar parallellt på samma konversation.
Fixen

DynamicUpdate() på ChatbotConversationMap. Då skriver flushen bara dirty kolumner och lämnar låskolumnerna ifred. Nytt test i ConversationLockTests laddar entiteten, tar låset, smutsar ner och flushar, och kontrollerar att låset inte går att ta igen. Rött utan fixen, grönt med.
Demo

Chatboten i web med fixen: Flexie ber om godkännande för en frånvaroansökan, ansökan skapas efter Godkänn och svaret strömmar klart. Låset tas och släpps genom hela flödet (bekräftelse, verktygskörning, fortsatt generering) utan att flushen av konversationen släpper det i förtid.
```

Exempel på bättre, kortare pr description:
```markdown
När en användare skickar ett meddelande till en konversation låser vi den genom att sätta två kolumner på ChatbotConversation-raden: LockToken och LockedUntilUtc.

Låset sätts med UpdateBuilder, som ändrar databasen direkt utan att röra den ChatbotConversation-entitet som redan ligger i NHibernate-sessionen. Entiteten i minnet har alltså fortfarande LockToken = null. När genereringen sen lägger till ett meddelande blir entiteten dirty, och nästa FlushAsync skriver en UPDATE med alla kolumner, inklusive LockToken = null. Låset är borta mitt i genereringen, och ett nytt meddelande kan starta en generering till på samma konversation.

Fixen är DynamicUpdate() på ChatbotConversation-mappningen. Då skriver flushen bara de kolumner som faktiskt ändrats i sessionen, och det gamla null-värdet följer inte med.

Demo

Chatboten funkar som vanligt efter ändringen:
<gif>
(Om användaren t.ex. har bett dig om en video som visar att den fortfarande funkar som vanligt)

Closed AB#12345
```

Annat exempel på för lång description:
```markdown
Flexie har varit ute i prod ett tag och introt som pekade ut chattknappen och förklarade chatten i två steg när den öppnades behövs inte längre. Det lade till ett extra klick innan man kunde börja skriva och låg mitt i öppningsflödet.

`ChatbotIntroController` tas bort helt, tillsammans med kopplingen i `Chatbot` och `ChatbotToggleButtonHandler` och de två guid:arna i `IntroJsEnum`. Övriga intro.js-guider i HRM påverkas inte, det är bara chatbotens som försvinner.

Closed AB#12345
```

Bättre:
```markdown
Flexie har varit ute i prod ett tag och introt som pekade ut chattknappen och förklarade chatten i två steg när den öppnades behövs inte längre. Vi tar därför bort introjs från chatboten.
Closed AB#12345
```

Ett till exempel på onödigt lång description:
```markdown
Verktygen som kräver godkännande har hittills ägt allt själva: schema mot modellen, validering, bekräftelseformulär och exekvering i en och samma klass. Det gör dem svåra att återanvända utanför chatten och gör det lätt att råka exekvera utan att passera bekräftelsen.

Vi bryter därför ut en `ConfirmableAction<TInput>` per åtgärd, med `Validate` och `Execute`, och en `ConfirmationFormBuilder<TInput>` som bygger kortet från samma input. Toolet blir en tunn adapter: det äger namn, schema och tillgänglighet mot modellen och pekar på sin action. Actions registreras aldrig som `IAiTool`, så modellen har ingen väg till `Execute` annat än via bekräftelseflödet.

Kortet byggs nu av `ConfirmationCardBuilder`. När användaren redigerar och godkänner mergas de postade fälten in i den sparade inputen på servern, formuläret normaliserar (byte av bil nollar mätarställningen, byte av frånvaroorsak tar bort barnet) och actionen validerar innan något sparas. Fält delas i `InputField`, som mappar mot en egenskap på inputen, och `DisplayField`, beräknade visningsvärden som klienten inte kan skriva över. Bekräftelsemeddelandet renderas som markdown i webben.

`ToolArgumentValidator` lever kvar som brygga mot det gamla flödet i `ChatbotService` och försvinner i nästa PR i serien.

Closed AB#37459
```

Bättre
```markdown
Målet är att helt bryta ut confirmation från toolsen. Ett tool ska köras och returna direkt, sen kan det ge en artifact som visas upp för användaren med en accept knapp. Men det ska ske utanför tool loopen. Detta för att simplifiera och göra det lättare för mcp och programatisk toolcalling som kommer senare.

Vi delar upp så att toolet bara är det som körs, sen returnerar den ett ConfirmationForm (en artifact) med en accept knapp. När man accepterar den körs den ConfirmableAction som hör till formuläret.

Closed AB#37459
```

Exempel på hyffsad men ändå för lång description:
```markdown
Ett program som Flexie kör kan läsa mycket, upp till 10 MB per anrop och ofta uppgifter om andra anställda. Förut låg allt det kvar i konversationen och skickades om i varje request resten av turen, och det sparades i databasen.

Nu släpps det när programmet är klart. AgentRunner tar bort programmets anrop och resultat ur minnet när program_output kommer, och programmet går därefter som text, alltså koden och outputen. Det är samma form som ett program från en tidigare tur redan hade. I databasen sparas anropen fortfarande så att UI:t kan visa dem, men resultatet byts mot en platshållare. Raden behövs, annars räknas anropet som avbrutet.

Eftersom programmens anrop bara finns kvar medan programmet kan återupptas behöver Azure-servicen inte längre filtrera bort dem. ResumableProgram håller ihop Azures item och dess call_id.

Jag tog också bort kommentaren om att Azure avvisar ett reasoning-item vars följande item saknas. Jag provade mot dev-Azure, och det stämmer inte.
```

Bättre:
```markdown
Flexie kan anropa tools via kod, typ:
let employees = tools.ListEmployees();
print(employees[0:5])
ett sånt här tool call kan bli upp till 10mb med text som mest.
Förut sparade vi alla dom i databasen och i konversationen i minnet fastän modellen aldrig ska läsa svaret från toolcallet utan bara programmets resultat (som ofta är mycket kortare)
Nu slutar vi spara hela innehållet i databasen och slänger det från konversationen i minnet så fort det inte behövs längre (när programmet som körde toolet är klart).
```

## Stacked PRs, när flera PR:s beror på varandra
Segmenten ligger redan på varandra i stacken, så brancherna är kedjade av
sig själva. Den formella stacken (badgen "1/N" + stack-panelen) skapas
separat via API:t:

1. Pusha varje segments bookmark, nerifrån och upp.
2. Skapa PR 2..N med `gh pr create --base <föregående branch>` (drafts som
   vanligt) och referera botten-PR:et i beskrivningen.
3. Länka ihop dom till en formell stack (botten-till-topp; varje PR:s base
   måste matcha föregåendes head):
   ```
   echo '{"pull_requests": [<botten-nr>, <topp-nr>]}' | \
     gh api --method POST repos/flexapplicationsvisma/hrm/stacks --input -
   ```
   Fler PR:s läggs på toppen senare med `POST repos/.../stacks/{stack_number}/add`.

När botten-PR:et mergas retargetar GitHub nästa PR mot master automatiskt,
även vid squash-merge.

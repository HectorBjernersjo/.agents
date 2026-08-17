---
name: create-pr
description: Use when the user asks you to create a pr or pr:s
---

Användaren vill skapa upp ett pr från det de har byggt.

Feature-stackarna ligger direkt på master och tweaks-committen (base) kommer
in via merge i working copyn, så ett PR är bara ett segment av stacken:
bookmark på segmentets sista change + push. Ingen duplicering, inget jj-pr.

- Diffen för hela featuren: `jj diff -r 'trunk()..(@- ~ base)' --git`
  (feature-heden är @:s förälder minus base). För ett enskilt segment:
  `jj diff -r '<föregående segment-head>..<segment-head>' --git`.
  Diffa aldrig @ själv — den är merge-committen med base.
  (git-CLI:t finns bara i master.)

## Branch + push
1. `jj bookmark set <branch-namn> -r <segment-head>` — hoppa över om
   bookmarken redan sitter rätt.
2. `jj git push --bookmark <branch-namn> --allow-new`

Kalla branchen för users/hebj01/{din feature}

Uppdateringar av ett befintligt PR kräver ingen bookmark-hantering: squasha
in i stackens changes (bookmarken följer med när changen skrivs om) och kör
`jj git push --bookmark <branch-namn>` igen.

## Skapa pr:et
Skapa pr:et med gh cli:t, gör den som en draft och ge användaren en länk.
Lägg till Employee taggen på pr:et.

## PR description
Innehåller diffen UI-ändringar, kör `pr-media`-skillen och lägg gif:en under `## Demo` i beskrivningen.

Fokusera på varför jag har gjort det som det är, inte så mycket på exakt vad som har ändrats.
Om pr:et är något lite större eller där det annars är aktuellt kan du även beskriva flödet som man behöver förså i pr:et.
Håll den kortfattad, du behöver inte ta med varenda ändring.
Pr descriptionen ska vara på svenska, den kan ofta vara rätt lik user story descriptionen, men kanske med lite mer tekniska detaljer där det är relevant.

Avsluta pr descriptionen med `AB#{user story-id}` så att pr:et länkas till storyn i Azure DevOps. Id:t kommer från `ado-create-story` om `/create-user-story` kördes nyss i samma session — annars fråga användaren efter det.

## Stacked PRs — när flera prs beror på varandra
Segmenten ligger redan på varandra i stacken, så brancherna är kedjade av
sig själva. Den formella stacken (badgen "1/N" + stack-panelen) skapas
separat via API:t:

1. Pusha varje segments bookmark, nerifrån och upp.
2. Skapa pr 2..N med `gh pr create --base <föregående branch>` (drafts som
   vanligt) och referera botten-pr:et i beskrivningen.
3. Länka ihop dom till en formell stack (botten-till-topp; varje pr:s base
   måste matcha föregåendes head):
   ```
   echo '{"pull_requests": [<botten-nr>, <topp-nr>]}' | \
     gh api --method POST repos/flexapplicationsvisma/hrm/stacks --input -
   ```
   Fler prs läggs på toppen senare med `POST repos/.../stacks/{stack_number}/add`.

När botten-pr:et mergas retargetar GitHub nästa pr mot master automatiskt,
även vid squash-merge.

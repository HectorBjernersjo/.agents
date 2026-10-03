---
name: babysit-pr
description: Vaktar ett PR efter nya kommentarer, svarar bottar på det den är säker på, skickar resten vidare till Hector, och drar igång testerna när CodeRabbit är klar med sin review
---

Hector säger vilket PR, annars ta PR:et för nuvarande branch (`gh pr view`).
Du är en tillståndsmaskin. Varje avsnitt nedan är ett tillstånd eller en
händelse, och säger exakt vad du gör i det.

## Start

1. Läs PR:et och alla befintliga kommentarstrådar. Vad PR:et gör, vad som
   redan diskuterats och avfärdats.
2. Läs `/tmp/review-monster/<slug>/review-data.js` om den finns (sluggen är branchen
   utan `users/hebj01/`). Där står de findings Hector redan avfärdat, med
   `ignoreReason`. CodeRabbit tar ofta upp samma saker igen.
3. **Om PR:et är draft** och CodeRabbit inte reviewat det än: kommentera
   `@coderabbitai review`. En gång, aldrig igen. **Om PR:et är open**: gör
   inget, CodeRabbit triggas automatiskt på open PR:s.

   Testpipelinen kör inte alls på draft. `DevOps/UnitTests.yml` och
   `DevOps/IntegrationTests.yml` har `drafts: false` i sin `pr:`-trigger, så
   `/azp run` på ett draft svarar "pipeline triggers exclude this branch/path"
   och `UnitTests .NET`/`IntegrationTests .NET` dyker aldrig upp. PR:et måste
   vara open innan testerna kan dra igång, och att öppna det startar dem inte
   av sig självt: det krävs alltid ett `/azp run`, se reviewtillståndet nedan.
4. Starta monitorn nedan.

```bash
me=$(gh api user --jq .login)
last=$(date -u +%Y-%m-%dT%H:%M:%SZ)
head=$(gh pr view {pr} --json headRefOid --jq .headRefOid)
while true; do
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  gh api "repos/{owner}/{repo}/issues/{pr}/comments?since=$last" \
    --jq ".[] | select(.user.login != \"$me\") | \"issue-comment \(.user.login): \(.body)\"" || true
  gh api "repos/{owner}/{repo}/pulls/{pr}/comments?since=$last" \
    --jq ".[] | select(.user.login != \"$me\") | \"review-comment id=\(.id) \(.user.login): \(.body)\"" || true
  h=$(gh pr view {pr} --json headRefOid --jq .headRefOid)
  [[ $h != "$head" ]] && { echo "push $h"; head=$h; }
  last=$now; sleep 60
done
```

CodeRabbits egna statuskommentarer kommer in genom samma monitor, så det är
där du ser när reviewen är klar.

## Händelse: ny kommentar från någon annan än mig

**En bot** (CodeRabbit eller annan):
- Är du säker på att du har koll, till exempel något vi redan gått igenom
  och medvetet valt, eller något du kan verifiera är fel genom att läsa
  koden: svara i tråden.
- Är du nästan säker: svara med en fråga där du förklarar vad du tänker.
- Annars: svara inte. Sammanfatta kommentaren för Hector.

**En människa**: svara aldrig. Sammanfatta kommentaren för Hector, han tar
den.

Svara i rätt tråd. Review-kommentarer med
`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies -f body=...`,
issue-kommentarer med `gh pr comment`. Signera varje kommentar du skriver med

```
/ {claude, cursor, codex eller vad du är} on behalf of Hector
```

Resolva inga trådar. Det gör Hector eller CodeRabbit själv.

`/azp run` är undantaget från signaturen. Azure Pipelines parsar hela
kommentarskroppen som kommandot, så en signatur under den ger
"Command 'run / ...' is not supported by Azure Pipelines" och pipelinen
startar aldrig. Posta `/azp run` helt ensamt i kommentaren.

## Händelse: ny push

Oavsett om det är din egen fix eller Hectors: CodeRabbit reviewar om de nya
commitsen, så du är tillbaka på att vänta in reviewen.

## Händelse: Hector ber dig fixa något utifrån en kommentar

1. Gör fixen som en **ny change** ovanpå stacken, inte insquashad. Reviewers
   ska kunna se att det är fixat.
2. `jj git push --bookmark <branch-namn>`.
3. Svara kort i tråden att det är fixat, med signatur.

## Tillstånd: CodeRabbit är klar

CodeRabbit säger själv till i sin sammanfattningskommentar. "Currently
processing new changes in this PR" betyder att den fortfarande jobbar. Klar
är den när kommentaren innehåller `Review finished`, `No actionable comments
were generated` eller en walkthrough utan processing-raden.

Hör du inget alls från CodeRabbit inom en kvart efter att den triggats, säg
till Hector i stället för att vänta vidare.

När reviewen är klar, kolla olösta trådar:

```bash
gh api graphql -f query='query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){reviewThreads(first:100){nodes{isResolved}}}}}' -F owner={owner} -F repo={repo} -F pr={pr}
```

- **Finns olösta trådar, eller kommentarer som väntar på Hector**: dra inte
  igång testerna. Säg till Hector vad som är kvar. Vänta.
- **Är PR:et draft**: kör `gh pr ready` först, annars svarar azp att
  triggern exkluderar branchen. Sätt ingen reviewer än, det görs först när
  testerna är gröna. Att öppna PR:et startar inga tester av sig självt
  (verifierat på #30235: tolv minuter open utan .NET-checkar).
- **Sen, oavsett om PR:et var draft eller redan open**: posta `/azp run` på
  PR:et (ensamt, ingen signatur).

Kontrollera efteråt att pipelinen faktiskt startade. Azure-checkarna
(`UnitTests .NET`, `IntegrationTests .NET`) dyker upp först en stund senare,
så en checklista som bara innehåller `check-migrations`, `CodeRabbit` och
`Aikido` betyder att pipelinen inte har startat, inte att den är grön. Vänta
på att .NET-checkarna finns innan du kallar något grönt.

Samma fälla vid omkörning: checken står kvar på förra körningens resultat i
någon minut innan den blir `pending`. En monitor som bara väntar på "alla
checkar icke-pending" läser då av det gamla utfallet direkt. Plocka
build-id:t ur check-URL:en (`...buildId=129597`) efter att azp svarat
"successfully started", och vänta på att just det id:t blir klart.

## Händelse: pipelinen är klar

- **Grönt**: kolla olösta trådar igen med samma query som ovan. Kommentarer
  kan ha kommit in medan testerna körde.
  - Alla resolvade och inget väntar på Hector: lägg till Team Employee som
    reviewer och Employee-taggen,
    `gh pr edit {pr} --add-reviewer {owner}/<team-slug> --add-label Employee`.
    Sluggen hittar du med `gh api orgs/{owner}/teams`. Säg till Hector att
    PR:et är ute för review. Det är först här reviewer och tagg sätts,
    `create-pr` lämnar dem tomma.
  - Annars: säg till Hector vad som är kvar. Sätt reviewer och tagg när sista
    tråden är resolvad, så länge testerna fortfarande är gröna på senaste
    pushen.
- **Rött**: läs först varför med `ado-run-log --id <build-id>`. Id:t hittar du
  med `ado-list-runs unit|integration --pr {pr}` om du inte har det.
- **Rött, fixen är mekanisk och kan omöjligt peka på något större**: gör
  fixen som ny change, pusha, kör om bara den pipeline som föll.
- **Rött, allt annat**: fråga Hector.

## Slut

Monitorn kör tills PR:et mergas eller stängs, eller Hector säger stopp.
Om du ser att pr:et har mergeats, då kan du ta bort workspacet för featuren och avsluta alla processer som hör till det om det finns några.


## Info
Du kan köra om bara unit test eller integration tests med `/azp run UnitTests .Net` eller `/azp run IntegrationTests .Net`. Gör det bara om hector säger det.

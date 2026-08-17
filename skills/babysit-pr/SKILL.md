---
name: babysit-pr
description: Watches a PR for new comments, answers the ones it is 100% sure about, and posts /azp run when the PR has been quiet for an hour
---

Användaren vill att du vaktar ett pr. Användaren säger vilket pr, annars ta pr:et för nuvarande branch (`gh pr view`).

## Setup
1. Läs igenom pr:et och alla befintliga kommentarstrådar först så att du har kontexten — vad pr:et gör, vad som redan har diskuterats och avfärdats.
2. Starta en persistent Monitor som pollar efter nya kommentarer (både issue-kommentarer och review-kommentarer) varje minut. Filtrera bort dina egna kommentarer (kolla inloggat konto med `gh api user --jq .login`). Mönster:

```bash
me=$(gh api user --jq .login)
last=$(date -u +%Y-%m-%dT%H:%M:%SZ)
while true; do
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  gh api "repos/{owner}/{repo}/issues/{pr}/comments?since=$last" \
    --jq ".[] | select(.user.login != \"$me\") | \"issue-comment \(.user.login): \(.body)\"" || true
  gh api "repos/{owner}/{repo}/pulls/{pr}/comments?since=$last" \
    --jq ".[] | select(.user.login != \"$me\") | \"review-comment id=\(.id) \(.user.login): \(.body)\"" || true
  last=$now; sleep 60
done
```

## När en ny kommentar kommer
Svara bara på kommentarer där du är **100% säker** på att du har koll — t.ex. när CodeRabbit eller en annan bot lägger en kommentar om något vi redan har gått igenom och medvetet valt, eller något du kan verifiera är fel genom att läsa koden. 
Om du är ganska säker men inte helt säker kan du svara coderabbit med en fråga där du förklarar vad du tänker.
Är du inte helt säker: svara inte, sammanfatta istället kommentaren för Hector så tar han den.

- Svara i rätt tråd: review-kommentarer besvaras med `gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies -f body=...`, issue-kommentarer med `gh pr comment`.
- Signera alltid varje kommentar du skriver med:

```
— {Vem du är, claude, cursor eller codex eller nåt} on behalf of Hector
```

- Resolva inga trådar — det gör Hector eller coderabbit själv.
- Om en kommentar leder till kodändringar (Hector ber dig fixa något): squasha in fixen i rätt change i stacken (bookmarken följer med när changen skrivs om) och pusha med `jj git push --bookmark <branch-namn>`.

## Om alla kommentarer är resolvade och det inte har kommit några nya på 10 min:
Kolla om det finns olösta review-trådar:

```bash
gh api graphql -f query='query($owner:String!,$repo:String!,$pr:Int!){repository(owner:$owner,name:$repo){pullRequest(number:$pr){reviewThreads(first:100){nodes{isResolved}}}}}' -F owner={owner} -F repo={repo} -F pr={pr}
```

- Inga olösta trådar (och inga obesvarade kommentarer som väntar på Hector) → posta kommentaren `/azp run` på pr:et så att pipelinen körs.
- Finns det olösta trådar → posta inte `/azp run`, säg till Hector vad som är kvar.
- När testerna är klara så verifiera att dom gick igenom. Om dom failade så gör såhär:
    - Om det är en simpel och mekanisk fix och det här omöjligt kan peka på något större problem: gör den, pusha upp och kör testerna igen
    - Annars fråga Hector
- Failar bara en av pipelinesen räcker det med att du kör om den om du fixar något.

Monitorn fortsätter tills användaren säger stopp eller pr:et mergas/stängs.

## När Hector ber dig fixa något utifrån kommentarer
Gör alla fixes som en ny change istället för i samma change. Så reviewers lätt kan se att jag har fixat det.

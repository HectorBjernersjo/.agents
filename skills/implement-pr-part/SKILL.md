---
name: implement-pr-part
description: Implementerar en del av big som ett eget pr berätta vilken del du vill att ai:n implementerar när du använder skillen
disable-model-invocation: true
---

I big foldern finns det ett enda stort pr. Jag vill dela upp det i flera prs. Det finns en plan för hur det ska göras i PLAN.md.
Jag kommer att berätta för dig vilken del jag vill att du implementerar. När du har fått den delen så gör följande:
- Skapa ett nytt worktree för den pr:en du ska göra
- Om den beror på ett annat pr, kolla först om det pr:et redan är mergeat, om det är det - kör på.
  Annars: kör git reset {branchen den beror på} så att du kan utgå från rätt.
- Kör setup_worktree i roten för det nya worktree:t
- kolla igenom big med git diff master... Om jag inte säger något annat vill jag att slutresultatet ska bli så likt big som möjligt. 
  Så när du implementerar, se till att kolla på ändringarna i big och försök göra exakt samma i det här pr:et (fast bara dom delarna som är med i den här delen såklart)
- Om du ser att det är någon skillnad mellan planen, big och i branchen så ska du lyssna på dom i den här ordningen: branchen > big > planen.
  Det kan vara så att jag hittade något fel i big och fixade det under tiden jag delade upp den.

Börja med att undersöka vad som behöver göras. Ställ sedan alla följdfrågor du har till mig innan du börjar implementera, jag säger till när det är dags att implementera.


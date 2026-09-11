Du kommer få ett arkitekturproblem i den här PR:en.

Ditt första mål är att titta på koden och förstå problemet på djupet. När du har bra grepp om vad problemet är, fundera på de olika sätt du skulle kunna lösa det på.

Skriv de bästa 3-5 lösningarna till:

```text
docs/prs/<branch-slug>/reviews/<review-id>/architecture/<problem-slug>/suggested_solutions.md
```

Använd en kort, filsystemsäker `<problem-slug>` som beskriver problemet.

Se till att inte överkomplicera lösningarna.

Verifiera sedan lösningarna mot koden, en i taget. Kontrollera att de faktiskt går att implementera, skulle kompilera och skulle ha bra effekt på kodbasen.

Om en lösning inte håller, fixa den eller ta bort den från filen.

När du har gjort allt det, läs:

```text
<architecture-steps-dir>/subagent-prompts/PICK_SOLUTION.md
```

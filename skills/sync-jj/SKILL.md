---
name: sync-jj
description: Använd bara när du blir ombedd
disable-model-invocation: true
---

Kör från `main`:

```sh
jj workspace update-stale
jj git fetch
jj rebase -s 'roots(master..(bookmarks() | parents(working_copies())))' -d master
```

Revseten väljer `base` och roten i varje aktiv feature-stack. Jj rebasar deras
descendants och workspace-merges i samma operation. Rebasea inte varje workspace
separat och kör inte `workspace update-stale` i alla mappar.

Lös konflikter som den här rebasen skapar. Rör inte konflikter som fanns innan.

Om en befintlig feature redan kom med i nya master är den troligen mergad. Ta då
bort dess workspace, bookmark och jj-changes. Gör inga extra loggkontroller om
rebasens output inte ger anledning till det.

Ta även bort andra workspaces som redan har blivit mergeade tidigare och inte har några changes ovanpå master längre.

Du behöver bara bygga och köra tester om du behövde göra stora ändringar för att fixa konflikter.
Annars kan du skippa det.

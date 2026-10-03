---
name: pr-media
description: Använd när du har en gif eller skärmdumpar som ska in i ett PR, eller när create-pr hittar UI-ändringar i diffen. Själva inspelningen gör record-demo.
---

Pusha gifen eller skärmdumparna till orphan-branchen `pr-media` och länka
dem i PR-beskrivningen. Har du inget att publicera än, börja med
`record-demo`.

Gif, inte mp4. GitHub kan bara bädda in video som laddats upp via webben, och
det går inte från CLI. En gif i samma privata repo renderas för alla med
access till repot och autospelar i PR-flödet.

## Publicera

`scripts/publish.sh <slug> demo.gif [fler filer]`

Pushar till `pr-media`, städar bort allt äldre än 7 dagar, och skriver ut
färdiga markdown-rader på stdout. Branchen skrivs om till en enda commit
varje gång, så repot växer inte av gamla klipp. Slug-mappen ersätts helt:
publicerar du om en fil måste alla filer som ska finnas kvar med i samma
anrop.

## Länka i PR:en

Lägg raderna under en `## Demo`-rubrik i beskrivningen, med en mening om vad
man ser. `gh pr edit <nr> --body-file ...` från `~/work/HRM/master` med
`GH_TOKEN=$(gh auth token --user HectorVisma)`.

## Länkarna dör efter 7 dagar

Städningen tar bort mappar daterade äldre än 7 dagar. Ligger PR:en öppen
längre än så, kör publish igen så flyttas klippet fram.

Om du bara visar att chatboten funkar som förut kan du bara skriva "Chatboten funkar som förut" under Demo

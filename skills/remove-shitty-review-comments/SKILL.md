---
name: remove-shitty-review-comments
description: Removes shitty review comments
disable-model-invocation: true
---

jag har fått den här reviewn. Men jag tycker att det är lite för många "bullshit punkter". Ta bort alla punkter som:
- tar upp sånt som redan står i review_context att det ska ignoreras
- vill göra helt onödiga refactors som bara blir sämre
- Saker som faktiskt inte är buggar
- Saker som är intentional med den har flaggat ändå (du ska vara hyffsat säker på att det är intentional för att ta bort en review punkt)
- saker som föreslår att ändra något som då går emot resten av kodbasen
- saker som faktiskt inte har ändrats i pr:et utan var pre-existing
- duplicerade kommentarer (slå ihop dom)
- saker som pekar ut UTF-8 bom, vi har tester för det, behövs inte pr kommentarer
- kommentarer som pekar ut saker som faktiskt är bra
Ta inte bort kommentarer bara för att det är nitpicks eller bara är pyttelite bra.

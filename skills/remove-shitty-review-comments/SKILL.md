---
name: remove-shitty-review-comments
description: Invoke this only when you are explicitly told to
---

Jag tycker fortfarande att det kanske är lite för många "bullshit punkter". Ta bort alla punkter som:
- tar upp sånt som redan står i review_context att det ska ignoreras
- vill göra helt onödiga refactors som bara blir sämre
- Saker som faktiskt inte är buggar
- Saker som är intentional med den har flaggat ändå (du ska vara hyffsat säker på att det är intentional för att ta bort en review punkt)
- saker som föreslår att ändra något som då går emot resten av kodbasen
- saker som faktiskt inte har ändrats i pr:et utan var pre-existing (om dom inte är viktiga att få med i reviewn ändå (typ riktiga buggar))
- duplicerade kommentarer (slå ihop dom)
- saker som pekar ut UTF-8 bom, vi har tester för det, behövs inte pr kommentarer
- kommentarer som pekar ut saker som faktiskt är bra
- pekar ut att en klass kan vara sealed
- säger något om commit messages, dom squashas ändå
- påpekar risk för nre när det inte är någon risk
- Om du gör några claims som går att verifiera genom att googla eller att skriva lite kod och testa så gör det
Ta inte bort kommentarer bara för att det är nitpicks eller bara är pyttelite bra.

Du kan allmänt också tänka att om koden verkar inkonsekvent med shared/standard-mönster — fråga dig själv varför och undersök innan du föreslår att ändra.

För alla punkter som föreslår någon form av refaktorisering/renaming/utbrytning.
Tänk igenom hur det skulle bli om vi gjorde den. Skulle det bli bättre?
Är det värt o göra (det gör inget om det tar lite tid men det är dåligt med mer abstraction utan att det blir bättre)? 

Se till att VERKLIGEN GÅ IGENOM KODEN NOGGRANT för VARJE KOMMENTAR där det behövs för att se att den verkligen är vettig.
Gå igenom dom EN I TAGET och verifiera koden och tänk på alla mina punkter.
Säg inte att du ska verifera "a few key items" VERIFIERA ALLT, en grej i taget, det här kan ta ett tag, det är bra.

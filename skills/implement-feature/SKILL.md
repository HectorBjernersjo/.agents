---
name: implement-feature
description: "HRM: bygg en feature från en beskrivning hela vägen till draft-PR med user story och demo. Inte för spec-flödet under docs/work, där används /implement."
argument-hint: "<beskrivning av featuren>"
disable-model-invocation: true
---

Hector beskriver en feature i en mening eller ett stycke. Du tar den till en
draft-PR utan att stanna på vägen. Han tittar på PR:en när du är klar, och
kör sen `/babysit-pr` själv.

Alltid ett PR, om Hector inte säger något annat.

## Steg

1. **Slug.** Hitta på en kort kebab-case-slug för featuren. Den används
   överallt: `features/<slug>`, och branchen `users/hebj01/<slug>`. Finns
   en Linear-issue för featuren börjar sluggen med dess id, `ai-123-<slug>`.

2. **Workspace.** `setup_worktree <slug>` och `corc cd ~/work/HRM/features/<slug>`.
   Reglerna i `~/work/HRM/AGENTS.md` gäller: `jj workspace update-stale`
   först, squasha per path in i rätt change, aldrig blankt `jj squash`.

3. **Bygg.** Använd `/tdd` där det finns en naturlig söm att testa mot. Kör
   testerna enligt `test-hrm`: Hectors två alltid, plus de testprojekt du
   rört, aldrig hela sviten.

4. **Verifiera i browsern** enligt `test-hrm`, om featuren har något att
   klicka på (UI eller chatbot). Ren backend verifieras av testerna, då är
   det slöseri att starta tre processer. Funkar inte featuren: stanna här
   och rapportera med skärmdump. Inget PR på trasig kod.

5. **Review.** Kör `/code-review` på diffen och åtgärda det som håller.

6. **User story.** Kör `create-user-story` och skapa storyn direkt, utan att
   vänta på godkännande. Spara id:t.

7. **PR.** Kör `create-pr`. Rör diffen synligt UI, spela in med
   `record-demo` och publicera med `pr-media` under `## Demo`. En gif av en
   oförändrad skärm säger inget, så hoppa över den för backend-ändringar.
   Undantaget är när Hector uttryckligen bett om "testa att chatboten
   fortfarande funkar", det är alltid ett klipp.

8. **Städa.** Stoppa de HRM-processer du startat.

## När du ska stanna i stället

- Featuren funkar inte i browsern och du ser inte varför.
- Under bygget visar det sig att det borde bli flera PR:s. Stanna innan story
  och PR och säg det, så bestämmer Hector hur det delas.
- Du behöver ett beslut som `~/work/HRM/AGENTS.md` säger att du ska fråga om,
  till exempel vilken feature en ändring hör hemma i.

## Rapport när du är klar

- Länk till PR:et.
- Länk till storyn, med change classification och risknivå så Hector ser om
  du valt fel.
- Vad du verifierade i browsern, eller att du inte behövde.
- Vilka tester du körde.
- Sista raden: "Kör /babysit-pr när du tittat."

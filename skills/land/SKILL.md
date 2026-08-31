---
name: land
description: Avsluta ett färdigt arbete. Lyft upp det som är värt att behålla till glossaryt och ADR:erna, radera sen arbetsmaterialet under docs/work/.
disable-model-invocation: true
---

Arbetsmaterialet under `docs/work/` raderas när arbetet landar, det markeras aldrig som klart. Den här skillen kör sista steget: mappen är tom på tickets, så bestäm vad som överlever och ta bort resten.

Kör den när sista ticketen i en feature mergas, eller sista featuren i ett större arbete.

## Process

1. **Bekräfta att det faktiskt är klart.** Alla tickets stängda (i trackern enligt `docs/agents/issue-tracker.md`, annars: alla ticket-filer borta), och arbetet mergat. Finns det tickets kvar, stanna och säg vilka.

2. **Läs mappen.** `grilling.md`, `spec.md`, `map.md`, avgjorda beslutstickets.

3. **Lyft upp det som överlever.** För varje beslut där inne, fråga: stämmer det fortfarande, och skulle en framtida agent misslyckas med att lista ut det från bara koden och testerna?

   - Nya eller vässade domäntermer: `docs/CONTEXT.md`
   - Beslut där *varför* inte syns i koden, särskilt förkastade alternativ som någon annars skulle prova igen: en ADR i `docs/adr/`

   Använd `/domain-modeling` för båda formaten. Var sträng: det mesta i en spec beskriver beteende som koden nu beskriver bättre. Ett beslut som koden gör självklart behöver ingen ADR.

4. **Visa användaren** vad du tänker skriva och vad du tänker radera, och vänta på ett ja.

5. **Radera**, efter godkännande:
   - mappen `docs/work/<slug>/` (eller bara undermappen `<feature-slug>/` om andra features i samma arbete fortfarande är igång)
   - `docs/prs/<branch-slug>/` för de mergade brancherna, men behåll `docs/prs/_review-index/`, det är historik över flera PR:s

Att radera är säkert: innehållet finns kvar i versionshistoriken under samma slug om någon nånsin behöver det. Att låta det ligga är inte säkert. En levererad spec som fortfarande ligger i `docs/work/` ser ut som planerat arbete, och nästa agent kommer försöka bygga den igen.

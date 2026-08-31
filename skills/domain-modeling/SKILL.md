---
name: domain-modeling
description: Bygg och vässa ett projekts domänmodell. Använd när ni diskuterar terminologi i kodbasen, skriver eller redigerar en docs/CONTEXT.md, eller skriver eller redigerar en ADR.
---

# Domänmodellering

Bygg och vässa projektets domänmodell aktivt medan du designar. Det här är den *aktiva* disciplinen: ifrågasätta termer, hitta på edge case-scenarier, och skriva ner ordlistan och besluten i samma stund de faller på plats. (Att bara *läsa* `docs/CONTEXT.md` för att hitta ordförråd är inte den här skillen. Det är en enradsvana vilken skill som helst kan ha. Den här skillen är för när du ändrar modellen, inte bara använder den.)

## Filstruktur

De flesta repon har en enda kontext:

```
/
├── docs/
│   ├── CONTEXT.md
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

Om det finns en `CONTEXT-MAP.md` i roten har repot flera kontexter. Kartan pekar ut var var och en bor:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   └── docs/
│   │       ├── CONTEXT.md
│   │       └── adr/                  ← context-specific decisions
│   └── billing/
│       └── docs/
│           ├── CONTEXT.md
│           └── adr/
```

Skapa filer lat, bara när du har något att skriva. Finns ingen `docs/CONTEXT.md`, skapa en när den första termen är utredd. Finns ingen `docs/adr/`, skapa den när den första ADR:en behövs.

## Under sessionen

### Ifrågasätt mot ordlistan

När användaren använder en term som krockar med språket som redan finns i `docs/CONTEXT.md`, säg till direkt. "Din ordlista definierar 'cancellation' som X, men du verkar mena Y. Vilket är det?"

### Vässa luddigt språk

När användaren använder vaga eller överlastade termer, föreslå en precis kanonisk term. "Du säger 'account'. Menar du Customer eller User? Det är olika saker."

### Diskutera konkreta scenarier

När domänrelationer diskuteras, stresstesta dem med specifika scenarier. Hitta på scenarier som prövar edge cases och tvingar användaren att vara precis om gränserna mellan begreppen.

### Stäm av mot koden

När användaren säger hur något fungerar, kolla om koden håller med. Hittar du en motsägelse, lyft den: "Din kod avbryter hela Orders, men du sa nyss att delvis avbokning är möjlig. Vilket stämmer?"

### Uppdatera docs/CONTEXT.md direkt

När en term är utredd, uppdatera `docs/CONTEXT.md` på en gång. Samla inte ihop dem, fånga dem när de händer. Använd formatet i [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`docs/CONTEXT.md` ska vara helt fri från implementationsdetaljer. Behandla den inte som en spec, ett kladdblock eller ett förråd för implementationsbeslut. Den är en ordlista och inget annat.

### Erbjud ADR:er sparsamt

Erbjud bara att skapa en ADR när alla tre stämmer:

1. **Svårt att ångra.** Kostnaden för att ändra sig senare är kännbar
2. **Förvånande utan sammanhang.** En framtida läsare kommer undra "varför gjorde de så här?"
3. **Resultatet av en riktig avvägning.** Det fanns verkliga alternativ och ni valde ett av specifika skäl

Saknas någon av de tre, hoppa över ADR:en. Använd formatet i [ADR-FORMAT.md](./ADR-FORMAT.md).

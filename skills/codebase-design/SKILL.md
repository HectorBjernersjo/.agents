---
name: codebase-design
description: Gemensamt ordförråd för att designa djupa moduler. Använd när användaren vill designa eller förbättra en moduls interface, hitta möjligheter att fördjupa, bestämma var en söm ska ligga, göra kod mer testbar eller lättare för AI att navigera, eller när en annan skill behöver vokabulären kring djupa moduler.
---

# Codebase design

Designa **djupa moduler** (deep modules): mycket beteende bakom ett litet interface, placerat vid en ren söm (seam), testbart genom det interfacet. Använd det här språket och de här principerna överallt där kod designas eller struktureras om. Målet är hävstång för anropare, lokalitet för de som underhåller, och testbarhet för alla.

## Ordlista

Använd exakt de här termerna. Byt inte ut dem mot "komponent", "service", "API" eller "boundary". Konsekvent språk är hela poängen.

**Modul** (module). Allt som har ett interface och en implementation. Medvetet skaloberoende: en funktion, klass, paket eller en skiva som spänner över flera lager. _Undvik_: enhet, komponent, service.

**Interface**. Allt en anropare måste veta för att använda modulen korrekt: typsignaturen, men också invarianter, ordningskrav, felfall, nödvändig konfiguration och prestandaegenskaper. _Undvik_: API, signatur (för smalt, de syftar bara på typnivån).

**Implementation**. Det som finns inuti en modul, dess kodkropp. Skilj från **Adapter**: en sak kan vara en liten adapter med en stor implementation (ett Postgres-repo) eller en stor adapter med en liten implementation (en in-memory fake). Säg "adapter" när sömmen är ämnet, "implementation" annars.

**Djup** (depth). Hävstång vid interfacet: mängden beteende en anropare (eller ett test) kan använda per enhet interface den måste lära sig. En modul är **djup** när mycket beteende sitter bakom ett litet interface, **grund** (shallow) när interfacet är nästan lika komplext som implementationen.

**Söm** (seam) _(Michael Feathers)_. En plats där du kan ändra beteende utan att redigera just där; *platsen* där en moduls interface ligger. Var sömmen ska ligga är ett eget designbeslut, skilt från vad som hamnar bakom den. _Undvik_: boundary (krockar med DDD:s bounded context).

**Adapter**. En konkret sak som uppfyller ett interface vid en söm. Beskriver *roll* (vilken lucka den fyller), inte innehåll (vad som finns inuti).

**Hävstång** (leverage). Det anropare får av djup: mer kapacitet per enhet interface de lär sig. En implementation betalar tillbaka över N anropsställen och M tester.

**Lokalitet** (locality). Det underhållare får av djup: ändringar, buggar, kunskap och verifiering samlas på ett ställe istället för att spridas över anroparna. Fixa en gång, fixat överallt.

## Djup mot grund

**Djup modul** = litet interface + mycket implementation:

```
┌─────────────────────┐
│   Small Interface   │  ← Few methods, simple params
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Complex logic hidden
│                     │
└─────────────────────┘
```

**Grund modul** = stort interface + lite implementation (undvik):

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Many methods, complex params
├─────────────────────────────────┤
│  Thin Implementation            │  ← Just passes through
└─────────────────────────────────┘
```

När du designar ett interface, fråga:

- Kan jag minska antalet metoder?
- Kan jag förenkla parametrarna?
- Kan jag gömma mer komplexitet inuti?

## Principer

- **Djup är en egenskap hos interfacet, inte implementationen.** En djup modul kan internt bestå av små, mockbara, utbytbara delar. De är bara inte en del av interfacet. En modul kan ha **interna sömmar** (privata för implementationen, används av dess egna tester) och dessutom den **externa sömmen** vid sitt interface.
- **Raderingstestet.** Tänk dig att du raderar modulen. Om komplexiteten försvinner var den en pass-through. Om komplexiteten dyker upp igen hos N anropare gjorde den nytta.
- **Interfacet är testytan.** Anropare och tester korsar samma söm. Vill du testa *förbi* interfacet har modulen förmodligen fel form.
- **En adapter betyder en hypotetisk söm. Två adaptrar betyder en riktig.** Inför ingen söm om inget faktiskt varierar över den.

## Designa för testbarhet

Bra interface gör testning naturlig:

1. **Ta emot beroenden, skapa dem inte.**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Returnera resultat, producera inte sidoeffekter.**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Liten yta.** Färre metoder = färre tester behövs. Färre parametrar = enklare testuppsättning.

## Relationer

- En **Modul** har exakt ett **Interface** (ytan den visar för anropare och tester).
- **Djup** är en egenskap hos en **Modul**, mätt mot dess **Interface**.
- En **Söm** är där en **Moduls** **Interface** ligger.
- En **Adapter** sitter vid en **Söm** och uppfyller **Interfacet**.
- **Djup** ger **Hävstång** för anropare och **Lokalitet** för underhållare.

## Förkastade formuleringar

- **Djup som kvoten implementationsrader genom interfacerader** (Ousterhout): belönar utfyllnad av implementationen. Vi använder djup-som-hävstång istället.
- **"Interface" som TypeScripts `interface`-nyckelord eller en klass publika metoder**: för smalt. Interface här omfattar varje fakta en anropare måste känna till.
- **"Boundary"**: krockar med DDD:s bounded context. Säg **söm** eller **interface**.

## Gå djupare

- **Fördjupa ett kluster givet dess beroenden**, se [DEEPENING.md](DEEPENING.md): beroendekategorier, sömdisciplin och testning enligt ersätt-istället-för-att-lagra.
- **Utforska alternativa interface**, se [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): starta parallella sub-agenter som designar interfacet på flera radikalt olika sätt, jämför sedan på djup, lokalitet och sömplacering.

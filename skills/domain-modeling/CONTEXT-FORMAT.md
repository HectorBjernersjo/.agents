# Format för docs/CONTEXT.md

## Struktur

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Regler

- **Ha åsikter.** När det finns flera ord för samma begrepp, välj det bästa och lista de andra under `_Avoid_`.
- **Håll definitionerna korta.** Max en eller två meningar. Definiera vad det ÄR, inte vad det gör.
- **Ta bara med termer som är specifika för det här projektets kontext.** Allmänna programmeringsbegrepp (timeouts, feltyper, utility-mönster) hör inte hemma här även om projektet använder dem mycket. Innan du lägger till en term, fråga: är det här ett begrepp unikt för den här kontexten, eller ett allmänt programmeringsbegrepp? Bara det förra hör hemma.
- **Gruppera termer under underrubriker** när naturliga kluster dyker upp. Om alla termer hör till ett enda sammanhängande område räcker en platt lista.

## Repon med en eller flera kontexter

**En kontext (de flesta repon):** En `docs/CONTEXT.md` i repot.

**Flera kontexter:** En `CONTEXT-MAP.md` i repots rot listar kontexterna, var de bor och hur de hänger ihop:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/docs/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/docs/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/docs/CONTEXT.md) — manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

Skillen listar ut vilken struktur som gäller:

- Finns `CONTEXT-MAP.md`, läs den för att hitta kontexterna
- Finns bara `docs/CONTEXT.md`, en kontext
- Finns ingen av dem, skapa `docs/CONTEXT.md` lat när den första termen är utredd

När det finns flera kontexter, lista ut vilken det aktuella ämnet hör till. Är det oklart, fråga.

# Bra och dåliga tester

## Bra tester

**Integrationsstil**: Testa genom riktiga gränssnitt, inte mockar av interna delar.

```typescript
// GOOD: Tests observable behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Kännetecken:

- Testar beteende som användare/anropare bryr sig om
- Använder bara det publika API:et
- Överlever interna refaktoreringar
- Beskriver VAD, inte HUR
- En logisk assertion per test

## Dåliga tester

**Tester av implementationsdetaljer**: Kopplade till intern struktur.

```typescript
// BAD: Tests implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Varningstecken:

- Mockar interna samarbetspartners
- Testar privata metoder
- Assertar på antal anrop eller ordning
- Testet går sönder vid refaktorering utan beteendeändring
- Testnamnet beskriver HUR, inte VAD
- Verifierar via externa vägar istället för genom gränssnittet

```typescript
// BAD: Bypasses interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD: Verifies through interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

**Tautologiska tester**: Det förväntade värdet upprepar implementationen, så testet passerar per konstruktion.

```typescript
// BAD: Expected value is recomputed the way the code computes it
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD: Expected value is an independent, known literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```

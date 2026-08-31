# När du ska mocka

Mocka bara vid **systemgränser**:

- Externa API:er (betalning, e-post osv.)
- Databaser (ibland, föredra en test-DB)
- Tid/slump
- Filsystem (ibland)

Mocka inte:

- Dina egna klasser/moduler
- Interna samarbetspartners
- Något du själv kontrollerar

## Designa för mockbarhet

Vid systemgränser, designa gränssnitt som är lätta att mocka:

**1. Använd dependency injection**

Skicka in externa beroenden istället för att skapa dem internt:

```typescript
// Easy to mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Föredra SDK-liknande gränssnitt framför generiska fetchers**

Skapa specifika funktioner för varje extern operation istället för en generisk funktion med villkorslogik:

```typescript
// GOOD: Each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// BAD: Mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK-upplägget innebär:
- Varje mock returnerar en specifik form
- Ingen villkorslogik i testuppsättningen
- Lättare att se vilka endpoints ett test använder
- Typsäkerhet per endpoint

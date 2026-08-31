# HTML-rapportens format

Arkitekturgranskningen renderas som en enda självständig HTML-fil i operativsystemets temp-katalog. Tailwind och Mermaid kommer båda från CDN. Mermaid hanterar grafformade diagram pålitligt; handbyggda divs och inline-SVG hanterar de mer redaktionella visualiseringarna (massdiagram, tvärsnitt). Blanda de två. Luta dig inte på Mermaid för allt, då börjar det se generiskt ut.

## Skelett

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* small custom layer for things Tailwind doesn't cover cleanly:
         dashed seam lines, hand-drawn-feeling arrow heads, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

Reponamn, datum och en kompakt förklaring: heldragen ruta = modul, streckad linje = söm, röd pil = läckage, tjock mörk ruta = djup modul. Inget inledande stycke. Rakt in på kandidaterna.

## Kandidatkort

Diagrammen bär tyngden. Prosan är sparsam, enkel och använder glossariumtermerna (från skillen `/codebase-design`) utan ceremoni.

Varje kandidat är en `<article>`:

- **Title**, kort, namnger fördjupningen (t.ex. "Collapse the Order intake pipeline").
- **Badge row**, rekommendationsstyrka (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), plus en tagg för beroendekategorin (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Files**, lista i monospace, `font-mono text-sm`.
- **Before / After diagram**, mittpunkten. Två kolumner, sida vid sida. Se mönstren nedan.
- **Problem**, en mening. Vad som gör ont.
- **Solution**, en mening. Vad som ändras.
- **Wins**, punkter, max 6 ord var. T.ex. "Tests hit one interface", "Pricing logic stops leaking", "Delete 4 shallow wrappers".
- **ADR callout** (om tillämpligt), en rad i en amber-tonad ruta.

Inga förklarande stycken. Om diagrammet behöver ett stycke för att förstås, rita om diagrammet.

## Diagrammönster

Välj det mönster som passar kandidaten. Blanda dem. Låt inte alla diagram se likadana ut. Variationen är en del av poängen.

### Mermaid-graf (arbetshästen för beroenden / anropsflöde)

Använd en Mermaid `flowchart` eller `graph` när poängen är "X anropar Y anropar Z, och titta på röran." Slå in den i ett Tailwind-stylat kort så att den inte känns fallskärmshoppad in. Styla med classDef för att färga läckagekanter röda och den djupa modulen mörk. Sekvensdiagram funkar bra för "före: 6 rundresor; efter: 1."

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Handbyggda rutor och pilar (när Mermaids layout bråkar med dig)

Moduler som `<div>`:ar med ramar och etiketter. Pilar som inline-SVG `<line>`- eller `<path>`-element absolut positionerade över en relativ container. Ta till detta när du vill att "efter"-diagrammet ska kännas som en enda tjockramad djup modul med nedtonade innanmäten. Mermaid renderar inte det med rätt tyngd.

### Tvärsnitt (bra för lagrad grundhet)

Stapla horisontella band (`h-12 border-l-4`) för att visa lagren ett anrop passerar genom. Före: 6 tunna lager som vart och ett inte gör något. Efter: 1 tjockt band märkt med det konsoliderade ansvaret.

### Massdiagram (bra för "interfacet lika brett som implementationen")

Två rektanglar per modul, en för interfacets yta, en för implementationen. Före: interface-rektangeln är nästan lika hög som implementations-rektangeln (grund). Efter: interface-rektangeln är kort, implementations-rektangeln är hög (djup).

### Kollaps av anropsgraf

Före: ett träd av funktionsanrop renderat som nästlade rutor. Efter: samma träd kollapsat till en ruta, med de nu interna anropen visade nedtonade inuti.

## Stilguide

- Redaktionellt snarare än corporate dashboard. Generöst med luft. Serif valfritt för rubriker (`font-serif` funkar bra med stone/slate).
- Färg sparsamt: en accent (emerald eller indigo) plus rött för läckage och amber för varningar.
- Håll diagrammen runt 320px höga så att före/efter sitter bekvämt sida vid sida utan scroll.
- Använd `text-xs uppercase tracking-wider` för moduletiketter inuti diagram. De ska läsas som schematiska, inte som UI.
- De enda scripten är Tailwind-CDN:en och Mermaid-ESM-importen. Rapporten är annars statisk. Ingen appkod, ingen interaktivitet utöver Mermaids egen rendering.

## Sektionen Top recommendation

Ett större kort. Kandidatens namn, en mening om varför, ankarlänk till dess kort. Det är allt.

## Ton

Vanlig prosa, koncist, men arkitekturens substantiv och verb kommer rakt från skillen `/codebase-design`. Koncishet är ingen ursäkt för att glida.

**Använd exakt:** modul, interface, implementation, djup, djup (adj.), grund, söm, adapter, hävstång, lokalitet.

**Byt aldrig ut mot:** component, service, unit (för modul) · API, signatur (för interface) · boundary (för söm) · layer, wrapper (för modul, när du menar modul).

**Formuleringar som passar stilen:**

- "Order intake-modulen är grund. Interfacet matchar nästan implementationen."
- "Pricing läcker över sömmen."
- "Fördjupa: ett interface, ett ställe att testa."
- "Två adapters motiverar sömmen: HTTP i prod, in-memory i tester."

**Wins-punkterna** namnger vinsten i glossariumtermer: *"lokalitet: buggarna koncentreras i en modul"*, *"hävstång: ett interface, N anropsställen"*, *"interfacet krymper; implementationen absorberar wrappersen"*. Skriv inte *"lättare att underhålla"* eller *"renare kod"*. De termerna finns inte i glossariet och förtjänar inte sin plats.

Ingen hedging, inget harklande, inget "det är värt att notera att…". Om en mening kan vara en punkt, gör den till en punkt. Om en punkt kan strykas, stryk den. Om en term inte finns i `/codebase-design`-glossariet, ta en som gör det innan du hittar på en ny.

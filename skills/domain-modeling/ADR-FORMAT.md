# ADR-format

ADR:er bor i `docs/adr/` och numreras löpande: `0001-slug.md`, `0002-slug.md`, osv.

Skapa katalogen `docs/adr/` lat, bara när den första ADR:en behövs.

## Mall

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

Det är allt. En ADR kan vara ett enda stycke. Värdet ligger i att dokumentera *att* ett beslut togs och *varför*, inte i att fylla i sektioner.

## Valfria sektioner

Ta bara med de här när de faktiskt tillför något. De flesta ADR:er behöver dem inte.

- **Status** i frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`), användbart när beslut omprövas
- **Considered Options**, bara när de förkastade alternativen är värda att komma ihåg
- **Consequences**, bara när icke-uppenbara följdeffekter behöver lyftas

## Numrering

Leta upp det högsta befintliga numret i `docs/adr/` och öka med ett.

## När du ska erbjuda en ADR

Alla tre måste stämma:

1. **Svårt att ångra.** Kostnaden för att ändra sig senare är kännbar
2. **Förvånande utan sammanhang.** En framtida läsare kommer titta på koden och undra "varför i hela friden gjorde de så här?"
3. **Resultatet av en riktig avvägning.** Det fanns verkliga alternativ och ni valde ett av specifika skäl

Om ett beslut är lätt att ångra, hoppa över det. Ni ångrar det bara. Om det inte är förvånande kommer ingen undra varför. Om det inte fanns något riktigt alternativ finns det inget att dokumentera utöver "vi gjorde det uppenbara".

### Vad som kvalificerar

- **Arkitekturens form.** "Vi kör monorepo." "Skrivmodellen är event-sourced, läsmodellen projiceras in i Postgres."
- **Integrationsmönster mellan kontexter.** "Ordering och Billing kommunicerar via domänhändelser, inte synkron HTTP."
- **Teknikval som ger inlåsning.** Databas, meddelandebuss, auth-leverantör, deploymål. Inte varje bibliotek, bara de som skulle ta ett kvartal att byta ut.
- **Gräns- och omfångsbeslut.** "Kunddata ägs av Customer-kontexten, andra kontexter refererar till den enbart via ID." De uttalade nej:en är lika värdefulla som ja:en.
- **Medvetna avsteg från den uppenbara vägen.** "Vi skriver SQL för hand istället för att använda en ORM eftersom X." Allt där en rimlig läsare skulle anta motsatsen. De här hindrar nästa utvecklare från att "fixa" något som var avsiktligt.
- **Begränsningar som inte syns i koden.** "Vi kan inte använda AWS på grund av compliance-krav." "Svarstider måste vara under 200ms på grund av avtalet med partner-API:et."
- **Förkastade alternativ när förkastandet inte är uppenbart.** Om ni övervägde GraphQL och valde REST av subtila skäl, skriv ner det. Annars föreslår någon GraphQL igen om sex månader.

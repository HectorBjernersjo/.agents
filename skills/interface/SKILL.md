---
name: interface
description: "Skapa en markdown-fil som beskriver en moduls interface"
disable-model-invocation: true
---

Analysera den valda modulen, hur den fungerar, var den används och framför allt dess interface.
Om modulen är en enda fil, skapa {filnamn utan filändelse}.interface.md
Om det är en mapp, skapa bara interface.md inuti den mappen.

Målet med filen är att beskriva modulens publika interface och all information som krävs för att använda den.
Det är för att jag ska kunna förstå kodbasen och granska den bättre utan att läsa varje fil.

Ta med kodblock som bara innehåller interfacen, som en interface-klass i C#, men utan implementationen. Under interfacet, ta med andra typer som i praktiken är en del av interfacet (som input- och output-structs).
Förklara också funktionerna i interfacet. Om det finns submoduler kan de få egna kodblock och egna förklaringar under sin rubrik, men håll varje klass (eller motsvarande) i ett kodblock.
Feltyper behöver inte tas med, men saker som configs, results och request-typer bör oftast vara med.

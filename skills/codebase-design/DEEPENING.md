# Fördjupning

Hur du på ett säkert sätt fördjupar ett kluster av grunda moduler, givet dess beroenden. Förutsätter ordförrådet i [SKILL.md](SKILL.md): **modul**, **interface**, **söm**, **adapter**.

## Beroendekategorier

När du bedömer en kandidat för fördjupning, klassificera dess beroenden. Kategorin avgör hur den fördjupade modulen testas över sin söm.

### 1. In-process

Ren beräkning, tillstånd i minnet, ingen I/O. Går alltid att fördjupa. Slå ihop modulerna och testa direkt genom det nya interfacet. Ingen adapter behövs.

### 2. Lokalt utbytbara

Beroenden som har lokala ersättare för test (PGLite för Postgres, filsystem i minnet). Går att fördjupa om ersättaren finns. Den fördjupade modulen testas med ersättaren igång i testsviten. Sömmen är intern, ingen port vid modulens externa interface.

### 3. Fjärr men egen (Ports & Adapters)

Dina egna tjänster över en nätverksgräns (microservices, interna API:er). Definiera en **port** (interface) vid sömmen. Den djupa modulen äger logiken, transporten injiceras som en **adapter**. Tester använder en in-memory-adapter. Produktion använder en HTTP/gRPC/kö-adapter.

Rekommendationens form: *"Definiera en port vid sömmen, implementera en HTTP-adapter för produktion och en in-memory-adapter för test, så att logiken ligger i en djup modul även om den deployas över ett nätverk."*

### 4. Riktigt externa (mock)

Tredjepartstjänster (Stripe, Twilio osv.) du inte kontrollerar. Den fördjupade modulen tar det externa beroendet som en injicerad port, tester skickar in en mock-adapter.

## Sömdisciplin

- **En adapter betyder en hypotetisk söm. Två adaptrar betyder en riktig.** Inför ingen port om inte minst två adaptrar är motiverade (typiskt produktion + test). En söm med en enda adapter är bara indirektion.
- **Interna sömmar mot externa sömmar.** En djup modul kan ha interna sömmar (privata för implementationen, används av dess egna tester) och dessutom den externa sömmen vid sitt interface. Exponera inte interna sömmar genom interfacet bara för att tester använder dem.

## Teststrategi: ersätt, lagra inte

- Gamla unit tests på grunda moduler blir skräp när det finns tester vid den fördjupade modulens interface. Radera dem.
- Skriv nya tester vid den fördjupade modulens interface. **Interfacet är testytan.**
- Tester gör assertions på observerbara utfall genom interfacet, inte på internt tillstånd.
- Tester ska överleva interna refactors. De beskriver beteende, inte implementation. Om ett test måste ändras när implementationen ändras testar det förbi interfacet.

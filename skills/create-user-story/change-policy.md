# Local - Change Management & Secure Development Lifecycle (SDLC)

Policy DEV-POL-03, version 1.3, status Active, klassning Internal.
Ansvarig: Björn Lindqvist. Granskad av: Oskar Anderstål. Godkänd av: Jane Lundgren Ericsson. Senast granskad 2026-02-04.

Referenskopia för `/create-user-story`. Avsnitt 3 och 5 är de som styr fälten på en user story.

## 1. Syfte
Det här dokumentet definierar de obligatoriska kontrollerna för att testa och deploya ändringar till produktion. Det ser till att all utveckling är säker, effektiv och följer standarder som ISO 27001.

## 2. Omfattning
Policyn gäller alla ändringar som påverkar Flex HRM:s produktionsmiljö.

Tillämplighet: obligatorisk för all personal på avdelningen Product & Development, inklusive heltidsanställda, deltidsanställda och externa parter (konsulter och underleverantörer) som har tillgång till Flex HRM:s kodbas eller infrastruktur.

Omfattade tillgångar:
- Applikationskod: all källkod, alla script och artefakter (paket) som ska till produktion.
- Infrastruktur: Azure-resurser och konfiguration som hanteras via Infrastructure as Code (Terraform).
- Databas: schemamigreringar och ändringar av datastrukturer.
- Beroenden: alla tredjepartsbibliotek, ramverk och API:er.

Livscykelfaser: omfattningen täcker hela livscykeln, från kravplanering och riskanalys till deploy och löpande drift.

## 3. Change classification och auktorisering
Auktorisering av ändringar är inbyggd i CI/CD-pipelinen. För Standard och Normal Change ges auktoriseringen automatiskt när peer review och alla automatiska pipeline-gates har gått igenom. Under reviewen ansvarar reviewern för att verifiera att ändringen är rätt klassad.

| Klassning | Definition | Krav för auktorisering |
|---|---|---|
| Standard Change | Rutinändring med låg risk som följer etablerade rutiner. | Peer review + CI/CD-pipeline som går igenom. |
| Normal Change | Planerad ändring som påverkar säkerhet, data eller central affärslogik. | CI/CD som går igenom, peer review, 5x5-riskmatris (STRIDE obligatoriskt vid High/Critical risk). |
| Emergency Change (Hotfix) | Oplanerad ändring som krävs för att återställa tjänsten eller begränsa P1-påverkan. | Riskanalys, peer review, retrospektiv post-mortem. |

### 3.1 Beslutslogik och kriterier
Använd den här logiken för att avgöra klassningen och se vad som triggar varje kategori. Använd "No Change" för backlog-items eller tasks som inte innebär någon deploy till produktion eller ändring av produktionsmiljön.

Steg 1: Återställer det här tjänsten vid en P1-incident?
- JA → Emergency Change (Hotfix). Exempel: produktion är nere, lönekörningen är felaktig, ett aktivt exploit har upptäckts, persondataincident/intrång.

Steg 2: Avgör om det är Normal eller Standard. Om svaret på steg 1 är NEJ, rör ändringen NÅGOT av de här områdena?
- Databas: schemaändringar, migreringar, nya tabeller eller ändrade kolumner.
- Säkerhet: autentisering, auktorisering (RBAC), kryptering eller nyckelhantering.
- Data: hantering, lagring eller överföring av PII eller känslig data (t.ex. löneuppgifter, sjukfrånvaro, anställdinformation).
- Kritiska beräkningar och legal compliance: ändringar i logik som påverkar löneberäkningar, juridisk ställning eller anställningslivscykeln (onboarding/avslut).
- Externt: inkommande/utgående API:er eller tredjepartsintegrationer.
- Infra: deploy-pipelines, miljökonfiguration eller nya NuGet/NPM-beroenden.
- Omfattning: påverkar flera moduler eller cross-cutting concerns.

JA på NÅGON → Normal Change. NEJ på ALLA → Standard Change.

## 4. Secure SDLC-processen

### 4.1 Plan (krav och initiering)
- Initiering av ändring: ändringar initieras utifrån affärskrav som är dokumenterade i produktbacklogen.
- Teambaserat godkännande: rätten att gå vidare med en ändring ägs av respektive utvecklingsteam. Genom att flytta ett Work Item in i en aktiv sprint eller till "In Progress" bekräftar teamet att kraven är förstådda och i linje med "Definition of Done".
- Work Items: alla ändringar måste vara kopplade till ett spårat Work Item.
- Riskanalys för Normal och Emergency Change: en 5x5-riskmatris (se avsnitt 14) tillämpas på varje Work Item (bedömer påverkan på säkerhet, stabilitet och affär).
- Standard Change: undantagna från individuell riskmatris eftersom de är förhandsgodkända rutinaktiviteter med låg risk.
- Critical risk (threat modeling): för Normal Change där riskanalysen landar på Critical är en formell threat model (med STRIDE) obligatorisk. Fynd och åtgärder ska dokumenteras i Work Itemet.
- DRP-påverkan: alla ändringar som bedöms påverka Disaster Recovery Plan (DRP) ska formellt anmälas till Team Platform & Operations (Team PAO) under planeringsfasen.

### 4.2 Code (utveckling och review)
- Branch-policies: direkta commits till main är förbjudna, och force push är avstängt.
- Peer review och funktionell validering: varje produktionsändring kräver godkännande från minst två behöriga människor, varav en oberoende reviewer som inte är ändringens ursprungliga författare eller initiativtagare. Peer review är den primära tekniska och funktionella godkännandepunkten. Den oberoende reviewern ansvarar för:
  - Säkerhet och kodkvalitet: att koden uppfyller kraven på säkerhet och prestanda.
  - Kravverifiering: att koden faktiskt implementerar kraven i det länkade Work Itemet (fungerar som intern User Acceptance-verifiering).
  - Ansvar: att bekräfta att ingen enskild person kan både skapa och godkänna en ändring in i en skyddad branch.
  - Validering av klassning: reviewern måste uttryckligen validera att change classification är korrekt. Om en ändring är markerad som "Standard" men rör områden som borde klassa den som Normal, ska reviewern underkänna klassningen och kräva flödet för "Normal" Change.
- Standarder: koden ska följa riktlinjerna i OWASP Top 10.
- SAST: automatisk statisk analys körs dagligen.
- DAST: dynamisk analys körs veckovis mot Stage-miljön.

### 4.3 Build och test (verifiering)
CI-pipeline: pipelinen tvingar fram teknisk efterlevnad genom att kräva lyckad kompilering, unit tests och integrationstester innan en ändring kan gå vidare.

### 4.4 Beroenden (supply chain)
- Pakethanterare: hanteras via NuGet eller NPM.
- Scanning (SCA): automatisk Software Composition Analysis scannar alla tredjepartsbibliotek.
- SBOM-underhåll: en Software Bill of Materials genereras och underhålls automatiskt via SCA-verktyget.
- Policyefterlevnad: varje beroende måste följa Flex HRM Third-Party Policy.
- Sårbarhetshantering: High/Critical-fynd åtgärdas med högsta prioritet så snart som möjligt.
- Licensefterlevnad: "copyleft"-licenser (t.ex. GPL) är förbjudna.

### 4.5 Deploy (release)
- Artefakter: en strikt versionerad artefakt skapas för varje releasecykel.
- Innehåll: artefakten innehåller alla pull requests som mergats sedan förra releasen.
- Promotion: deploy till Dev -> Stage (smoke tests) -> Production.
- Automatisk kontroll: pipelinen förhindrar ensidiga deploys. Kod kan inte nå produktion utan att uppfylla kraven på peer review och CI/CD.
- Transparens: release notes publiceras automatiskt på https://www.flexhrm.com/release-notes.

### 4.6 Databashantering och dataskydd
- Automatisering: schemaändringar hanteras via FluentMigrator i pipelinen.
- Dataskydd (testmiljöer): Dev- och Stage-miljöerna använder enbart mockad eller syntetisk data.
- Åtkomst: utvecklare har ingen direkt åtkomst (läs/skriv) till produktionsdata.
- Privilegierad åtkomst: Team PAO har begränsad åtkomst skyddad av MFA och nätverks-/VPN-restriktioner.

## 5. Definition of Done
Obligatoriska kontroller för varje ändring. Både automatiska gates som Azure DevOps tvingar fram och manuella verifieringssteg som utvecklaren eller leadet gör.

| Krav | Beskrivning |
|---|---|
| Spårbarhet | Obligatoriskt länkat Work Item för varje pull request (PR). |
| Fyra ögon-principen | Peer review krävs, minst 1 godkännande per PR. |
| Automatisk validering | Build-validering (kompilering) krävs på PR-nivå. |
| Automatisk verifiering | Unit- och integrationstestsviterna går igenom. |
| Kommentarer lösta | Alla peer review-kommentarer ska vara markerade som "Resolved" innan merge. |
| Change Classification | Fältet "Change Classification" måste vara ifyllt på User Storyn. |
| Riskbedömning | 5x5-riskmatris + motivering krävs för Normal/Emergency Change. |
| Funktionell verifiering | Manuell eller lokal verifiering (unit, integration eller e2e) av alla acceptanskriterier. |
| Säker kod | Följer OWASP best practices för skydd mot vanliga sårbarheter. |
| Hemligheter | Verifierat att inga secrets, API-nycklar eller credentials finns i källkoden. |
| Dokumentation | All relaterad dokumentation är uppdaterad så att den speglar ändringarna. |

## 6. Infrastruktur (IaC)
Infrastrukturändringar (Terraform) följer det vanliga SDLC-flödet (Work Item -> PR -> CI/CD).

## 7. Rollback och återställning
- Omedelbar åtgärd (Azure Portal): medlemmar i Team PAO får manuellt gå tillbaka till föregående stabila version via Azure Portal vid brådskande återställning.
- Standardmetod roll-forward (CI/CD-pipeline): standardmetoden för både kritiska och icke-kritiska problem. Innebär att en commit revertas eller en fix läggs på, följt av automatisk deploy av ett nytt paket.
- Omdeploy av tidigare version: Azure DevOps kan användas för att trigga om en deploy av en specifik tidigare stabil artefakt.
- Verifiering: varje rollback eller roll-forward måste genomgå smoke tests i Stage-miljön.

## 8. Drift (övervakning)
- Telemetri: Azure Monitor följer prestanda och fel.
- Säkerhet: GSOC/SIEM övervakar avvikelser.
- Support: Team PAO har jour dygnet runt.

## 9. Nödprocedur (hotfix)
- Trigger: endast P1-incidenter.
- Auktorisering: Development Manager måste uttryckligen godkänna alla avsteg från den ordinarie releasecykeln.
- Post-mortem: Work Item, riskanalys och RCA skapas inom 1 arbetsdag.

## 10. Identitet och åtkomst
- Identitetsleverantör: Microsoft Entra ID styr all åtkomst.
- MFA: krävs för alla användare.
- Offboarding: åtkomst dras in när anställningen avslutas.

## 11. Kvalitetssäkring och kompetens
- Penetrationstest: görs årligen av en extern leverantör.
- Utbildning: utvecklare går kvartalsvis Secure Coding-utbildning (Q1-Q4) via Secure Code Warrior, med fokus på OWASP Top 10.

## 12. Kontinuitet och disaster recovery
- DRP-uppföljning: Disaster Recovery Plan granskas och uppdateras varje kvartal.
- Ansvar: Team PAO leder kvartalsgranskningen, tabletop-övningar och regelbundna DR-övningar. Beskrivs i DRP-dokumentationen.

## 13. Dokumentation och lagring
För att uppfylla ISO 27001:s krav på bevis sparas följande i minst 1 år:
- Work Items: inklusive krav, riskanalys och tillhörande dokumentation.
- Peer reviews: fullständig historik över godkännanden och kommentarer.
- Deploy-bevis: releaser sparas i 1 år i CI/CD-plattformen.

Not om lagring av releaser: från och med 2026-Q2 har lagringstiden för releaser förlängts till 1 år för att matcha revisionskraven. Före det datumet gällde en kortare lagringstid.

Not om release-artefakter: releaser sparas i 1 år medan binära artefakter (paket) tas bort för att spara lagringsutrymme. Miljön har reproducerbara builds och full versionering i GIT, så historiska paket kan genereras vid behov. På grund av begränsningar i bakåtkompatibilitet är rollbacks normalt begränsade till föregående stabila version (N-1).

## 14. Bilaga: riskmatris
Används för riskanalys av Normal och Emergency Change.

Sannolikhetsskala:
- Rare: förväntas inte inträffa.
- Unlikely: förväntas inte, men möjligt under exceptionella omständigheter.
- Possible: kan inträffa någon gång.
- Likely: det finns en stark möjlighet att händelsen inträffar inom en snar framtid.
- Almost Certain: inträffar sannolikt snart och ofta.

Konsekvensskala (impact):
- Negligible: mycket små konsekvenser som inte stör normal drift.
- Minor: kan ge en liten störning, men lätt att hantera och återhämta sig från.
- Moderate: ger en märkbar störning eller skada. Kan kräva extra resurser för återställning.
- Major: betydande störning, skada eller ekonomisk förlust. Återställning är svår/tidskrävande.
- Catastrophic: extrem störning, långvarig skada eller stor ekonomisk förlust. Återställning kan vara omöjlig.

## 15. Ändringslogg

| Datum | Version | Namn | Ändring |
|---|---|---|---|
| 2026-02-04 | 1.0 | Oskar Anderstål (Development Manager) | Första dokumentationen av vår nuvarande SDLC och change management. |
| 2026-03-06 | 1.1 | Oskar Anderstål (Development Manager) | Ändrade DAST-scanningar från dagligen till veckovis för att spegla verkligheten. |
| 2026-03-20 | 1.2 | Oskar Anderstål (Development Manager) | Lade till klassningen "No Change" eftersom vissa user stories (work items) inte är formella ändringar. Lade till ett nytt avsnitt för Definition of Done. |
| 2026-03-23 | 1.3 | Oskar Anderstål (Development Manager) | Peer review kräver nu godkännande från minst två människor, varav en oberoende reviewer som inte är författare/initiativtagare. Tog bort information om AI-review. |

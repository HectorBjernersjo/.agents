# Local - Change Management & Secure Development Lifecycle (SDLC)

Policy DEV-POL-03, version 1.3, status Active, classification Internal.
Responsible: Björn Lindqvist. Reviewed by: Oskar Anderstål. Approved by: Jane Lundgren Ericsson. Last review 2026-02-04.

Referenskopia för `/create-user-story`. Avsnitt 3 och 5 är de som styr fälten på en user story.

## 1. Purpose
This document defines the mandatory controls for testing and deploying production changes. It ensures all development is secure, efficient, and compliant with standards like ISO 27001.

## 2. Scope
This policy applies to all changes affecting the Flex HRM production environment.

Applicability: mandatory for all personnel within the Product & Development department, including full-time employees, part-time staff, and external parties (consultants and contractors) who have access to the Flex HRM codebase or infrastructure.

Asset scope:
- Application Code: all source code, scripts, and artifacts (packages) destined for production.
- Infrastructure: Azure resources and configurations managed via Infrastructure as Code (Terraform).
- Database: schema migrations and data structure changes.
- Dependencies: all 3rd-party libraries, frameworks, and APIs.

Lifecycle phases: the scope covers the entire lifecycle from requirements planning and risk analysis to deployment and ongoing operations.

## 3. Change Classification & Authorization
Authorization for changes is integrated into the CI/CD pipeline. For Standard and Normal changes, authorization is intrinsically granted upon the successful completion of Peer Review and all automated pipeline gates. During the review process, the reviewer is responsible for verifying that the change is classified correctly.

| Classification | Definition | Authorization requirements |
|---|---|---|
| Standard Change | Low-risk, routine change following established procedures. | Peer Review + CI/CD Pipeline Pass. |
| Normal Change | Planned change impacting security, data, or core business logic. | CI/CD pass, Peer Review, 5x5 Risk Matrix (STRIDE mandatory if High/Critical risk). |
| Emergency Change (Hotfix) | Unplanned change required to restore service or mitigate P1 impact. | Risk Analysis, Peer Review, Retrospective Post-Mortem. |

### 3.1 Decision Logic & Criteria
Use this logic to determine the change classification and view the specific triggers for each category. Use "No Change" for backlog items or tasks that do not involve a deployment to production or modification of the production environment.

Step 1: Is this restoring service for a P1 incident?
- YES → Emergency Change (Hotfix). Examples: production is down; payroll run is incorrect; active exploit discovered; personal data incident/breach.

Step 2: Determine if Normal or Standard. If the answer to Step 1 is NO, does it touch ANY of these areas?
- Database: schema changes, migrations, new tables, or column modifications.
- Security: authentication, authorization (RBAC), encryption, or key management.
- Data: handling, storage, or transmission of PII or sensitive data (e.g., salary details, sick leave, employee information).
- Critical Calculations & Legal Compliance: changes to logic that impact salary calculations, legal standings or employment lifecycle (onboarding/termination).
- External: inbound/outbound APIs or third-party integrations.
- Infra: deployment pipelines, environment configuration, or new NuGet/NPM dependencies.
- Scope: affects multiple modules or cross-cutting concerns.

If YES to ANY → Normal Change. If NO to ALL → Standard Change.

## 4. The Secure SDLC Process

### 4.1 Plan (Requirements & Initiation)
- Change Initiation: changes are initiated based on business requirements documented in the product backlog.
- Team-Based Approval: authorization to proceed with a change is owned by the respective development team. By moving a Work Item into an active sprint or "In Progress" state, the team acknowledges that requirements are understood and aligned with the "Definition of Done."
- Work Items: all changes must be linked to a tracked Work Item.
- Risk Analysis for Normal & Emergency Changes: a 5x5 Risk Matrix (see section 14) is applied to every Work Item (assessing Security, Stability, and Business impact).
- Standard Changes: exempt from individual risk matrix application as they are pre-approved low-risk routine activities.
- Critical Risk (Threat Modeling): for Normal Changes where the Risk Analysis result is Critical, a formal Threat Model (using STRIDE) is mandatory. Findings and mitigations must be documented in the Work Item.
- DRP Impact: any change identified as impacting the Disaster Recovery Plan (DRP) must be formally notified to Team Platform & Operations (Team PAO) during the planning phase.

### 4.2 Code (Development & Review)
- Branch Policies: direct commits to main are prohibited, also force push is disabled.
- Peer Review & Functional Validation: every production change requires approval from at least two authorized humans, including one independent reviewer who is not the original author or initiator of the change. Peer review serves as the primary technical and functional approval gate. The independent reviewer is responsible for:
  - Security & Code Quality: ensuring the code meets security and performance standards.
  - Requirement Verification: validating that the code accurately implements the requirements defined in the linked Work Item (serving as the internal User Acceptance verification).
  - Accountability: confirming that no single individual has the ability to both create and approve a change into a protected branch.
  - Classification Validation: the reviewer must explicitly validate that the change classification is correct. If a change is marked as "Standard" but affects areas that should classify the change as Normal, the reviewer must reject the classification and enforce the "Normal" change workflow.
- Standards: code must adhere to OWASP Top 10 guidelines.
- SAST: automated static analysis is performed daily.
- DAST: dynamic analysis is executed weekly against the Stage environment.

### 4.3 Build & Test (Verification)
CI Pipeline: the pipeline enforces technical compliance by requiring successful compilation, Unit Tests, and Integration Tests before any change is eligible for promotion.

### 4.4 Dependencies (Supply Chain)
- Package Managers: managed via NuGet or NPM.
- Scanning (SCA): automated Software Composition Analysis scans all third-party libraries.
- SBOM Maintenance: a Software Bill of Materials is automatically generated and maintained via the SCA tool.
- Policy Compliance: every dependency must comply with the Flex HRM Third-Party Policy.
- Vulnerability Handling: High/Critical findings are remediated with the highest priority as soon as possible.
- License Compliance: "Copyleft" (e.g., GPL) licenses are prohibited.

### 4.5 Deploy (Release)
- Artifacts: a strictly versioned artifact is created for every release cycle.
- Contents: the artifact includes all Pull Requests merged since the previous release.
- Promotion: Deploy to Dev -> Stage (Smoke Tests) -> Production.
- Automated Enforcement: the pipeline prevents unilateral deployments; code cannot reach production without satisfying the Peer Review and CI/CD requirements.
- Transparency: release notes are automatically published to https://www.flexhrm.com/release-notes.

### 4.6 Database Management & Data Protection
- Automation: schema changes are managed via FluentMigrator in the pipeline.
- Data Protection (Test Environments): Dev and Stage environments strictly use mocked or synthetic data.
- Access: developers have no direct access (Read/Write) to production data.
- Privileged Access: Team PAO has restricted access protected by MFA and Network/VPN restrictions.

## 5. Definition of Done
Mandatory checks for every change. Both automated gates enforced by Azure DevOps and manual verification steps performed by the Developer or Lead.

| Requirement | Description |
|---|---|
| Traceability | Mandatory linked Work Item for every Pull Request (PR). |
| Four-Eyes Principle | Peer Review enforced; minimum 1 required approval per PR. |
| Automated Validation | Build validation (compilation) enforced on PR level. |
| Automated Verification | Successful completion of Unit and Integration test suites. |
| Comment resolution | All Peer Review comments must be marked as "Resolved" before merging. |
| Change Classification | "Change Classification" field must be populated on the User Story. |
| Risk Assessment | 5x5 Risk Matrix + justification required for Normal/Emergency changes. |
| Functional Verification | Manual or local verification (unit, integration, or e2e) of all acceptance criteria. |
| Secure Coding | Adherence to OWASP best practices to protect against common vulnerabilities. |
| Secret Management | Verification that no secrets, API keys, or credentials are included in the source code. |
| Documentation | Any related documentation has been updated to reflect the changes. |

## 6. Infrastructure (IaC)
Infrastructure changes (Terraform) follow the standard SDLC flow (Work Item -> PR -> CI/CD).

## 7. Rollback & Recovery
- Immediate Remediation (Azure Portal): members of Team PAO are authorized to manually revert to the previous stable version via the Azure Portal for urgent restoration.
- Standard Roll-forward (CI/CD Pipeline): the standard method for both critical and non-critical issues. Involves reverting a commit or applying a fix, followed by automated deployment of a new package.
- Re-deployment of Previous Version: Azure DevOps can be used to re-trigger a deployment of a specific previous stable artifact.
- Verification: any rollback or roll-forward must undergo Smoke Tests in the Stage environment.

## 8. Operate (Monitoring)
- Telemetry: Azure Monitor tracks performance and errors.
- Security: GSOC/SIEM monitors for anomalies.
- Support: Team PAO maintains a 24/7 On-Call rotation.

## 9. Emergency Procedure (Hotfix)
- Trigger: P1 Incidents only.
- Authorization: Development Manager must explicitly approve any deviation from the standard release cycle.
- Post-Mortem: Work Item, Risk Analysis, and RCA created within 1 business day.

## 10. Identity & Access
- Identity Provider: Microsoft Entra ID governs all access.
- MFA: enforced for all users.
- Offboarding: access revoked upon termination.

## 11. Assurance & Competence
- Penetration Test: performed annually by a third-party vendor.
- Training: developers undergo quarterly Secure Coding training (Q1-Q4) via Secure Code Warrior, focusing on the OWASP Top 10.

## 12. Business Continuity & Disaster Recovery
- DRP Alignment: the Disaster Recovery Plan is reviewed and updated every quarter.
- Responsibility: Team PAO leads the quarterly review, tabletop exercise and regular DR drills. Detailed in the DRP documentation.

## 13. Records & Retention
To satisfy ISO 27001 evidence requirements, the following records are retained for a minimum period of 1 year:
- Work Items: including requirements, risk analysis, and associated documentation.
- Peer Reviews: full history of approvals, comments.
- Deployment Evidence: releases are retained for 1 year within the CI/CD platform.

Note on Release Retention: effective as of 2026-Q2, the retention policy for releases has been extended to 1 year to align with audit requirements. Prior to this date, a shorter retention period was in place.

Note on Release Artifacts: releases are retained for 1 year while binary artifacts (packages) are removed to optimize storage. The environment maintains Reproducible Builds and full versioning within GIT, allowing for the generation of historical packages if required. Due to backward compatibility constraints, rollbacks are typically limited to the previous stable version (N-1).

## 14. Appendix: Risk Assessment Matrix
Used for Risk Analysis of Normal and Emergency changes.

Likelihood scale:
- Rare: not expected to occur.
- Unlikely: not expected, but possible in exceptional circumstances.
- Possible: could occur at some point.
- Likely: there is a strong possibility that the event will occur in the near future.
- Almost Certain: likely to occur soon and often.

Consequence (impact) scale:
- Negligible: very minor consequences that would not disrupt normal operations.
- Minor: could result in a small disruption, but easy to manage and recover from.
- Moderate: would cause a noticeable disruption or harm; might require extra resources to recover.
- Major: significant disruption, harm, or financial loss. Recovery is challenging/time-consuming.
- Catastrophic: extreme disruption, long-term harm, or major financial loss. Recovery might be unattainable.

## 15. Change Log

| Date | Version | Name | Change |
|---|---|---|---|
| 2026-02-04 | 1.0 | Oskar Anderstål (Development Manager) | Initial documentation of our current SDLC & Change management. |
| 2026-03-06 | 1.1 | Oskar Anderstål (Development Manager) | Changed from daily to weekly for DAST-scans to reflect reality. |
| 2026-03-20 | 1.2 | Oskar Anderstål (Development Manager) | Added Change Classification "No Change" since some user stories (work items) are no formal changes. Added a new section for Definition of Done. |
| 2026-03-23 | 1.3 | Oskar Anderstål (Development Manager) | Peer review now requires approval from at least two humans, including one independent reviewer who is not the author/initiator. Removed information about AI-review. |

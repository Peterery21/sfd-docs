# ERP-SFD — Matrice des dépendances Maven

> Ordre de build et consommation des librairies SFD.

---

## Librairies SFD (Layer 0–1)

| Artifact | Type | Version typique | Déployé |
|----------|------|-----------------|---------|
| `sfd-integration-api` | Lib REST | 1.0.1-SNAPSHOT | Nexus |
| `sfd-report-api` | Lib rapports | 1.0.2-SNAPSHOT | Nexus |
| `sfd-demo-data` | Lib démo UEMOA | 1.0.0-SNAPSHOT | Nexus |

### Ordre build Layer 0–1

```bash
cd sfd-integration-api && ./mvnw clean install -DskipTests
cd sfd-demo-data      && ./mvnw clean install -DskipTests
cd sfd-report-api     && ./mvnw clean install -DskipTests
```

`sfd-report-api` dépend de `sfd-integration-api`.

---

## Consommation par microservice

| Service | integration-api | report-api | demo-data |
|---------|:---------------:|:----------:|:---------:|
| sfd-commun-service | ✓ | ✓ | ✓ |
| sfd-client-service | ✓ | ✓ | ✓ |
| sfd-epargne-service | ✓ | ✓ | ✓ |
| sfd-caisse-service | ✓ | ✓ | ✓ |
| sfd-comptabilite-service | ✓ | ✓ | ✓ |
| sfd-credit-service | ✓ | ✓ | ✓ |
| sfd-rh-service | ✓ | ✓ | ✓ |
| sfd-paie-service | ✓ | ✓ | ✓ |
| sfd-stock-service | ✓ | ✓ | ✓ |
| sfd-budget-service | ✓ | — | ✓ |
| sfd-transfert-service | ✓ | — | ✓ |
| sfd-immobilisation-service | ✓ | — | ✓ |
| sfd-commercial-service | ✓ | — | ✓ |
| sfd-suivi-evaluation-service | ✓ | — | ✓ |
| sfd-reporting-service | ✓ | — | ✓ |
| sfd-agent-mobile-service | ✓ | — | ✓ |
| sfd-portail-client-service | — | — | — |
| sfd-erp-monolith | ✓ | — | — |

---

## Librairies Kodzotech/Evoltica (via pom.xml services)

| Artifact | Package | Usage |
|----------|---------|-------|
| `security-oauth2` | `com.kodzotech.authentification` | JWT, rôles, login |
| `notification-api` | `com.kodzotech.notification` | Email/SMS |
| `activity-tracking-starter` | `com.evoltica.audit` | Audit JPA + business |
| `number-generator-api` | `com.kodzotech.numbergenerator` | Séquences |
| `fileupload-api` | `com.kodzotech.fileupload` | Photos, documents |
| `paiement-api` | `com.kodzotech.paiementapi` | Gateways paiement (selon modules) |

Import central : `@Import` dans `AppConfig.java` ou `MonolithAppConfig.java`.

Détail : [EXTERNAL_LIBS.md](EXTERNAL_LIBS.md)

---

## Monolithe — thin JARs agrégés

[`sfd-erp-monolith/pom.xml`](../sfd-erp-monolith/pom.xml) dépend de :

```
sfd-commun-service, sfd-client-service, sfd-epargne-service,
sfd-caisse-service, sfd-comptabilite-service, sfd-credit-service,
sfd-immobilisation-service, sfd-rh-service, sfd-paie-service,
sfd-budget-service, sfd-transfert-service, sfd-stock-api,
sfd-commercial-api, sfd-suivi-evaluation-api,
sfd-reporting-service, sfd-agent-mobile-service,
sfd-portail-client-service
```

### Prérequis build monolithe

```bash
# Pour CHAQUE service listé ci-dessus :
./mvnw clean install -DskipTests -Dspring-boot.repackage.skip=true

# Puis monolithe :
cd sfd-erp-monolith
./mvnw clean package -DskipTests
java -jar target/sfd-erp-monolith-*.jar
```

**Piège** : `clean package` sans `install` + `repackage.skip` → monolithe lit un JAR obsolète dans `~/.m2/my-repository`.

---

## Ordre push Jenkins (Layer 2 microservices)

```
commun (4597)
  → client (4598)
  → epargne (4596)
  → credit (4594)
  → caisse (4599)
  → comptabilite (4595)
  → immobilisation, rh, paie, budget, transfert, stock,
    commercial, suivi-evaluation, reporting, agent-mobile, portail
  → sfd-angular (Layer 3)
```

Ne pas pousser si le job Jenkins du repo précédent est en FAILURE ou en cours.

---

## Dépendances inter-services REST (runtime)

```
                    ┌─────────────────┐
                    │ Preference :4597│
                    └────────┬────────┘
                             │
     ┌───────────────────────┼───────────────────────┐
     ▼                       ▼                       ▼
┌─────────┐           ┌──────────┐           ┌────────────┐
│ Client  │◄──────────│ Épargne  │──────────►│ Comptabilité│
│ :4598   │           │ :4596    │  RabbitMQ │ :4595      │
└─────────┘           └──────────┘           └────────────┘
     │                       │
     └───────────┬───────────┘
                 ▼
           ┌──────────┐
           │ Crédit   │
           │ :4594    │
           └──────────┘
```

Tous passent par `sfd-integration-api` pour Preference/Client/Comptabilite.

---

## Spring Boot parent

| Composant | Version |
|-----------|---------|
| Spring Boot | 3.5.8 – 3.5.9 |
| Java services | 17 ou 21 selon service |
| Java demo-data | 21 |
| MapStruct + Lombok | processors ordre : mapstruct → lombok-binding → lombok |

---

*Matrice générée depuis pom.xml — juin 2026*

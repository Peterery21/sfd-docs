# ERP-SFD — Règles transverses partagées

> Source unique de vérité pour toutes les règles appliquées à l'ensemble des 17 microservices.  
> **Ne pas dupliquer dans les service CLAUDE.md** — y faire référence.

---

## ⚠️ Règle critique : Date des opérations comptables

**JAMAIS `LocalDate.now()` ou `new Date()` pour toute opération financière.**

```java
// ✅ CORRECT
LocalDate dateOperation = comptabiliteService.getDateJourneeComptableOuverte();
// Lève JourneeComptableNonOuverteException si aucune journée ouverte

// ❌ INTERDIT
LocalDate dateOperation = LocalDate.now();
```

**Pourquoi** : date système ≠ date comptable (rattrapage, décalage horaire). Obligation réglementaire BCEAO.  
S'applique à : déblocage, remboursement, dépôt, retrait, virement, écriture comptable, tout mouvement financier.

---

## Pagination obligatoire

**Toutes listes métier** → `Pageable` backend + `<app-server-pagination>` frontend. Jamais de `List<Dto>` pour données volumineuses.

```java
// Backend
Page<XxxDto> findAll(String codeAgence, Pageable pageable);

// Appel contrôleur
@GetMapping
public Page<XxxDto> findAll(@RequestParam String codeAgence, Pageable pageable) { ... }
```

```html
<!-- Frontend -->
<app-server-pagination [totalElements]="total$ | async" (pageChange)="onPageChange($event)">
```

Jamais de filtrage/tri en mémoire sur dataset complet.

---

## Filtrage agence obligatoire

`codeAgence` requis sur toutes listes : Client, Épargne, Crédit, Caisse, Comptabilité, RH, Paie, Stock, Budget, Transfert, Immobilisation, Commercial.  
Exception : référentiels courts (types, devises, pays).

```java
@RequestParam String codeAgence  // backend
```

```typescript
// Frontend : toujours utiliser
selectAgencesUtilisateurFiltrees  // selector NgRx
```

---

## Numérotation séquentielle

**Jamais `count()+1` ou séquence manuelle.**

```java
String numero = numberGeneratorService.generateNumber("FORMAT_NOM", Locale.FRENCH, dateOperation);
```

Formats déclarés dans `SetupXxxLoader.onApplicationEvent()`.

---

## JWT / Sécurité

- `app.auth.tokenSecret` **identique** sur TOUS les microservices
- Format rôles : `ROLE_{DOMAIN}_{ENTITY}_{ACTION}` — ex: `ROLE_CREDIT_DOSSIER_CREATE`
- Enregistrement : `Role.builder().name("ROLE_X").service("sfd-xxx-service").module("XXX")`
- Contrôle accès : `@PreAuthorize("hasAnyAuthority('ROLE_X', 'ROLE_ADMIN')")`

---

## Upload fichiers

- Retourner chemin **relatif** : `public/media?url=clients/photos/file.jpg`
- Frontend préfixe avec URL du **service propriétaire** (`CLIENT_URL + photo`)
- **Jamais** inventer `/api/files/...` côté backend

---

## Audit trail

Automatique via `activity-tracking-starter` → table `audit_entry` (JPA auto).  
Audit métier explicite : `BusinessAuditService` + helper module `XxxAuditHelper`.

---

## Démarrage local sans profil Spring

```bash
# ✅ CORRECT
./mvnw spring-boot:run -DskipTests

# ❌ INTERDIT — pointe sur sql-server-dev (inaccessible localement)
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

DB locale : `localhost:1433;databaseName=sfd;encrypt=false;trustServerCertificate=true`

---

## Commit / Push

**JAMAIS** committer ni pousser sans instruction explicite de l'utilisateur.  
Valider localement d'abord (build + tests + health).

---

## Inter-services (sfd-integration-api)

```yaml
# application.yml pattern
app:
  preference:
    base-url: ${PREFERENCE_SERVICE_URL:http://localhost:4597/api/preference}
  client:
    base-url: ${CLIENT_SERVICE_URL:http://localhost:4598/api/client}
```

Facades disponibles : `PreferenceServiceClient`, `ClientServiceClient` → voir [sfd-integration-api/CLAUDE.md](../sfd-integration-api/CLAUDE.md).

---

## Events RabbitMQ

```
Exchange : sfd.operations
Queue    : q.{module}.operations
Routing  : {module}.{entity}.{action}
```

---

## Package structure standard

```
com.synapsesit.sfd/
├── SfdApiApplication.java
├── audit/
├── config/          (AppConfig, SetupLoader, DemoDataLoader)
├── integration/
└── {module}/
    ├── controller/
    ├── dto/
    ├── entity/
    ├── mapper/      (MapStruct)
    ├── repository/
    └── service/
```

---

## Réglementations UEMOA

| Règle | Valeur |
|-------|--------|
| Devise | XOF, 0 décimales |
| LAB/FT déclaration | Seuil 5 000 000 XOF |
| Base calcul intérêts | 360 jours |
| Jours fériés | Par pays (service Preference) |

---

## Libs externes (AppConfig import)

```java
@Import({
    SecurityOauth2Config.class,
    NotificationApiConfig.class,
    AuditAutoConfiguration.class,
    NumberGeneratorApiConfig.class,
    FileUploadApiConfig.class       // si uploads
})
```

Détail : [docs/EXTERNAL_LIBS.md](EXTERNAL_LIBS.md)

---

## Tests E2E — vidéo récap implémentation (UI)

Après feature non triviale avec écran Angular : **1 vidéo Playwright** résume tout le parcours (pas N vidéos).

- Repo : **`sfd-angular`** uniquement
- Doc complète : [E2E_VIDEO_SUMMARY.md](E2E_VIDEO_SUMMARY.md)
- Backend seul : JUnit + curl — pas de vidéo
- Feature backend **+** UI : JUnit service **puis** vidéo récap Angular avant push Layer 3

---

*Source unique — ne pas dupliquer dans les CLAUDE.md service.*

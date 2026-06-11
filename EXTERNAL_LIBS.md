# ERP-SFD — Librairies externes (Java/commons)

> Chemin : `/Users/pierreadopre/Projects/Java/commons/`  
> Index complet : [Java/commons/INDEX.md](../../Java/commons/INDEX.md)

---

## Librairies critiques SFD

| Dossier | artifactId | Package | CLAUDE.md |
|---------|------------|---------|-----------|
| [security-oauth2](../../Java/commons/security-oauth2/) | `security-oauth2` | `com.kodzotech.authentification` | [Oui](../../Java/commons/security-oauth2/CLAUDE.md) |
| [fileupload-api](../../Java/commons/fileupload-api/) | `fileupload-api` | `com.kodzotech.fileupload` | [Oui](../../Java/commons/fileupload-api/CLAUDE.md) |
| [number-generator-api](../../Java/commons/number-generator-api/) | `number-generator-api` | `com.kodzotech.numbergenerator` | [Oui](../../Java/commons/number-generator-api/CLAUDE.md) |
| [notification-api](../../Java/commons/notification-api/) | `notification-api` | `com.kodzotech.notification` | [Oui](../../Java/commons/notification-api/CLAUDE.md) |
| [activity-tracking-starter-full](../../Java/commons/activity-tracking-starter-full/) | `activity-tracking-starter` | `com.evoltica.audit` | [Oui](../../Java/commons/activity-tracking-starter-full/CLAUDE.md) |
| [paiement-api](../../Java/commons/paiement-api/) | `paiement-api` | `com.kodzotech.paiementapi` | — |

---

## Import dans services SFD

```java
// AppConfig.java (pattern standard)
@Import({
    SecurityOauth2Config.class,      // ou SecurityConfig selon version
    NotificationApiConfig.class,
    AuditAutoConfiguration.class,
    NumberGeneratorApiConfig.class,
    FileUploadApiConfig.class       // si uploads
})
```

Monolithe : centralisé dans `MonolithAppConfig.java` — **chaque nouveau SetupLoader doit y être ajouté**.

---

## Règles transverses

### JWT (security-oauth2)

- `app.auth.tokenSecret` **identique** sur tous les microservices
- Rôles : `Role.builder().name("ROLE_X").service("sfd-xxx-service").module("XXX")`
- `@PreAuthorize("hasAnyAuthority('ROLE_X', 'ROLE_ADMIN')")`

### Numérotation (number-generator-api)

```java
numberGeneratorService.generateNumber("FORMAT_NAME", Locale.FRENCH, dateOperation);
```

Formats enregistrés dans `SetupXxxLoader.onApplicationEvent()`.

### Upload (fileupload-api)

- Retourne chemin relatif : `public/media?url=clients/photos/file.jpg`
- Frontend préfixe avec URL du **service propriétaire** (`CLIENT_URL + photo`)
- Jamais `/api/files/...` inventé côté backend

### Notifications (notification-api)

- Cache dédié `notificationCacheManager` — auto-configuré, pas de config consommateur
- Providers SMS/email actifs en cache

### Audit (activity-tracking-starter)

- JPA auto : table `audit_entry`
- Business : `BusinessAuditService` / helpers module (`XxxAuditHelper`)

---

## Build & deploy libs

```bash
cd /Users/pierreadopre/Projects/Java/commons/{lib}
./mvnw clean install -DskipTests
# ou deploy Nexus si credentials configurés
```

Référencées dans workspace VS Code : [sfd-angular.code-workspace](../sfd-angular.code-workspace)

---

## Autres libs commons (catalogue)

Voir [Java/commons/INDEX.md](../../Java/commons/INDEX.md) pour : `adresse-api`, `comment-api`, `pays-api`, `planificateur-api`, `realtime-ws`, `utilisateur-api`, etc.

---

*Ne pas dupliquer secrets/tokens — utiliser variables d'environnement ou fichiers hors repo.*

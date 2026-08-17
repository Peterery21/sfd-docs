# Liquibase → Hibernate + Cross-DB Migration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Supprimer les scripts Liquibase DDL redondants (tables/colonnes/index déjà gérés par Hibernate `ddl-auto: update`), rendre le projet deployable sur PostgreSQL/MySQL/SQL Server, et documenter l'interdiction des requêtes SQL Server-spécifiques.

**Architecture:**
- Tous les services utilisent déjà `ddl-auto: update` → Hibernate gère CREATE TABLE/ADD COLUMN/CREATE INDEX automatiquement depuis les annotations JPA `@Entity`, `@Column`, `@Table(indexes=...)`. Les scripts Liquibase DDL sont donc **redondants et bloquants** pour un déploiement multi-DB.
- Les seuls scripts à conserver sont : DROP COLUMN (Hibernate ne drop pas), DML data migration, et ALTER COLUMN type (modifyDataType).
- Seuls `sfd-epargne-service` et `sfd-credit-service` utilisent Liquibase. Les 15 autres services n'ont que le dialect hardcodé à corriger.

**Tech Stack:** Spring Boot 3.5.x, Hibernate 6, Liquibase 4.20, PostgreSQL/MySQL/SQL Server, Java 21

---

## Analyse préliminaire — État des lieux

### Services avec Liquibase actif
| Service | Changesets | Fichiers SQL |
|---------|-----------|--------------|
| `sfd-epargne-service` | 9 XML → 11 SQL | DDL + DML, SQL Server only |
| `sfd-credit-service` | 14 XML → 14 SQL | DDL + DML, SQL Server only |

### Tous les 17 services
- `ddl-auto: update` ✓ (Hibernate gère le schéma)
- Dialect hardcodé `SQLServerDialect` (à retirer → auto-détection Spring Boot)
- Driver hardcodé `com.microsoft.sqlserver.jdbc.SQLServerDriver` (à rendre configurable)
- PostgreSQL driver absent des pom.xml (à ajouter)

### Classification des changesets Liquibase

**sfd-credit-service — À SUPPRIMER (DDL pur, Hibernate couvre):**
- `V002__add_personnalisable_to_frais_credit.sql` — ADD COLUMN
- `V_analyse_relational.sql` — CREATE TABLE × 4 + INDEX × 4
- `V20260527__create_produit_credit_compte_configuration.sql` — CREATE TABLE + INDEX + ADD COLUMN
- `V20260529__create_produit_penalite_configuration.sql` — CREATE TABLE + INDEX
- `V20260611__add_mode_recalcul_produit_credit.sql` — ADD COLUMN
- `V20260612__add_contrat_dossier_credit.sql` — ADD COLUMN × 3
- `V20260613__phase3_credit_features.sql` — ADD COLUMN × 12
- `V20260614__phase4_bailleur_contentieux.sql` — CREATE TABLE × 3 + ADD COLUMN × 3
- `V20260616__add_differe_paiement_mois_dossier.sql` — ADD COLUMN

**sfd-credit-service — À CONSERVER (DROP ou DML):**
- `V20260528__add_taux_to_produit_credit_compte_configuration.sql` → GARDER la partie UPDATE DML uniquement (le ADD COLUMN DDL est supprimé)
- `V20260530__drop_code_from_penalite_credit.sql` → CONVERTIR en Liquibase XML natif `<dropColumn>`
- `V20260601__update_type_garantie_and_garantie_financiere.sql` → GARDER DROP COLUMN de `type_garantie` uniquement (le CREATE TABLE + ADD COLUMN sont supprimés)
- `V20260615__drop_code_from_bailleur_source.sql` → CONVERTIR en Liquibase XML natif `<dropColumn>`
- `V20260617__create_secteur_activite.sql` → GARDER INSERT DATA uniquement (le CREATE TABLE est supprimé)

**sfd-epargne-service — À SUPPRIMER:**
- `add-ordre-virement-permanent.xml` → `V20260612__ordre_virement_permanent.sql` — CREATE TABLE × 2 + INDEX
- `add-desactivation-dormants.xml` → `V20260613__desactivation_dormants.sql` — ADD COLUMN × 4
- `add-extend-historique-action-type-check.xml` → `V20260614__...sql` — SQL Server CHECK CONSTRAINT (pas d'équivalent portable, validation Java enum suffit)
- `add-collecte-lot-repartition.xml` changeset DDL → `V20260615__collecte_lot_repartition_01_ddl.sql`
- `add-ecart-collecte.xml` → `V20260615__ecart_collecte_ddl.sql` — CREATE TABLE + INDEX
- `add-operation-epargne-ventilation-credit.xml` → `V2026_06_11__...sql` — ADD COLUMN × 2
- `add-operation-tontine-comptabilisation.xml` → `V2026_06_11__...sql` — ADD COLUMN × 2
- `add-operation-epargne-non-aboutie-compta-repair.xml` changeset DDL → `V2026_06_14__...sql` partie CREATE TABLE

**sfd-epargne-service — À CONSERVER:**
- `add-collecte-lot-repartition.xml` changeset migrate → `V20260615__collecte_lot_repartition_02_migrate.sql` — DML: INSERT + UPDATE
- `add-collecte-lot-repartition.xml` changeset constraints → `V20260615__collecte_lot_repartition_03_constraints.sql` — ALTER NOT NULL + ADD FK
- `widen-operation-tontine-correlation-id.xml` → `V20260615__operation_tontine_correlation_id_widen.sql` — CONVERTIR en `<modifyDataType>`
- `add-operation-epargne-non-aboutie-compta-repair.xml` changeset DML → `V2026_06_14__...sql` partie UPDATE data repair

---

## Task 1: Retirer le dialect SQLServerDialect de tous les services (17 services)

**Principe :** Spring Boot 6 / Hibernate 6 auto-détecte le dialect depuis la connexion JDBC. Aucun `dialect:` n'est nécessaire dans application.yml. La suppression de cette ligne rend chaque service compatible PostgreSQL/MySQL/SQL Server sans code change.

**Note :** Le profil `application-h2.yml` a déjà `H2Dialect` explicitement → À laisser intact.  
**Note :** Le profil `application-dev.yml` contient aussi un `dialect:` → À supprimer dans chaque service.

**Files:**
- Modify: `src/main/resources/application.yml` dans les 17 services
- Modify: `src/main/resources/application-dev.yml` dans chaque service (si présent et contient dialect)
- Modify: `src/main/resources/application-prod.yml` dans chaque service (si contient dialect)

- [ ] **Step 1.1: Supprimer `dialect:` de application.yml — sfd-epargne-service**

Dans `/Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service/src/main/resources/application.yml` :

Supprimer la ligne :
```yaml
        dialect: org.hibernate.dialect.SQLServerDialect
```

Et dans `application-dev.yml` :
```yaml
        dialect: org.hibernate.dialect.SQLServerDialect
```

Le bloc `jpa.properties.hibernate` doit rester (garder `format_sql`, `jdbc.time_zone`) mais sans la ligne `dialect:`.

- [ ] **Step 1.2: Supprimer `dialect:` de application.yml — sfd-credit-service**

Dans `/Users/pierreadopre/Projects/erp-sfd/sfd-credit-service/src/main/resources/application.yml` :

Supprimer la ligne :
```yaml
              dialect: ${HIBERNATE_DIALECT:org.hibernate.dialect.SQLServerDialect}
```

Dans `application-dev.yml` si présente.

- [ ] **Step 1.3: Supprimer `dialect:` — 15 autres services**

Répéter pour chacun :
- `sfd-caisse-service` → supprimer `dialect: org.hibernate.dialect.SQLServerDialect`
- `sfd-client-service` → idem
- `sfd-commun-service` → idem
- `sfd-comptabilite-service` → idem
- `sfd-immobilisation-service` → idem
- `sfd-rh-service` → idem
- `sfd-paie-service` → idem
- `sfd-budget-service` → idem
- `sfd-transfert-service` → idem
- `sfd-stock-service` → supprimer `dialect: ${HIBERNATE_DIALECT:org.hibernate.dialect.SQLServerDialect}`
- `sfd-reporting-service` → supprimer `dialect: org.hibernate.dialect.SQLServerDialect`
- `sfd-suivi-evaluation-service` → supprimer `dialect: ${HIBERNATE_DIALECT:...}`
- `sfd-commercial-service` → supprimer `dialect: ${HIBERNATE_DIALECT:...}`
- `sfd-agent-mobile-service` → supprimer `dialect: org.hibernate.dialect.SQLServerDialect`
- `sfd-portail-client-service` → supprimer `dialect: org.hibernate.dialect.SQLServerDialect`

Vérifier aussi les profils `-dev.yml` et `-prod.yml` qui peuvent dupliquer le dialect.

- [ ] **Step 1.4: Rendre `driver-class-name` configurable par env var**

Dans chaque `application.yml`, remplacer :
```yaml
    driver-class-name: com.microsoft.sqlserver.jdbc.SQLServerDriver
```
Par :
```yaml
    driver-class-name: ${DATABASE_DRIVER:com.microsoft.sqlserver.jdbc.SQLServerDriver}
```

Cela permet de définir `DATABASE_DRIVER=org.postgresql.Driver` ou `DATABASE_DRIVER=com.mysql.cj.jdbc.Driver` sans modifier le code.

Idem dans les profils `-dev.yml` et `-prod.yml` qui surchargeraient le driver.

- [ ] **Step 1.5: Vérifier le build**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service
./mvnw compile -DskipTests
cd /Users/pierreadopre/Projects/erp-sfd/sfd-credit-service
./mvnw compile -DskipTests
```

Expected: `BUILD SUCCESS`

- [ ] **Step 1.6: Commit**

```bash
git add -p
git commit -m "chore(config): retirer dialect SQLServer hardcodé — auto-détection Hibernate 6

Supprime dialect: SQLServerDialect de tous les application.yml (17 services).
Spring Boot 3.5 / Hibernate 6 auto-détecte le dialect depuis la connexion JDBC.
Rend DATABASE_DRIVER configurable via env var (SQL Server reste la valeur par défaut)."
```

---

## Task 2: Ajouter le driver PostgreSQL dans les pom.xml (17 services)

**Principe :** `mssql-jdbc` + `mysql-connector-j` + `h2` sont déjà présents dans les services qui ont Liquibase. Les autres services ont `mssql-jdbc` + `mysql-connector-j`. PostgreSQL est manquant partout.

**Files:**
- Modify: `pom.xml` de chaque service

- [ ] **Step 2.1: Ajouter `postgresql` dans sfd-epargne-service/pom.xml**

Après la dépendance `mysql-connector-j`, ajouter :
```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

- [ ] **Step 2.2: Ajouter `postgresql` dans les 16 autres services**

Même bloc à ajouter dans :
```
sfd-credit-service, sfd-caisse-service, sfd-client-service, sfd-commun-service,
sfd-comptabilite-service, sfd-immobilisation-service, sfd-rh-service, sfd-paie-service,
sfd-budget-service, sfd-transfert-service, sfd-stock-service, sfd-reporting-service,
sfd-suivi-evaluation-service, sfd-commercial-service, sfd-agent-mobile-service,
sfd-portail-client-service
```

Pour les services qui n'ont pas encore `mysql-connector-j`, vérifier sa présence et ajouter si absent.

- [ ] **Step 2.3: Vérifier le build**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service && ./mvnw dependency:resolve | grep postgresql
```

Expected: `org.postgresql:postgresql:xxx:runtime`

- [ ] **Step 2.4: Commit**

```bash
git commit -m "chore(deps): ajouter driver PostgreSQL dans tous les microservices (runtime scope)"
```

---

## Task 3: Nettoyer Liquibase credit-service — Supprimer les changesets DDL purs

**Principe :** Les tables/colonnes suivantes sont définies dans des entités JPA. Hibernate `ddl-auto: update` les crée automatiquement. Les changesets Liquibase correspondants sont redondants et incompatibles avec PostgreSQL/MySQL.

**Files:**
- Modify: `sfd-credit-service/src/main/resources/db/changelog/db-changelog-master.xml`
- Delete: 9 fichiers SQL DDL purs (listés ci-dessous)

- [ ] **Step 3.1: Supprimer les changesets DDL du master changelog**

Remplacer le contenu de `db-changelog-master.xml` par :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <!--
        POLITIQUE DDL : Hibernate ddl-auto=update gère CREATE TABLE, ADD COLUMN, CREATE INDEX.
        Ce changelog ne contient que :
          - DROP COLUMN (Hibernate ne supprime jamais de colonnes)
          - DML data migration (INSERT/UPDATE de données)
          - modifyDataType (Hibernate ne modifie pas les types existants)
    -->

    <!-- Suppression colonne 'code' sur penalite_credit (uk + colonne) -->
    <include file="2026/06/drop-code-from-penalite-credit.xml" relativeToChangelogFile="true"/>

    <!-- Suppression colonne 'code' sur type_garantie -->
    <include file="2026/06/drop-code-from-type-garantie.xml" relativeToChangelogFile="true"/>

    <!-- UPDATE taux_provision par défaut selon classe_risque -->
    <include file="2026/06/update-taux-provision-defaut.xml" relativeToChangelogFile="true"/>

    <!-- Suppression colonnes 'code' sur bailleur_credit et source_financement -->
    <include file="2026/06/drop-code-from-bailleur-source.xml" relativeToChangelogFile="true"/>

    <!-- INSERT données référentiel secteur_activite -->
    <include file="2026/06/insert-secteur-activite-data.xml" relativeToChangelogFile="true"/>

</databaseChangeLog>
```

- [ ] **Step 3.2: Créer le répertoire 2026/06/**

```bash
mkdir -p /Users/pierreadopre/Projects/erp-sfd/sfd-credit-service/src/main/resources/db/changelog/2026/06
```

- [ ] **Step 3.3: Créer drop-code-from-penalite-credit.xml**

`db/changelog/2026/06/drop-code-from-penalite-credit.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="credit-v20260530-drop-code-penalite" author="sfd-credit">
        <comment>Suppression contrainte unique + colonne code sur penalite_credit</comment>
        <preConditions onFail="MARK_RAN">
            <columnExists tableName="penalite_credit" columnName="code"/>
        </preConditions>
        <dropUniqueConstraint tableName="penalite_credit" constraintName="uk_penalite_credit_code"/>
        <dropColumn tableName="penalite_credit" columnName="code"/>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 3.4: Créer drop-code-from-type-garantie.xml**

`db/changelog/2026/06/drop-code-from-type-garantie.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="credit-v20260601-drop-code-type-garantie" author="sfd-credit">
        <comment>Suppression colonne code sur type_garantie (remplacée par libelle)</comment>
        <preConditions onFail="MARK_RAN">
            <columnExists tableName="type_garantie" columnName="code"/>
        </preConditions>
        <dropUniqueConstraint tableName="type_garantie" constraintName="uk_type_garantie_code"
                              onFail="MARK_RAN" onError="MARK_RAN"/>
        <dropColumn tableName="type_garantie" columnName="code"/>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 3.5: Créer update-taux-provision-defaut.xml**

`db/changelog/2026/06/update-taux-provision-defaut.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="credit-v20260528-update-taux-provision" author="sfd-credit">
        <comment>Initialise taux_provision par défaut selon classe_risque BCEAO</comment>
        <preConditions onFail="MARK_RAN">
            <tableExists tableName="produit_credit_compte_configuration"/>
            <columnExists tableName="produit_credit_compte_configuration" columnName="taux_provision"/>
        </preConditions>
        <sql>
UPDATE produit_credit_compte_configuration
SET taux_provision = CASE classe_risque
    WHEN 'SAIN'      THEN 0
    WHEN 'SENSIBLE'  THEN 0
    WHEN 'DOUTEUX'   THEN 40
    WHEN 'LITIGIEUX' THEN 80
    WHEN 'COMPROMIS' THEN 100
    ELSE 0
END
WHERE taux_provision IS NULL
        </sql>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 3.6: Créer drop-code-from-bailleur-source.xml**

`db/changelog/2026/06/drop-code-from-bailleur-source.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="credit-v20260615-drop-code-bailleur" author="sfd-credit">
        <comment>Suppression colonne code sur bailleur_credit</comment>
        <preConditions onFail="MARK_RAN">
            <columnExists tableName="bailleur_credit" columnName="code"/>
        </preConditions>
        <dropUniqueConstraint tableName="bailleur_credit" constraintName="uk_bailleur_credit_code"
                              onFail="MARK_RAN" onError="MARK_RAN"/>
        <dropColumn tableName="bailleur_credit" columnName="code"/>
    </changeSet>

    <changeSet id="credit-v20260615-drop-code-source-financement" author="sfd-credit">
        <comment>Suppression colonne code sur source_financement</comment>
        <preConditions onFail="MARK_RAN">
            <columnExists tableName="source_financement" columnName="code"/>
        </preConditions>
        <dropUniqueConstraint tableName="source_financement" constraintName="uk_source_financement_code"
                              onFail="MARK_RAN" onError="MARK_RAN"/>
        <dropColumn tableName="source_financement" columnName="code"/>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 3.7: Créer insert-secteur-activite-data.xml**

`db/changelog/2026/06/insert-secteur-activite-data.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="credit-v20260617-insert-secteurs-activite" author="sfd-credit">
        <comment>Référentiel secteurs activité BCEAO — données initiales</comment>
        <preConditions onFail="MARK_RAN">
            <tableExists tableName="secteur_activite"/>
            <sqlCheck expectedResult="0">SELECT COUNT(*) FROM secteur_activite WHERE code = 'AGRICULTURE'</sqlCheck>
        </preConditions>
        <insert tableName="secteur_activite">
            <column name="code" value="AGRICULTURE"/>
            <column name="libelle" value="Agriculture"/>
            <column name="ordre" valueNumeric="1"/>
            <column name="actif" valueBoolean="true"/>
            <column name="date_creation" valueDate="now()"/>
        </insert>
        <insert tableName="secteur_activite">
            <column name="code" value="COMMERCE"/>
            <column name="libelle" value="Commerce"/>
            <column name="ordre" valueNumeric="2"/>
            <column name="actif" valueBoolean="true"/>
            <column name="date_creation" valueDate="now()"/>
        </insert>
        <insert tableName="secteur_activite">
            <column name="code" value="ARTISANAT"/>
            <column name="libelle" value="Artisanat"/>
            <column name="ordre" valueNumeric="3"/>
            <column name="actif" valueBoolean="true"/>
            <column name="date_creation" valueDate="now()"/>
        </insert>
        <insert tableName="secteur_activite">
            <column name="code" value="SERVICES"/>
            <column name="libelle" value="Services"/>
            <column name="ordre" valueNumeric="4"/>
            <column name="actif" valueBoolean="true"/>
            <column name="date_creation" valueDate="now()"/>
        </insert>
        <insert tableName="secteur_activite">
            <column name="code" value="INDUSTRIE"/>
            <column name="libelle" value="Industrie"/>
            <column name="ordre" valueNumeric="5"/>
            <column name="actif" valueBoolean="true"/>
            <column name="date_creation" valueDate="now()"/>
        </insert>
        <insert tableName="secteur_activite">
            <column name="code" value="FONCTION_PUBLIQUE"/>
            <column name="libelle" value="Fonction publique / Salarié"/>
            <column name="ordre" valueNumeric="6"/>
            <column name="actif" valueBoolean="true"/>
            <column name="date_creation" valueDate="now()"/>
        </insert>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 3.8: Supprimer les anciens fichiers SQL DDL purs**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-credit-service/src/main/resources/db/migration
rm V002__add_personnalisable_to_frais_credit.sql
rm V_analyse_relational.sql
rm V20260527__create_produit_credit_compte_configuration.sql
rm V20260528__add_taux_to_produit_credit_compte_configuration.sql
rm V20260529__create_produit_penalite_configuration.sql
rm V20260530__drop_code_from_penalite_credit.sql
rm V20260601__update_type_garantie_and_garantie_financiere.sql
rm V20260611__add_mode_recalcul_produit_credit.sql
rm V20260612__add_contrat_dossier_credit.sql
rm V20260613__phase3_credit_features.sql
rm V20260614__phase4_bailleur_contentieux.sql
rm V20260615__drop_code_from_bailleur_source.sql
rm V20260616__add_differe_paiement_mois_dossier.sql
rm V20260617__create_secteur_activite.sql
```

- [ ] **Step 3.9: Vérifier le build**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-credit-service
./mvnw test -Dspring.profiles.active=h2 2>&1 | tail -20
```

Expected: `BUILD SUCCESS`

- [ ] **Step 3.10: Commit**

```bash
git add sfd-credit-service/
git commit -m "refactor(credit): remplacer scripts Liquibase DDL par Hibernate ddl-auto

Supprime 14 scripts SQL Server-spécifiques (CREATE TABLE, ADD COLUMN, CREATE INDEX).
Hibernate ddl-auto=update les remplace nativement et supporte PostgreSQL/MySQL/SQL Server.
Conserve uniquement : DROP COLUMN (3), DML UPDATE taux_provision, INSERT secteurs_activite."
```

---

## Task 4: Nettoyer Liquibase epargne-service — Supprimer les changesets DDL purs

**Files:**
- Modify: `sfd-epargne-service/src/main/resources/db/changelog/db-changelog-master.xml`
- Modify: `sfd-epargne-service/src/main/resources/db/changelog/2026/06/add-collecte-lot-repartition.xml`
- Create: nouveaux XML portables
- Delete: 7 fichiers SQL DDL purs + 1 SQL incompatible (check constraint)

- [ ] **Step 4.1: Réécrire db-changelog-master.xml**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
        http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <!--
        POLITIQUE DDL : Hibernate ddl-auto=update gère CREATE TABLE, ADD COLUMN, CREATE INDEX.
        Ce changelog ne contient que :
          - DML data migration (INSERT/UPDATE de données)
          - ALTER NOT NULL et ADD FK (après migration de données)
          - modifyDataType (Hibernate ne modifie pas les types existants)
        Les changesets CHECK CONSTRAINT (SQL Server-spécifiques) sont supprimés ;
        la validation est assurée par les annotations Java @Enumerated.
    -->

    <!-- Data migration: lot_repartition (INSERT lots + UPDATE FK) -->
    <include file="2026/06/migrate-lot-repartition-data.xml" relativeToChangelogFile="true"/>

    <!-- Contraintes post-migration: lot_repartition_id NOT NULL + FK -->
    <include file="2026/06/add-lot-repartition-constraints.xml" relativeToChangelogFile="true"/>

    <!-- Élargir correlation_id opération tontine (100 → 150 chars) -->
    <include file="2026/06/widen-operation-tontine-correlation-id.xml" relativeToChangelogFile="true"/>

    <!-- Correction données: opérations épargne mal comptabilisées -->
    <include file="2026/06/repair-operation-epargne-compta.xml" relativeToChangelogFile="true"/>

</databaseChangeLog>
```

- [ ] **Step 4.2: Créer migrate-lot-repartition-data.xml**

`db/changelog/2026/06/migrate-lot-repartition-data.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="2026-06-15-migrate-lot-repartition-data" author="sfd-epargne"
               runOnChange="false">
        <comment>Migration data: crée les lots de répartition manquants puis met à jour les FK</comment>
        <preConditions onFail="MARK_RAN">
            <tableExists tableName="lot_repartition_depot_collecteur"/>
            <tableExists tableName="repartition_depot_collecteur"/>
            <columnExists tableName="repartition_depot_collecteur" columnName="lot_repartition_id"/>
        </preConditions>

        <!-- Créer lots pour les lignes avec fiche_id (ANSI SQL — aucun ISNULL ni FROM JOIN UPDATE) -->
        <sql splitStatements="true">
INSERT INTO lot_repartition_depot_collecteur
    (depot_collecteur_id, fiche_id, numero_fiche_preimprime, code_produit, agent_saisie, statut, ordre)
SELECT DISTINCT
    r.depot_collecteur_id,
    r.fiche_id,
    r.numero_fiche_preimprime,
    NULL,
    'migration',
    'BROUILLON',
    1
FROM repartition_depot_collecteur r
WHERE r.lot_repartition_id IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM lot_repartition_depot_collecteur l
      WHERE l.depot_collecteur_id = r.depot_collecteur_id
        AND COALESCE(l.fiche_id, -1) = COALESCE(r.fiche_id, -1)
        AND COALESCE(l.numero_fiche_preimprime, '') = COALESCE(r.numero_fiche_preimprime, '')
  )
        </sql>

        <!-- Mettre à jour lot_repartition_id (sous-requête corrélée ANSI SQL) -->
        <sql splitStatements="true">
UPDATE repartition_depot_collecteur
SET lot_repartition_id = (
    SELECT l.id
    FROM lot_repartition_depot_collecteur l
    WHERE l.depot_collecteur_id = repartition_depot_collecteur.depot_collecteur_id
      AND COALESCE(l.fiche_id, -1) = COALESCE(repartition_depot_collecteur.fiche_id, -1)
      AND COALESCE(l.numero_fiche_preimprime, '') = COALESCE(repartition_depot_collecteur.numero_fiche_preimprime, '')
    FETCH FIRST 1 ROWS ONLY
)
WHERE lot_repartition_id IS NULL
        </sql>

        <!-- Créer lots pour les lignes sans fiche_id -->
        <sql splitStatements="true">
INSERT INTO lot_repartition_depot_collecteur
    (depot_collecteur_id, fiche_id, numero_fiche_preimprime, code_produit, agent_saisie, statut, ordre)
SELECT DISTINCT r.depot_collecteur_id, NULL, NULL, NULL, 'migration', 'BROUILLON', 1
FROM repartition_depot_collecteur r
WHERE r.lot_repartition_id IS NULL
  AND NOT EXISTS (
      SELECT 1 FROM lot_repartition_depot_collecteur l
      WHERE l.depot_collecteur_id = r.depot_collecteur_id
        AND l.fiche_id IS NULL
        AND l.numero_fiche_preimprime IS NULL
  )
        </sql>

        <!-- Mettre à jour FK pour les lignes sans fiche_id -->
        <sql splitStatements="true">
UPDATE repartition_depot_collecteur
SET lot_repartition_id = (
    SELECT l.id
    FROM lot_repartition_depot_collecteur l
    WHERE l.depot_collecteur_id = repartition_depot_collecteur.depot_collecteur_id
      AND l.fiche_id IS NULL
      AND l.numero_fiche_preimprime IS NULL
    FETCH FIRST 1 ROWS ONLY
)
WHERE lot_repartition_id IS NULL
        </sql>
    </changeSet>

</databaseChangeLog>
```

**Note sur `FETCH FIRST 1 ROWS ONLY` :** Standard SQL:2008, supporté par PostgreSQL 8.4+, MySQL 8.0.2+, SQL Server 2012+, H2. C'est la syntaxe portables cross-DB pour limiter à 1 résultat dans une sous-requête.

- [ ] **Step 4.3: Créer add-lot-repartition-constraints.xml**

`db/changelog/2026/06/add-lot-repartition-constraints.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="2026-06-15-lot-repartition-not-null" author="sfd-epargne">
        <comment>lot_repartition_id NOT NULL après migration de données</comment>
        <preConditions onFail="MARK_RAN">
            <columnExists tableName="repartition_depot_collecteur" columnName="lot_repartition_id"/>
            <sqlCheck expectedResult="0">
                SELECT COUNT(*) FROM repartition_depot_collecteur WHERE lot_repartition_id IS NULL
            </sqlCheck>
        </preConditions>
        <addNotNullConstraint tableName="repartition_depot_collecteur"
                              columnName="lot_repartition_id"
                              columnDataType="BIGINT"/>
    </changeSet>

    <changeSet id="2026-06-15-lot-repartition-fk" author="sfd-epargne">
        <comment>FK repartition → lot_repartition_depot_collecteur</comment>
        <preConditions onFail="MARK_RAN">
            <not>
                <foreignKeyConstraintExists foreignKeyTableName="repartition_depot_collecteur"
                                            foreignKeyName="fk_repartition_lot"/>
            </not>
        </preConditions>
        <addForeignKeyConstraint
                baseTableName="repartition_depot_collecteur"
                baseColumnNames="lot_repartition_id"
                constraintName="fk_repartition_lot"
                referencedTableName="lot_repartition_depot_collecteur"
                referencedColumnNames="id"/>
    </changeSet>

    <changeSet id="2026-06-15-repartition-nullable-columns" author="sfd-epargne">
        <comment>Rendre nullable les colonnes de ligne vide de répartition</comment>
        <preConditions onFail="MARK_RAN">
            <columnExists tableName="repartition_depot_collecteur" columnName="numero_compte"/>
        </preConditions>
        <dropNotNullConstraint tableName="repartition_depot_collecteur"
                               columnName="numero_compte"
                               columnDataType="VARCHAR(50)"/>
        <dropNotNullConstraint tableName="repartition_depot_collecteur"
                               columnName="montant"
                               columnDataType="DECIMAL(18,2)"/>
        <dropNotNullConstraint tableName="repartition_depot_collecteur"
                               columnName="type_cible"
                               columnDataType="VARCHAR(20)"/>
        <dropNotNullConstraint tableName="repartition_depot_collecteur"
                               columnName="affectation_id"
                               columnDataType="BIGINT"/>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 4.4: Créer widen-operation-tontine-correlation-id.xml (remplace l'existant)**

Supprimer l'ancien `db/changelog/2026/06/widen-operation-tontine-correlation-id.xml` et créer :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="2026-06-15-widen-operation-tontine-correlation-id" author="sfd-epargne">
        <comment>Élargir correlation_id : 50 → 150 chars (ANSI modifyDataType)</comment>
        <preConditions onFail="MARK_RAN">
            <tableExists tableName="operation_tontine"/>
            <columnExists tableName="operation_tontine" columnName="correlation_id"/>
        </preConditions>
        <modifyDataType tableName="operation_tontine"
                        columnName="correlation_id"
                        newDataType="VARCHAR(150)"/>
    </changeSet>

</databaseChangeLog>
```

- [ ] **Step 4.5: Créer repair-operation-epargne-compta.xml**

`db/changelog/2026/06/repair-operation-epargne-compta.xml` :
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.20.xsd">

    <changeSet id="2026-06-14-repair-compta-sans-ecriture" author="sfd-epargne">
        <comment>Correction: opérations marquées comptabilisées sans écriture réelle</comment>
        <preConditions onFail="MARK_RAN">
            <tableExists tableName="operation_epargne"/>
            <columnExists tableName="operation_epargne" columnName="comptabilisee"/>
        </preConditions>
        <sql>
UPDATE operation_epargne
SET comptabilisee = false,
    ecriture_comptable_id = NULL,
    date_comptabilisation = NULL
WHERE comptabilisee = true
  AND ecriture_comptable_id IS NULL
        </sql>
    </changeSet>

    <changeSet id="2026-06-14-repair-compta-saga-echec" author="sfd-epargne">
        <comment>Correction: opérations comptabilisées alors que saga EPARGNE en ECHEC</comment>
        <preConditions onFail="MARK_RAN">
            <tableExists tableName="operation_epargne"/>
            <tableExists tableName="saga_operation"/>
        </preConditions>
        <sql>
UPDATE operation_epargne
SET comptabilisee = false,
    ecriture_comptable_id = NULL,
    date_comptabilisation = NULL
WHERE id IN (
    SELECT id FROM (
        SELECT o.id
        FROM operation_epargne o
        INNER JOIN saga_operation s ON s.operation_locale_id = o.id
        WHERE s.statut = 'ECHEC'
          AND s.module_courant = 'EPARGNE'
          AND o.comptabilisee = true
    ) AS subq
)
        </sql>
    </changeSet>

</databaseChangeLog>
```

**Note :** La double imbrication `SELECT id FROM (SELECT ...) AS subq` est le pattern cross-DB pour UPDATE basé sur JOIN — MySQL ne permet pas UPDATE sur la même table dans le FROM direct, mais permet cette double imbrication. PostgreSQL et SQL Server l'acceptent aussi.

- [ ] **Step 4.6: Supprimer les anciens fichiers SQL DDL/incompatibles**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service/src/main/resources/db

# Supprimer anciens XML (changelog) — l'existant incompatible
rm changelog/2026/06/add-ordre-virement-permanent.xml
rm changelog/2026/06/add-desactivation-dormants.xml
rm changelog/2026/06/add-extend-historique-action-type-check.xml
rm changelog/2026/06/add-collecte-lot-repartition.xml
rm changelog/2026/06/add-ecart-collecte.xml
rm changelog/2026/06/add-operation-epargne-ventilation-credit.xml
rm changelog/2026/06/add-operation-tontine-comptabilisation.xml
rm changelog/2026/06/add-operation-epargne-non-aboutie-compta-repair.xml
# widen-operation-tontine sera remplacé à l'étape 4.4

# Supprimer anciens fichiers SQL migration
rm migration/V20260612__ordre_virement_permanent.sql
rm migration/V20260613__desactivation_dormants.sql
rm migration/V20260614__extend_historique_action_type_check.sql
rm migration/V20260615__collecte_lot_repartition.sql
rm migration/V20260615__collecte_lot_repartition_01_ddl.sql
rm migration/V20260615__collecte_lot_repartition_02_migrate.sql
rm migration/V20260615__collecte_lot_repartition_03_constraints.sql
rm migration/V20260615__ecart_collecte_ddl.sql
rm migration/V20260615__operation_tontine_correlation_id_widen.sql
rm migration/V2026_06_11__operation_epargne_ventilation_credit.sql
rm migration/V2026_06_11__operation_tontine_comptabilisation.sql
rm migration/V2026_06_14__operation_epargne_non_aboutie_compta_repair.sql
```

- [ ] **Step 4.7: Tester**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service
./mvnw test -Dspring.profiles.active=h2 2>&1 | tail -20
```

Expected: `BUILD SUCCESS`

- [ ] **Step 4.8: Commit**

```bash
git add sfd-epargne-service/
git commit -m "refactor(epargne): remplacer scripts Liquibase DDL par Hibernate ddl-auto

Supprime 11 scripts SQL Server-spécifiques (CREATE TABLE, ADD COLUMN, CHECK CONSTRAINT).
Convertit les changesets portables en Liquibase XML natif (dropColumn, modifyDataType,
addNotNullConstraint, addForeignKeyConstraint).
DML data migration réécrit en ANSI SQL (COALESCE, FETCH FIRST 1 ROWS ONLY, sous-requête corrélée)."
```

---

## Task 5: Vérifier et documenter les règles cross-DB

**Files:**
- Modify: `sfd-docs/SHARED_RULES.md`
- Modify: `sfd-angular/CLAUDE.md` (pas de changement DB côté Angular mais on peut mentionner la politique)
- Root `CLAUDE.md`

- [ ] **Step 5.1: Ajouter section cross-DB dans SHARED_RULES.md**

Ajouter à la fin de `/Users/pierreadopre/Projects/erp-sfd/sfd-docs/SHARED_RULES.md` :

```markdown
---

## Multi-DB : Interdictions SQL Server-spécifiques

**Le projet se déploie sur PostgreSQL, MySQL et SQL Server.** Aucun code ou script ne doit utiliser de syntaxe propre à un seul SGBD.

### Interdits dans les scripts SQL et @Query/@NativeQuery

| SQL Server-spécifique | Remplacement portable |
|----------------------|-----------------------|
| `OBJECT_ID('table')` | `<preConditions>` Liquibase XML |
| `sys.tables`, `sys.columns`, `sys.indexes` | `INFORMATION_SCHEMA.TABLES/COLUMNS` ou `<preConditions>` Liquibase |
| `COL_LENGTH('t', 'c')` | `<columnExists>` Liquibase XML |
| `NVARCHAR(n)` | `VARCHAR(n)` |
| `BIT` | `BOOLEAN` |
| `DATETIME2` | `TIMESTAMP` |
| `IDENTITY(1,1)` | Géré par `@GeneratedValue(strategy=AUTO)` JPA |
| `GETDATE()` / `SYSUTCDATETIME()` | `CURRENT_TIMESTAMP` |
| `ISNULL(a, b)` | `COALESCE(a, b)` |
| `IF NOT EXISTS ... BEGIN ... END` | `<preConditions onFail="MARK_RAN">` Liquibase XML |
| `UPDATE t SET ... FROM t JOIN t2` | `UPDATE t SET col = (SELECT ... FROM t2 WHERE ...)` |
| `SELECT TOP N` | `FETCH FIRST N ROWS ONLY` (SQL:2008) |
| `sp_executesql`, `EXEC(...)` | À proscrire — utiliser Liquibase XML natif |
| `PRINT 'message'` | Supprimer |
| `@@FETCH_STATUS`, `CURSOR` | Réécrire en SQL ensembliste |
| `WITH (NOLOCK)` | À proscrire — configurer `isolation-level` Spring si besoin |

### Règles DDL

- **JAMAIS de scripts SQL pour CREATE TABLE, ADD COLUMN, CREATE INDEX.**  
  Utiliser **uniquement** les annotations JPA : `@Entity`, `@Column`, `@Table(indexes={...})`, `@ManyToOne`.  
  Hibernate `ddl-auto: update` applique ces changements automatiquement.

- **DROP COLUMN / DROP TABLE** uniquement via Liquibase XML natif `<dropColumn>`, `<dropTable>`.  
  Toujours avec `<preConditions onFail="MARK_RAN">` pour idempotence.

- **Modification de type** (`VARCHAR(50)→VARCHAR(150)`) → `<modifyDataType>` Liquibase XML.

- **Données de référence** (INSERT initiaux) → `<insert>` Liquibase XML avec `<preConditions>` sur `<sqlCheck expectedResult="0">SELECT COUNT(*) WHERE...</sqlCheck>`.

### Dialect Hibernate

**Ne jamais spécifier `dialect:` dans application.yml.** Spring Boot 3+ auto-détecte le dialect depuis la connexion JDBC. Le configurer fige le service sur un seul SGBD.

Exception unique : `application-h2.yml` peut garder `H2Dialect` pour les tests.

### Driver JDBC

Le driver est configurable via l'env var `DATABASE_DRIVER` :
```bash
# SQL Server (défaut)
DATABASE_DRIVER=com.microsoft.sqlserver.jdbc.SQLServerDriver

# PostgreSQL
DATABASE_DRIVER=org.postgresql.Driver

# MySQL
DATABASE_DRIVER=com.mysql.cj.jdbc.Driver
```

Toujours inclure les 3 drivers en scope `runtime` dans `pom.xml`.
```

- [ ] **Step 5.2: Référencer dans le CLAUDE.md racine du projet**

Dans `/Users/pierreadopre/Projects/erp-sfd/CLAUDE.md`, dans la table "Règles absolues", ajouter une ligne :

```markdown
| **Cross-DB SQL** | JAMAIS de SQL Server-spécifique (OBJECT_ID, NVARCHAR, BIT, GETDATE, ISNULL) — voir [SHARED_RULES.md](sfd-docs/SHARED_RULES.md#multi-db--interdictions-sql-server-spécifiques) |
```

Et dans la table "Où trouver quoi", ajouter :

```markdown
| Règles SQL cross-DB | [sfd-docs/SHARED_RULES.md](sfd-docs/SHARED_RULES.md#multi-db--interdictions-sql-server-spécifiques) |
```

- [ ] **Step 5.3: Commit**

```bash
git add sfd-docs/SHARED_RULES.md CLAUDE.md
git commit -m "docs: documenter règles cross-DB et interdiction SQL Server-spécifique

Ajoute section complète dans SHARED_RULES.md : tableau des interdits SQL Server,
règles DDL (Hibernate-only), dialect auto-détection, driver configurable par env var."
```

---

## Task 6: Vérification finale et nettoyage

- [ ] **Step 6.1: Build complet des services modifiés**

```bash
for svc in sfd-epargne-service sfd-credit-service sfd-caisse-service sfd-client-service sfd-commun-service; do
  cd /Users/pierreadopre/Projects/erp-sfd/$svc
  echo "=== $svc ==="
  ./mvnw compile -DskipTests -q && echo "OK" || echo "FAIL"
done
```

- [ ] **Step 6.2: Tests H2 des services avec Liquibase**

```bash
cd /Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service
./mvnw test -Dspring.profiles.active=h2 -q

cd /Users/pierreadopre/Projects/erp-sfd/sfd-credit-service
./mvnw test -Dspring.profiles.active=h2 -q
```

Expected: `BUILD SUCCESS` sur les deux.

- [ ] **Step 6.3: Vérifier qu'il ne reste plus de dialect hardcodé**

```bash
grep "SQLServerDialect" \
  /Users/pierreadopre/Projects/erp-sfd/sfd-*/src/main/resources/application.yml \
  /Users/pierreadopre/Projects/erp-sfd/sfd-*/src/main/resources/application-dev.yml \
  /Users/pierreadopre/Projects/erp-sfd/sfd-*/src/main/resources/application-prod.yml \
  2>/dev/null
```

Expected: aucune ligne (ou uniquement dans `application-h2.yml` si H2Dialect est différent).

- [ ] **Step 6.4: Vérifier qu'il ne reste plus de SQL Server-spécifique dans les changelogs**

```bash
grep -r "OBJECT_ID\|sys\.tables\|NVARCHAR\|IDENTITY(1\|DATETIME2\|GETDATE\|sp_executesql" \
  /Users/pierreadopre/Projects/erp-sfd/sfd-epargne-service/src/main/resources/db \
  /Users/pierreadopre/Projects/erp-sfd/sfd-credit-service/src/main/resources/db \
  2>/dev/null
```

Expected: aucune ligne.

- [ ] **Step 6.5: Commit final et push si demandé**

```bash
git log --oneline -5
```

---

## Résumé des changements

| Catégorie | Avant | Après |
|-----------|-------|-------|
| Dialect | `SQLServerDialect` hardcodé (17 services) | Auto-détection Hibernate 6 |
| Driver | Hardcodé SQL Server | `${DATABASE_DRIVER:mssql}` configurable |
| Changesets credit | 14 changesets SQL Server | 5 changesets portables XML natif |
| Changesets epargne | 9 changesets (11 SQL) SQL Server | 4 changesets portables XML natif |
| Fichiers SQL supprimés | — | 26 fichiers .sql + 8 .xml |
| PostgreSQL driver | Absent | `runtime` dans tous les pom.xml |
| Docs cross-DB | Aucune règle documentée | Section dans SHARED_RULES.md + CLAUDE.md |

## Compatibilité Hibernate `ddl-auto: update`

Ce mode **crée mais ne supprime pas**. Pour les bases de données existantes en production :
- Les colonnes ajoutées via Liquibase DDL (maintenant supprimés) existent déjà → `ddl-auto: update` ne les recrée pas, il les détecte et continue.
- Les nouvelles colonnes ajoutées dans les entités JPA seront ajoutées par Hibernate au démarrage.
- Les colonnes supprimées (DROP COLUMN dans les nouveaux XML Liquibase) seront supprimées par Liquibase au démarrage, comme avant.

**Déploiement sur base vierge PostgreSQL/MySQL :** Démarrer le service → Hibernate crée toutes les tables → Liquibase applique les DROP et les DML → opérationnel.

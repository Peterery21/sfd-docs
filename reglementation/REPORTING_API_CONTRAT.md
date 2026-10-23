# Refonte reporting réglementaire : contrat d'API et format des paquets (v1, 2026-10-23)

Ce contrat est fixé par l'orchestrateur et lie toutes les sessions : backend (S2, S4, S6) et Angular (S5, S7). On ne le modifie pas sans passer par l'orchestrateur. Préfixe : `/api/reporting`.

## 1. Format des paquets de localisation (`sfd-reporting-service/src/main/resources/localisation/`)

```
localisation/<ZONE>/package.yml          # en-tête du paquet
localisation/<ZONE>/rapports/<CODE>.yml  # un fichier par rapport
localisation/<ZONE>/pays/<CC>.yml        # surcharge pays (facultative)
```
ZONE ∈ `UEMOA-BCEAO`, `CEMAC-COBAC`, `RDC-BCC`, `OHADA` (états financiers SYSCOHADA/SYCEBNL, pour les entités non SFD).

Source des données : les brouillons `sfd-docs/reglementation/<zone>/paquet-draft.yml`. S2 les découpe selon ce format et normalise les champs.

### package.yml
```yaml
zone: UEMOA-BCEAO
regulateur: BCEAO / Commission Bancaire UMOA
planComptable: RCSFD            # RCSFD | PCEMF | PCCI | SYSCOHADA | SYCEBNL
version: 2026.10.0              # semver ; changement = resynchro MISSING
pays: [BJ, BF, CI, GW, ML, NE, SN, TG]
typesAssujettis: [TOUS, ART44, AUTRES_SFD, RESEAUX, IMF_CB]
conventions: {...}              # texte libre repris des brouillons
transmission: {...}             # facultatif
sanctions: [...]                # facultatif
```

### rapports/<CODE>.yml
```yaml
code: UEMOA-REP-PRU-05
libelle: Coefficient de liquidité
periodicite: MENSUELLE          # DECADAIRE|MENSUELLE|TRIMESTRIELLE|SEMESTRIELLE|ANNUELLE|EVENEMENT
periodiciteParCategorie: {ART44: MENSUELLE, AUTRES_SFD_DEPOT: MENSUELLE}
delaiJours: 30                  # null = non fixé
echeance: "10 du mois suivant"  # facultatif, texte
assujettis: [TOUS]
destinataire: [BCEAO, CB]
layout: SFP_SECTIONS            # BILAN_BICOLONNE|CR_VERTICAL|INDICATEURS_SECTIONS|SFP_SECTIONS|RATIOS|ANNEXE|GENERIC|DOCUMENT|EXTERNE
nature: CALCULE                 # CALCULE (lignes évaluées) | DOCUMENT (modèle à remplir + pièce jointe) | EXTERNE (format tiers, pas de lignes)
source: "Instr. 010-08-2010, annexe V"
confiance: HAUTE                # HAUTE|MOYENNE|BASSE ; UI : badge « à valider » si ≠ HAUTE
reprend: null                   # code d'un autre rapport dont on reprend les lignes
lignes:
  - code: R5_NUM
    libelle: Valeurs disponibles et réalisables
    section: Numérateur          # facultatif, regroupement d'affichage
    ordre: 10
    comptes: "10,11,-119"        # préfixes ; '-' soustrait ; suffixe dr/cr = solde débiteur/créditeur seul
    comptesAllegee: null         # variante RCSFD allégée (SFD non art. 44)
    sens: D                      # D | C | SOLDE (sens de lecture du solde)
    colonnes: [BRUT, AMORT_PROV, NET, NET_N1]   # facultatif (bilans)
    expression: null             # exclusif avec comptes : codes de lignes, + - * / ( ), MIN(a,b), MAX(a,b), constantes ; référence à un autre rapport : AUTRE_CODE.LIGNE
    sourceDonnees: null          # null = balance | CROSS_SERVICE:<clé> (donnée métier, ex. CROSS_SERVICE:credit.encoursParClasse) | SAISIE (saisie manuelle)
    typeValeur: MONTANT          # MONTANT | POURCENTAGE | NOMBRE | RATIO
    norme: {operateur: ">=", valeur: 100}   # opérateurs >= <= > < =
    normesParCategorie: {AFFILIE: {operateur: "<=", valeur: 65}}
    controle: {egal: E90}        # contrôle de cohérence ligne à ligne (facultatif)
    confiance: HAUTE
    source: "RCSFD annexe 1"
    note: "…"
```

### pays/<CC>.yml
```yaml
pays: TG
autorite: Direction de la Microfinance (MEF)
loiNationale: "loi 2026-005 du 24/03/2026"
ajouter: [ {rapport complet au format ci-dessus} ]
modifier: [ {code: <rapport>, lignes: [ {code: <ligne>, ...champs remplacés} ] } ]
desactiver: [<code rapport>]
```

### Instanciation (façon l10n d'Odoo)
- `LocalisationRegistry` parse le paquet une seule fois au démarrage. Il garde une map immuable, avec un checksum SHA-256 par rapport et par ligne.
- La base contient les tables `rapport_definition` et `rapport_formule`, avec `zone`, `paysCode` (null = toute la zone), `origine` ∈ PAQUET | PERSONNALISEE | AJOUTEE, `checksumPaquet` et `versionPaquet`.
- La synchro MISSING tourne au démarrage et à chaque changement de version. Elle crée les lignes absentes et met à jour les lignes `PAQUET` dont le checksum a changé. Elle ne touche jamais une ligne `PERSONNALISEE` ou `AJOUTEE`.
- Réinitialiser remet la valeur du paquet et repasse `origine` à PAQUET.

## 2. Cloisonnement
- La zone et le pays de l'institution sont stockés dans `ReportingParametre` (singleton), alimenté par `/setup/init` (zoneCode + paysCode).
- Toutes les lectures sont filtrées par `zone = param.zone` et `(paysCode is null or paysCode = param.pays)`. Un accès par id ou par code hors périmètre renvoie **404**.
- Endpoints supprimés : `POST /formules/zones/active`, `GET /formules/zones`, `DELETE /formules/vider`, `POST /formules/sync`. La synchro devient interne ; seule reste la réinitialisation, exposée plus bas.

## 3. Endpoints

### Paramètres et localisation
| Méthode | Chemin | Corps / réponse |
|---|---|---|
| GET | `/parametres` | `ReportingParametreDto` |
| PUT | `/parametres` | `ReportingParametreDto` (zone et pays ignorés : lecture seule) |
| GET | `/localisation` | `LocalisationDto` (paquet actif, rapports filtrés zone + pays) |

```ts
ReportingParametreDto { zoneCode: string; paysCode: string; zoneLibelle: string; regulateur: string; planComptable: string;
  modeSource: 'INTEGRE'|'STANDALONE'; versionPaquet: string; categorieAssujetti: string|null;  // ex. ART44, CAT2, IMF
  entete: { raisonSociale: string; adresse?: string; numeroAgrement?: string; logoUrl?: string };
  signataires: { fonction: string; nom: string }[] }
LocalisationDto { zoneCode; regulateur; planComptable; versionPaquet; pays: string[]; rapports: RapportDefinitionDto[] }
RapportDefinitionDto { code; libelle; periodicite; delaiJours: number|null; echeance?: string; assujettis: string[];
  destinataire: string[]; layout; nature: 'CALCULE'|'DOCUMENT'|'EXTERNE'; source; confiance: 'HAUTE'|'MOYENNE'|'BASSE';
  origine: 'PAQUET'|'AJOUTEE'; paysCode: string|null; actif: boolean; nbLignes: number }
```

### Formules
| Méthode | Chemin | Corps / réponse |
|---|---|---|
| GET | `/rapports/{code}/formules` | `FormuleDto[]` triés par `ordre` |
| GET | `/formules/{id}` | `FormuleDto` |
| POST | `/rapports/{code}/formules` | `FormuleSaisieDto` → `FormuleDto` (origine AJOUTEE) |
| PUT | `/formules/{id}` | `FormuleSaisieDto` → `FormuleDto` (passe en PERSONNALISEE si différente du paquet) |
| DELETE | `/formules/{id}` | 204 ; refusé (409) si origine ≠ AJOUTEE |
| POST | `/formules/{id}/reinitialiser` | `FormuleDto` |
| POST | `/rapports/{code}/formules/reinitialiser` | `{ reinitialisees: number }` |
| POST | `/formules/reinitialiser-tout` | `{ reinitialisees: number }` |
| POST | `/formules/valider` | `ValidationFormuleRequest` → `ValidationFormuleDto` |
| POST | `/formules/apercu` | `ApercuFormuleRequest` → `ApercuFormuleDto` |
| GET | `/formules/{id}/historique` | `HistoriqueFormuleDto[]` |
| GET | `/rapports/{code}/references` | `{ code; libelle; codeRapport }[]` (lignes référençables pour le constructeur visuel) |

```ts
FormuleDto { id: number; codeRapport; codeLigne; libelle; section?: string; ordre: number;
  comptes: string|null; comptesAllegee: string|null; expression: string|null; sourceDonnees: string|null;
  sens: 'D'|'C'|'SOLDE'; typeValeur: 'MONTANT'|'POURCENTAGE'|'NOMBRE'|'RATIO';
  norme: { operateur: string; valeur: number }|null; normesParCategorie?: Record<string,{operateur:string;valeur:number}>;
  libelleClair: string;                 // ex. « Encours sains ÷ Total actif × 100 »
  origine: 'PAQUET'|'PERSONNALISEE'|'AJOUTEE'; confiance; source; note?: string;
  valeurPaquet: { comptes; expression; norme } | null;   // pour « valeur d'origine vs la vôtre »
  modifiePar?: string; modifieLe?: string; actif: boolean }
FormuleSaisieDto { codeLigne; libelle; section?; ordre; comptes?; comptesAllegee?; expression?; sourceDonnees?; sens; typeValeur; norme?; note?; actif }
ValidationFormuleRequest { codeRapport; codeLigne?; comptes?; expression? }
ValidationFormuleDto { valide: boolean; libelleClair: string;
  erreurs: { type: 'SYNTAXE'|'REFERENCE_INCONNUE'|'CYCLE'|'DIVISION_ZERO_POSSIBLE'|'COMPTE_INCONNU'; message: string; token?: string }[] }
ApercuFormuleRequest { codeRapport; formule: FormuleSaisieDto; periodeDebut: string; periodeFin: string; codeAgence?: string }
ApercuFormuleDto { valeur: number|null; conformite: 'CONFORME'|'NON_CONFORME'|'SANS_NORME'; erreurs: string[];
  contributeurs: { compte: string; libelle: string; solde: number }[] }
HistoriqueFormuleDto { date; utilisateur; action: 'MODIFICATION'|'REINITIALISATION'|'CREATION'|'SUPPRESSION'; avant: Partial<FormuleSaisieDto>; apres: Partial<FormuleSaisieDto> }
```

### Éditions (les endpoints existants sont gardés, auxquels s'ajoutent les suivants)
| Méthode | Chemin | Réponse |
|---|---|---|
| GET | `/editions/tableau-periode?periodeFin=YYYY-MM-DD` | `StatutRapportPeriodeDto[]` (un par rapport de la zone) |
| POST | `/editions/generer` | inchangé ; `sourceDonnees` imposé par `modeSource` (champ client ignoré) |
| GET | `/editions/{id}/controles` | `ControleCoherenceDto[]` |
| POST | `/editions/{id}/soumettre` | `RapportEditionDto` (statut SOUMIS, uniquement depuis VALIDE ou CLOTURE) |
| POST | `/editions/export-zip` | `ExportZipRequest` → `application/zip` (+ `manifest.json`) |

```ts
StatutRapportPeriodeDto { codeRapport; libelle; periodicite; echeance: string|null; enRetard: boolean;
  derniereEditionId: number|null; statut: 'A_FAIRE'|'BROUILLON'|'EN_COURS'|'VALIDE'|'SOUMIS'|'CLOTURE'|'REJETE'; scoreQualite: number|null }
ControleCoherenceDto { code; libelle; niveau: 'CRITIQUE'|'ALERTE'|'INFO'; ok: boolean; valeurRapport?: number; valeurReference?: number; ecart?: number; source: string }
ExportZipRequest { periodeDebut; periodeFin; codesRapport: string[]; formats: ('PDF'|'XLSX')[]; genererManquants: boolean }
```
`RapportLigneDto` reçoit en plus : `valeurPrecedente`, `variation`, `conformite: 'CONFORME'|'NON_CONFORME'|'SANS_NORME'|'ERREUR'`, `erreur?: string`, `confiance`.

### Données importées (mode STANDALONE)
| Méthode | Chemin | Réponse |
|---|---|---|
| GET | `/donnees-importees/modele?periodeFin=` | xlsx (onglet Balance + un onglet par donnée annexe CROSS_SERVICE du paquet) |
| POST | `/donnees-importees/preview` (multipart `fichier`, `periodeFin`) | `ImportPreviewDto` |
| POST | `/donnees-importees/confirm` (multipart) | `ImportLotDto` |
| GET | `/donnees-importees` | `ImportLotDto[]` |
| DELETE | `/donnees-importees/{id}` | 204 |

```ts
ImportPreviewDto { periodeFin; balance: { lignes: number; totalDebit; totalCredit; equilibree: boolean; comptesInconnus: string[] };
  annexes: { cle: string; libelle: string; renseignee: boolean; valeur?: number }[]; erreurs: string[]; avertissements: string[] }
ImportLotDto { id; periodeFin; importeLe; importePar; nbComptes; equilibree: boolean; annexesManquantes: string[] }
```

### États financiers
| Méthode | Chemin | Réponse |
|---|---|---|
| GET | `/etats-financiers?type=BILAN\|CR\|TFT\|NOTES&periodeFin=` | `EtatFinancierDto` |
| GET | `/etats-financiers/export?type=&periodeFin=&format=PDF\|XLSX` | fichier |

```ts
EtatFinancierDto { type; referentiel: string; periodeFin; source: 'INTEGRE'|'STANDALONE'; equilibre: boolean|null;
  lignes: { code; libelle; niveau: number; brut?: number; amortProv?: number; net: number; netN1?: number; note?: string }[] }
```
En mode intégré, les données viennent des endpoints compta (`/etats-financiers/*`). En mode standalone, elles viennent des formules du rapport EF du paquet, appliquées à la balance importée.

## 4. Règles communes
- Les erreurs suivent le format standard du service (`message` lisible, i18n côté Angular).
- Rôles : `ROLE_REPORTING_READ` pour la lecture ; `ROLE_REPORTING_ALL` / `ROLE_REPORTING_FORMULE_*` / `ROLE_ADMIN` pour les écritures (formules, paramètres, imports).
- Montants en `number` (FCFA ou CDF selon la devise de l'institution) ; dates au format ISO `YYYY-MM-DD`.

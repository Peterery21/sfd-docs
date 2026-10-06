# Parametrage de paie IFOD SA (RDC) — jeu `IFOD_RDC`

Document de saisie : ce jeu de parametres est a **entrer par l'interface** (ecrans Parametrage Paie), jamais par script, SQL ni appel API direct.
Le moteur est entierement pilote par les donnees (voir `sfd-paie-service/docs/engine-parametrable.md`) : aucune regle RDC n'est dans le code.
Tous les montants sont en **CDF**. Sources reglementaires : voir le plan de demo (LF 19/005 pour l'IPR, decret 18/041 et arretes 2025 pour la securite sociale, arrete 08/2025 pour l'ONEM).

## 1. Profil

| Ecran | Champ | Valeur |
|---|---|---|
| Parametres pays/profil (`ParamPaysPaie`) | `codePays` (= code du profil) | `IFOD_RDC` |
| | `libellePays`, `devise` | `RDC — IFOD SA`, `CDF` |
| | `smigMensuel` | `559000` (SMIG 21 500 FC/jour x 26 jours, a verifier) |
| | `dureeLegaleHebdo` | `45` |
| | `organismeSecuriteSociale` | `CNSS` |
| | `plafondSecuriteSociale` | `0` (aucun plafond CNSS retenu) |
| | `abattementFiscal` | `0` (pas d'abattement ; l'IPR prevoit une reduction par charge) |
| Configuration paie (`/configuration-paie`) | `profilActifCode` | `IFOD_RDC` |

Parametres cle/valeur (`/param-valeurs`, `profilCode = IFOD_RDC`) — utilises dans les formules par `PARAM.CLE` :

| Cle | Valeur | Usage |
|---|---|---|
| `PLAFOND_LOGEMENT_PCT` | `30` | exoneration de l'indemnite de logement (% du brut) |
| `HEURES_MOIS` | `195` | 45 h x 52 semaines / 12 (taux horaire = salaire de base / HEURES_MOIS) |
| `TAUX_HS_1` | `30` | majoration des 1eres heures supplementaires |
| `TAUX_HS_2` | `60` | majoration des heures suivantes / nuit |
| `TAUX_HS_3` | `100` | majoration dimanche et jours feries |
| `ALLOC_FAM_PAR_ENFANT` | *a confirmer avec IFOD* | allocation familiale legale par enfant (plafonnee a `ALLOC_FAM_MAX_ENFANTS`) |
| `ALLOC_FAM_MAX_ENFANTS` | `6` | nombre d'enfants ouvrant droit (a confirmer) |

## 2. Bareme IPR (`/baremes`, code `IPR`, profil `IFOD_RDC`, type `PROGRESSIF`)

Bareme annuel de la LF 19/005 applique a la base **mensuelle** (annualisation x12).

| Parametre | Valeur |
|---|---|
| `facteurAnnualisation` | `12` |
| `reductionParCharge` | `2` (% d'impot par personne a charge) ; `expressionCharges` laisse vide (= `E.enfants`) ; `minPersonnes` vide ; `maxPersonnes` = `9` |
| `impotMin` | `2000` (par mois, applique si la base est positive) |
| `impotMaxPctBase` | `30` (% de la base mensuelle) |
| `expressionParts`, `abattementPct`, `abattementExpression` | vides (pas de quotient familial, pas d'abattement) |

Lignes (annuel, FC) :

| borneMin | borneMax | taux |
|---|---|---|
| 0 | 1 944 000 | 3 % |
| 1 944 000 | 21 600 000 | 15 % |
| 21 600 000 | 43 200 000 | 30 % |
| 43 200 000 | *(vide = infini)* | 40 % |

(equivalent mensuel : 162 000 / 1 800 000 / 3 600 000.) Utiliser l'**apercu** (`POST /baremes/{id}/apercu?base=760000`, corps `{"enfants":3}`) :
resultat attendu **88 886,40** (cf. cas de reference ci-dessous).

## 3. Cotisations sociales (`/cotisations`, `codePays` = `IFOD_RDC`, `profilCode` = `IFOD_RDC`)

Toutes : `formuleAssiette = A.COTISABLE` (assiette = brut cotisable, sans plafond), `dateEffet` = `2026-01-01`, actives, `deductibleFiscalement` = oui.

| Code | Libelle | Organisme | Type | Taux salarial | Taux patronal |
|---|---|---|---|---|---|
| `CNSS_PENSION` | CNSS — pension | CNSS | RETRAITE | 5 % | 5 % |
| `CNSS_AF` | CNSS — allocations familiales | CNSS | SECURITE_SOCIALE | 0 | 6,5 % |
| `CNSS_RP` | CNSS — risques professionnels | CNSS | SECURITE_SOCIALE | 0 | 1,5 % |
| `INPP` | INPP — formation professionnelle (51 a 300 travailleurs) | INPP | FORMATION | 0 | 3 % |
| `ONEM` | ONEM — emploi (arrete 08/2025) | ONEM | TAXE | 0 | 0,5 % |

Hypothese a valider avec IFOD : les indemnites de logement et de transport sont soumises aux cotisations sociales (assiette = brut complet). Si elles ne le sont pas,
retirer `COTISABLE` de leurs `agregats` (voir 4) — aucune autre modification.

## 4. Rubriques (`/rubriques`, profil `IFOD_RDC` ou vide = tous profils)

Aide a la saisie : l'editeur propose les variables (`E`, `G`, `P`, `V`, `X`, `R`, `A`, `PARAM`) et valide en direct (`POST /rubriques/valider-formule`).
Colonne *Agregats* : `B` = BRUT, `C` = COTISABLE, `I` = IMPOSABLE ; vide = aucun.

| Ordre | Code | Type | Mode | Formule / source | Agregats | Regroupement | Notes |
|---|---|---|---|---|---|---|---|
| 1 | `SAL_BASE` | GAIN | FORMULE | `E.salaireBase` | B C I | SALAIRE_BASE | obligatoire ; salaire charge depuis le contrat/grille RH |
| 2 | `PRIME_ANC` | GAIN | FORMULE | `E.salaireBase * palier('ANCIENNETE', E.ancienneteAnnees) / 100` (`tauxExpression` = `palier('ANCIENNETE', E.ancienneteAnnees)`) | B C I | PRIME_ANCIENNETE | necessite le bareme PALIER `ANCIENNETE` (paliers a definir avec IFOD, ex. 5 ans = 2, 10 ans = 4, 15 ans = 6) |
| 3 | `IND_LOGEMENT` | GAIN | REF_GRILLE | `G.indemniteLogement` (individualisable par personnalisation : montant fixe) | B C | AUTRE_GAIN | exoneree a hauteur de 30 % du brut (ligne suivante) |
| 4 | `IND_LOGEMENT_IMPOSABLE` | INFORMATION | FORMULE | `max(R.IND_LOGEMENT - PARAM.PLAFOND_LOGEMENT_PCT / 100 * A.BRUT, 0)` | I | AUCUN | `imprimable` = non ; part de logement > 30 % du brut, seule imposable |
| 5 | `IND_TRANSPORT` | GAIN | REF_GRILLE | `G.indemniteTransport` (ou personnalisation) | B C | PRIME_TRANSPORT | exoneree d'IPR (4 courses taxi pour les cadres, bus pour les autres) |
| 6 | `ALLOC_FAM` | GAIN | FORMULE | `min(E.enfants, PARAM.ALLOC_FAM_MAX_ENFANTS) * PARAM.ALLOC_FAM_PAR_ENFANT` | B | AUTRE_GAIN | allocations familiales legales exonerees d'IPR ; non cotisables (a confirmer) |
| 7 | `PRIME_RISQUE` | GAIN | SAISIE_VARIABLE | `X.PRIME_RISQUE` (element variable de la periode) | B C I | AUTRE_GAIN | saisie par employe et par mois |
| 8 | `PRIME_RESP` | GAIN | SAISIE_VARIABLE | `X.PRIME_RESP` | B C I | AUTRE_GAIN | prime de responsabilite |
| 9 | `HS_30` | GAIN | FORMULE | `V.hsTaux30 * (E.salaireBase / PARAM.HEURES_MOIS) * (1 + PARAM.TAUX_HS_1 / 100)` | B C I | HEURES_SUPP_25 | `quantiteExpression` = `V.hsTaux30`, unite `h` ; heures validees dans RH avec majoration 30 |
| 10 | `HS_60` | GAIN | FORMULE | `V.hsTaux60 * (E.salaireBase / PARAM.HEURES_MOIS) * (1 + PARAM.TAUX_HS_2 / 100)` | B C I | HEURES_SUPP_50 | `quantiteExpression` = `V.hsTaux60` |
| 11 | `HS_100` | GAIN | FORMULE | `V.hsTaux100 * (E.salaireBase / PARAM.HEURES_MOIS) * (1 + PARAM.TAUX_HS_3 / 100)` | B C I | HEURES_SUPP_AUTRE | `quantiteExpression` = `V.hsTaux100` ; dimanche et jours feries |
| 12 | `RETENUE_ABS` | RETENUE | FORMULE | `min(round(prorata(E.salaireBase, V.joursAbsenceRetenus, P.joursCalendaires), 2), A.BRUT_GAINS)` | B C I | RETENUE_ABSENCE | absences validees `NON_PAYE` (poids 1) et `PARTIEL` (poids 0,5) ; prorata calendaire |
| 13 | `AVANCE_SALAIRE` | RETENUE | SAISIE_VARIABLE | `X.AVANCE_SALAIRE` | (defaut RETENUE : retenue au net) | RETENUE_AUTRE | alimentee ensuite par le circuit « avance sur salaire » ; retenue du mois suivant |
| 20 | `IPR` | IMPOT | FORMULE | `bareme('IPR', A.NET_IMPOSABLE)` (`baseExpression` = `A.NET_IMPOSABLE`) | aucun | AUCUN | libelle « Impot professionnel sur les remunerations (IPR) » repris sur le bulletin et le PDF |

Agregats resultants : base IPR = `A.NET_IMPOSABLE` = (somme des rubriques `I`) - (cotisations salariales deductibles) = brut imposable - CNSS salariale.
Rubriques variables (`PRIME_RISQUE`, `PRIME_RESP`, `AVANCE_SALAIRE`) : saisir les montants dans l'ecran Elements variables de la periode.
Individualisation du logement/transport : ecran Personnalisation de bulletin (montant fixe par employe).

## 5. Cas de reference a verifier apres saisie (simulation)

Employe : salaire de base 820 000, indemnite de logement 300 000, indemnite de transport 80 000, 3 enfants, celibataire (`POST /simulation`).

| Etape | Calcul | Montant |
|---|---|---|
| Brut | 820 000 + 300 000 + 80 000 | 1 200 000 |
| CNSS pension salariale | 1 200 000 x 5 % | 60 000 |
| Charges patronales | 60 000 (pension) + 78 000 (AF 6,5 %) + 18 000 (RP 1,5 %) + 36 000 (INPP 3 %) + 6 000 (ONEM 0,5 %) | 198 000 |
| Imposable | 820 000 + max(300 000 - 30 % x 1 200 000, 0) = 820 000 + 0 | 820 000 |
| Base IPR mensuelle | 820 000 - 60 000 | 760 000 |
| IPR annuel | 760 000 x 12 = 9 120 000 ; 1 944 000 x 3 % = 58 320 ; (9 120 000 - 1 944 000) x 15 % = 1 076 400 | 1 134 720 |
| IPR mensuel | 1 134 720 / 12 | 94 560 |
| Reduction charges | 94 560 x (1 - 3 x 2 %) | 88 886,40 |
| Minimum / maximum | min 2 000 ; max 30 % x 760 000 = 228 000 : non atteints | 88 886,40 |
| **Net a payer** | 1 200 000 - 60 000 - 88 886,40 | **1 051 113,60** |
| Cout employeur | 1 200 000 + 198 000 | 1 398 000 |

Ce cas est verifie par le test automatique `PayrollEngineTest#referenceRdc`.

## 6. Points a confirmer avec IFOD
- Montant legal de l'allocation familiale par enfant et plafond d'enfants.
- Paliers de la prime d'anciennete (convention collective IFOD).
- Soumission des indemnites de logement/transport aux cotisations CNSS (hypothese : soumises).
- Compte de dette des organismes sociaux (432 par defaut) : sujet de la comptabilisation (flux ulterieur).

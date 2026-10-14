# CEMAC — Questions ouvertes du référentiel (adaptées de RCSFD §5-6)

- Zone : CEMAC / COBAC (norme PCEMF). Date : 2026-10-13. Rédacteur : agent de recherche Claude.
- Chaque réponse distingue : IMPOSÉ PAR TEXTE (un texte lu le prescrit), SILENCE DU TEXTE (le texte lu ne dit rien), CHOIX DE PRODUIT (décision d'implémentation). `NON TROUVÉ` = recherche faite, rien trouvé.
- Comptes toujours du PCEMF (classe 3 pour la clientèle). Règles : voir `comptabilite.md`, `epargne.md`, `credit.md`, `parts-sociales.md`.

| # | Question | Réponse (source) | Statut | Règles |
|---|----|----|----|----|
| 1 | Comptes des dépôts des membres par type de produit | À vue : « 371 Comptes courants » (3711 sociétaires, 3712 clients) ou « 372 Comptes de chèques » ; livret : « 373 Comptes sur livrets » ; DAT : « 361 Dépôts à terme » ; garantie : « 374 Dépôts de garantie » (3741 sociétaires, 3742 clients) ; épargne à régime spécial (bons de caisse, CEL, plans retraite, autres) : « 351 »…« 355 Autres comptes d'épargne à régime spécial ». Intérêts : 611-614. Le PCEMF impose le plan (adopté par règlement COBAC) mais ne rattache aucun produit commercial à un compte. | Plan : IMPOSÉ PAR TEXTE ; rattachement d'un produit nommé à un compte : SILENCE DU TEXTE / CHOIX DE PRODUIT | CEMAC-EPA-004, 007, 009, 010, 011 ; CEMAC-CPT-001 |
| 2 | Compte de la caisse de la session (ne pas coder le numéro en dur) | Le plan prévoit « 57 Caisse » (571 Billets et Monnaies : 5710 Caisse FCFA, 5711 Caisse devises) et le virement interne via « 459 Mouvements de fonds et autres virements internes » (solde nul en fin de journée). La notion de caisse de session/guichetier n'existe pas dans le PCEMF. | Existence de 57 : IMPOSÉ PAR TEXTE ; auxiliaire par caisse/agence : SILENCE / CHOIX DE PRODUIT | CEMAC-CPT-008 |
| 3a | Pénalités (de retard, de remboursement anticipé) | NON TROUVÉ : aucun compte dédié dans le PCEMF (recherche des termes « pénalit » : seulement « 664 Etat, pénalités et amendes fiscales », « 6794 Amendes et pénalités fiscales » et « 524 Avances au taux de pénalité », sans rapport). Le TEG exclut les pénalités d'inexécution. | SILENCE DU TEXTE ; compte = CHOIX DE PRODUIT (à valider avec la COBAC) | CEMAC-CRD-007, CEMAC-TUS-004 |
| 3b | Retrait anticipé d'un DAT | Autorisé « dans les conditions précisées » par le contrat d'ouverture ; aucun compte ni pénalité prévus. | Principe : IMPOSÉ PAR TEXTE (renvoi au contrat) ; compte de la pénalité : SILENCE / NON TROUVÉ | CEMAC-EPA-003 |
| 3c | Intérêts de crédit | « 711 Intérêts sur les crédits à long terme », « 712 … à moyen terme », « 713 … à court terme » ; courus : créances rattachées 309/319/329. | IMPOSÉ PAR TEXTE (plan) | CEMAC-CRD-006 |
| 3d | Gain / perte de change | À titre principal : « 723 Commissions et profits sur opérations de change effectuées à titre principal » / « 623 Commissions, frais et pertes sur opération de change effectuées à titre principal » ; à titre accessoire : « 7411 Produits sur opérations de change » / « 6411 Charges sur opérations de change ». Positions : 475, 476, 477. | IMPOSÉ PAR TEXTE (plan) ; choix principal/accessoire : dépend du Règl. 01/17 (non lu) | CEMAC-CPT-012, 013 |
| 3e | Dotations aux provisions | Créances de clientèle : « 6913 Dotations aux provisions pour dépréciation des comptes de clientèle » (contrepartie « 39 ») ; risques et charges : « 6911 » (contrepartie « 19 ») ; stocks : « 6917 » ; reprises « 7913 ». | IMPOSÉ PAR TEXTE (plan) ; taux et calendrier : R-2017/07 non lu (NON TROUVÉ) | CEMAC-CPT-017, CEMAC-CRD-012, 013 |
| 4 | Résolution des numéros courts (compléter par des zéros) ou rejet explicite d'un compte absent | Le PCEMF a des comptes à 2, 3, 4 et 5 chiffres (le 5e = 9 pour le réseau) et est « indicatif » ; aucun texte lu ne traite de la complétion de numéros ni du rejet d'un compte absent du plan. | SILENCE DU TEXTE ; CHOIX DE PRODUIT | CEMAC-CPT-002, 006 |
| 5 | Tontine (cotisations, cagnotte) et épargne planifiée | NON TROUVÉ : ni le PCEMF, ni les textes lus ne mentionnent la tontine ou l'épargne planifiée. Les cotisations et contributions obligatoires d'un membre ne sont pas de l'épargne (1re catégorie). Candidats du plan (non imposés) : « 355 Autres comptes d'épargne à régime spécial » (conventions particulières) ou « 373 Comptes sur livrets ». | SILENCE DU TEXTE ; CHOIX DE PRODUIT | CEMAC-EPA-001, 010 |
| 6 | Classe des comptes de membres vs RCSFD (25xxxx) | PCEMF : la clientèle est en classe 3 (35, 36, 37, 38) ; les parts sociales en classe 1 (compte 100) ; les créances sur les sociétaires (apports) en classe 4 (44). Ne pas utiliser 25xxxx. | IMPOSÉ PAR TEXTE (plan) | CEMAC-CPT-007 |
| 7 | Frais de dossier / assurance emprunteur : quel compte ? | NON TROUVÉ : le PCEMF ne cite ni l'un ni l'autre. Ils entrent dans le TEG. Compte candidat pour une commission de crédit : « 715 Commissions sur opérations avec la clientèle » (7151/7152/7153). | SILENCE DU TEXTE ; CHOIX DE PRODUIT | CEMAC-CRD-007, 008 |
| 8 | Écart de caisse (manquant / excédent) | Manquant : « 4631 Erreurs (manquants) » puis « 6795 Déficits de caisse non récupérés » ; excédent : « 4632 Erreurs (excédents) » / « 7786 Excédents de caisse » (l'excédent ne doit pas être viré directement en produits d'exploitation). | IMPOSÉ PAR TEXTE (comptes) | CEMAC-CPT-010 |
| 9 | Document fonctionnel interne à lire en priorité | Hors périmètre réglementaire : à fournir par le client. | n/a | — |

## Choix de produit (hors réglementation)

- Tout mapping « produit → compte » (qui n'est pas dans le plan) : voir `regles-vers-produit-cemac.md`.

## Lacunes / à confirmer

- Les réponses 3e, 7 dépendent du Règl. COBAC EMF R-2017/07 et du Règl. 01/17 non lus ; elles doivent être revérifiées dès que ces textes sont obtenus.
- La question 4 pourrait être traitée par l'instruction COBAC sur les modèles d'états (non lue).

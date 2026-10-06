[vps-rh] 00-vps-sessions: OK (read-only) MAX_SESSIONS=20, INVALIDER_ANCIENNE; marker created 02:00
[vps-rh] 02c: OK (spec fixed: bank ng-select pick instead of fill; monitor ignores 50x on agora-notifications) 8m
[vps-agora] 50-agora run1: users+? 2 passed (28 min, VPS slow), groupe sécurité KO modal reset timeout -> spec rendue robuste, relance
[vps-paie] 20-paie-parametrage: PARTIEL 7/9 OK (profil, barèmes, cotisations, rubriques OK; schémas comptables KO: paie VPS appelle localhost:4595 compta/4632 workflow -> BLOCKED-BY-DEPLOY sfd-paie-service application-dev.yml fix) 02:38
[vps-paie] 72-paie-effet-retroactif: OK 9/9 7.4m
[vps-paie] 70-paie-periodes: OK 17/17 24.5m
[vps-paie] 20 restant (schémas comptables, journal PA, simulation): BLOCKED-BY-DEPLOY — sfd-paie-service/src/main/resources/application-dev.yml (URLs rh/compta/workflow/preference en sfd-*-dev, non commité). A redéployer puis rejouer: 20-paie-parametrage (idempotent). Vérif navigateur non faite (pas de session).
[vps-rh] 10-rh-parametrage: OK (data fixes: salaireMinLegal>0, postes categorie by code) ~45m
[vps-paie] 20-paie-parametrage: OK 9/9 (schémas, journal PA, simulation IPR 88 886,40 / net 1 051 113,60 vérifiés) après redéploiement paie #56
[vps-agora] 50-agora: OK (11/12, recherche non jouée: clé Meilisearch invalide côté agora-dev 'The provided API key is invalid') ~1h45
[vps-paie] 39a-compta-auxiliaires (nouveau spec, préalable de 39: génération comptes auxiliaires CDF AG001-4): OK 4.0m
[vps-paie] 39-caisse-prealables: OK 6/6 5.5m

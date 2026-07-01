# Tests E2E Playwright — vidéo récap (tous modules)

> **Règle workspace** : après toute implémentation **non triviale** avec impact UI (frontend `sfd-angular` ou parcours cross-module), livrer **une seule vidéo** qui résume le parcours complet — pas N vidéos fragmentées.

Référencé par : [SHARED_RULES.md](SHARED_RULES.md) · [AGENTS.md](../AGENTS.md) · [sfd-angular/CLAUDE.md](../sfd-angular/CLAUDE.md) · [daily-dev](../.cursor/rules/daily-dev.mdc)

---

## Quand c'est obligatoire

| Contexte | Obligatoire |
|----------|-------------|
| Nouvelle feature UI (écran, workflow, module) | ✅ |
| Correction métier multi-étapes (UAT, parcours) | ✅ |
| Bug fix UI 1 ligne / typo / i18n | ❌ (CRUD/smoke suffit) |
| Backend seul sans changement Angular | ❌ (JUnit + curl) |
| Lib Maven (`integration-api`, `report-api`, `demo-data`) | ❌ |

**Backend + frontend** : tests JUnit côté service **et** vidéo récap côté `sfd-angular` avant push Layer 3.

---

## Architecture des fichiers (sfd-angular)

```
e2e/helpers/{feature}-scenarios.ts     # logique métier partagée (1 fn = 1 cas)
e2e/functional/{module}/{feature}-uat.spec.ts    # N tests (CI, debug)
e2e/functional/{module}/{feature}-summary.spec.ts # 1 test = 1 vidéo
e2e/crud/{module}-parcours-crud.spec.ts          # parcours existant (projet parcours)
playwright.config.ts                   # projet parcours : video: 'on'
playwright.{feature}.config.ts         # optionnel si suite UAT dédiée
```

**Sortie vidéo fixe** (copie en fin de test) :

```
e2e-results/{feature}-implementation-summary.webm
```

Exemple tontine : `e2e-results/tontine-implementation-summary.webm`

---

## Pattern `{feature}-summary.spec.ts`

```typescript
test.describe.configure({ mode: 'serial' });

test('FEATURE-SUMMARY-001 — parcours complet (une vidéo)', async ({ page, request }, testInfo) => {
  test.setTimeout(300_000);

  await runAllFeatureScenarios({ ctx, page, request, crud, step: test.step.bind(test) });

  const video = page.video();
  if (video) {
    const src = await video.path();
    if (src && fs.existsSync(src)) {
      fs.copyFileSync(src, SUMMARY_VIDEO_PATH);
      await testInfo.attach('implementation-summary', { path: SUMMARY_VIDEO_PATH, contentType: 'video/webm' });
    }
  }
});
```

**Règles Playwright** :

- Projet dédié ou `parcours` : `video: 'on'`, `fullyParallel: false`, timeout ≥ 300s
- **1 seul `test()`** par feature pour la vidéo récap
- Enchaîner les cas via `test.step('CAS-XXX — libellé', …)`
- Bandeau UI visible dans la vidéo (`annotateVideoStep()` dans le helper scenarios)
- Scénarios réutilisés par les tests granulaires (`*-uat.spec.ts`)

---

## Commandes npm (sfd-angular)

Convention scripts :

```json
"e2e:{module}:summary": "npx playwright test -c playwright.config.ts --project=parcours e2e/crud/{module}-parcours-crud.spec.ts"
"e2e:{feature}:summary": "npx playwright test -c playwright.{feature}.config.ts --project={feature}-summary"
```

| Exemple | Commande | Vidéo |
|---------|----------|-------|
| Parcours épargne | `npx playwright test --project=parcours e2e/crud/epargne-parcours-crud.spec.ts` | 1 vidéo / spec |
| Tontine UAT | `npm run e2e:tontine:summary` | `tontine-implementation-summary.webm` |
| CRUD module | `npx playwright test e2e/crud/<module>-crud.spec.ts --project=crud` | pas de récap (tests unitaires E2E) |

---

## Checklist livraison (Gate 2)

```
□ Scénarios dans e2e/helpers/{feature}-scenarios.ts (zéro duplication)
□ *-uat.spec.ts : tous les cas passent (granulaire)
□ *-summary.spec.ts : 1 test, 1 vidéo, tous les cas en test.step()
□ Vidéo copiée vers e2e-results/{feature}-implementation-summary.webm
□ npm run build → 0 errors
□ Script npm documenté dans package.json + CLAUDE.md
```

---

## Références implémentées

| Module | Spec récap | Scenarios | Config |
|--------|------------|-----------|--------|
| Tontine | `epargne-tontine-summary.spec.ts` | `tontine-uat-scenarios.ts` | `playwright.uat-tontine.config.ts` |
| Client | `client-parcours-crud.spec.ts` | inline | projet `parcours` |
| Crédit | `credit-parcours-crud.spec.ts` | inline | projet `parcours` |
| Caisse | `caisse-parcours-crud.spec.ts` | inline | projet `parcours` |
| Compta | `comptabilite-parcours-crud.spec.ts` | inline | projet `parcours` |
| Épargne | `epargne-parcours-crud.spec.ts` | inline | projet `parcours` |

Nouvelle feature : suivre le pattern **tontine** (scenarios.ts extrait) si ≥ 5 cas métier ; sinon projet `parcours` suffit.

---

*Juin 2026 — erp-sfd workspace*

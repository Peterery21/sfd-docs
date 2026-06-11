# T-AIDE Maintenance Runbook
## Operations Guide for Production Help System

**Version**: 1.0 | **Status**: Production Ready | **Last Updated**: April 2025

---

## Table of Contents

1. [Daily Operations](#1-daily-operations)
2. [Publishing Workflow](#2-publishing-workflow)
3. [Regional Expansion Playbook](#3-regional-expansion-playbook)
4. [Incident Response](#4-incident-response)
5. [Rollback Procedures](#5-rollback-procedures)
6. [Monitoring & Alerts](#6-monitoring--alerts)
7. [Escalation Path](#7-escalation-path)

---

## 1. Daily Operations

### Check 1: Content Validation

**Frequency**: Daily (automated in GitHub Actions)  
**Manual Run**: `npm run help:validate`

**Expected Output**:
```
✓ acces.md: 112 sections, 0 errors
✓ budget.md: 78 sections, 0 errors
✓ caisse.md: 156 sections, 0 errors
✓ credit.md: 189 sections, 0 errors
✓ epargne.md: 199 sections, 0 errors
✓ comptabilite.md: 132 sections, 0 errors
... (all 17 modules)

TOTAL: 1,603 heading IDs, 0 errors, 0 warnings
✅ Validation PASSED
```

**If Failures**:
1. Check GitHub Actions logs: `gh run list --repo Peterery21/sfd-angular --branch develop`
2. Identify failing module
3. Review recent commits: `git log --oneline -- src/assets/help/`
4. Fix issue (see [Troubleshooting](#troubleshooting-guide))
5. Re-run validation: `npm run help:validate`

---

### Check 2: Image Integrity

**Frequency**: Weekly  
**Manual Run**: `npm run help:validate --check-images`

**Expected Output**:
```
✓ Checking 208 image references...
✓ All 208 images found
✓ No broken links detected
✓ Image paths valid for all regions (UEMOA, Maghreb)

TOTAL: 208 images, 0 broken links
✅ Image check PASSED
```

**If Failures**:
1. Identify missing image path: `npm run help:validate --check-images 2>&1 | grep "NOT FOUND"`
2. Add image file or fix markdown reference
3. If regional variant needed, create in `/assets/help-images/{region}/`
4. Re-run: `npm run help:validate --check-images`

---

### Check 3: Glossary Consistency

**Frequency**: Weekly or when glossary updates  
**Manual Run**: `npm run help:sync --validate-glossary`

**Expected Output**:
```
✓ Validating glossary across FR/EN...
✓ All 60 terms present in FR and EN
✓ No conflicting definitions detected
✓ Regional variants consistent

TOTAL: 60 terms, 0 conflicts
✅ Glossary validation PASSED
```

**If Failures**:
1. Identify missing terms: `npm run help:sync --validate-glossary 2>&1 | grep "MISSING"`
2. Add missing term to `help-config.*.ts`
3. Verify FR/EN translation: `npm run help:sync --compare=fr:en`
4. Re-run: `npm run help:sync --validate-glossary`

---

## 2. Publishing Workflow

### Overview

```
Writer edits → Local validation → Commit → GitHub Actions → Jenkins → Deploy
   (30 min)     (10 min)        (5 min)   (2 min)         (5 min)   (2 min)
```

**Total Time**: ~1 hour

---

### Step 1: Writer Edits Help Content

**Tool**: VS Code + Markdown Editor

**Edit Markdown**:
```bash
cd sfd-angular/src/assets/help/fr/
# Edit module, e.g., epargne.md
# Add/modify heading with explicit {#id} anchor
```

**Example**:
```markdown
## 2.3 Nouveau Flux de Création {#nouveau-flux}

Description...

### 2.3.1 Étape 1: Initialisation {#step-1-init}
...
```

---

### Step 2: Local Validation

**Command Sequence**:

```bash
# Terminal 1: Validate structure
npm run help:validate

# Expected: All modules valid, 0 errors

# Terminal 2: If adding new section, check FR/EN sync
npm run help:sync --compare=fr:en --module=epargne

# Expected: ID counts match, 0 mismatches

# Terminal 3: If added images, validate paths
npm run help:validate --check-images

# Expected: All image paths valid, 0 broken links

# Terminal 4: Update menu config (if grouping changed)
npm run help:generate --module=epargne

# Expected: MODULE_MENU_PATTERNS updated (if needed)
```

**Checklist**:
- [ ] `npm run help:validate` passes
- [ ] FR/EN translations synchronized (if EN updated)
- [ ] Image paths valid (if images added)
- [ ] Menu config generated (if structure changed)
- [ ] No conflicts with other recent edits

---

### Step 3: Commit & Push

```bash
# Stage changes
git add src/assets/help/ src/app/core/config/

# Commit with ticket reference
git commit -m "docs(help): update Épargne module with new flow [SE-42]"

# Or multiple commits for large changes
git commit -m "docs(help): add 'Nouveau Flux' section to Épargne [SE-42]"
git commit -m "docs(help): add creation flow diagram [SE-42]"

# Push to develop
git push origin develop
```

**Commit Message Format**:
```
docs(help): [action] [module] [details] [SE-XX]

docs(help): add new section to Épargne module [SE-42]
docs(help): update glossary for 'compte-epargne' [SE-43]
docs(help): add Maghreb region images [SE-44]
```

---

### Step 4: GitHub Actions (Automatic)

**Triggered On**: Push to `develop`

**Actions Performed**:
1. **Validation**: Structure, images, glossary
2. **Generation**: TypeScript configs, menu patterns
3. **Testing**: E2E tests for help panel
4. **Optimization**: Image compression (PNG → WebP)
5. **Auto-Commit**: If changes generated (configs, optimized images)

**Monitoring**:
```bash
# Check workflow status
gh run list --repo Peterery21/sfd-angular --branch develop --limit 3

# View workflow run details
gh run view {run-id}

# Get logs if failed
gh run view {run-id} --log
```

**Expected Status**: ✅ SUCCESS (all steps)

**If Failed**:
1. Check logs: `gh run view {run-id} --log`
2. Identify failing step (validation, test, etc.)
3. Fix locally (see [Troubleshooting](#troubleshooting-guide))
4. Re-push: `git push origin develop`

---

### Step 5: Merge to Main & Deploy

**Prerequisites**:
- GitHub Actions workflow must PASS
- Code review approved (if required)
- No conflicts with main branch

**Merge Process**:
```bash
# Ensure local main is up-to-date
git checkout main
git pull origin main

# Merge develop into main (no-ff for history)
git merge --no-ff develop -m "merge(help): release help content [SE-42]"

# Push to main
git push origin main
```

**Jenkins Deployment**:
- Triggered on push to main
- Builds sfd-admin-angular (includes help assets)
- Runs tests
- Deploys to staging/production

**Monitor Deployment**:
```bash
# Watch Jenkins job
open https://jenkins.evolticatechnologies.com/job/sfd-admin-angular/

# Or via GitHub Actions
gh run list --repo Peterery21/sfd-angular --branch main
```

---

## 3. Regional Expansion Playbook

### Goal: Add Support for New Region

**Example**: Adding "West Africa (Non-UEMOA)" support

**Timeline**: 1-2 days (depending on complexity)

---

### Phase 1: Create Region Config (1 hour)

**Step 1a**: Create configuration file

```bash
# Copy template
cp src/app/core/config/help-config.uemoa.ts \
   src/app/core/config/help-config.wa-non-uemoa.ts
```

**Step 1b**: Edit configuration

```typescript
// src/app/core/config/help-config.wa-non-uemoa.ts

import { HelpConfig } from '../models/help-config';

export const helpConfigWaNonUemoa: HelpConfig = {
  contextMap: {
    'epargne': 'epargne',
    'credit': 'credit',
    // ... same as UEMOA
  },

  moduleLabels: {
    'epargne': 'Épargne (West Africa)',
    'credit': 'Crédit (West Africa)',
    // Regional names
  },

  glossary: {
    'compte-epargne': {
      fr: 'Compte d\'épargne selon directives WAEMU',
      en: 'Savings Account per WAEMU guidelines'
    },
    // ... override regional terms
  },

  images: {
    'epargne/dashboard': '/assets/help-images/wa-non-uemoa/epargne/dashboard.png',
    // Regional image paths
  },

  regulatoryFramework: {
    regulator: 'West Africa Central Bank',
    framework: 'WAEMU Directives 2025',
    links: {
      bceao: 'https://www.bceao.int/',
      compliance: 'https://...'
    }
  }
};
```

**Step 1c**: Register region in HelpConfigService

```typescript
// src/app/core/config/help-config.service.ts

export function getHelpConfig(region: string): HelpConfig {
  switch (region) {
    case 'uemoa':
      return helpConfigUemoa;
    case 'maghreb-test':
      return helpConfigMaghreb;
    case 'wa-non-uemoa':           // ← Add this
      return helpConfigWaNonUemoa;
    default:
      return helpConfigUemoa;
  }
}
```

**Validation**:
```bash
npm run help:validate --region=wa-non-uemoa
# Expected: ✓ Config loaded, 0 errors
```

---

### Phase 2: Regional Images (2-4 hours)

**Step 2a**: Assess critical images

```bash
# Identify text-heavy images
find src/assets/help-images/fr -name "*.png" -exec file {} \; | \
  grep -i "text\|ocr" | wc -l

# Only 8 images have significant text → 2 hours to customize
```

**Step 2b**: Create regional directory

```bash
mkdir -p src/assets/help-images/wa-non-uemoa/{epargne,credit,caisse}
```

**Step 2c**: Copy and customize critical images

```bash
# Epargne dashboard (contains BCEAO logo → customize)
cp src/assets/help-images/fr/epargne/dashboard.png \
   src/assets/help-images/wa-non-uemoa/epargne/dashboard.png
# Edit in Photoshop/Figma to replace BCEAO with WACB logo

# Credit workflow (generic flow → no change needed)
# → Use fallback to FR version
```

**Step 2d**: Update image aliases in config

```typescript
// src/app/core/config/help-config.wa-non-uemoa.ts

images: {
  'epargne/dashboard': '/assets/help-images/wa-non-uemoa/epargne/dashboard.png',
  'epargne/workflow': '/assets/help-images/fr/epargne/workflow.png',  // Fallback
  // ... other images (fallback to FR)
}
```

**Validation**:
```bash
npm run help:validate --check-images --region=wa-non-uemoa
# Expected: All 208 image paths valid (regional + fallback)
```

---

### Phase 3: Translation (8-16 hours, if new language)

**If region uses existing language (FR)**: Skip this phase

**If new language (e.g., Portuguese for Angola)**:

**Step 3a**: Copy markdown structure

```bash
# Create English structure (as example)
mkdir -p src/assets/help/pt/
cp src/assets/help/fr/* src/assets/help/pt/
```

**Step 3b**: Translate content

```bash
# Using professional translator or machine translation (reviewed)
# Requirements:
#   - Preserve all heading IDs
#   - Maintain markdown formatting
#   - Apply glossary terms (translated)
#   - Keep technical terms consistent
```

**Step 3c**: Sync languages

```bash
npm run help:sync --compare=fr:pt --module=epargne
# Expected: ID counts match, 0 mismatches
```

**Step 3d**: Validate glossary

```bash
npm run help:sync --validate-glossary
# Expected: All terms translated to PT, 0 conflicts
```

---

### Phase 4: Testing (2-3 hours)

**Step 4a**: E2E tests with new region

```bash
npm run test:help-system --region=wa-non-uemoa
```

**Test Checklist**:
- [ ] Help panel loads for all 17 modules
- [ ] Menu navigation works (groups collapsible)
- [ ] Headings extract correctly
- [ ] Images load (regional + fallback)
- [ ] Glossary terms displayed correctly
- [ ] Language switch works
- [ ] Region switch works (from UEMOA → WA-NonUEMOA)
- [ ] Performance <500ms for all operations

**Step 4b**: Manual spot checks

```bash
# User journey 1: Navigate to Épargne module in new region
# - Help panel loads
# - Dashboard image shows WACB logo (regional version)
# - Glossary terms use regional language
# - Menu groups organize content

# User journey 2: Switch from UEMOA to WA-NonUEMOA
# - All modules reload
# - Images switch to regional versions
# - Glossary updates

# User journey 3: Accessibility
# - Screen reader reads heading IDs correctly
# - Images have alt text in region language
# - Keyboard navigation works
```

---

### Phase 5: Merge & Deploy (30 min)

```bash
# Commit all changes
git add src/app/core/config/help-config.wa-non-uemoa.ts
git add src/assets/help-images/wa-non-uemoa/
git commit -m "feat(help): add WA-NonUEMOA region support [SE-50]"

# Create feature branch
git checkout -b feature/help-wa-non-uemoa
git push origin feature/help-wa-non-uemoa

# Create Pull Request
gh pr create --title "feat(help): add WA-NonUEMOA region" \
            --body "Adds region config, images, glossary for West Africa non-UEMOA region"

# Merge when approved
gh pr merge --merge  # Squash or create merge commit per team policy

# Deploy
git checkout main && git pull
git merge --no-ff develop
git push origin main
```

---

## 4. Incident Response

### Scenario A: Help Content Missing

**Symptom**: User reports "Module XYZ help not found" or 404 error

**Investigation**:
```bash
# Step 1: Verify file exists
ls -la src/assets/help/fr/xyz.md

# Step 2: Verify module is in MODULE_MENU_PATTERNS
grep -r "xyz" src/app/core/models/help-menu.model.ts

# Step 3: Check recent commits
git log --oneline -- src/assets/help/ | head -5

# Step 4: Run validation
npm run help:validate
```

**Root Cause Analysis**:
- **File deleted accidentally**: Check git history, restore from commit
- **File not in menu patterns**: Module not registered in patterns
- **Build issue**: Module not included in ng build artifacts

**Resolution**:

*Case A1: File deleted*
```bash
# Restore from recent commit
git checkout <commit>~1 -- src/assets/help/fr/xyz.md
git add src/assets/help/fr/xyz.md
git commit -m "fix(help): restore deleted xyz module [SE-XX]"
git push
```

*Case A2: Module not in menu patterns*
```bash
# Add to MODULE_MENU_PATTERNS
nano src/app/core/models/help-menu.model.ts
# Add: MODULE_MENU_PATTERNS['xyz'] = [...]

git add src/app/core/models/help-menu.model.ts
git commit -m "fix(help): register xyz module in menu patterns [SE-XX]"
git push
```

*Case A3: Build issue*
```bash
# Verify file included in build
npm run build
ls -la dist/nexora/browser/assets/help/fr/xyz.md

# If missing, check angular.json assets configuration
grep -A 5 '"glob": "*.md"' angular.json

# Rebuild
npm run build
```

---

### Scenario B: Image Broken (404)

**Symptom**: Help panel shows broken image icon

**Investigation**:
```bash
# Step 1: Identify image in markdown
grep -r "help-images" src/assets/help/fr/xyz.md

# Output: ![...](/assets/help-images/fr/xyz/image.png)

# Step 2: Verify file exists
ls -la src/assets/help-images/fr/xyz/image.png

# Step 3: Check image aliases (if regional)
grep "xyz/image" src/app/core/config/help-config.*.ts

# Step 4: Run image validation
npm run help:validate --check-images
```

**Root Cause Analysis**:
- **Path typo**: `/help-images` vs `/help_images`, case sensitivity
- **File missing**: Not committed or lost in merge
- **Regional override broken**: Image path in config incorrect

**Resolution**:

*Case B1: Path typo*
```bash
# Edit markdown with correct path
nano src/assets/help/fr/xyz.md
# Change: `/help-images/...` (correct)
# From: `/help_images/...` (wrong)

git add src/assets/help/fr/xyz.md
git commit -m "fix(help): correct image path in xyz module [SE-XX]"
git push
```

*Case B2: File missing*
```bash
# Designer provides image
mkdir -p src/assets/help-images/fr/xyz/
cp ~/Downloads/image.png src/assets/help-images/fr/xyz/

git add src/assets/help-images/fr/xyz/image.png
git commit -m "docs(help): add missing image to xyz module [SE-XX]"
git push
```

*Case B3: Regional override broken*
```bash
# Fix image alias in config
nano src/app/core/config/help-config.maghreb-test.ts
# Verify path: '/assets/help-images/maghreb/...'

# Or remove broken override to fallback to UEMOA
images: {
  // Remove bad entry: 'xyz/image': '/broken/path'
}

git add src/app/core/config/help-config.*.ts
git commit -m "fix(help): correct image alias for xyz module [SE-XX]"
git push
```

---

### Scenario C: Glossary Term Mismatch

**Symptom**: Same term shown differently in different modules, or not translated

**Investigation**:
```bash
# Step 1: Search for term usage
grep -r "compte-epargne" src/assets/help/

# Step 2: Check glossary definitions
grep -r "compte-epargne" src/app/core/config/

# Step 3: Verify FR/EN synchronization
npm run help:sync --validate-glossary

# Step 4: Check regional overrides
grep -A 2 "compte-epargne" src/app/core/config/help-config.*.ts
```

**Root Cause Analysis**:
- **Term not in glossary**: Hardcoded in markdown instead of glossary
- **FR/EN mismatch**: Term defined in FR but not EN (or vice versa)
- **Regional override missing**: New region added but glossary not updated

**Resolution**:

*Case C1: Term not in glossary*
```bash
# Add term to glossary
nano src/app/core/config/help-config.uemoa.ts

# Add:
glossary: {
  'compte-epargne': {
    fr: 'Compte d\'épargne: dépôt rémunéré auprès de la banque',
    en: 'Savings Account: interest-bearing deposit at bank'
  },
  // ...
}

git add src/app/core/config/help-config.uemoa.ts
git commit -m "fix(help): add compte-epargne to glossary [SE-XX]"
git push
```

*Case C2: FR/EN mismatch*
```bash
# Update glossary to include both languages
nano src/app/core/config/help-config.uemoa.ts

# Change:
# glossary: { 'compte-epargne': { fr: 'French text' } }  // Missing EN
# To:
# glossary: { 
#   'compte-epargne': { 
#     fr: 'French text',
#     en: 'English text'
#   } 
# }

npm run help:sync --validate-glossary
git add src/app/core/config/help-config.uemoa.ts
git commit -m "fix(help): synchronize glossary FR/EN [SE-XX]"
git push
```

*Case C3: Regional override missing*
```bash
# Update new region's glossary
nano src/app/core/config/help-config.wa-non-uemoa.ts

glossary: {
  'compte-epargne': {
    fr: 'Compte d\'épargne selon directives WAEMU',
    en: 'Savings Account per WAEMU guidelines'
  },
  // ...
}

git add src/app/core/config/help-config.wa-non-uemoa.ts
git commit -m "fix(help): add glossary terms to new region [SE-XX]"
git push
```

---

## 5. Rollback Procedures

### If Critical Issue Found Post-Deploy

**Scenario**: Deployed help content causes production outage (e.g., broken JavaScript in component)

**Immediate Action** (< 5 min):

```bash
# Step 1: Identify last known good commit
git log --oneline main | head -10
# Output:
# a1b2c3d fix(help): update glossary [SE-42]  ← Current (broken)
# d4e5f6g docs(help): add Épargne section [SE-41]
# g7h8i9j feat(help): region support [SE-40]  ← Last known good

# Step 2: Revert to good state
git revert a1b2c3d -m 1 --no-edit

# Or reset if needed (dangerous, use only if revert fails)
git reset --hard d4e5f6g
```

**Step 3: Validate before re-deploy**
```bash
npm run help:validate
npm run help:sync
npm run build

# If all pass:
git push origin main
```

**Step 4: Monitor re-deployment**
```bash
# Watch Jenkins build
open https://jenkins.evolticatechnologies.com/job/sfd-admin-angular/

# Or check GitHub Actions
gh run list --repo Peterery21/sfd-angular --branch main
```

**Step 5: Root Cause Analysis** (after stabilization)

```bash
# What broke?
git show a1b2c3d --stat

# Why wasn't this caught in testing?
npm run help:validate
npm run test:help-system

# What should prevent this in future?
# - Add pre-commit hooks?
# - Improve test coverage?
# - Require code review?
```

---

## 6. Monitoring & Alerts

### Metrics to Track

| Metric | Target | Tool | Alert Threshold |
|--------|--------|------|-----------------|
| Validation pass rate | 100% | GitHub Actions | <95% |
| Image loading success | 99.9% | CloudFront logs | <99% |
| Help panel load time | <500ms | APM/Datadog | >1s |
| Language switch time | <200ms | APM/Datadog | >500ms |
| Region switch time | <150ms | APM/Datadog | >300ms |

---

### Setup Alerts

#### GitHub Actions Alerts

```bash
# Create workflow for notifications
# .github/workflows/help-alerts.yml

name: Help System Alerts
on: [workflow_run]
jobs:
  notify:
    if: failure()
    runs-on: ubuntu-latest
    steps:
      - name: Slack notification
        uses: slackapi/slack-github-action@v1
        with:
          payload: |
            {
              "text": "❌ Help validation failed",
              "channel": "#devops-alerts"
            }
```

#### Dashboard Monitoring

**Tools**: Datadog, New Relic, or custom dashboard

**Metrics**:
```
help.validation.pass_rate      → 100%
help.image.loading.success     → 99.9%
help.panel.load_time.p95       → <500ms
help.language.switch.time.p95  → <200ms
help.region.switch.time.p95    → <150ms
```

---

## 7. Escalation Path

| Issue | Severity | Owner | SLA | Escalate to |
|-------|----------|-------|-----|-------------|
| Validation failure | 🔴 High | Writer + Dev | 1 hour | Tech Lead |
| Image broken | 🟡 Medium | DevOps + Designer | 2 hours | Arch |
| Performance degradation | 🟡 Medium | Dev + SRE | 2 hours | Arch |
| Regional expansion | 🟢 Low | Arch + DevOps | 1 day | PM |
| Security concern | 🔴 Critical | Security + Lead | 30 min | CTO |
| Content out-of-date | 🟢 Low | Writer | 1 week | PM |

---

### Escalation Process

**Step 1**: Identify severity
```
🔴 Critical: Security breach, data loss, outage
🟡 High: Feature broken, user impact
🟢 Medium: Performance issue, missing documentation
🟢 Low: Content update, enhancement request
```

**Step 2**: Notify owner
```bash
# Create Jira ticket
curl -u "$JIRA_EMAIL:$JIRA_TOKEN" \
  -X POST https://kodzotech.atlassian.net/rest/api/3/issue \
  -H "Content-Type: application/json" \
  -d '{
    "fields": {
      "project": {"key": "SE"},
      "summary": "[HELP] Issue title",
      "issuetype": {"name": "Bug"},
      "priority": {"name": "High"},
      "assignee": {"id": "owner-id"}
    }
  }'

# Or Slack notification
slack -c "#help-system-team" "🔴 Help system alert: [issue details]"
```

**Step 3**: If SLA at risk, escalate
```bash
# Notify manager/tech lead
slack -c "@tech-lead" "Help system escalation needed - SLA at risk"
```

---

## Appendix: Quick Commands

### Validation
```bash
npm run help:validate                            # All checks
npm run help:validate --region=maghreb-test      # Specific region
npm run help:validate --check-images             # Images only
```

### Generation
```bash
npm run help:generate                            # All modules
npm run help:generate --module=epargne           # Single module
npm run help:generate --force                    # Overwrite existing
```

### Synchronization
```bash
npm run help:sync --compare=fr:en                # FR/EN comparison
npm run help:sync --validate-glossary            # Glossary only
npm run help:sync --fix                          # Auto-fix mismatches
```

### Testing
```bash
npm run test:help-system                         # All tests
npm run test:help-system --region=uemoa          # Single region
npm test -- --include="help"                     # Help tests only
```

### Building
```bash
npm run build                                    # Full build
npm run build -- --watch                         # Watch mode
npm run build -- --prod                          # Production build
```

---

**Runbook Version**: 1.0  
**Last Updated**: April 2025  
**Maintained By**: DevOps Team  
**Emergency Contact**: devops@uemoa.local

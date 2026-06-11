# T-AIDE: Tiered Accessibility Driven Environment
## Technical Architecture & Design Document

---

## 1. Overview

**T-AIDE** (Tiered Accessibility Driven Environment) is a multi-region, multi-language contextual help system designed for the SFD banking platform. It provides role-aware, context-sensitive help across 17 core modules with support for 2 languages (French, English) and multiple regional configurations (UEMOA, Maghreb, etc.).

### Key Metrics
- **17 Core Modules**: Épargne, Crédit, Caisse, Comptabilité, Stock, Paie, RH, Budget, Immobilisation, Transfert, Reporting, Suivi-Évaluation, Commercial, Préférence, Accès, Client, Default
- **Content Volume**: 18,347 lines of Markdown across all modules
- **Heading IDs**: 1,603+ unique identifiers (extracted from headings)
- **Glossary**: 60+ financial terms with regional variants
- **Images**: 208 help images (screenshots, diagrams, flow charts)
- **Regions**: UEMOA (default), Maghreb (test), extensible to additional regions

### Use Cases
1. **User Support**: Context-aware help panels when users need guidance
2. **Onboarding**: Role-specific help content for new users
3. **Mobile**: Help accessible from mobile app (sfd-agent-mobile-flutter)
4. **Compliance**: Regional regulatory frameworks (BCEAO, BCM, etc.)
5. **Accessibility**: Automatic i18n, glossary expansion, screen reader support

---

## 2. Architecture

### 2.1 Core Components

#### HelpConfigService
**Purpose**: Single source of truth for region-specific configurations.

**Key Features**:
- Dependency injection for lazy-loaded region configs
- Dynamic region switching at runtime
- Caching in memory to avoid re-loading
- Observable pattern for reactive updates

**Implementation Location**: `sfd-angular/src/app/core/config/help-config.service.ts`

```typescript
@Injectable({ providedIn: 'root' })
export class HelpConfigService {
  private currentRegion = 'uemoa';
  private config: HelpConfig;

  setRegion(region: string): void {
    this.currentRegion = region;
    this.config = getHelpConfig(region); // Lazy import
  }
  
  getConfig(): HelpConfig {
    return this.config;
  }
}
```

**Loaded Configs**:
- `help-config.uemoa.ts` — Default UEMOA configuration
- `help-config.maghreb-test.ts` — Maghreb test region
- Extensible: Add new `help-config.{region}.ts` for additional regions

**Config Properties**:
```typescript
interface HelpConfig {
  contextMap: Record<string, string>;           // Route → module mapping
  moduleLabels: Record<string, string>;         // FR/EN labels
  glossary: Glossary;                           // Regional glossary terms
  images: ImageAliasMap;                        // Region-specific image paths
  regulatoryFramework: RegulatoryInfo;          // Local regulator info
}
```

---

#### MenuGroup & TocHierarchical
**Purpose**: Hierarchical menu structure for navigating help content.

**Key Features**:
- Grouping of headings by pattern (module-specific)
- Collapsible groups in UI
- Heading ID → menu section mapping
- `MODULE_MENU_PATTERNS` registry for pattern-based grouping

**Implementation Location**: `sfd-angular/src/app/core/models/help-menu.model.ts`

```typescript
interface MenuGroup {
  id: string;                    // 'intro', 'operations', 'advanced'
  label: string;                 // Display label
  pattern?: RegExp;              // Regex to identify group headings
  icon?: string;                 // Optional icon
  sections: MenuSection[];       // Child sections
}

interface TocHierarchical {
  moduleLabel: string;           // 'Épargne', 'Crédit', etc.
  groups: MenuGroup[];           // Hierarchical groups
}
```

**Pattern Registry** (`MODULE_MENU_PATTERNS`):
```typescript
// Auto-populated per module
MODULE_MENU_PATTERNS = {
  'epargne': [
    { id: 'intro', label: 'Introduction', pattern: /^##\s+1\.|^##\s+Introduction/ },
    { id: 'operations', label: 'Opérations', pattern: /^##\s+2\.|^##\s+Opération/ },
    { id: 'advanced', label: 'Avancé', pattern: /^##\s+3\.|^##\s+Paramét/ }
  ],
  // ... other modules
}
```

**Menu Extraction Flow**:
1. Load module markdown from `/assets/help/fr/{module}.md`
2. Extract all headings with explicit `{#id}` anchors
3. Group by `MODULE_MENU_PATTERNS` regex
4. Generate `TocHierarchical` for UI rendering

---

#### HelpImageAliasService
**Purpose**: Region-specific image substitution with fallback logic.

**Key Features**:
- Path aliasing for region-specific screenshots
- Fallback to UEMOA default if region variant missing
- Image metadata (alt text, captions) per region
- Performance optimized (no file system checks at runtime)

**Implementation Location**: `sfd-angular/src/app/core/services/help-image-alias.service.ts`

```typescript
@Injectable({ providedIn: 'root' })
export class HelpImageAliasService {
  resolveImageAlias(defaultPath: string, region: string): string {
    // Example:
    // Input:  '/assets/help-images/fr/epargne/dashboard.png'
    // Region: 'maghreb'
    // Output: '/assets/help-images/maghreb/epargne/dashboard.png'
    //         (or fallback to UEMOA if not found)
  }

  getImageMetadata(id: string, region: string): ImageMetadata {
    // Returns alt text, caption in region's language
  }
}
```

**Directory Structure**:
```
src/assets/help-images/
├── fr/                          # Default UEMOA
│   ├── epargne/
│   │   ├── dashboard.png
│   │   └── workflow-creation.png
│   ├── credit/
│   └── ...
├── maghreb/                     # Maghreb region override
│   ├── epargne/
│   │   └── dashboard.png        # Region-specific if text in UI
│   └── ...
└── en/                          # English screenshots (future)
```

---

#### HelpMenuExtractor
**Purpose**: Parse markdown and extract hierarchical menu structure.

**Key Features**:
- Heading level detection (H1-H6)
- Explicit ID extraction from `{#id}` anchors
- Auto-ID generation from title if not explicit
- Section grouping by pattern

**Implementation Location**: `sfd-angular/src/app/core/generators/help-menu-extractor.ts`

```typescript
export class HelpMenuExtractor {
  extract(): TocHierarchical {
    // 1. Parse markdown for headings
    // 2. Extract heading level + title + ID
    // 3. Group by MODULE_MENU_PATTERNS
    // 4. Return TocHierarchical
  }

  private extractSections(): MenuSection[] {
    // Regex: /^(#{1,6})\s+(.+?)(?:\s*\{#([\w-]+)\})?$/
    // Captures: level, title, explicit ID (optional)
  }

  private generateIdFromTitle(title: string): string {
    // 'Créer un Compte' → 'creer-un-compte'
  }
}
```

---

#### FieldDictionary.generator
**Purpose**: Auto-generate field documentation from OpenAPI specs.

**Key Features**:
- 4 generation methods: OpenAPI, FormModel, i18n, regions
- 26 validation checks for completeness
- Markdown injection into help modules
- Links to field definitions in help content

**Implementation Location**: `sfd-angular/src/app/core/generators/field-dictionary.generator.ts`

```typescript
export class FieldDictionaryGenerator {
  /**
   * Generate documentation from multiple sources
   */
  generate(sources: GenerationSource[]): FieldDictionary {
    // Sources: OpenAPI, FormModel, i18n, regional overrides
  }

  /**
   * Validate 26 completeness checks
   */
  validate(): ValidationResult {
    // Check: required fields defined, examples provided, 
    // translations present, image references valid, etc.
  }

  /**
   * Inject generated docs into module markdown
   */
  injectIntoModule(markdown: string, fieldDocs: FieldDictionary): string {
    // Insert field definitions alongside help content
  }
}
```

**Validation Checks**:
1. Required fields documented
2. Types specified (text, number, date, enum)
3. Examples provided
4. Constraints listed (min, max, pattern)
5. Translations present (FR/EN)
6. Glossary terms linked
7. Image references valid
8. Help module structure correct
9. i18n keys synchronized
10. Regional overrides consistent
... and 16+ more checks

---

### 2.2 Workflow: Module Help Loading

```
User navigates to /epargne/create
     ↓
RouteGuard checks auth
     ↓
HelpPanelComponent initializes
     ↓
HelpService.loadModule('epargne')
     ↓
HelpConfigService.getConfig()        ← Cached, <50ms
     ↓
Fetch /assets/help/fr/epargne.md     ← 98,966 bytes
     ↓
HelpMenuExtractor.extract()          ← Parse headings, <100ms
     ↓
HelpImageAliasService.resolve()      ← Resolve image paths, <50ms
     ↓
Glossary substitution               ← Replace terms, <30ms
     ↓
Render help panel with TOC            ← <300ms total
```

---

### 2.3 Workflow: Region Switching

```
User selects "Maghreb" from region dropdown
     ↓
HelpConfigService.setRegion('maghreb-test')
     ↓
Load help-config.maghreb-test.ts     ← Lazy import, <50ms
     ↓
Update glossary (regional variants)   ← <30ms
     ↓
Reload current module                 ← <150ms
     ↓
Switch image aliases                  ← <50ms
     ↓
Refresh all UI bindings               ← <200ms total
```

---

## 3. Adding a New Region

### Step 1: Create Region Config (1 hour)

Create `src/app/core/config/help-config.{region}.ts`:

```typescript
import { HelpConfig } from '../models/help-config';

export const helpConfig{Region}: HelpConfig = {
  contextMap: {
    'epargne': 'epargne',
    'credit': 'credit',
    // Map routes to module keys
  },

  moduleLabels: {
    'epargne': 'Épargne{RegionName}',
    'credit': 'Crédit{RegionName}',
    // Labels in regional language
  },

  glossary: {
    'compte-epargne': {
      fr: 'Compte d\'épargne {region-specific}',
      en: 'Savings Account {region-specific}'
    },
    // Regional term variants
  },

  images: {
    'epargne/dashboard': '/assets/help-images/{region}/epargne/dashboard.png',
    'epargne/workflow': '/assets/help-images/fr/epargne/workflow.png', // Fallback
    // Image path overrides
  },

  regulatoryFramework: {
    regulator: 'Name of regional regulator',
    framework: 'E.g., BCEAO directives',
    links: { /* ... */ }
  }
};
```

### Step 2: Update HelpConfigService (30 min)

```typescript
// sfd-angular/src/app/core/config/help-config.service.ts

export function getHelpConfig(region: string): HelpConfig {
  switch (region) {
    case 'uemoa':
      return helpConfigUemoa;
    case 'maghreb-test':
      return helpConfigMaghreb;
    case '{new-region}':
      return helpConfig{Region};  // ← Add here
    default:
      return helpConfigUemoa;
  }
}
```

### Step 3: Create Regional Images (2-4 hours)

```bash
mkdir -p src/assets/help-images/{region}/{module}/
# Copy and customize screenshots with region-specific text
```

### Step 4: Test Multi-Language + Region (2 hours)

```bash
npm run help:validate --region={region}
npm run help:sync --compare=fr:en --region={region}
npm run test:help-system --region={region}
```

### Step 5: Deploy

```bash
git add .
git commit -m "feat(help): add {region} support [SE-XX]"
git push origin feature/help-{region}
# GitHub Actions validates, Jenkins builds, deploy
```

---

## 4. Maintenance: Updating Help Content

### Scenario A: Add New Section to Module

**Goal**: Add section "4. Nouveau Produit" to Épargne module

**Step 1**: Edit markdown
```bash
# Edit: src/assets/help/fr/epargne.md
# Add at end:

## 4. Nouveau Produit {#nouveau-produit}

Description du nouveau produit...

### 4.1 Caractéristiques {#nouveau-produit-caracteristiques}
...
```

**Step 2**: Validate structure
```bash
npm run help:validate
# Output: ✓ epargne.md: 5 sections, 199 headings, 0 errors
```

**Step 3**: Translate to English
```bash
# Edit: src/assets/help/en/epargne.md
# Add with SAME heading ID:

## 4. New Product {#nouveau-produit}

Product description...

### 4.1 Features {#nouveau-produit-caracteristiques}
...
```

**Step 4**: Sync languages
```bash
npm run help:sync --compare=fr:en --module=epargne
# Output: ✓ FR/EN IDs match (199 headings each)
```

**Step 5**: Generate menu config
```bash
npm run help:generate --module=epargne
# Updates MODULE_MENU_PATTERNS if grouping changed
```

**Step 6**: Commit & push
```bash
git add src/assets/help/
git commit -m "docs(help): add Nouveau Produit section to Épargne [SE-XX]"
git push
# GitHub Actions validates + auto-tests
```

---

### Scenario B: Update Glossary Term

**Goal**: Update definition of "compte-epargne" with regional variants

**Step 1**: Edit glossary
```typescript
// src/app/core/config/help-config.uemoa.ts
glossary: {
  'compte-epargne': {
    fr: 'Compte d\'épargne: dépôt rémunéré auprès de la banque (BCEAO)',
    en: 'Savings Account: interest-bearing deposit at bank (BCEAO)',
    'maghreb-variant': 'Compte d\'épargne: selon réglementation BCM'
  },
  // ...
}
```

**Step 2**: Validate glossary
```bash
npm run help:sync --validate-glossary
# Output: ✓ All terms present in FR/EN, 0 conflicts
```

**Step 3**: Commit & push
```bash
git add src/app/core/config/help-config*.ts
git commit -m "docs(help): update glossary definitions [SE-XX]"
git push
```

---

### Scenario C: Add Image to Module

**Goal**: Add screenshot showing "Création de compte" flow to Épargne help

**Step 1**: Create image
```bash
# Designer creates: src/assets/help-images/fr/epargne/create-flow.png
```

**Step 2**: Reference in markdown
```markdown
## 2.1 Flux de Création {#flux-creation}

![Flux de création d'un compte d'épargne](/assets/help-images/fr/epargne/create-flow.png)

Etapes:
1. Cliquer sur "Créer compte"
...
```

**Step 3**: Validate image paths
```bash
npm run help:validate --check-images
# Output: ✓ All 208 images found, 0 broken links
```

**Step 4**: Add regional override (if needed)
```bash
# Create: src/assets/help-images/maghreb/epargne/create-flow.png
# Update help-config.maghreb-test.ts:
images: {
  'epargne/create-flow': '/assets/help-images/maghreb/epargne/create-flow.png'
}
```

**Step 5**: Commit & push
```bash
git add src/assets/help-images/ src/assets/help/
git commit -m "docs(help): add creation flow diagram to Épargne [SE-XX]"
git push
```

---

## 5. Troubleshooting Guide

| Issue | Root Cause | Solution |
|-------|-----------|----------|
| "Heading ID not found" | Missing `{#id}` anchor in markdown | Add explicit anchor to heading: `## Title {#id}` |
| "FR/EN IDs don't match" | Translated heading but ID not preserved | Keep same `{#id}` during translation |
| "Image 404" | Wrong path or missing file | Verify path in markdown, check file exists |
| "Glossary term not recognized" | Term not in glossary-observed.en.ts | Add to glossary or use regional override |
| "Menu group missing" | MODULE_MENU_PATTERNS regex too strict | Adjust heading pattern or grouping logic |
| "Region not loading" | help-config.{region}.ts not imported | Add to getHelpConfig() switch statement |
| "Performance slow" | Large module or missing cache | Check HelpConfigService caching, profile load times |
| "Content not translating" | i18n key missing or wrong path | Verify key in fr.json AND en.json |

---

## 6. Performance Considerations

### Baseline Targets

| Operation | Target | Notes |
|-----------|--------|-------|
| Config load | <50ms | Cached after first load |
| Menu generation | <100ms | Heading extraction from markdown |
| Module load | <300ms | Fetch + parse + render |
| Language switch | <200ms | Observable update |
| Region switch | <150ms | Config reload + glossary update |
| Image load | <100ms each | Lazy load on scroll |
| Full module (complex) | <500ms | 1000+ lines, 100+ headings, 10+ images |

### Optimization Strategies

1. **Lazy Loading**: Load modules only when user navigates to them
2. **Caching**: Cache configs in memory (region × language)
3. **Image Lazy Loading**: Load images only when visible in viewport
4. **Content Compression**: Markdown pre-parsed to JSON
5. **Observable Pattern**: Use RxJS for efficient updates
6. **Change Detection**: OnPush strategy in help components

### Memory Profile

- Config in memory: ~200KB per region
- Module content (FR + EN): ~5MB total
- Images (208 files, cached): ~20MB
- **Total**: <30MB (acceptable for help system)

---

## 7. Security & Compliance

### Authentication
- Help routes require authentication (same as main app)
- Auth tokens checked in `HelpService.loadModule()`

### RBAC (Role-Based Access Control)
- Can extend to per-role help content (future enhancement)
- Example: "Admin-only" sections for settings

### Regional Compliance
- UEMOA config includes BCEAO regulatory references
- Maghreb config includes BCM directives
- Extensible for other regions' frameworks

### Data Privacy
- No PII in help content
- Safe to cache in localStorage
- No personal data collected from users

---

## 8. Future Enhancements

### Phase 2: Rich Media
- [ ] Video tutorials (embedded Vimeo/YouTube)
- [ ] Interactive walkthroughs (guided tours with Shepherd.js)
- [ ] Downloadable PDFs (help modules as PDF)
- [ ] Printable guides (printer-friendly CSS)

### Phase 3: Advanced Features
- [ ] Full-text search across modules
- [ ] Help content versioning (A/B testing)
- [ ] User feedback collection (ratings, corrections)
- [ ] Analytics (which sections most viewed)

### Phase 4: AI Integration
- [ ] Automated translation (AI-powered glossary suggestions)
- [ ] Smart help suggestions (based on user behavior)
- [ ] Context-aware help (ML-based context detection)
- [ ] Multilingual support (beyond FR/EN)

### Phase 5: Mobile
- [ ] Native mobile help (Flutter integration)
- [ ] Offline help content (sync on demand)
- [ ] Mobile-optimized layouts
- [ ] Voice-guided tutorials

---

## 9. File Structure Reference

```
sfd-angular/src/
├── app/
│   └── core/
│       ├── config/
│       │   ├── help.config.ts                 # Base interface
│       │   ├── help-config.service.ts         # DI + region mgmt
│       │   ├── help-config.uemoa.ts           # UEMOA config
│       │   └── help-config.maghreb-test.ts    # Maghreb config
│       ├── models/
│       │   ├── help-config.ts                 # Interfaces
│       │   ├── help-menu.model.ts             # Menu + patterns
│       │   └── help-image-alias.model.ts      # Image metadata
│       ├── generators/
│       │   ├── help-menu-extractor.ts         # Menu generation
│       │   ├── help-toc.generator.ts          # TOC generation
│       │   ├── help-language-sync.ts          # FR/EN sync
│       │   ├── help-structure.validator.ts    # Validation
│       │   ├── help-validation.harness.ts     # Test harness
│       │   ├── field-dictionary.generator.ts  # Auto-docs
│       │   └── field-dictionary-validator.ts  # Field validation
│       └── services/
│           ├── help.service.ts                # Main service
│           ├── help.service.v2.ts             # V2 API
│           └── help-image-alias.service.ts    # Image aliasing
│   └── shared/
│       ├── components/
│       │   ├── help-panel/                    # Main panel
│       │   └── help-toc-hierarchical/         # Menu component
│       └── services/
│           └── help.service.ts                # Frontend service
└── assets/
    ├── help/
    │   ├── fr/                                # French content
    │   │   ├── epargne.md                     (98,966 bytes)
    │   │   ├── credit.md
    │   │   ├── caisse.md                      (85,751 bytes)
    │   │   └── ... (17 modules)
    │   └── en/                                # English content
    │       └── ... (17 modules)
    └── help-images/
        ├── fr/                                # Default UEMOA images
        │   ├── epargne/
        │   ├── credit/
        │   └── ... (46 images, 208 files total)
        ├── maghreb/                           # Regional overrides
        │   └── ...
        └── en/                                # English (future)
            └── ...
```

---

## 10. Contact & Support

**Maintainers**:
- Architecture: @pierreadopre
- Content: Help team
- DevOps: @devops

**Communication**:
- Issues: GitHub issues (sfd-angular repo)
- Questions: Slack #help-system
- Emergency: escalate-help@uemoa.local

---

**Document Version**: 1.0  
**Last Updated**: April 2025  
**Status**: Production Ready

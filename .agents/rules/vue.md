---
description: Vue 3 + Inertia rules
paths:
  - "resources/js/**/*.vue"
  - "resources/js/**/*.js"
  - "resources/js/**/*.mjs"
  - "resources/js/**/*.ts"
globs: resources/js/**/*.vue,resources/js/**/*.js,resources/js/**/*.mjs,resources/js/**/*.ts
alwaysApply: false
applyTo: "resources/js/**/*.vue,resources/js/**/*.js,resources/js/**/*.mjs,resources/js/**/*.ts"
trigger: glob
---

# Vue + Inertia

- Vue 3 with `<script setup>`. Use TypeScript only where nearby files already do.
- Inertia differs per repo (`@inertiajs/vue3` 1.x–3.x; legacy `@inertiajs/inertia` in older code). Import from the same package as neighboring pages and use the API of the installed version.
- Pages live in `resources/js/Pages/` (`pages/` in newer kits). Reuse components from `Components/` (`components/`) before writing new ones.
- If `components.json` exists, UI primitives are shadcn-vue: add one with `npx shadcn-vue@latest add <name>` instead of writing it by hand.
- Never pass user-supplied content to `v-html`.
- Verify with `npm run build`.

<!-- Style below: from antigravity/rules/coding-standards.md in the team's ai-agents-md repo. -->

## Style

### Architecture & Abstraction (Composables, Stores, Utils)

In code you write or change, long or complex business processes MUST be extracted from UI components and separated based on their context of responsibility:

- **Utils (`resources/js/Utils/*.mjs`)**:
  - Used EXCLUSIVELY for **rendering, visualization, formatting, pure calculations, or UI data transformations**.
  - **STRICTLY FORBIDDEN** to use *Composables* or *Pinia Stores* for display/rendering concerns.
  - Extract using the `.mjs` extension (NEVER `.js`).
- **Composables (`resources/js/Composables/`)**:
  - Used for **data CRUD operations, security/authentication flows, side-effect encapsulation, and feature/local-scoped reactive logic**.
  - Place API/Inertia interaction logic that requires *lifecycle hooks* or *stateful request* handling here.
- **Stores (`resources/js/Stores/` via Pinia)**:
  - Used for **global state, cross-component/page data sharing without parent-child relationships**, and application *state caching*.

### Component Reusability & Import Standards

- **Component Reusability**:
  - In code you write or change, ALL repetitive UI elements (buttons, cards, modals) MUST be refactored into reusable components.
  - **Global Components** (`resources/js/Components/`): Generic components used across modules. Import using `@/Components/`.
  - **Local Components** (`resources/js/Pages/[Module]/Components/`): Path-specific components (e.g., local modals/forms). Import using relative paths (`./Components/`).
- **Import Order in `<script setup>`**:
  1. **Components First**: All component imports (e.g., `ButtonBack`, `ModalCard`) MUST be placed at the top.
  2. **Functions, Stores & Utilities Below**: Imports for Vue functions (`ref`, `watch`), Pinia stores, Composables, Inertia helpers, and utilities MUST be placed BELOW component imports.

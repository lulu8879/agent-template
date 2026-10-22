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

- **Component Reusability & Architecture**:
  - In code you write or change, ALL repetitive UI elements (buttons, cards, modals) MUST be refactored into reusable components.
  - **Global Components** (`resources/js/Components/`): Generic components used across modules. Import using `@/Components/`.
  - **Local Components** (`resources/js/Pages/[Module]/Components/`): Path-specific components (e.g., local modals/forms). Import using relative paths (`./Components/`).
- **Import Order in `<script setup>`**:
  1. **Components First**: All component imports (e.g., `ButtonBack`, `ModalCard`) MUST be placed at the top.
  2. **Functions & Utilities Below**: Imports for Vue functions (`ref`, `watch`), Inertia helpers, and utilities MUST be placed BELOW component imports.
- **Utilities (`.mjs` Files)**:
  - In code you write or change, ALL repetitive algorithms, formatting helpers, or calculations MUST be extracted into `resources/js/Utils/` using the **`.mjs` extension (NEVER `.js`)**.
  - Example: `import { truncate } from "@/Utils/string.mjs"`.

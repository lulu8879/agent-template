---
paths:
  - "resources/js/**/*.{vue,js,ts}"
---

# Vue + Inertia

- Vue 3 with `<script setup>`. Use TypeScript only where nearby files already do.
- Inertia differs per repo (`@inertiajs/vue3` 1.x–3.x; legacy `@inertiajs/inertia` in older code). Import from the same package as neighboring pages and use the API of the installed version.
- Pages live in `resources/js/Pages/` (`pages/` in newer kits). Reuse components from `Components/` (`components/`) before writing new ones.
- If `components.json` exists, UI primitives are shadcn-vue: add one with `npx shadcn-vue@latest add <name>` instead of writing it by hand.
- Never pass user-supplied content to `v-html`.
- Verify with `npm run build`.

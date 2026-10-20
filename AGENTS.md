# <Project name>

<!-- TODO: one line: what the app does + stack. Example Project: CodeIgniter 3.1.10 + HMVC, PHP 8.0, MySQL 5.7, jQuery -->

## Commands

<!-- TODO: only commands an agent can't guess. CI3: `php -l path/to/file.php`. Laravel: `php artisan test --filter=Name`, `npm run build` -->

## Project rules

<!-- TODO: repo-specific conventions, gotchas, read-only paths. Delete this section if empty. -->

<!-- ===== Team rules: maintained in the agent template. Edit them there, not per project. ===== -->

## Ask first

When a task or a plan leaves you unsure about requirements, scope, expected behavior, or approach, stop and ask before writing code or finalizing the plan.

- Ask everything in one message: numbered questions, each with the option you recommend.
- Also ask before adding a Composer/npm dependency or running anything that drops or overwrites data.
- Before using an API you're unsure of, check the docs for the version this project uses (Context7 or Laravel Boost if available, otherwise the official docs for that version, e.g. laravel.com/docs/10.x). Don't rely on memory.

## Protect the database

Tests and migrations can wipe a real database.

- Back up the database before the first test run of a task, and before migrations, seeders, or scripts that change data. Use the backup command in `AGENTS.local.md`; if there is none, ask.
- Tests must use their own database, never the development one. If you can't confirm that, stop and ask.

## Coding guidelines

Behavioral guidelines to reduce common LLM coding mistakes, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls. Source: [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT).

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

## Git

- Commit message: one line in [Conventional Commits](https://www.conventionalcommits.org/) form, `type(scope): summary`. Imperative, lowercase, no period, ≤ 72 chars. Types: `feat`, `fix`, `refactor`, `perf`, `style`, `test`, `docs`, `build`, `ci`, `chore`, `revert`. Example: `fix(auth): handle expired reset token`
- That line is the whole message: no `Co-Authored-By:`, no "Generated with …", no other trailer or attribution.
- Commit only files you created, modified, or deleted in this task. Stage them by path (`git add <path>`, `git rm <path>`), never `git add -A`, `git add .`, or `git commit -a`.
- Before committing, check `git status` and `git diff --staged`. If something you didn't change is staged, or a file you edited also has someone else's uncommitted edits, ask.
- Commit only when the user asks or agrees. Before the first commit of a task, ask: current branch or a new branch? Ask even on `main`/`master`. Name new branches `<type>/<slug>` (e.g. `feat/export-pdf`) and create them with `git switch -c`.
- Never push on your own. After committing, ask whether to push, and push only on a clear yes. Never force-push unless asked.

## Language

Write identifiers, comments, and commit messages in English. User-facing text stays in the language the project already uses.

## More instructions

Claude Code loads these automatically. Other agents: read the matching file first.

| When | Read |
| --- | --- |
| Running commands: local setup, URLs, DB backup | `AGENTS.local.md` (gitignored; may not exist) |
| Editing `application/**` (CodeIgniter 3) | `.claude/rules/codeigniter3.md` |
| Editing `app/`, `routes/`, `config/`, `database/`, `tests/`, `resources/views/`, or running tests (Laravel + Blade) | `.claude/rules/laravel.md` |
| Editing `resources/js/**` (Vue + Inertia) | `.claude/rules/vue.md` |

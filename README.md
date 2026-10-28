# Agent Template

Shared instructions for AI coding agents (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Antigravity, OpenCode, Command Code) in our CodeIgniter 3 and Laravel (Blade + Vue/Inertia) projects.

`AGENTS.md` is the single source of truth. Every other file either imports it or adds rules for one stack or one machine.

## Contents

- [Files](#files)
- [Stack rules](#stack-rules)
- [Supported agents](#supported-agents)
  - [Windows](#windows)
- [Use it in a project](#use-it-in-a-project)
- [Setup prompt](#setup-prompt)
- [Notes](#notes)

## Files

| File | Purpose |
| --- | --- |
| `AGENTS.md` | Project section (fill in) + team rules: ask when unsure, protect the database, coding guidelines, git, language |
| `CLAUDE.md` | `@AGENTS.md` import, so Claude Code reads the same rules |
| `AGENTS.local.md` | Your machine only: DDEV/Laragon/Herd commands, local URL, DB backup command |
| `CLAUDE.local.md` | `@AGENTS.local.md` import for Claude Code |
| `.claude/settings.json` | Claude Code: no commit/PR attribution, asks before `git push` |
| `.agents/rules/codeigniter3.md` | CI3 rules (`application/**`) |
| `.agents/rules/laravel.md` | Laravel + Blade + test-database rules |
| `.agents/rules/laravel-style.md` | Team Laravel code style: validation, models, imports, routes, method names |
| `.agents/rules/laravel-9-10.md` | Laravel 9–10 only: `Kernel.php`, `$casts`/`$fillable` properties |
| `.agents/rules/laravel-13.md` | Laravel 13 only: `bootstrap/app.php`, `#[Fillable]`/`#[Hidden]`, `casts()` |
| `.agents/rules/vue.md` | Vue 3 + Inertia rules + team frontend style: what goes in Utils, Composables, and Pinia Stores; component reuse; import order |
| `.agents/skills/refactor-bloated-code/` | Laravel skill, run on request (`/refactor-bloated-code`): splits a bloated controller into Form Requests, Repositories, and Services behind Contracts |
| `.claude/skills/refactor-bloated-code` | Symlink to the skill for Claude Code |
| `.claude/rules/*.md` | Symlinks to `.agents/rules/` for Claude Code |
| `.cursor/rules/*.mdc` | Symlinks to `.agents/rules/` for Cursor |
| `.github/instructions/*.instructions.md` | Symlinks to `.agents/rules/` for Copilot |
| `GEMINI.md` | Imports `.agents/rules/*.md` for Gemini CLI |
| `.gemini/settings.json` | Makes Gemini CLI read `AGENTS.md`, `AGENTS.local.md`, and `GEMINI.md` |
| `opencode.json` | OpenCode: loads `AGENTS.local.md` and `.agents/rules/*.md`, asks before `git push` and before the model loads `refactor-bloated-code` |

## Stack rules

Edit the rules only in `.agents/rules/`. Each file's frontmatter carries the file patterns once per tool, so the same file works everywhere:

| Key | Read by |
| --- | --- |
| `paths` | Claude Code |
| `globs`, `alwaysApply`, `description` | Cursor |
| `applyTo` | Copilot |
| `trigger`, `globs`, `description` | Antigravity (drops a rule without a valid `trigger`) |

When you change a rule's file patterns, update `paths`, `globs`, and `applyTo`. Each tool ignores the keys it doesn't use.

## Supported agents

| Agent | Main rules | Stack rules | Local file | Extra setup |
| --- | --- | --- | --- | --- |
| Claude Code | `CLAUDE.md` imports `AGENTS.md` | `.claude/rules/` symlinks, loaded when matching files are touched | `CLAUDE.local.md` imports it | None |
| Cursor | `AGENTS.md`, natively | `.cursor/rules/` symlinks, attached when matching files are in context | Via the `AGENTS.md` table | None |
| VS Code / Copilot | `AGENTS.md` (`chat.useAgentsMdFile`, on by default in recent versions) | `.github/instructions/` symlinks, applied to matching files | Via the `AGENTS.md` table | Turn the setting on if your version has it off |
| Gemini CLI | `AGENTS.md`, via `.gemini/settings.json` | `GEMINI.md` imports, always loaded | Loaded via `.gemini/settings.json` | On older versions, use `"contextFileName": [...]` instead of `context.fileName` |
| Antigravity | `AGENTS.md`, natively | `.agents/rules/`, natively (`trigger: glob`), loaded when matching files are touched | Via the `AGENTS.md` table | None |
| OpenCode | `AGENTS.md`, natively | `opencode.json` `instructions`, always loaded (no file-pattern scoping) | `opencode.json` `instructions` | None |
| Codex | `AGENTS.md`, natively | Via the `AGENTS.md` table | Via the `AGENTS.md` table | None |
| Command Code | Not confirmed | Via the `AGENTS.md` table | Via the `AGENTS.md` table | If it doesn't pick up `AGENTS.md`, point its instruction file at it |

Codex and Command Code have no rules folder of their own, so they follow the "More instructions" table at the end of `AGENTS.md`.

Skills live in `.agents/skills/`. Codex, Cursor, Copilot, Antigravity, and OpenCode read that folder natively; Claude Code reads the `.claude/skills/` symlink. Cursor and Copilot also read `.claude/skills/`, so they may list a skill twice; OpenCode merges skills with the same name.

### Windows

The per-tool rule files and the Claude Code skill folder are symlinks. On Windows, Git checks them out as one-line text files unless symlinks are enabled. Turn on Developer Mode, then clone with:

```bash
git clone -c core.symlinks=true <repo-url>
```

## Use it in a project

1. From the project root, clone the template to a temporary folder, copy everything except `README.md`, `scripts/`, and `.git`, then remove the clone:

   ```bash
   git clone --depth 1 -c core.symlinks=true https://github.com/lulu8879/agent-template.git /tmp/agent-template && rsync -a --exclude README.md --exclude scripts --exclude .git /tmp/agent-template/ ./ && rm -rf /tmp/agent-template
   ```

2. Add the local files to the project's `.gitignore`:

   ```
   AGENTS.local.md
   CLAUDE.local.md
   ```

3. Delete the stacks the project doesn't use. The Laravel stack is `laravel`, `laravel-style`, `laravel-9-10`, and `laravel-13`, plus the `refactor-bloated-code` skill (`.agents/skills/` folder and its `.claude/skills/` symlink).
   - CodeIgniter 3: remove the Laravel stack and `vue`.
   - Laravel + Blade: remove `codeigniter3` and `vue`.
   - Laravel + Vue/Inertia: remove `codeigniter3`.
   - Laravel: also keep only the version file that matches `laravel/framework` in `composer.json` (`laravel-9-10` for 9–10, `laravel-13` for 13) and remove the other. There is none for 11–12 yet: ask the team.

   For each stack you remove, delete its file in `.agents/rules/`, its three symlinks, its import line in `GEMINI.md`, and its row in the `AGENTS.md` table. For example, to remove `vue`:

   ```bash
   rm .agents/rules/vue.md .claude/rules/vue.md .cursor/rules/vue.mdc .github/instructions/vue.instructions.md
   ```

   If the project already has an `opencode.json`, merge the template's settings into it instead of replacing it.
4. Fill in the TODO sections at the top of `AGENTS.md` (project line, commands, project rules).
5. Rewrite `AGENTS.local.md` for your machine. Not on DDEV? The comment at its top has a non-DDEV example.
6. Laravel: make sure tests can't hit the dev database. Either `phpunit.xml` uses sqlite `:memory:`, or `.env.testing` (a copy of `.env`) has its own `DB_DATABASE`.
7. Check it loaded: in Claude Code, open a file under `app/` or `application/`, then run `/context`. `CLAUDE.md`, `AGENTS.md`, and the matching rule should be under Memory files.

If the project already has an `AGENTS.md`, move its content into the project section instead of overwriting it.

## Setup prompt

Instead of the steps above, you can paste this into any agent (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Antigravity, OpenCode, Command Code) from the project root.

```text
Set up the agent template from https://github.com/lulu8879/agent-template in this project. Read its README.md first.

1. Clone it to a temporary folder outside this project (git clone --depth 1 -c core.symlinks=true). Copy every file except README.md, scripts/, and .git into the project root, keeping symlinks as symlinks (e.g. rsync -a), then delete the temporary clone. Ask before overwriting any existing file. If the project already has an AGENTS.md, merge its content into the project section instead. If it already has an opencode.json, merge the template's settings into it instead.
2. Ask me which agents to set up: (a) AGENTS.* only (default: no agent-specific files), (b) all agents, (c) only the agent running this setup, or (d) a list I choose. If I don't pick, use (a). Always keep AGENTS.md, AGENTS.local.md, .agents/rules/, and .agents/skills/. For each agent not chosen, delete its files:
   - Claude Code: CLAUDE.md, CLAUDE.local.md, .claude/settings.json, .claude/rules/, .claude/skills/
   - Cursor: .cursor/rules/
   - Copilot: .github/instructions/
   - Gemini CLI: GEMINI.md, .gemini/settings.json
   - OpenCode: opencode.json
   Delete only the files the template added; keep anything the project already had in those folders.
   - Antigravity, Codex, Command Code: no files of their own (they read AGENTS.md; Antigravity also reads .agents/rules/, and Antigravity and Codex read .agents/skills/)
   Then update the first line of the "More instructions" section in AGENTS.md so it names only the kept agents that load rules automatically. With (a), only Antigravity does: change it to "Antigravity loads these automatically. Other agents: read the matching file first."
3. Add AGENTS.local.md to .gitignore, and CLAUDE.local.md too if Claude Code is kept.
4. Detect the stack: CodeIgniter 3 (application/ and system/), Laravel (artisan), Vue/Inertia (package.json). For each stack the project doesn't use, delete its file in .agents/rules/, its remaining symlinks, its import line in GEMINI.md (if kept), and its row in the AGENTS.md table. The Laravel stack is laravel, laravel-style, laravel-9-10, and laravel-13, plus the refactor-bloated-code skill (.agents/skills/ and its .claude/skills/ symlink).
   Laravel: read laravel/framework in composer.json. Keep laravel-9-10 for 9–10 or laravel-13 for 13, and delete the other the same way. For any other version, stop and ask me.
5. Fill in the TODO sections at the top of AGENTS.md from what you find in the repo. Write only facts you verified.
6. Fill in AGENTS.local.md for this machine: DDEV or not, local URL, DB backup command.
7. Laravel: check whether tests could use the dev database (phpunit.xml, .env.testing). If they could, tell me; don't change it yet.
8. Summarize what you changed. Don't commit.

Ask me if anything is unclear.
```

## Notes

- After adding, renaming, or deleting a rule in `.agents/rules/` or a skill in `.agents/skills/`, run `scripts/link.sh`. It creates the missing per-tool symlinks, removes dangling ones, and reports rules missing from `GEMINI.md` or the `AGENTS.md` table. `scripts/link.sh --check` only reports, and exits 1 if anything is wrong. On Windows, run it from WSL, or from Git Bash with `MSYS=winsymlinks:nativestrict` (Developer Mode on); otherwise Git Bash copies files instead of linking them.
- Team rules live below the "Team rules" comment in `AGENTS.md`. Change them here, then copy them to projects; don't edit them per project.
- Agents run Pint with the project's own settings. Pint's default preset sorts imports alphabetically and removes blank lines between them, so in projects without a `pint.json` it overrides the import grouping in `laravel-style.md`.
- After upgrading a project's Laravel version, swap its version file (`laravel-9-10` ↔ `laravel-13`).
- Laravel and Vue code style come from the team's [ai-agents-md](https://gitlab.com/tataadin/ai-agents-md) coding standards.
- Coding guidelines come from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT).
- MCP servers (Context7, Laravel Boost) are optional and set up per person in their own agent. The rules work without them.

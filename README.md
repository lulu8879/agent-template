# Agent Template

Shared instructions for AI coding agents (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Antigravity, OpenCode, Command Code) in our CodeIgniter 3 and Laravel (Blade + Vue/Inertia) projects.

`AGENTS.md` is the single source of truth. Every other file either imports it or adds rules for one stack or one machine.

## Contents

- [Files](#files)
- [Stack rules](#stack-rules)
- [Agent team](#agent-team)
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
| `.claude/agents/`, `.opencode/agents/`, `.agents/agents/` | The agent team (`tech-lead` plus nine specialists) for Claude Code, OpenCode, and Antigravity. See [Agent team](#agent-team) |
| `.claude/skills/tech-lead/` | Claude Code: `/tech-lead <task>` runs the tech lead in the current conversation |
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

## Agent team

For work bigger than a quick fix, start the **tech lead**. It asks questions first, gets a plan, shows you the plan before any code is written, hands each task to a specialist, checks their work, sends it to review, and reports back. It doesn't commit.

| Agent | Role | Edits files | Claude Code | OpenCode | Antigravity |
| --- | --- | --- | --- | --- | --- |
| `tech-lead` | Orchestrator: clarifies, plans, delegates, verifies, reports | Trivial only | opus | Opus | pro |
| `software-architect` | Plans medium/large changes and splits them into tasks | No | opus | Opus | pro |
| `backend-engineer` | Laravel / CodeIgniter 3 controllers, requests, models, services, routes | Yes | sonnet | Sonnet | inherit |
| `frontend-engineer` | Vue/Inertia pages and components, Blade, Pinia, composables | Yes | sonnet | Sonnet | inherit |
| `database-engineer` | Migrations, seeders, indexes, slow and N+1 queries | Yes | sonnet | Sonnet | inherit |
| `qa-engineer` | Writes and runs tests, after checking the test database | Yes | sonnet | Sonnet | inherit |
| `support-engineer` | Bugs with an unknown cause: reproduce, root cause, regression test, fix | Yes | sonnet | Sonnet | inherit |
| `code-reviewer` | Reviews the diff against the plan and team rules | No | opus | Opus | pro |
| `security-engineer` | Security review: IDOR, mass assignment, SQLi, XSS, CSRF, uploads | No | opus | Opus | pro |
| `research-analyst` | Version-correct docs and codebase lookups | No | haiku | Haiku | flash |

Models follow one rule: planning and review use the strongest model, writing code uses the mid model, read-only lookups use the fast model. Antigravity only has `flash` and `pro`, so code-writing agents use `inherit` (the model you picked). OpenCode IDs are `anthropic/claude-*-5-5`; change them if you use another provider.

Start the tech lead:

- **Claude Code:** `/tech-lead <task>` in any session, or `claude --agent tech-lead` to make the whole session the tech lead.
- **OpenCode:** press Tab to switch to `tech-lead`.
- **Antigravity:** pick `tech-lead` in the agent picker or `/agents`, or run `agy --agent tech-lead`.

You can also call a specialist directly, e.g. "use the security-engineer to review my changes" (Claude Code, Antigravity) or `@security-engineer` (OpenCode). Codex, Cursor, Copilot, and Gemini CLI don't load these agents.

Each tool needs its own frontmatter, so every agent has three copies instead of symlinks. The body is the same in all three (it refers to `AGENTS.md`, `AGENTS.local.md`, and `.agents/rules/`); only the tech lead's "Start agents with the … tool" line differs. Change an agent in all three folders, then run `scripts/link.sh --check` to catch a missed copy:

| Tool | Location | Frontmatter | Tech lead starts agents with |
| --- | --- | --- | --- |
| Claude Code | `.claude/agents/<name>.md` | `name`, `description`, `model` (`opus`/`sonnet`/`haiku`); `tools: Agent(...)` on `tech-lead`, `disallowedTools` on read-only agents | the Agent tool |
| OpenCode | `.opencode/agents/<name>.md` | `description`, `mode` (`primary` for `tech-lead`), `model` (`provider/model`), `permission` (`task` on `tech-lead`, `edit: deny` on read-only agents) | the Task tool |
| Antigravity | `.agents/agents/<name>.md` | `name`, `description`, `mainAgent`, `subagent`, `model` (`pro`/`flash`/`inherit`) | the `invoke_subagent` tool |

To drop an agent from a project, delete its three files, then remove its row from the Team table in each `tech-lead.md` and its name from the tech lead's frontmatter (`tools: Agent(...)` in `.claude/agents/`, `permission.task` in `.opencode/agents/`). Without `tech-lead`, also delete `.claude/skills/tech-lead/` and the tech-lead row in the `AGENTS.md` table.

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

Skills live in `.agents/skills/`. Codex, Cursor, Copilot, Antigravity, and OpenCode read that folder natively; Claude Code reads the `.claude/skills/` symlink. Cursor and Copilot also read `.claude/skills/`, so they may list a skill twice; OpenCode merges skills with the same name. The `tech-lead` skill is Claude Code only and lives in `.claude/skills/tech-lead/`; Cursor and Copilot may list it, but it only works in Claude Code.

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
4. Agent team: delete the agents the project doesn't need (for example `frontend-engineer` without Vue/Inertia or Blade) as described in [Agent team](#agent-team), and the agents folders of tools nobody on the team uses. If you delete `.agents/agents/`, point the tech-lead row in `AGENTS.md` at a folder you kept.
5. Fill in the TODO sections at the top of `AGENTS.md` (project line, commands, project rules).
6. Rewrite `AGENTS.local.md` for your machine. Not on DDEV? The comment at its top has a non-DDEV example.
7. Laravel: make sure tests can't hit the dev database. Either `phpunit.xml` uses sqlite `:memory:`, or `.env.testing` (a copy of `.env`) has its own `DB_DATABASE`.
8. Check it loaded: in Claude Code, open a file under `app/` or `application/`, then run `/context`. `CLAUDE.md`, `AGENTS.md`, and the matching rule should be under Memory files.

If the project already has an `AGENTS.md`, move its content into the project section instead of overwriting it.

## Setup prompt

Instead of the steps above, you can paste this into any agent (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Antigravity, OpenCode, Command Code) from the project root.

```text
Set up the agent template from https://github.com/lulu8879/agent-template in this project. Read its README.md first.

1. Clone it to a temporary folder outside this project (git clone --depth 1 -c core.symlinks=true). Copy every file except README.md, scripts/, and .git into the project root, keeping symlinks as symlinks (e.g. rsync -a), then delete the temporary clone. Ask before overwriting any existing file. If the project already has an AGENTS.md, merge its content into the project section instead. If it already has an opencode.json, merge the template's settings into it instead.
2. Detect the stack: CodeIgniter 3 (application/ and system/), Laravel (artisan; version from laravel/framework in composer.json), Vue/Inertia (package.json, resources/js/), Blade views (resources/views/). Then ask me these in one message, numbered, each with the answer you recommend, and wait for my answers:
   a. Which agents to set up: (a) AGENTS.* only (default: no agent-specific files), (b) all agents, (c) only the agent running this setup, or (d) a list I choose. If I don't pick, use (a).
   b. Which agents from the README "Agent team" to install. List all ten with a one-line role each and mark the ones you recommend: tech-lead, software-architect, code-reviewer, security-engineer, research-analyst, backend-engineer, qa-engineer, support-engineer, and database-engineer for any CodeIgniter 3 or Laravel app; frontend-engineer only if the project has Vue/Inertia or Blade views. "None" is a valid answer. Only Claude Code, OpenCode, and Antigravity load them: if none of those is kept, recommend none.
3. Always keep AGENTS.md, AGENTS.local.md, .agents/rules/, and .agents/skills/. For each agent not chosen in 2a, delete its files:
   - Claude Code: CLAUDE.md, CLAUDE.local.md, .claude/settings.json, .claude/rules/, .claude/skills/, .claude/agents/
   - Cursor: .cursor/rules/
   - Copilot: .github/instructions/
   - Gemini CLI: GEMINI.md, .gemini/settings.json
   - OpenCode: opencode.json, .opencode/agents/
   - Antigravity: .agents/agents/ (kept with (a))
   - Codex, Command Code: no files of their own (they read AGENTS.md; Codex also reads .agents/skills/)
   Delete only the files the template added; keep anything the project already had in those folders.
   Then update the first line of the "More instructions" section in AGENTS.md so it names only the kept agents that load rules automatically. With (a), only Antigravity does: change it to "Antigravity loads these automatically. Other agents: read the matching file first."
4. Agent team, in every kept folder (.claude/agents/, .opencode/agents/, .agents/agents/):
   - Delete the files of the agents I left out in 2b, remove their rows from the Team table in tech-lead.md, and their names from its frontmatter (tools: Agent(...) in .claude/agents/, permission.task in .opencode/agents/).
   - Without tech-lead: also delete .claude/skills/tech-lead/ and the tech-lead row in the "More instructions" table of AGENTS.md.
   - No agents at all: delete the agents folders.
   - If .agents/agents/ is gone but another agents folder is kept, point the tech-lead row in AGENTS.md at that folder and drop the start hints for tools that aren't kept.
5. Add AGENTS.local.md to .gitignore, and CLAUDE.local.md too if Claude Code is kept.
6. For each stack the project doesn't use, delete its file in .agents/rules/, its remaining symlinks, its import line in GEMINI.md (if kept), and its row in the AGENTS.md table. The Laravel stack is laravel, laravel-style, laravel-9-10, and laravel-13, plus the refactor-bloated-code skill (.agents/skills/ and its .claude/skills/ symlink).
   Laravel: keep laravel-9-10 for 9–10 or laravel-13 for 13, and delete the other the same way. For any other version, stop and ask me.
7. Fill in the TODO sections at the top of AGENTS.md from what you find in the repo. Write only facts you verified.
8. Fill in AGENTS.local.md for this machine: DDEV or not, local URL, DB backup command.
9. Laravel: check whether tests could use the dev database (phpunit.xml, .env.testing). If they could, tell me; don't change it yet.
10. Summarize what you changed: agents set up, team agents installed, rule files kept. Don't commit.

Ask me if anything is unclear.
```

## Notes

- After adding, renaming, or deleting a rule in `.agents/rules/` or a skill in `.agents/skills/`, run `scripts/link.sh`. It creates the missing per-tool symlinks, removes dangling ones, and reports rules missing from `GEMINI.md` or the `AGENTS.md` table. `scripts/link.sh --check` only reports, and exits 1 if anything is wrong. On Windows, run it from WSL, or from Git Bash with `MSYS=winsymlinks:nativestrict` (Developer Mode on); otherwise Git Bash copies files instead of linking them.
- `scripts/link.sh` doesn't change agents. When you change one, edit its copy in `.claude/agents/`, `.opencode/agents/`, and `.agents/agents/` (see [Agent team](#agent-team)). The script reports an agent missing from a kept folder, or whose body differs between copies (frontmatter and the tech lead's "Start agents with the … tool" line are ignored).
- Team rules live below the "Team rules" comment in `AGENTS.md`. Change them here, then copy them to projects; don't edit them per project.
- Agents run Pint with the project's own settings. Pint's default preset sorts imports alphabetically and removes blank lines between them, so in projects without a `pint.json` it overrides the import grouping in `laravel-style.md`.
- After upgrading a project's Laravel version, swap its version file (`laravel-9-10` ↔ `laravel-13`).
- Coding guidelines come from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT).
- MCP servers (Context7, Laravel Boost) are optional and set up per person in their own agent. The rules work without them.

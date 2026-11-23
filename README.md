# Agent Template

Team rules, stack rules, skills, and an agent team for AI coding agents in our CodeIgniter 3 and Laravel (Blade + Vue/Inertia) projects.

Each top-level folder is a ready-to-copy setup for one agent. Pick the folder for your agent and copy its contents into the project root. Folders don't depend on each other, and there are no symlinks. Every folder has the same template: `AGENTS.md` (or `CLAUDE.md`), a local file, the six stack rules, the `refactor-bloated-code` skill, and the ten-agent team, each in that agent's native format.

## Contents

- [Pick a folder](#pick-a-folder)
- [What's inside](#whats-inside)
- [Agent team](#agent-team)
- [Setup prompt](#setup-prompt)
- [Manual setup](#manual-setup)
- [Editing the template](#editing-the-template)
- [Notes](#notes)
- [License](#license)

## Pick a folder

| Agent | Folder | Main rules | Stack rules | Local file | Skills | Agent team |
| --- | --- | --- | --- | --- | --- | --- |
| Claude Code | `claude/` | `CLAUDE.md` | `.claude/rules/`, loaded when matching files are touched | `CLAUDE.local.md`, loaded natively | `.claude/skills/` | `.claude/agents/` |
| Google Antigravity | `antigravity/` | `AGENTS.md` | `.agents/rules/` (`trigger: glob`), loaded when matching files are touched | Via the `AGENTS.md` table | `.agents/skills/` | `.agents/agents/` |
| OpenCode | `opencode/` | `AGENTS.md` | `.agents/rules/`, always loaded via `opencode.json` | Loaded via `opencode.json` | `.agents/skills/` | `.opencode/agents/` |
| Cursor | `cursor/` | `AGENTS.md` | `.cursor/rules/*.mdc`, attached when matching files are in context | Via the `AGENTS.md` table | `.agents/skills/` | `.cursor/agents/` + `tech-lead` skill |
| VS Code / Copilot | `copilot/` | `AGENTS.md` | `.github/instructions/*.instructions.md` (`applyTo`), applied to matching files | Via the `AGENTS.md` table | `.github/skills/` | `.github/agents/*.agent.md` |
| Codex | `codex/` | `AGENTS.md` | `.agents/rules/`, via the `AGENTS.md` table | Via the `AGENTS.md` table | `.agents/skills/` | `.codex/agents/*.toml` + `tech-lead` skill |
| Command Code | `commandcode/` | `AGENTS.md` | `.agents/rules/`, via the `AGENTS.md` table | Imported by `@AGENTS.local.md` in `AGENTS.md` | `.agents/skills/` | `.commandcode/agents/` + `tech-lead` skill |

Pick one folder per project. If the team uses several agents, copy several folders: their files don't overlap, except `AGENTS.md`, `AGENTS.local.md`, and `.agents/` (see [Notes](#notes)).

## What's inside

| File | Purpose |
| --- | --- |
| `AGENTS.md` / `CLAUDE.md` | Project section (fill in) + team rules: ask when unsure, protect the database, coding guidelines, git, language. Ends with a "More instructions" table that points to the folder's rule, skill, and agent files (not in `CLAUDE.md`, since Claude Code loads them itself) |
| `AGENTS.local.md` / `CLAUDE.local.md` | Your machine only (gitignored): DDEV/Laragon/Herd commands, local URL, DB backup command |
| `codeigniter3` rule | CodeIgniter 3 (`application/**`) |
| `laravel` rule | Laravel, Blade, and test-database rules |
| `laravel-style` rule | Team Laravel code style: Form Requests, models, imports, routes, method names |
| `laravel-9-10` rule | Laravel 9–10 only: `Kernel.php`, `$casts`/`$fillable` properties |
| `laravel-13` rule | Laravel 13 only: `bootstrap/app.php`, `#[Fillable]`/`#[Hidden]`, `casts()` |
| `vue` rule | Vue 3 + Inertia rules and team frontend style: what goes in Utils, Composables, and Pinia Stores; component reuse; import order |
| `refactor-bloated-code` skill | Run on request: splits a bloated controller into Form Requests, Repositories, and Services behind Contracts |
| Agent team | `tech-lead` plus nine specialists. See [Agent team](#agent-team) |

Per-agent settings:

| Folder | File | Purpose |
| --- | --- | --- |
| `claude/` | `.claude/settings.json` | No commit/PR attribution, asks before `git push` |
| `claude/` | `.claude/skills/tech-lead/` | `/tech-lead <task>` runs the tech lead in the current conversation |
| `opencode/` | `opencode.json` | Loads `AGENTS.local.md` and the rules, asks before `git push` and before the model loads the skill |
| `codex/` | `.codex/rules/default.rules` | Asks before `git push` (experimental; project must be trusted) |
| `codex/` | `.agents/skills/*/agents/openai.yaml` | Skills run only when invoked with `$name` |
| `commandcode/` | `.commandcode/settings.json` | No commit co-author trailer, asks before `git push` |

## Agent team

For work bigger than a quick fix, start the **tech lead**. It asks questions first, gets a plan, shows you the plan before any code is written, hands each task to a specialist, checks their work, sends it to review, and reports back. It doesn't commit.

| Agent | Role | Edits files |
| --- | --- | --- |
| `tech-lead` | Orchestrator: clarifies, plans, delegates, verifies, reports | Trivial only |
| `software-architect` | Plans medium/large changes and splits them into tasks | No |
| `backend-engineer` | Laravel / CodeIgniter 3 controllers, requests, models, services, routes | Yes |
| `frontend-engineer` | Vue/Inertia pages and components, Blade, Pinia, composables | Yes |
| `database-engineer` | Migrations, seeders, indexes, slow and N+1 queries | Yes |
| `qa-engineer` | Writes and runs tests, after checking the test database | Yes |
| `support-engineer` | Bugs with an unknown cause: reproduce, root cause, regression test, fix | Yes |
| `code-reviewer` | Reviews the diff against the plan and team rules | No |
| `security-engineer` | Security review: IDOR, mass assignment, SQLi, XSS, CSRF, uploads | No |
| `research-analyst` | Version-correct docs and codebase lookups | No |

How each agent starts the tech lead, where it lives, and how models and read-only access are set:

| Agent | Start the tech lead | Tech lead lives in | Models (plan & review / code / lookups) | Read-only agents |
| --- | --- | --- | --- | --- |
| Claude Code | `/tech-lead <task>`, or `claude --agent tech-lead` for the whole session | `.claude/agents/tech-lead.md` (+ skill that loads it) | `opus` / `sonnet` / `haiku` | `disallowedTools` |
| Antigravity | Agent picker or `/agents` | `.agents/agents/tech-lead.md` (`mainAgent: true`) | `pro` / `inherit` / `flash` | Instructions only |
| OpenCode | Tab to switch to `tech-lead` | `.opencode/agents/tech-lead.md` (`mode: primary`) | `anthropic/claude-opus-5-5` / `-sonnet-5-5` / `-haiku-5-5` | `permissions`: `edit` deny |
| Copilot | Pick `tech-lead` in the agent picker | `.github/agents/tech-lead.agent.md` (`disable-model-invocation: true`) | The model you pick | `tools: ['read', 'search', 'execute', 'web']` |
| Cursor | `/tech-lead` | `.agents/skills/tech-lead/SKILL.md` | `inherit` | `readonly: true` |
| Codex | `$tech-lead` | `.agents/skills/tech-lead/SKILL.md` | Session model | Instructions only |
| Command Code | `/tech-lead` | `.agents/skills/tech-lead/SKILL.md` | Session model | `disallowedTools: edit_file, write_file` |

Cursor, Codex, and Command Code can't make a custom agent the main session. So the tech lead is a skill there: it runs in the main conversation and starts the nine specialists as subagents.

Models follow one rule where the tool lets you pick: planning and review use the strongest model, writing code uses the mid model, read-only lookups use the fast model. Cursor, Copilot, Codex, and Command Code model IDs depend on your plan or provider, so their agents use the session model; add a `model` field if you want to pin one.

You can also call a specialist directly, e.g. "use the security-engineer to review my changes", `@security-engineer` (OpenCode), or pick it in the agent picker (Copilot).

## Setup prompt

Paste this into your agent from the project root. It checks the project first, then asks which AI tool you use and which agents to install before it changes anything.

```text
Set up the agent template from https://github.com/lulu8879/agent-template in this project. Read its README.md first.

1. Look first, change nothing yet. Detect the stack: CodeIgniter 3 (application/ and system/), Laravel (artisan; version from laravel/framework in composer.json), Vue/Inertia (package.json, resources/js/), Blade views (resources/views/). Note which AI tool you are running in.
2. Ask me these in one message, numbered, each with the answer you recommend from step 1. Wait for my answers.
   a. Which AI tool(s) will this project use? Recommend the one you are running in. Each maps to one folder: claude/, antigravity/, opencode/, cursor/, copilot/, codex/, commandcode/.
   b. Which agents from the README "Agent team" should I install? List all ten with a one-line role each and mark the ones you recommend: tech-lead, software-architect, code-reviewer, security-engineer, research-analyst, backend-engineer, qa-engineer, support-engineer, and database-engineer for any CodeIgniter 3 or Laravel app; frontend-engineer only if the project has Vue/Inertia or Blade views. "None" is a valid answer.
3. Clone the repo to a temporary folder outside this project. Copy the contents of each chosen folder (including dot-folders) into the project root, leaving out the agent files I didn't choose, then delete the temporary clone. Ask before overwriting any existing file. If the project already has an AGENTS.md or CLAUDE.md, merge its content into the project section instead. If it already has an opencode.json or another settings file, merge the settings into it instead. If two chosen folders both have AGENTS.md, keep one and merge the "More instructions" tables.
4. If I left out any agents, keep the rest consistent in every chosen folder:
   - Delete their files, remove their rows from the Team table in the tech lead file (an agent file or .agents/skills/tech-lead/SKILL.md), and their names from its frontmatter (tools: Agent(...) in claude/, the subagent rules under permissions in opencode/).
   - Without tech-lead: also delete the tech-lead skill (.claude/skills/tech-lead/ or .agents/skills/tech-lead/) and the tech-lead row in the "More instructions" table of AGENTS.md.
   - No agents at all: delete the empty agents folder.
5. Add the local file (AGENTS.local.md, or CLAUDE.local.md for claude/) to .gitignore.
6. Delete the rule files for stacks the project doesn't use, and their rows in the "More instructions" table. The Laravel stack is laravel, laravel-style, laravel-9-10, and laravel-13, plus the refactor-bloated-code skill.
7. Laravel: keep laravel-9-10 for 9–10 or laravel-13 for 13, and delete the other the same way. For any other version, stop and ask me.
8. Fill in the TODO sections at the top of AGENTS.md (or CLAUDE.md) from what you find in the repo. Write only facts you verified.
9. Fill in the local file for this machine: DDEV or not, local URL, DB backup command.
10. Laravel: check whether tests could use the dev database (phpunit.xml, .env.testing). If they could, tell me; don't change it yet.
11. Summarize what you changed: folders used, agents installed, rule files kept. Don't commit.

Ask me if anything is unclear.
```

## Manual setup

1. Copy one folder's contents into the project root (here `claude/`).

   macOS / Linux:

   ```bash
   git clone --depth 1 https://github.com/lulu8879/agent-template.git /tmp/agent-template && cp -a /tmp/agent-template/claude/. /path/to/project/ && rm -rf /tmp/agent-template
   ```

   Windows (PowerShell):

   ```powershell
   git clone --depth 1 https://github.com/lulu8879/agent-template.git $env:TEMP\agent-template
   Copy-Item -Path $env:TEMP\agent-template\claude\* -Destination C:\path\to\project -Recurse -Force
   Remove-Item -Recurse -Force $env:TEMP\agent-template
   ```

2. Add `AGENTS.local.md` (or `CLAUDE.local.md`) to the project's `.gitignore`.
3. Follow steps 4 and 6–10 of the setup prompt by hand. To skip an agent, delete its file and follow step 4.
4. Check it loaded. In Claude Code, open a file under `app/` or `application/`, then run `/context`: `CLAUDE.md` and the matching rule should be under Memory files. In other agents, ask "which instruction files and rules do you have loaded?"

## Editing the template

Every folder has its own copy of each file, so a change has to be made in all seven folders. The body text is the same everywhere; only the frontmatter, the file format, and the paths inside the text differ.

Rules:

| Folder | Location | Frontmatter |
| --- | --- | --- |
| `claude/` | `.claude/rules/<name>.md` | `paths` |
| `antigravity/` | `.agents/rules/<name>.md` | `trigger: glob`, `description`, `globs` (Antigravity drops a rule without a valid `trigger`) |
| `cursor/` | `.cursor/rules/<name>.mdc` | `description`, `globs`, `alwaysApply: false` |
| `copilot/` | `.github/instructions/<name>.instructions.md` | `description`, `applyTo` |
| `opencode/`, `codex/`, `commandcode/` | `.agents/rules/<name>.md` | None: loaded by `opencode.json` or the `AGENTS.md` table |

Paths inside rule, skill, and agent text point to the folder's own rule location and extension, e.g. `.claude/rules/laravel.md`, `.cursor/rules/laravel.mdc`, `.github/instructions/laravel.instructions.md`.

Agents:

| Folder | Location | Frontmatter |
| --- | --- | --- |
| `claude/` | `.claude/agents/<name>.md` | `name`, `description`, `model` (`opus`/`sonnet`/`haiku`); `tools: Agent(...)` on `tech-lead`, `disallowedTools` on read-only agents |
| `antigravity/` | `.agents/agents/<name>.md` | `name`, `description`, `mainAgent`, `subagent`, `model` (`pro`/`flash`/`inherit`) |
| `opencode/` | `.opencode/agents/<name>.md` | `description`, `mode` (`primary` for `tech-lead`), `model` (`provider/model`), `permissions` list of `action`/`resource`/`effect` (`subagent` rules on `tech-lead`, `edit` deny on read-only agents) |
| `copilot/` | `.github/agents/<name>.agent.md` | `name`, `description`, `tools` (on `tech-lead` and read-only agents), `disable-model-invocation: true` on `tech-lead` |
| `cursor/` | `.cursor/agents/<name>.md` | `name`, `description`, `model: inherit`, `readonly: true` on read-only agents |
| `codex/` | `.codex/agents/<name>.toml` | `name`, `description`, `developer_instructions` (the body) |
| `commandcode/` | `.commandcode/agents/<name>.md` | `name`, `description`, `tools: "*"`, `disallowedTools` on read-only agents |

The tech lead's "Start agents with the … tool" line differs per tool. In `cursor/`, `codex/`, and `commandcode/` the tech lead is `.agents/skills/tech-lead/SKILL.md` instead of an agent file.

`AGENTS.md` is the same in every folder except the "More instructions" section at the end. `CLAUDE.md` is `AGENTS.md` without that section, and it refers to `CLAUDE.local.md`.

## Notes

- Copying several folders into one project: `antigravity/`, `opencode/`, `codex/`, and `commandcode/` share `.agents/rules/`, and those four plus `cursor/` share `.agents/skills/`. The rules and `refactor-bloated-code` have the same body everywhere, so keep one copy with the frontmatter every kept tool needs: `trigger`, `description`, and `globs` on rules (Antigravity); `disable-model-invocation: true` on the skill (Cursor, OpenCode, Command Code); `agents/openai.yaml` next to it (Codex). The `tech-lead` skill differs per tool: its "Start agents with …" line names that tool's subagent folder, so one copy serves only one of `cursor/`, `codex/`, and `commandcode/`.
- Some agents also read other agents' folders: Cursor reads `.claude/agents/`, `.claude/skills/`, `.codex/agents/`, and `.codex/skills/`; OpenCode reads `.claude/skills/`, `.agents/skills/`, and `CLAUDE.md` in folders without an `AGENTS.md`; Claude Code reads `AGENTS.md` only when there is no `CLAUDE.md`. So copying `claude/` next to `cursor/` or `opencode/` gives those tools a second `tech-lead` and duplicate skills. When a project needs several folders, delete the duplicates the other tool would pick up.
- Copilot asks before terminal commands by default. To make it always ask before `git push`, add `"chat.tools.terminal.autoApprove": { "git push": false }` to your VS Code User settings (Copilot ignores this in Workspace settings).
- Codex reads only `AGENTS.md`, so it follows the "More instructions" table for `AGENTS.local.md` and the rules. Codex agent files can't set a sandbox, so read-only agents rely on their instructions.
- Agents run Pint with the project's own settings. Pint's default preset sorts imports alphabetically and removes blank lines between them, so in projects without a `pint.json` it overrides the import grouping in `laravel-style`.
- After upgrading a project's Laravel version, swap its version file (`laravel-9-10` ↔ `laravel-13`).
- Team rules live below the "Team rules" comment in `AGENTS.md`/`CLAUDE.md`. Change them here, then copy them to projects; don't edit them per project.
- Coding guidelines come from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT), unchanged.
- MCP servers (Context7, Laravel Boost) are optional and set up per person. The rules work without them.

## License

MIT License.

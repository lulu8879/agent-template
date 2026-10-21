# Agent Template

Shared instructions for AI coding agents (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Command Code) in our CodeIgniter 3 and Laravel (Blade + Vue/Inertia) projects.

`AGENTS.md` is the single source of truth. Every other file either imports it or adds rules for one stack or one machine.

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
| `.agents/rules/vue.md` | Vue 3 + Inertia rules |
| `.claude/rules/*.md` | Symlinks to `.agents/rules/` for Claude Code |
| `.cursor/rules/*.mdc` | Symlinks to `.agents/rules/` for Cursor |
| `.github/instructions/*.instructions.md` | Symlinks to `.agents/rules/` for Copilot |
| `GEMINI.md` | Imports `.agents/rules/*.md` for Gemini CLI |
| `.gemini/settings.json` | Makes Gemini CLI read `AGENTS.md`, `AGENTS.local.md`, and `GEMINI.md` |

## Stack rules

Edit the rules only in `.agents/rules/`. Each file's frontmatter carries the file patterns once per tool, so the same file works everywhere:

| Key | Read by |
| --- | --- |
| `paths` | Claude Code |
| `globs`, `alwaysApply`, `description` | Cursor |
| `applyTo` | Copilot |

When you change a rule's file patterns, update all three keys. Each tool ignores the keys it doesn't use.

## Supported agents

| Agent | Main rules | Stack rules | Local file | Extra setup |
| --- | --- | --- | --- | --- |
| Claude Code | `CLAUDE.md` imports `AGENTS.md` | `.claude/rules/` symlinks, loaded when matching files are touched | `CLAUDE.local.md` imports it | None |
| Cursor | `AGENTS.md`, natively | `.cursor/rules/` symlinks, attached when matching files are in context | Via the `AGENTS.md` table | None |
| VS Code / Copilot | `AGENTS.md` (`chat.useAgentsMdFile`, on by default in recent versions) | `.github/instructions/` symlinks, applied to matching files | Via the `AGENTS.md` table | Turn the setting on if your version has it off |
| Gemini CLI | `AGENTS.md`, via `.gemini/settings.json` | `GEMINI.md` imports, always loaded | Loaded via `.gemini/settings.json` | On older versions, use `"contextFileName": [...]` instead of `context.fileName` |
| Codex | `AGENTS.md`, natively | Via the `AGENTS.md` table | Via the `AGENTS.md` table | None |
| Command Code | Not confirmed | Via the `AGENTS.md` table | Via the `AGENTS.md` table | If it doesn't pick up `AGENTS.md`, point its instruction file at it |

Codex and Command Code have no rules folder of their own, so they follow the "More instructions" table at the end of `AGENTS.md`.

### Windows

The per-tool rule files are symlinks. On Windows, Git checks them out as one-line text files unless symlinks are enabled. Turn on Developer Mode, then clone with:

```bash
git clone -c core.symlinks=true <repo-url>
```

## Use it in a project

1. Copy everything except `README.md` into the project root:

   ```bash
   rsync -a --exclude README.md --exclude .git /path/to/agent-template/ /path/to/project/
   ```

2. Add the local files to the project's `.gitignore`:

   ```
   AGENTS.local.md
   CLAUDE.local.md
   ```

3. Delete the stacks the project doesn't use:
   - CodeIgniter 3: remove `laravel` and `vue`.
   - Laravel + Blade: remove `codeigniter3` and `vue`.
   - Laravel + Vue/Inertia: remove `codeigniter3`.

   For each stack you remove, delete its file in `.agents/rules/`, its three symlinks, its import line in `GEMINI.md`, and its row in the `AGENTS.md` table. For example, to remove `vue`:

   ```bash
   rm .agents/rules/vue.md .claude/rules/vue.md .cursor/rules/vue.mdc .github/instructions/vue.instructions.md
   ```
4. Fill in the TODO sections at the top of `AGENTS.md` (project line, commands, project rules).
5. Rewrite `AGENTS.local.md` for your machine. Not on DDEV? The comment at its top has a non-DDEV example.
6. Laravel: make sure tests can't hit the dev database. Either `phpunit.xml` uses sqlite `:memory:`, or `.env.testing` (a copy of `.env`) has its own `DB_DATABASE`.
7. Check it loaded: in Claude Code, open a file under `app/` or `application/`, then run `/context`. `CLAUDE.md`, `AGENTS.md`, and the matching rule should be under Memory files.

If the project already has an `AGENTS.md`, move its content into the project section instead of overwriting it.

## Notes

- Team rules live below the "Team rules" comment in `AGENTS.md`. Change them here, then copy them to projects; don't edit them per project.
- Coding guidelines come from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT).
- MCP servers (Context7, Laravel Boost) are optional and set up per person in their own agent. The rules work without them.

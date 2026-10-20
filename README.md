# Agent Template

Shared instructions for AI coding agents (Claude Code, Codex, Cursor, Copilot, Gemini CLI, Command Code) in our CodeIgniter 3 and Laravel (Blade + Vue/Inertia) projects.

`AGENTS.md` is the single source of truth. Every other file either imports it or adds rules for one stack or one machine.

## Files

| File | Purpose |
| --- | --- |
| `AGENTS.md` | Project section (fill in) + team rules: ask first, protect the database, coding guidelines, git, language |
| `CLAUDE.md` | `@AGENTS.md` import, so Claude Code reads the same rules |
| `AGENTS.local.md` | Your machine only: DDEV/Laragon/Herd commands, local URL, DB backup command |
| `CLAUDE.local.md` | `@AGENTS.local.md` import for Claude Code |
| `.claude/settings.json` | Claude Code: no commit/PR attribution, asks before `git push` |
| `.claude/rules/codeigniter3.md` | CI3 rules, loaded when `application/**` files are touched |
| `.claude/rules/laravel.md` | Laravel + Blade + test-database rules |
| `.claude/rules/vue.md` | Vue 3 + Inertia rules |
| `.gemini/settings.json` | Makes Gemini CLI read `AGENTS.md` and `AGENTS.local.md` |

Claude Code loads the rule files and local files automatically. Other agents reach them through the "More instructions" table at the end of `AGENTS.md`.

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

3. Delete the stack files the project doesn't use, and their rows in the `AGENTS.md` table:
   - CodeIgniter 3: keep `codeigniter3.md`; delete `laravel.md` and `vue.md`.
   - Laravel + Blade: delete `codeigniter3.md` and `vue.md`.
   - Laravel + Vue/Inertia: delete `codeigniter3.md`.
4. Fill in the TODO sections at the top of `AGENTS.md` (project line, commands, project rules).
5. Rewrite `AGENTS.local.md` for your machine. Not on DDEV? The comment at its top has a non-DDEV example.
6. Laravel: make sure tests can't hit the dev database. Either `phpunit.xml` uses sqlite `:memory:`, or `.env.testing` (a copy of `.env`) has its own `DB_DATABASE`.
7. Check it loaded: in Claude Code, open a file under `app/` or `application/`, then run `/context`. `CLAUDE.md`, `AGENTS.md`, and the matching rule should be under Memory files.

If the project already has an `AGENTS.md`, move its content into the project section instead of overwriting it.

## Notes

- Team rules live below the "Team rules" comment in `AGENTS.md`. Change them here, then copy them to projects; don't edit them per project.
- Coding guidelines come from [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) (MIT).
- MCP servers (Context7, Laravel Boost) are optional and set up per person in their own agent. The rules work without them.

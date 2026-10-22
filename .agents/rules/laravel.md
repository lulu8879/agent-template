---
description: Laravel, Blade, and test-database rules
paths:
  - "app/**/*.php"
  - "bootstrap/app.php"
  - "config/**/*.php"
  - "database/**/*.php"
  - "routes/**/*.php"
  - "tests/**/*.php"
  - "resources/views/**/*.blade.php"
  - "phpunit.xml"
globs: app/**/*.php,bootstrap/app.php,config/**/*.php,database/**/*.php,routes/**/*.php,tests/**/*.php,resources/views/**/*.blade.php,phpunit.xml
alwaysApply: false
applyTo: "app/**/*.php,bootstrap/app.php,config/**/*.php,database/**/*.php,routes/**/*.php,tests/**/*.php,resources/views/**/*.blade.php,phpunit.xml"
trigger: glob
---

# Laravel

- Versions differ per repo (9–13); `laravel/framework` in `composer.json` is the source of truth. Version-specific rules are in `laravel-9-10.md` or `laravel-13.md`, whichever this project has.
- Write PHP for the minimum version in `composer.json` (`require.php`), not the newer PHP the dev environment runs.
- Create classes with `php artisan make:*` (migration, model, controller, request, …).
- Never edit a migration that may have run; add a new one.
- Call `config()` in app code; `env()` belongs only in `config/*.php` (it returns null once config is cached).
- Eager-load relations you loop over (`with()`) to avoid N+1 queries.
- If `vendor/bin/pint` exists, run it on the files you changed: `vendor/bin/pint <file>…`.

## Tests

`RefreshDatabase`, `DatabaseMigrations`, and `DatabaseTruncation` drop or empty every table on the connection the tests use.

- Before running tests, find the database they'll use: `DB_CONNECTION`/`DB_DATABASE` in `phpunit.xml` take precedence, then `.env.testing`. If neither points away from the `.env` database (sqlite `:memory:` or e.g. `testing`), stop and offer to create `.env.testing`: a copy of `.env` with its own `DB_DATABASE`. Laravel loads it instead of `.env`; it doesn't merge the two.
- Run `php artisan config:clear` first: while config is cached, Laravel ignores `.env.testing`.
- Run only the related tests: `php artisan test --filter=<Name>`.

## Blade

- Print with `{{ }}`. Use `{!! !!}` only for HTML you built or sanitized, never raw user input.
- Reuse existing layouts and `resources/views/components/` before creating new ones.
- If the project has a `lang/` directory, put new UI text through `__()`.

# Local environment

<!-- Machine-specific notes for this checkout. Gitignored. The AI reads this file, so no real passwords or API keys. -->

<!-- Not on DDEV? Replace the commands with your setup, e.g.
     URL: http://example-project.test
     Tools: php artisan, composer, npm (run on the host)
     Back up: mysqldump -u root example_db > ~/db-backups/example_db-$(date +%F-%H%M).sql
     Restore: mysql -u root example_db < <file>  (ask first) -->

## Run

- DDEV: `ddev start`. App URL: https://example-project.ddev.site
- Run tools in the container: `ddev php`, `ddev composer`, `ddev artisan` (Laravel), `ddev npm`.
- Database: MySQL 8.4, name `db`. Client: `ddev mysql` (`ddev psql` on Postgres).

## Database backup

- Back up: `ddev snapshot`
- Restore the latest: `ddev snapshot restore --latest` (overwrites current data: ask first)

## Tests (Laravel)

- Test database `testing`, set in `.env.testing`. Create it once: `ddev mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS testing; GRANT ALL ON testing.* TO 'db'@'%';"`
- Run: `ddev artisan test --filter=<Name>`

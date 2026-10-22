---
description: Laravel 13 rules
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

# Laravel 13

- Apps created on 11+ register middleware, exceptions, and routes in `bootstrap/app.php`. Apps upgraded from 10 may still use `app/Http/Kernel.php` and `app/Exceptions/Handler.php`; follow whichever this app has.
- **Models**:
  - Use PHP 8 Attributes `#[Fillable([...])]` and `#[Hidden([...])]` at class level.
  - Define casts via `protected function casts(): array` method (not `$casts` property).
  - Import the attributes from `Illuminate\Database\Eloquent\Attributes\`.

---
description: Team Laravel code style (validation, models, imports, routes, method names)
paths:
  - "app/**/*.php"
  - "routes/**/*.php"
globs: app/**/*.php,routes/**/*.php
alwaysApply: false
applyTo: "app/**/*.php,routes/**/*.php"
trigger: glob
---

<!-- Source: antigravity/rules/coding-standards.md in the team's ai-agents-md repo. Version-specific model rules live in laravel-13.md. -->

# Laravel code style

## Backend Standards

- **Database Safety**: Wrap ALL `CREATE`, `UPDATE`, and `DELETE` operations in `try-catch` blocks. Use `DB::beginTransaction()`, `DB::commit()`, and `DB::rollBack()` for transactions. Log errors using `Log::error()`.
- **NEVER use inline `$request->validate()` IF**:
  1. Validation contains **more than 4 fields**, OR
  2. Validation uses ANY class/facade from `Illuminate\Validation` or `Illuminate\Validation\Rules` (e.g., `Rule::unique()`, `Rule::exists()`, `Rule::enum()`, `Password::defaults()`, `File::types()`), **REGARDLESS of the number of fields**.
- **Mandatory Action**: Extract to a dedicated `FormRequest` class whenever `Rule::` or `Password::` is detected.
- **Subfolder Structuring**: If a context/module has **more than 1 Form Request class**, group them inside a dedicated subfolder (e.g., `App\Http\Requests\User\UpdateUserRequest.php`).
- **Models**:
  - Add PHPDoc `@use HasFactory<FactoryName>` above factory trait usage.
  - Specify explicit return types on relation methods (`BelongsTo`, `HasMany`, etc.).

## PHP Namespace & Routing Rules

- **Namespace Imports (`use`)**:
  - Base controller (`use App\Http\Controllers\Controller;`) MUST be isolated at the very top.
  - Sort all imports alphabetically and group by namespace prefix with a blank line.
  - Separate 3rd-party/native PHP imports into their own segment if **more than 3 items**.
- **Route Files (`routes/web.php`)**:
  - Sort top-level route groups alphabetically by base prefix (`roles` -> `student` -> `user`).
  - Use fluent syntax: `Route::controller(...)->prefix(...)->name(...)->group(...)`.
  - Always apply explicit parameter constraints (`whereUuid`, `whereNumber`, `whereAlpha`).

## Method Naming Convention (Avoid Redundancy / Stuttering)

- **NO Redundant Entity Names**: NEVER repeat the entity/class name inside Repository, Service, or Controller method names if the class or property context already implies it.
  - **BAD**: `$this->userRepo->updateUser($user, $data)`, `$this->studentService->getStudentDetail($id)`
  - **GOOD**: `$this->userRepo->update($user, $data)`, `$this->studentService->getDetail($id)` or `$this->studentService->find($id)`

---
name: refactor-bloated-code
description: Refactors a bloated Laravel controller into Form Requests, Repositories (heavy DB queries), and Services (3rd-party HTTP calls and non-CRUD logic), each behind a Contract interface. Use only when the user runs /refactor-bloated-code or explicitly asks for this refactor.
disable-model-invocation: true
metadata:
  opencode/slash: "true"
  opencode/autoinvoke: "false"
---

<!-- Source: antigravity/workflows/refactor-bloated-code.md in the team's ai-agents-md repo. -->

# Refactor Bloated Code (Repositories, Services & Requests)

Refactor only the controller the user names. Behavior must not change.

1. **Evaluate Request Validation**: Follow the Form Request rules in `.agents/rules/laravel-style.md` (inline `$request->validate()` only for 4 or fewer fields with no `Illuminate\Validation` classes; group a module's Form Requests in a subfolder when it has more than one).

2. **Evaluate Controller Code Complexity**:
   - **Keep in Controller**: Short, standard CRUD queries (simple `Model::all()`, `find()`, or basic `where()` statements).
   - **Extract to Repository**: Long/complex `SELECT` queries, heavy data aggregation, or lengthy `STORE`/`UPDATE`/`DELETE` queries.
   - **Extract to Service**: 3rd-party HTTP calls (`Http::get()`, API integrations) OR non-CRUD business calculations/logic (e.g., HTML sanitization/cleaning, complex string manipulation, external data processing).

3. **Enforce Contracts / Interfaces**:
   - Every Repository and Service MUST implement its respective Contract interface.
   - Place Contracts under `App\Contracts\Repositories\` or `App\Contracts\Services\`.
   - Name implementations accordingly (e.g., `EmployeeService implements EmployeeServiceContract`).

4. **Bind Contracts**: Bind each Contract to its implementation in a service provider's `register()` method, preferably the existing `App\Providers\AppServiceProvider`. Without a binding, Laravel can't resolve the Contract and throws `BindingResolutionException`. If you create a new provider, register it in `bootstrap/providers.php` (Laravel 11+) or the `providers` array in `config/app.php` (9–10).

5. **Dependency Injection & Explicit Property Assignment**:
   - Explicitly declare private properties at the class level.
   - Inject Contracts via constructor arguments and manually assign them to class properties inside `__construct()`.

6. **Verify**: Run the controller's related tests before and after the refactor (follow the test-database rules in `.agents/rules/laravel.md`). If there are none, run `php -l` on every changed file and tell the user which routes to check in the browser.

For the full reference code, see [references/patterns.md](references/patterns.md).

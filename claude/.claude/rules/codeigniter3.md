---
paths:
  - "application/**/*.php"
---

# CodeIgniter 3

- This is CodeIgniter 3, not CI4 or Laravel: `$this->load->model()`, `$this->input->post()`, `$this->db->…`; controllers extend `CI_Controller` or a base class in `application/core/`.
- Write PHP for the version the app runs on (`php_version` in `.ddev/config.yaml` if present; otherwise ask). On 8.0 (all CI3 apps today) that means no enums, readonly properties, or first-class callable syntax.
- Features are HMVC modules: `application/modules/<module>/{controllers,models,views}`. URLs not in `application/config/routes.php` map to `<module>/<controller>/<method>`.
- `system/`, `application/third_party/`, and `vendor/` are third-party code: read-only.
- Class file names are ucfirst and match the class: `User_model.php` → `class User_model extends CI_Model`.
- SQL: Query Builder or bindings (`$this->db->query($sql, [$id])`). Never concatenate request input into SQL.
- Views use a Laravel 3 Blade port, not Laravel Blade: `@layout` instead of `@extends`, and `{{ }}` does not escape. Wrap user data in `html_escape()`.
- Front-end is jQuery; write new UI code in jQuery too.
- There is no test suite: run `php -l <file>` on every changed PHP file, then tell the user what to check in the browser.

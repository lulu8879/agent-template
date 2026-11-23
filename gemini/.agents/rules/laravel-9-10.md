# Laravel 9–10

- Middleware is registered in `app/Http/Kernel.php`, exception handling in `app/Exceptions/Handler.php`.
- Models: define casts with the `protected $casts` property and mass assignment with the `$fillable`/`$hidden` properties. The `casts()` method needs Laravel 11+, and the `#[Fillable]`/`#[Hidden]` attributes need Laravel 13.

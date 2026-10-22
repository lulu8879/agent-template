# Reference patterns

## 1. Form Request (`App\Http\Requests\Employee\StoreEmployeeRequest.php`)

```php
namespace App\Http\Requests\Employee;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreEmployeeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', Rule::unique('employees', 'email')],
            'unit_id' => ['required', Rule::exists('units', 'id')],
        ];
    }
}
```

## 2. Service Contract & Implementation

```php
namespace App\Contracts\Services;

interface EmployeeServiceContract
{
    public function fetchExternal(string $employeeId): array;

    public function cleanHtmlContent(string $rawHtml): string;
}
```

```php
namespace App\Services;

use App\Contracts\Services\EmployeeServiceContract;

use Illuminate\Support\Facades\Http;

class EmployeeService implements EmployeeServiceContract
{
    public function fetchExternal(string $employeeId): array
    {
        $response = Http::get("https://api.thirdparty.com/employees/{$employeeId}");

        return $response->json();
    }

    public function cleanHtmlContent(string $rawHtml): string
    {
        return strip_tags($rawHtml, '<p><br><b><i>');
    }
}
```

## 3. Repository Contract & Implementation

```php
namespace App\Contracts\Repositories;

use App\Models\Employee;

interface EmployeeRepositoryContract
{
    public function create(array $data): Employee;

    public function getDetailedReport(string $unitId): array;
}
```

```php
namespace App\Repositories;

use App\Contracts\Repositories\EmployeeRepositoryContract;
use App\Models\Employee;

class EmployeeRepository implements EmployeeRepositoryContract
{
    public function create(array $data): Employee
    {
        return Employee::create($data);
    }

    public function getDetailedReport(string $unitId): array
    {
        return Employee::query()
            ->with(['unit', 'roles', 'salaryLogs'])
            ->where('unit_id', $unitId)
            ->where('is_active', true)
            ->orderBy('created_at', 'desc')
            ->get()
            ->toArray();
    }
}
```

## 4. Binding (`App\Providers\AppServiceProvider.php`)

```php
namespace App\Providers;

use App\Contracts\Repositories\EmployeeRepositoryContract;
use App\Contracts\Services\EmployeeServiceContract;
use App\Repositories\EmployeeRepository;
use App\Services\EmployeeService;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(EmployeeRepositoryContract::class, EmployeeRepository::class);
        $this->app->bind(EmployeeServiceContract::class, EmployeeService::class);
    }
}
```

## 5. Controller Usage (Explicit Property Declaration)

```php
namespace App\Http\Controllers;

use App\Contracts\Repositories\EmployeeRepositoryContract;
use App\Contracts\Services\EmployeeServiceContract;
use App\Http\Requests\Employee\StoreEmployeeRequest;

use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Throwable;

class EmployeeController extends Controller
{
    private EmployeeRepositoryContract $employeeRepo;
    private EmployeeServiceContract $employeeService;

    public function __construct(
        EmployeeRepositoryContract $employeeRepository,
        EmployeeServiceContract $employeeService,
    ) {
        $this->employeeRepo = $employeeRepository;
        $this->employeeService = $employeeService;
    }

    public function store(StoreEmployeeRequest $request): RedirectResponse
    {
        DB::beginTransaction();

        try {
            $this->employeeRepo->create($request->validated());
            DB::commit();
        } catch (Throwable $e) {
            DB::rollBack();
            Log::error('Failed to create employee', ['exception' => $e]);

            return back()->withInput()->with('error', 'Failed to save the employee.');
        }

        return redirect()->route('employees.index');
    }
}
```

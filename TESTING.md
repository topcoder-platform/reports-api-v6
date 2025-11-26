# Testing Guide

## Overview
Jest with `@nestjs/testing` is used for unit and lightweight integration tests. Tests focus on isolating controllers, services, DTO validation, and module wiring without hitting external systems such as databases or the filesystem.

## Running Tests
- `pnpm test` — run all specs once
- `pnpm test:watch` — watch mode during development
- `pnpm test:cov` — generate coverage report
- `pnpm test:debug` — start Jest in debug/inspect mode

## Test Structure
- Tests live alongside source files and are named `*.spec.ts`.
- Use `describe` blocks per class or function and keep expectations close to the behavior under test.
- Mock framework dependencies (e.g., `DbService`, `SqlLoaderService`) to avoid side effects.

## Writing Tests for SFDC Endpoints
- **Controllers:** mock services, assert route handlers pass through parameters and propagate errors.
- **Services:** mock `DbService` and `SqlLoaderService`; verify parameter ordering and validation paths.
- **DTOs:** leverage `class-validator` with `validate()` to assert decorator behavior and data transforms.
- **Modules:** use `Test.createTestingModule` to ensure providers/controllers are registered and injectable.

## Mock Data
Reusable fixtures live under `src/reports/sfdc/test-helpers`. Share mock responses and query DTOs across controller, service, and DTO specs to keep assertions consistent.

## Best Practices
- Reset mocks in `beforeEach` to avoid cross-test leakage.
- Cover happy paths and error cases, especially validation failures.
- Prefer deterministic data; avoid randomness and timers.
- Keep assertions focused—each test should validate one behavior.

## Example Patterns
```ts
const mockDb = { query: jest.fn() };
const moduleRef = await Test.createTestingModule({
  providers: [{ provide: DbService, useValue: mockDb }, SfdcReportsService],
}).compile();
```

```ts
const dto = plainToInstance(ChallengesReportQueryDto, input);
const errors = await validate(dto);
expect(errors).toHaveLength(0);
```

## CI/CD Integration
- Ensure `pnpm test` and `pnpm test:cov` run cleanly in CI; failing tests should block deployments.
- Coverage output is written to `coverage/` and should be ignored from commits by default.

## Coverage for SFDC Endpoints

All SFDC report endpoints (`/challenges`, `/payments`, `/taas/*`, `/ba-fees`) should have:
- **Controller tests**: Route handling, parameter transforms, error propagation
- **Service tests**: SQL loading, parameter ordering (verify all query params), filter logic (include/exclude via `multiValueArrayFilter`), empty results, error handling
- **DTO tests**: All validators (`@IsString`, `@IsDateString`, `@IsNumber`, etc.), transforms (`transformArray`, `transformToNumber`), optional fields, invalid input rejection

Example service test for parameter ordering:
```ts
it('passes all filters in correct order', async () => {
  await service.getPaymentsReport({
    billingAccountIds: ['12345'],
    challengeIds: ['uuid1'],
    handles: ['user1'],
    challengeName: 'Task',
    startDate: '2023-01-01',
    endDate: '2023-12-31',
    minPaymentAmount: 100,
    maxPaymentAmount: 1000,
    challengeStatus: ['COMPLETED']
  });
  
  expect(mockDbService.query).toHaveBeenCalledWith(mockSql, [
    ['12345'], // include billing accounts
    undefined,  // exclude billing accounts
    ['uuid1'],  // challenge IDs
    ['user1'],  // handles
    'Task',     // challenge name
    '2023-01-01', // start date
    '2023-12-31', // end date
    100,        // min amount
    1000,       // max amount
    ['COMPLETED'] // challenge status
  ]);
});
```

Refer to `sfdc-reports.controller.spec.ts`, `sfdc-reports.service.spec.ts`, and `sfdc-reports.dto.spec.ts` for complete patterns.

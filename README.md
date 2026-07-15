# Campus Equipment Loan

An Android Flutter application for browsing campus devices and submitting
equipment-loan requests through RESTful API.

## Local configuration

Copy `.env.example` to `.env` and replace the API key. The real `.env` is
ignored by Git.

Run the configured app on the Android emulator:

```powershell
flutter run -d emulator-5554 --dart-define-from-file=.env
```

`RESTFUL_API_OBJECTS_URL` defaults in code to the exam endpoint
`https://api.restful-api.dev/objects`. It can point to an authenticated test
collection during development without changing application code.

## Development checks

Generate transport serializers, format source, and run static analysis:

```powershell
dart run build_runner build
dart format lib
flutter analyze
```

Automated tests are intentionally introduced in PART 4 of the implementation
plan. PARTs 1-3 use the documented Android manual-verification matrices.

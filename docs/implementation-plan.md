# Campus Equipment Loan Implementation Plan

Status: agreed documentation baseline; implementation has not started.

Source requirement: [`requirement.docx`](../requirement.docx)

Primary application target: Android only, portrait phone layout, light theme.

## 1. Objective and delivery sequence

Build the campus equipment-loan Flutter application in five separately
navigable states. PARTs 1-4 apply to the root project. PART 5 is a separate,
tracked Flutter subproject delegated to another AI agent.

The execution order is fixed:

1. Complete PART 1, verify it, update evidence, commit, and tag it.
2. Complete PART 2 on top of PART 1, verify it, update evidence, commit, and tag
   it.
3. Complete PART 3 on top of PART 2, verify it, update evidence, commit, and tag
   it.
4. Stop after PART 3 and wait for explicit user approval.
5. After approval, implement all root-app automated tests in PART 4, verify,
   update evidence, commit, and tag it.
6. Stop this agent's implementation work at `part-4-complete` and hand PART 5
   to another AI agent using section 14 of this plan.

No implementation commit may mix work from two PARTs. Do not squash or rewrite
the five checkpoint commits after their tags are created.

## 2. Agreed constraints and interpretations

### 2.1 In scope

- Clean Architecture with Data, Domain, and Presentation responsibilities kept
  separate by feature.
- Explicit Riverpod providers; no Riverpod code generator.
- Declarative navigation with `go_router`.
- Remote access through `package:http`.
- Drift over SQLite for all durable application state.
- The four designed workflow screens: Device Catalogue, Device Detail, Loan
  Request Form, and Request Result.
- A fifth Compare screen introduced in PART 2.
- A Pending Requests view introduced in PART 3.
- Evidence and concise written answers maintained as each PART is completed.

### 2.2 Deliberately out of scope

- iOS, web, Windows, tablet, and landscape acceptance targets.
- Dark theme and in-app theme switching.
- Expanded responsive-layout or large-text acceptance work.
- Automatic background submission of pending loan requests.
- Automated tests during PARTs 1-3. Those tests are created only in PART 4.
- Riverpod annotations/code generation.
- A fake Home or Profile destination copied from the reference mockups.

### 2.3 Requirement clarifications

- **Deposit policy:** value at or above $1,000 produces a $50 refundable
  deposit; lower, missing, or unparseable value produces $20. The threshold and
  amounts must be injected through one domain policy so they can change without
  touching widgets, sorting, persistence, or tests.
- **Loan period:** borrowing today is allowed; dates are local calendar dates;
  return must be strictly later; `return - borrow` must be at most 14 days.
- **Search:** query handling is local because the public endpoint exposes no
  documented name-search operation. The query controller owns a 400 ms
  debounce and never calls the remote endpoint while typing.
- **Sort:** every device keeps a `sourceIndex`. Default uses Source Order; Name
  A-Z is case-insensitive; Deposit Low-High uses the injected deposit policy;
  ties use Source Order.
- **Compare List:** this is the canonical term. The mockup's Watchlist/Saved
  wording is not used. At most two IDs are allowed.
- **Offline retry:** retry is explicit and user-controlled. There is never a
  silent submission on app start, resume, or connectivity change.
- **Exactly once:** the public POST endpoint has no idempotency contract.
  Guarantee one in-flight call and one POST per explicit retry, not impossible
  global exactly-once delivery. Preserve an Unknown Outcome when a request may
  have reached the server but no definitive response was received.
- **PART 5 evidence:** replace the stale title-sorting and confirmation labels
  with search and refresh/error-recovery evidence matching Tasks 5.3-5.4.

## 3. Planned packages

Resolve compatible versions with the Dart MCP at implementation time and let
`flutter pub add` update `pubspec.lock`. The versions observed during planning
include `flutter_riverpod 3.3.2`, `go_router 17.3.0`, `http 1.6.0`,
`drift_flutter 0.3.1`, `json_serializable 6.14.0`, `uuid 4.5.3`, and
`checks 0.3.1`; do not hard-code these versions if the solver selects newer
compatible releases.

### Runtime dependencies

- `flutter_riverpod`: explicit dependency injection and presentation state.
- `go_router`: catalogue/compare shell and workflow routes.
- `http`: injected remote HTTP adapter.
- `drift` and `drift_flutter`: SQLite schema, transactions, and Android
  database opening.
- `json_annotation`: generated transport-model serialization where it reduces
  hand-written mapping risk.
- `uuid`: stable local submission and idempotency identifiers.

### Development dependencies

- `build_runner`: Drift and JSON code generation.
- `drift_dev`: database generation.
- `json_serializable`: transport-model generation.
- `checks`: expressive assertions added in PART 4.
- `flutter_test`: unit and widget testing in PART 4.

### Explicit exclusions

- No `shared_preferences`, Hive, Drift web support, or connectivity-monitor
  dependency.
- No mocking generator. Prefer hand-written fakes and Riverpod overrides.
- No third-party theme, date picker, form, or networking wrapper.

## 4. Target project structure

```text
lib/
|-- app/
|   |-- app.dart
|   |-- app_providers.dart
|   |-- router.dart
|   `-- theme.dart
|-- core/
|   |-- error/
|   |   |-- app_failure.dart
|   |   `-- failure_mapper.dart
|   |-- network/
|   |   |-- api_client.dart
|   |   `-- network_exceptions.dart
|   |-- storage/
|   |   |-- app_database.dart
|   |   |-- database_connection.dart
|   |   `-- tables/
|   |-- time/
|   |   `-- clock.dart
|   `-- utils/
|       `-- result.dart
|-- features/
|   |-- equipment/
|   |   |-- data/
|   |   |   |-- datasources/
|   |   |   |-- models/
|   |   |   |-- repositories/
|   |   |   `-- mapping/
|   |   |-- domain/
|   |   |   |-- entities/
|   |   |   |-- policies/
|   |   |   |-- repositories/
|   |   |   `-- usecases/
|   |   `-- presentation/
|   |       |-- providers/
|   |       |-- pages/
|   |       `-- widgets/
|   `-- loan_request/
|       |-- data/
|       |   |-- datasources/
|       |   |-- models/
|       |   `-- repositories/
|       |-- domain/
|       |   |-- entities/
|       |   |-- repositories/
|       |   `-- usecases/
|       `-- presentation/
|           |-- providers/
|           |-- pages/
|           `-- widgets/
`-- main.dart

test/                         # populated in PART 4
|-- core/
|-- features/equipment/
|-- features/loan_request/
`-- support/fakes/

docs/
|-- adr/
`-- implementation-plan.md

part5_flutter_mvvm/           # imported only by the delegated PART 5 agent
```

Equivalent private-library splits are acceptable when a file becomes too
large, but layer direction is not negotiable:

```text
Presentation -> Domain <- Data
                    ^
                    |
              app composition
```

Widgets may invoke notifier commands and navigation only. They must not import
`http`, Drift tables/DAOs, DTOs, or concrete repositories.

## 5. Deep modules, interfaces, and adapters

Keep each caller-facing interface small and place complexity behind it.

### 5.1 Equipment catalogue module

Domain interface responsibilities:

- load the best available catalogue;
- refresh from the remote source without erasing valid visible data;
- fetch one device when detail data is required;
- preserve Source Order and expose whether returned data is cached/stale.

Production adapters:

- remote adapter: HTTP GET list and GET one;
- local adapter: Drift catalogue snapshot;
- repository implementation: tolerant mapping, cache coordination, and typed
  failures.

PART 4 fake adapter:

- deterministic lists, delays, transport failures, server failures, and
  malformed payloads.

The presentation layer consumes an immutable catalogue state rather than
coordinating remote and local calls itself.

### 5.2 Device mapping and policy modules

`Device` is immutable and contains at least:

- `id`, `name`, `sourceIndex`;
- inferred category;
- nullable normalized estimated value and year;
- immutable raw attributes for safe detail display.

Mapping rules:

- treat `data: null`, missing data, and heterogeneous maps as valid;
- recognize price keys case-insensitively;
- parse numeric values and numeric strings;
- keep unrecognized attributes for the detail screen;
- never use a null assertion on remote data.

`DeviceCategoryClassifier` is an injected policy with keyword rules for
`laptop`, `phone`, `tablet`, `wearable`, `audio`, and `other`.

`DepositPolicy` is an injected interface returning deposit money from nullable
estimated value. All catalogue labels, detail labels, form summaries, payloads,
sorting, persistence, and tests use the same policy instance.

### 5.3 Compare List module

Expose operations to restore, add, remove, reorder, and resolve the current
selection. Enforce the maximum of two inside the module before persistence.
Return a typed result such as `added`, `alreadySelected`, or `limitReached` so
widgets only render feedback.

After a successful remote refresh, remove IDs that the authoritative catalogue
no longer contains. During offline/cache-only loads, retain selections that can
still resolve against the cached catalogue.

### 5.4 Loan request module

Domain types:

- `LoanPeriod` validates date-only invariants through an injected clock;
- `LoanDraft` represents editable form state;
- `LoanRequest` contains the finalized immutable payload;
- `LoanSubmission` represents local submission state and remote result;
- `SubmissionState` is exhaustive: `pending`, `sending`, `unknownOutcome`, and
  `succeeded`.

Keep the exact remote payload construction in one module:

```json
{
  "name": "Campus Equipment Loan Request",
  "data": {
    "deviceId": "7",
    "studentId": "SE1819",
    "borrowDate": "2026-08-01",
    "returnDate": "2026-08-07",
    "purpose": "Mobile app demo",
    "deposit": 50,
    "status": "pending"
  }
}
```

The local idempotency key is stored with the immutable request snapshot but is
not added to the remote payload because the requirement calls for the exact
nested fields and the server does not document an idempotency header or field.

Submission coordination must:

1. reject invalid finalized input before I/O;
2. block rapid/concurrent duplicate commands;
3. classify transport, HTTP, decoding, and ambiguous in-flight failures;
4. persist a pending record only for a confirmed offline transport failure;
5. mark an interrupted in-flight request Unknown Outcome;
6. perform one POST per explicit Retry command;
7. persist the returned `id`, `createdAt`, and response data before showing
   success.

## 6. Drift schema and migration plan

Use ISO-8601 UTC timestamps for persistence and date-only ISO strings for loan
dates. Store money as integer whole-dollar or cent values consistently; never
store binary floating-point money in domain records.

### Schema version 1 - introduced in PART 2

`compare_selections`

- `device_id` text primary key;
- `position` integer unique, limited by the domain module to 0 or 1;
- `selected_at` date-time.

### Schema version 2 - introduced in PART 3

`cached_devices`

- `device_id` text primary key;
- `name` text;
- `raw_data_json` text;
- `estimated_value_minor` integer nullable;
- `year` integer nullable;
- `category` text;
- `source_index` integer;
- `cached_at` date-time.

`catalogue_metadata`

- singleton key;
- `last_successful_refresh_at` date-time;
- cached record count.

`loan_drafts`

- singleton key;
- selected device ID and serialized Device Snapshot;
- student ID, borrow date, return date, and purpose;
- derived deposit value;
- `updated_at` date-time.

`loan_submissions`

- `local_id` UUID primary key;
- `idempotency_key` UUID unique;
- serialized immutable payload and Device Snapshot;
- exhaustive state string;
- attempt count;
- created, last-attempt, and completed timestamps;
- nullable remote ID, remote creation time, serialized remote response, and
  last error summary.

Migration requirements:

- increment `schemaVersion` from 1 to 2;
- create new tables without dropping `compare_selections`;
- run all multi-table replacements and state transitions transactionally;
- generate and review Drift output;
- manually verify a PART 2 database survives upgrade to PART 3 with comparison
  IDs intact.

## 7. Presentation and navigation plan

Use a centralized light Material 3 theme based on navy hierarchy and teal
actions from the reference screens. Prefer small private widget classes and
`const` constructors.

Final navigation graph:

```text
Equipment shell
|-- /equipment                     Device Catalogue
|   `-- /equipment/:id             Device Detail
|       `-- /equipment/:id/request Loan Request Form
|           `-- /request-result    Remote or pending result
|-- /compare                       Compare List
`-- /pending                       Pending/unknown submissions
```

The bottom navigation exposes only meaningful destinations:

- Equipment;
- Compare.

Pending Requests is reached from a catalogue app-bar action or status banner.
Detail, form, and result screens are pushed workflow routes and do not pretend
to be top-level destinations.

Presentation state must be immutable and exhaustive enough to render:

- initial/loading;
- content;
- refreshing with existing content;
- empty;
- cached/offline content;
- error without content;
- submitting;
- validation failure;
- remote success;
- locally pending;
- unknown submission outcome.

## 8. PART 1 - Core application (35 points)

### 8.1 Build order

1. Replace the counter sample and remove its obsolete smoke test.
2. Add PART 1 runtime/generator dependencies except Drift-specific packages if
   they are not needed until PART 2.
3. Create app composition, light theme, routes, failure/result primitives, and
   HTTP client configuration with explicit timeouts.
4. Define domain entities and the injected clock, category classifier, and
   configurable Deposit Policy.
5. Add remote DTOs/mappers for GET list, GET one, and POST response.
6. Implement the remote datasource and repository adapter.
7. Build explicit Riverpod providers for dependencies and presentation
   notifiers.
8. Build Device Catalogue cards with loading, error, empty, refresh, inferred
   category, year, estimated value, and deposit.
9. Build Device Detail with raw-attribute fallbacks and Request This Device.
10. Build Loan Request Form with student ID, date pickers, purpose,
    field-specific validation, and derived summary.
11. Build Request Result using only the POST response as success evidence.
12. Guard the button visually while submission is in progress; the formal
    rapid-tap regression test is deferred to PART 4.
13. Write the concise architecture trace requested by Task 1.2.

### 8.2 Manual verification matrix

- GET catalogue succeeds on `emulator-5554`.
- Pull/manual refresh preserves the screen while loading.
- Forced transport error shows a retryable error when no cache exists.
- An empty fake/manual response renders the empty state.
- Devices with `data: null`, missing year, numeric price, string price, and no
  price render without crashing.
- Detail route works from at least one complete and one incomplete device.
- Today is accepted; past, same-day/reversed return, and over-14-day periods
  show precise errors.
- Invalid form never calls POST.
- Valid form sends the exact nested payload.
- 200 and 201 responses display returned ID, creation time, dates, deposit, and
  Pending status.
- HTTP and decoding failures remain on the form with retryable feedback.

### 8.3 Evidence and documentation

- Catalogue/error-state screenshot.
- Detail missing-data screenshot.
- Validated form screenshot.
- POST result screenshot.
- Architecture trace names exact DTO, mapper, entity, repository, notifier, and
  screen paths.
- Update the working exam-document copy before the checkpoint commit.

### 8.4 Gate and checkpoint

- Format all changed Dart files with the Dart MCP.
- Run Dart/Flutter analysis through `mcp__dart__analyze_files` with zero errors.
- Run the Android flow manually; do not add automated tests yet.
- Review `git diff` and ensure no PART 2 work is present.
- Commit: `part-1: build core equipment loan workflow`
- Tag: `part-1-complete`

## 9. PART 2 - Change request sprint (20 points)

### 9.1 Debounced search

- Add an explicit Riverpod query notifier that owns the raw query, debounced
  query, 400 ms timer, and disposal.
- Filter the already loaded immutable device list locally by name.
- Trim whitespace and compare case-insensitively.
- Clear query to restore all devices in Source Order.
- Do not mutate repository or cached lists and do not perform HTTP while typing.

### 9.2 Compare List

- Introduce Drift schema version 1 and database composition.
- Add Compare List domain module and Drift adapter.
- Enforce maximum two before writing.
- Persist ordered IDs and restore them after process/app restart.
- Provide add/remove feedback and a side-by-side Compare screen.
- Reconcile stale IDs only after an authoritative successful catalogue refresh.

### 9.3 Sorting

- Add exhaustive sort mode: Source Order, Deposit Low-High, Name A-Z.
- Create derived sorted copies; never sort repository/domain lists in place.
- Missing price uses the agreed $20 deposit through Deposit Policy.
- Use `sourceIndex` as the stable tie-breaker for all derived sorts.
- Changing filters, query, or sort must compose predictably and returning to
  Source Order must exactly reproduce the API order.

### 9.4 Manual verification matrix

- Rapid typing updates once after 400 ms and produces no extra GET calls.
- Clearing search restores all rows in exact Source Order.
- Add first and second comparison device; third is rejected with clear
  feedback.
- Remove and re-add devices without duplicates.
- Kill/restart app and confirm ordered selection IDs restore.
- Verify Compare renders missing values safely.
- Verify both sort modes, ties, missing prices, and reset to Source Order.
- Verify query + category + sort composition.

### 9.5 Evidence, gate, and checkpoint

- Capture debounced-search and Compare screenshots.
- Capture validation/sorting screenshot or analyzer output as requested.
- Answer which notifier owns query/debounce, where the two-device limit lives,
  where loan dates are validated, and how missing price is sorted.
- Update the working exam document.
- Run formatting and static analysis; perform Android restart verification.
- Do not add automated tests yet.
- Commit: `part-2: add search comparison and stable sorting`
- Tag: `part-2-complete`

## 10. PART 3 - Offline support (15 points)

### 10.1 Schema and adapters

- Add Drift schema version 2 tables from section 6.
- Implement migration preserving PART 2 comparison rows.
- Add catalogue-cache, draft, and submission DAOs behind repository interfaces.
- Serialize Device Snapshots and exact payloads at the data seam.

### 10.2 Stale-while-revalidate catalogue

1. Read Drift and publish cached content immediately when present.
2. Start remote refresh without blanking content.
3. Parse the complete response before opening the replacement transaction.
4. Replace cached rows and metadata atomically on success.
5. Preserve cached rows and show offline/stale banner on transport failure.
6. Show full error only when neither remote nor cached data exists.
7. Treat HTTP rejection and malformed success data as server/data errors, not
   proof that the device is offline.

### 10.3 Draft lifecycle

- Debounce form persistence separately from search.
- Persist selected Device Snapshot, student ID, date values, purpose, and
  derived deposit.
- Restore draft after restart and revalidate it against the current clock and
  policy before enabling Submit.
- Retain draft on navigation or validation/server failure.
- On confirmed remote success or successful conversion to Pending, clear the
  editable draft only after the immutable record is safely stored.

### 10.4 Pending and Unknown Outcome lifecycle

- On confirmed offline transport failure before a definitive response, offer
  Save as Pending; never claim remote creation.
- Pending screen shows immutable request facts, age, attempt count, and Retry.
- Retry is explicit and executes one guarded POST.
- Confirmed 200/201 atomically marks Succeeded and persists remote result.
- HTTP rejection remains retryable/error according to status but is not
  silently reclassified as offline.
- A timeout/disconnect after the POST may have been accepted becomes Unknown
  Outcome and requires user review before another attempt.
- Never automatically submit on app start, resume, or connectivity change.

### 10.5 Manual verification matrix

- Online launch caches the current catalogue.
- With network unavailable, cached catalogue appears with offline banner.
- Fresh install plus network failure shows no-cache error.
- Comparison IDs survive version-1-to-version-2 migration.
- Full draft survives app kill/restart.
- Offline submission becomes Pending with stable local/idempotency IDs and
  unchanged nested payload.
- Editing a new draft does not mutate the pending snapshot.
- One Retry produces one POST and then a persisted result.
- Rapid Retry taps do not create concurrent calls.
- Simulated ambiguous timeout becomes Unknown Outcome, not ordinary Pending.

### 10.6 Evidence and focused answer

The written answer must name the persisted Device Snapshot, borrow/return date
strings, all seven nested payload fields, local ID, idempotency key, state,
attempt count, timestamps, and remote response fields. It must also state the
server's idempotency limitation.

Capture:

- cached catalogue with offline banner;
- restored draft;
- Pending screen and explicit Retry/result.

### 10.7 Gate, checkpoint, and mandatory pause

- Run code generation, formatting, and static analysis.
- Perform all Android offline/restart/migration flows.
- Do not add automated tests yet.
- Update the working exam document.
- Commit: `part-3: add drift offline cache drafts and retry queue`
- Tag: `part-3-complete`
- Stop and report changed files, manual verification, known limitations,
  commit hash, and tag.
- Wait for explicit user approval before PART 4.

## 11. PART 4 - Testing and bug detection (10 points)

PART 4 begins only after user approval following PART 3.

### 11.1 Test infrastructure

- Add `checks` and test support fakes.
- Use injected fake HTTP/catalogue/submission adapters, an in-memory Drift
  database, fake clock, configurable Deposit Policy, and Riverpod overrides.
- Never use the live network.
- Assert through repository/use-case/notifier interfaces rather than generated
  Drift internals.

### 11.2 Required automated tests

1. **Deposit Policy unit test**
   - below threshold -> $20;
   - exactly threshold -> $50;
   - above threshold -> $50;
   - missing/unparseable price -> $20;
   - alternate injected configuration proves easy policy change.
2. **Loan Period unit test**
   - today allowed;
   - past borrow rejected;
   - same-day and reversed return rejected;
   - 14 days accepted;
   - 15 days rejected;
   - fake clock removes date flakiness.
3. **Mapper/repository test**
   - `data: null`, missing nested fields, numeric and string Price forms;
   - successful remote refresh writes cache;
   - transport failure returns cache with stale/offline metadata;
   - HTTP/data failure classification is preserved.
4. **Rapid Submit widget test**
   - render form with provider overrides;
   - enter valid data;
   - tap Submit rapidly;
   - fake adapter records exactly one POST;
   - disabled/progress state is visible.

Add focused persistence tests for Compare maximum/restoration, draft restoration,
pending immutable snapshot, one-call Retry, and Unknown Outcome if needed to
protect the PART 3 state machine.

### 11.3 Red/green bug evidence

Prefer a real defect discovered by the required tests. If the completed PART 3
code already passes every required edge, prove test sensitivity with a temporary
uncommitted mutation in an isolated worktree or reversible edit:

1. introduce one realistic defect, such as removing the single-flight guard;
2. run only the focused test and capture the expected failure;
3. restore the correct implementation;
4. rerun and capture the pass;
5. verify the mutation never enters a commit.

The explanation must state the observed bug, why the assertion fails, the
production fix, and why the same assertion passes afterward.

### 11.4 Gate and checkpoint

- Run code generation if test-visible database code changed.
- Run formatter and static analysis.
- Run the complete root-project `flutter test` suite.
- Re-run the rapid-submit test independently for clean evidence.
- Update failing/passing evidence and Task 4.2 explanation in the exam document.
- Commit: `part-4: add automated regression coverage`
- Tag: `part-4-complete`
- Report completion and end this agent's implementation responsibility.

## 12. Evidence and working exam document

Preserve `requirement.docx` as the source. At implementation start, create a
working copy whose final student-specific name is supplied later. Do not place
screenshots into the source requirement.

For every PART:

1. capture evidence from the exact checkpoint code;
2. write answers with exact file, type, method, provider, and route names;
3. insert screenshots/test output into the matching cells;
4. correct PART 5's stale labels in the working copy;
5. render the DOCX to page images;
6. visually inspect all changed pages for clipping, overlap, broken tables, and
   unreadable text;
7. include the working document changes in that PART's commit.

The final packaging plan must eventually create:

```text
StudentID_FullName_PRM393_VariantD/
|-- source_code/
|-- exam_document/StudentID_FullName_Exam.docx
`-- ai_evidence/
```

Student ID and full name are execution-time inputs; do not invent them.

## 13. Git checkpoint protocol

### Baseline documentation commit

- Commit: `docs: add agreed campus equipment loan plan`
- Contains only `requirement.docx`, `docs/implementation-plan.md`, `CONTEXT.md`,
  and agreed ADRs.

### PART checkpoints

| PART | Commit message | Tag | Owner |
|---|---|---|---|
| 1 | `part-1: build core equipment loan workflow` | `part-1-complete` | This agent |
| 2 | `part-2: add search comparison and stable sorting` | `part-2-complete` | This agent |
| 3 | `part-3: add drift offline cache drafts and retry queue` | `part-3-complete` | This agent |
| 4 | `part-4: add automated regression coverage` | `part-4-complete` | This agent, after approval |
| 5 | `part-5: extend legacy mvvm search and recovery` | `part-5-complete` | Delegated AI agent |

Before every commit:

- check Git status and diff;
- exclude unrelated user changes;
- verify only the current PART is staged;
- record analysis/test/manual evidence in the commit handoff;
- create the tag only after the commit succeeds.

Use Git MCP for status, diff, staging, commits, and history. The available Git
MCP has no tag operation, so create and verify local tags with `git tag` and
`git show-ref --tags` as the narrow fallback.

## 14. PART 5 delegated handoff plan (20 points)

This section is a specification for another AI agent. The current agent must
not implement PART 5.

### 14.1 Handoff preconditions

- Root project is at `part-4-complete` with a clean worktree.
- Create branch `codex/part-5-mvvm` from that tag.
- Import a cleaned copy of `jitsm555/Flutter-MVVM` at commit
  `959c25e5c07454e33de8473c6ed0ce494b06f227` into
  `part5_flutter_mvvm/`.
- Exclude nested `.git`, `.dart_tool`, `build`, `.idea`, `.packages`, generated
  plugin files, and other caches committed by upstream.
- Record source URL, commit, import date, and exclusions in the subproject
  README.

### 14.2 Reproduce before modifying

The pinned project declares Dart `<3.0.0`, `provider 5.0.0`, `http 0.13.1`, and
`audioplayers 0.18.2`, so it cannot be assumed to run on Flutter 3.44/Dart 3.12.

The delegated agent must:

1. run dependency resolution and capture the exact failure;
2. map actual source responsibilities:
   - `HomeScreen` is the View;
   - `MediaViewModel` is the ChangeNotifier ViewModel;
   - `Media` is the Model;
   - `MediaRepository` maps results;
   - `MediaService`/`BaseService` perform HTTP;
   - Provider/`notifyListeners` connect state to UI;
3. trace `HomeScreen` submission -> `MediaViewModel.fetchMediaData` ->
   `MediaRepository.fetchMediaList` -> service -> `ApiResponse` -> rebuilt UI;
4. capture loading and error behavior before feature changes;
5. make only the compatibility changes required to run on the installed Android
   toolchain.

### 14.3 Deferred audio decision

`PlayerWidget` genuinely uses `audioplayers` for preview playback. The delegated
agent must not assume removal or modernization. After reproducing compatibility
work, present the user with:

- retain and update playback, with estimated file/API changes; or
- remove playback as an explicitly approved scope change, with UI and grading
  consequences.

Wait for the user's decision before applying that branch of work.

### 14.4 Task 5.3 - ViewModel-owned search

- Keep raw fetched media immutable in `MediaViewModel`.
- Add query and derived visible results to the ViewModel.
- Debounce input approximately 300-500 ms inside the ViewModel.
- Filter case-insensitively without mutating the original list.
- Clearing query restores all media.
- Dispose the timer with the ViewModel.
- Update `HomeScreen`/list widget to render ViewModel-visible results.
- Add focused ViewModel tests for debounce, case-insensitivity, immutability,
  and clearing.

### 14.5 Task 5.4 - Refresh and error recovery

- Add pull-to-refresh or an explicit refresh action.
- Preserve current visible data while refreshing.
- Expose refresh-in-progress separately from initial loading.
- On refresh failure, keep valid current data and show retryable error feedback.
- On success, replace source data and recompute the filtered view with the
  current query.
- Add ViewModel or widget tests for success and failure recovery.

### 14.6 Correct evidence and checkpoint

Relabel the working exam-document cells as:

- Search UI and changed files;
- Refresh/error-recovery UI;
- Search ViewModel test output;
- Refresh success/failure test output.

Run PART 5 analysis, tests, and Android app verification within
`part5_flutter_mvvm/`. Update exact-source architecture answers and screenshots,
then:

- commit `part-5: extend legacy mvvm search and recovery`;
- tag `part-5-complete`;
- report compatibility changes, audio decision, exact source trace, test
  results, commit hash, and tag.

## 15. Final acceptance checklist

The overall work is complete only when:

- all required screens and states are demonstrable on Android;
- widgets contain no direct HTTP or Drift access;
- Deposit Policy, category inference, and clock are centralized and replaceable;
- POST uses the exact nested payload and success uses the returned response;
- Source Order survives search/sort reset;
- Compare List enforces and persists exactly zero to two IDs;
- cache, draft, Pending, and Unknown Outcome states survive restart as designed;
- root static analysis passes;
- root tests pass after PART 4;
- delegated PART 5 analysis and tests pass;
- each PART commit and tag identifies a verified repository state;
- exam-document evidence corresponds to the tagged code;
- the final ZIP excludes build output, `.dart_tool`, `.git`, IDE caches, and
  other generated clutter and has been opened once for verification.

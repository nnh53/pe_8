# Use Drift over SQLite for local persistence

The app needs structured, durable storage for comparison selections, catalogue
snapshots, loan drafts, and submission state. Use Drift over SQLite instead of
key-value storage so these records have explicit schemas, transactions, query
interfaces, and migrations while repositories keep database details out of the
domain and presentation layers.

## Consequences

PART 2 introduces the initial database for persisted comparison selections.
PART 3 increments the schema for catalogue, draft, and submission records and
must include a verified migration. Android is the only supported runtime for
this exercise.


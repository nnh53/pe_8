# Campus Equipment Loan

This context describes the language used to browse campus devices and create,
store, and retry equipment-loan requests.

## Language

**Device**:
A piece of campus equipment that a student can inspect and request to borrow.
_Avoid_: Product, item, object

**Device Catalogue**:
The ordered collection of devices currently available for browsing.
_Avoid_: Inventory, product list

**Source Order**:
The order in which devices appear in the remote catalogue before any derived
search or sorting is applied.
_Avoid_: Default sort, natural order

**Device Snapshot**:
The device facts captured when a loan request is prepared so the request keeps
its original meaning even if the catalogue later changes.
_Avoid_: Cached device, device copy

**Deposit Policy**:
The replaceable business rule that derives the refundable deposit from a
device's estimated value.
_Avoid_: Deposit calculation, price rule

**Loan Period**:
The inclusive choice of a borrow date and an exclusive later return date that
defines how many calendar days a device is requested.
_Avoid_: Date range, duration

**Loan Draft**:
An incomplete or unsubmitted loan request that belongs to the form and may be
edited or restored.
_Avoid_: Pending request, saved request

**Loan Request**:
A student's finalized intent to borrow a specific device for a valid loan
period and stated purpose.
_Avoid_: Order, booking

**Pending Loan Request**:
A finalized loan request stored locally because it has not yet been confirmed
as remotely created.
_Avoid_: Draft, failed request, remote request

**Unknown Outcome**:
A submission whose remote creation cannot be confirmed or disproved because
communication ended after submission began.
_Avoid_: Failed request, pending request

**Remote Loan Request**:
A loan request whose creation is confirmed by the remote system and identified
by the returned remote identifier and creation time.
_Avoid_: Pending request, local request

**Compare List**:
The student's ordered selection of no more than two devices for side-by-side
comparison.
_Avoid_: Watchlist, saved list, favourites


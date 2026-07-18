/// The outcome of attempting to add a device to the compare list.
enum CompareAddResult {
  /// The device was added to the selection.
  added,

  /// The device was already part of the selection.
  alreadySelected,

  /// The selection already holds the maximum of two devices.
  limitReached,
}

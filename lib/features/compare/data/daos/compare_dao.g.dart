// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_dao.dart';

// ignore_for_file: type=lint
mixin _$CompareDaoMixin on DatabaseAccessor<AppDatabase> {
  $CompareSelectionsTable get compareSelections =>
      attachedDatabase.compareSelections;
  CompareDaoManager get managers => CompareDaoManager(this);
}

class CompareDaoManager {
  final _$CompareDaoMixin _db;
  CompareDaoManager(this._db);
  $$CompareSelectionsTableTableManager get compareSelections =>
      $$CompareSelectionsTableTableManager(
        _db.attachedDatabase,
        _db.compareSelections,
      );
}

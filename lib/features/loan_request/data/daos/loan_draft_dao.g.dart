// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_draft_dao.dart';

// ignore_for_file: type=lint
mixin _$LoanDraftDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoanDraftsTable get loanDrafts => attachedDatabase.loanDrafts;
  LoanDraftDaoManager get managers => LoanDraftDaoManager(this);
}

class LoanDraftDaoManager {
  final _$LoanDraftDaoMixin _db;
  LoanDraftDaoManager(this._db);
  $$LoanDraftsTableTableManager get loanDrafts =>
      $$LoanDraftsTableTableManager(_db.attachedDatabase, _db.loanDrafts);
}

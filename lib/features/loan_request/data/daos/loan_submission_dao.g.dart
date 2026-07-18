// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_submission_dao.dart';

// ignore_for_file: type=lint
mixin _$LoanSubmissionDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoanSubmissionsTable get loanSubmissions => attachedDatabase.loanSubmissions;
  LoanSubmissionDaoManager get managers => LoanSubmissionDaoManager(this);
}

class LoanSubmissionDaoManager {
  final _$LoanSubmissionDaoMixin _db;
  LoanSubmissionDaoManager(this._db);
  $$LoanSubmissionsTableTableManager get loanSubmissions =>
      $$LoanSubmissionsTableTableManager(
        _db.attachedDatabase,
        _db.loanSubmissions,
      );
}

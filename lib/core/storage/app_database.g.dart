// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CompareSelectionsTable extends CompareSelections
    with TableInfo<$CompareSelectionsTable, CompareSelection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompareSelectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedAtMeta = const VerificationMeta(
    'selectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> selectedAt = GeneratedColumn<DateTime>(
    'selected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, position, selectedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compare_selections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompareSelection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('selected_at')) {
      context.handle(
        _selectedAtMeta,
        selectedAt.isAcceptableOrUnknown(data['selected_at']!, _selectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_selectedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  CompareSelection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompareSelection(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      selectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}selected_at'],
      )!,
    );
  }

  @override
  $CompareSelectionsTable createAlias(String alias) {
    return $CompareSelectionsTable(attachedDatabase, alias);
  }
}

class CompareSelection extends DataClass
    implements Insertable<CompareSelection> {
  /// The selected device identifier.
  final String deviceId;

  /// The zero-based ordered position, constrained to 0 or 1 by the domain.
  final int position;

  /// When the selection was stored.
  final DateTime selectedAt;
  const CompareSelection({
    required this.deviceId,
    required this.position,
    required this.selectedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['position'] = Variable<int>(position);
    map['selected_at'] = Variable<DateTime>(selectedAt);
    return map;
  }

  CompareSelectionsCompanion toCompanion(bool nullToAbsent) {
    return CompareSelectionsCompanion(
      deviceId: Value(deviceId),
      position: Value(position),
      selectedAt: Value(selectedAt),
    );
  }

  factory CompareSelection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompareSelection(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      position: serializer.fromJson<int>(json['position']),
      selectedAt: serializer.fromJson<DateTime>(json['selectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'position': serializer.toJson<int>(position),
      'selectedAt': serializer.toJson<DateTime>(selectedAt),
    };
  }

  CompareSelection copyWith({
    String? deviceId,
    int? position,
    DateTime? selectedAt,
  }) => CompareSelection(
    deviceId: deviceId ?? this.deviceId,
    position: position ?? this.position,
    selectedAt: selectedAt ?? this.selectedAt,
  );
  CompareSelection copyWithCompanion(CompareSelectionsCompanion data) {
    return CompareSelection(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      position: data.position.present ? data.position.value : this.position,
      selectedAt: data.selectedAt.present
          ? data.selectedAt.value
          : this.selectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompareSelection(')
          ..write('deviceId: $deviceId, ')
          ..write('position: $position, ')
          ..write('selectedAt: $selectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, position, selectedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompareSelection &&
          other.deviceId == this.deviceId &&
          other.position == this.position &&
          other.selectedAt == this.selectedAt);
}

class CompareSelectionsCompanion extends UpdateCompanion<CompareSelection> {
  final Value<String> deviceId;
  final Value<int> position;
  final Value<DateTime> selectedAt;
  final Value<int> rowid;
  const CompareSelectionsCompanion({
    this.deviceId = const Value.absent(),
    this.position = const Value.absent(),
    this.selectedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompareSelectionsCompanion.insert({
    required String deviceId,
    required int position,
    required DateTime selectedAt,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       position = Value(position),
       selectedAt = Value(selectedAt);
  static Insertable<CompareSelection> custom({
    Expression<String>? deviceId,
    Expression<int>? position,
    Expression<DateTime>? selectedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (position != null) 'position': position,
      if (selectedAt != null) 'selected_at': selectedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompareSelectionsCompanion copyWith({
    Value<String>? deviceId,
    Value<int>? position,
    Value<DateTime>? selectedAt,
    Value<int>? rowid,
  }) {
    return CompareSelectionsCompanion(
      deviceId: deviceId ?? this.deviceId,
      position: position ?? this.position,
      selectedAt: selectedAt ?? this.selectedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (selectedAt.present) {
      map['selected_at'] = Variable<DateTime>(selectedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompareSelectionsCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('position: $position, ')
          ..write('selectedAt: $selectedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompareSelectionsTable compareSelections =
      $CompareSelectionsTable(this);
  late final CompareDao compareDao = CompareDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [compareSelections];
}

typedef $$CompareSelectionsTableCreateCompanionBuilder =
    CompareSelectionsCompanion Function({
      required String deviceId,
      required int position,
      required DateTime selectedAt,
      Value<int> rowid,
    });
typedef $$CompareSelectionsTableUpdateCompanionBuilder =
    CompareSelectionsCompanion Function({
      Value<String> deviceId,
      Value<int> position,
      Value<DateTime> selectedAt,
      Value<int> rowid,
    });

class $$CompareSelectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompareSelectionsTable> {
  $$CompareSelectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get selectedAt => $composableBuilder(
    column: $table.selectedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompareSelectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompareSelectionsTable> {
  $$CompareSelectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get selectedAt => $composableBuilder(
    column: $table.selectedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompareSelectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompareSelectionsTable> {
  $$CompareSelectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get selectedAt => $composableBuilder(
    column: $table.selectedAt,
    builder: (column) => column,
  );
}

class $$CompareSelectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompareSelectionsTable,
          CompareSelection,
          $$CompareSelectionsTableFilterComposer,
          $$CompareSelectionsTableOrderingComposer,
          $$CompareSelectionsTableAnnotationComposer,
          $$CompareSelectionsTableCreateCompanionBuilder,
          $$CompareSelectionsTableUpdateCompanionBuilder,
          (
            CompareSelection,
            BaseReferences<
              _$AppDatabase,
              $CompareSelectionsTable,
              CompareSelection
            >,
          ),
          CompareSelection,
          PrefetchHooks Function()
        > {
  $$CompareSelectionsTableTableManager(
    _$AppDatabase db,
    $CompareSelectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompareSelectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompareSelectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompareSelectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> selectedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompareSelectionsCompanion(
                deviceId: deviceId,
                position: position,
                selectedAt: selectedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required int position,
                required DateTime selectedAt,
                Value<int> rowid = const Value.absent(),
              }) => CompareSelectionsCompanion.insert(
                deviceId: deviceId,
                position: position,
                selectedAt: selectedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompareSelectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompareSelectionsTable,
      CompareSelection,
      $$CompareSelectionsTableFilterComposer,
      $$CompareSelectionsTableOrderingComposer,
      $$CompareSelectionsTableAnnotationComposer,
      $$CompareSelectionsTableCreateCompanionBuilder,
      $$CompareSelectionsTableUpdateCompanionBuilder,
      (
        CompareSelection,
        BaseReferences<
          _$AppDatabase,
          $CompareSelectionsTable,
          CompareSelection
        >,
      ),
      CompareSelection,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompareSelectionsTableTableManager get compareSelections =>
      $$CompareSelectionsTableTableManager(_db, _db.compareSelections);
}

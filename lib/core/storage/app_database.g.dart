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

class $CachedDevicesTable extends CachedDevices
    with TableInfo<$CachedDevicesTable, CachedDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedDevicesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawDataJsonMeta = const VerificationMeta(
    'rawDataJson',
  );
  @override
  late final GeneratedColumn<String> rawDataJson = GeneratedColumn<String>(
    'raw_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedValueMinorMeta =
      const VerificationMeta('estimatedValueMinor');
  @override
  late final GeneratedColumn<int> estimatedValueMinor = GeneratedColumn<int>(
    'estimated_value_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIndexMeta = const VerificationMeta(
    'sourceIndex',
  );
  @override
  late final GeneratedColumn<int> sourceIndex = GeneratedColumn<int>(
    'source_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    name,
    rawDataJson,
    estimatedValueMinor,
    year,
    category,
    sourceIndex,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedDevice> instance, {
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('raw_data_json')) {
      context.handle(
        _rawDataJsonMeta,
        rawDataJson.isAcceptableOrUnknown(
          data['raw_data_json']!,
          _rawDataJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawDataJsonMeta);
    }
    if (data.containsKey('estimated_value_minor')) {
      context.handle(
        _estimatedValueMinorMeta,
        estimatedValueMinor.isAcceptableOrUnknown(
          data['estimated_value_minor']!,
          _estimatedValueMinorMeta,
        ),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('source_index')) {
      context.handle(
        _sourceIndexMeta,
        sourceIndex.isAcceptableOrUnknown(
          data['source_index']!,
          _sourceIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceIndexMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  CachedDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedDevice(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      rawDataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_data_json'],
      )!,
      estimatedValueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_value_minor'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      sourceIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_index'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedDevicesTable createAlias(String alias) {
    return $CachedDevicesTable(attachedDatabase, alias);
  }
}

class CachedDevice extends DataClass implements Insertable<CachedDevice> {
  /// The remote device identifier.
  final String deviceId;

  /// The display name.
  final String name;

  /// The complete raw attribute map encoded as JSON.
  final String rawDataJson;

  /// The estimated value in whole cents, when available.
  final int? estimatedValueMinor;

  /// The model or release year, when available.
  final int? year;

  /// The inferred category stored by its enum name.
  final String category;

  /// The original zero-based remote position.
  final int sourceIndex;

  /// When this row was cached.
  final DateTime cachedAt;
  const CachedDevice({
    required this.deviceId,
    required this.name,
    required this.rawDataJson,
    this.estimatedValueMinor,
    this.year,
    required this.category,
    required this.sourceIndex,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    map['raw_data_json'] = Variable<String>(rawDataJson);
    if (!nullToAbsent || estimatedValueMinor != null) {
      map['estimated_value_minor'] = Variable<int>(estimatedValueMinor);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['category'] = Variable<String>(category);
    map['source_index'] = Variable<int>(sourceIndex);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedDevicesCompanion toCompanion(bool nullToAbsent) {
    return CachedDevicesCompanion(
      deviceId: Value(deviceId),
      name: Value(name),
      rawDataJson: Value(rawDataJson),
      estimatedValueMinor: estimatedValueMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedValueMinor),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      category: Value(category),
      sourceIndex: Value(sourceIndex),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedDevice(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      rawDataJson: serializer.fromJson<String>(json['rawDataJson']),
      estimatedValueMinor: serializer.fromJson<int?>(
        json['estimatedValueMinor'],
      ),
      year: serializer.fromJson<int?>(json['year']),
      category: serializer.fromJson<String>(json['category']),
      sourceIndex: serializer.fromJson<int>(json['sourceIndex']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'rawDataJson': serializer.toJson<String>(rawDataJson),
      'estimatedValueMinor': serializer.toJson<int?>(estimatedValueMinor),
      'year': serializer.toJson<int?>(year),
      'category': serializer.toJson<String>(category),
      'sourceIndex': serializer.toJson<int>(sourceIndex),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedDevice copyWith({
    String? deviceId,
    String? name,
    String? rawDataJson,
    Value<int?> estimatedValueMinor = const Value.absent(),
    Value<int?> year = const Value.absent(),
    String? category,
    int? sourceIndex,
    DateTime? cachedAt,
  }) => CachedDevice(
    deviceId: deviceId ?? this.deviceId,
    name: name ?? this.name,
    rawDataJson: rawDataJson ?? this.rawDataJson,
    estimatedValueMinor: estimatedValueMinor.present
        ? estimatedValueMinor.value
        : this.estimatedValueMinor,
    year: year.present ? year.value : this.year,
    category: category ?? this.category,
    sourceIndex: sourceIndex ?? this.sourceIndex,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedDevice copyWithCompanion(CachedDevicesCompanion data) {
    return CachedDevice(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      rawDataJson: data.rawDataJson.present
          ? data.rawDataJson.value
          : this.rawDataJson,
      estimatedValueMinor: data.estimatedValueMinor.present
          ? data.estimatedValueMinor.value
          : this.estimatedValueMinor,
      year: data.year.present ? data.year.value : this.year,
      category: data.category.present ? data.category.value : this.category,
      sourceIndex: data.sourceIndex.present
          ? data.sourceIndex.value
          : this.sourceIndex,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedDevice(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('rawDataJson: $rawDataJson, ')
          ..write('estimatedValueMinor: $estimatedValueMinor, ')
          ..write('year: $year, ')
          ..write('category: $category, ')
          ..write('sourceIndex: $sourceIndex, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    deviceId,
    name,
    rawDataJson,
    estimatedValueMinor,
    year,
    category,
    sourceIndex,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedDevice &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.rawDataJson == this.rawDataJson &&
          other.estimatedValueMinor == this.estimatedValueMinor &&
          other.year == this.year &&
          other.category == this.category &&
          other.sourceIndex == this.sourceIndex &&
          other.cachedAt == this.cachedAt);
}

class CachedDevicesCompanion extends UpdateCompanion<CachedDevice> {
  final Value<String> deviceId;
  final Value<String> name;
  final Value<String> rawDataJson;
  final Value<int?> estimatedValueMinor;
  final Value<int?> year;
  final Value<String> category;
  final Value<int> sourceIndex;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedDevicesCompanion({
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.rawDataJson = const Value.absent(),
    this.estimatedValueMinor = const Value.absent(),
    this.year = const Value.absent(),
    this.category = const Value.absent(),
    this.sourceIndex = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedDevicesCompanion.insert({
    required String deviceId,
    required String name,
    required String rawDataJson,
    this.estimatedValueMinor = const Value.absent(),
    this.year = const Value.absent(),
    required String category,
    required int sourceIndex,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       name = Value(name),
       rawDataJson = Value(rawDataJson),
       category = Value(category),
       sourceIndex = Value(sourceIndex),
       cachedAt = Value(cachedAt);
  static Insertable<CachedDevice> custom({
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? rawDataJson,
    Expression<int>? estimatedValueMinor,
    Expression<int>? year,
    Expression<String>? category,
    Expression<int>? sourceIndex,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (rawDataJson != null) 'raw_data_json': rawDataJson,
      if (estimatedValueMinor != null)
        'estimated_value_minor': estimatedValueMinor,
      if (year != null) 'year': year,
      if (category != null) 'category': category,
      if (sourceIndex != null) 'source_index': sourceIndex,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedDevicesCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? name,
    Value<String>? rawDataJson,
    Value<int?>? estimatedValueMinor,
    Value<int?>? year,
    Value<String>? category,
    Value<int>? sourceIndex,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedDevicesCompanion(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      rawDataJson: rawDataJson ?? this.rawDataJson,
      estimatedValueMinor: estimatedValueMinor ?? this.estimatedValueMinor,
      year: year ?? this.year,
      category: category ?? this.category,
      sourceIndex: sourceIndex ?? this.sourceIndex,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rawDataJson.present) {
      map['raw_data_json'] = Variable<String>(rawDataJson.value);
    }
    if (estimatedValueMinor.present) {
      map['estimated_value_minor'] = Variable<int>(estimatedValueMinor.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sourceIndex.present) {
      map['source_index'] = Variable<int>(sourceIndex.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedDevicesCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('rawDataJson: $rawDataJson, ')
          ..write('estimatedValueMinor: $estimatedValueMinor, ')
          ..write('year: $year, ')
          ..write('category: $category, ')
          ..write('sourceIndex: $sourceIndex, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CatalogueMetadataTable extends CatalogueMetadata
    with TableInfo<$CatalogueMetadataTable, CatalogueMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogueMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSuccessfulRefreshAtMeta =
      const VerificationMeta('lastSuccessfulRefreshAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulRefreshAt =
      GeneratedColumn<DateTime>(
        'last_successful_refresh_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recordCountMeta = const VerificationMeta(
    'recordCount',
  );
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
    'record_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSuccessfulRefreshAt,
    recordCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalogue_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogueMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_successful_refresh_at')) {
      context.handle(
        _lastSuccessfulRefreshAtMeta,
        lastSuccessfulRefreshAt.isAcceptableOrUnknown(
          data['last_successful_refresh_at']!,
          _lastSuccessfulRefreshAtMeta,
        ),
      );
    }
    if (data.containsKey('record_count')) {
      context.handle(
        _recordCountMeta,
        recordCount.isAcceptableOrUnknown(
          data['record_count']!,
          _recordCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogueMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogueMetadataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSuccessfulRefreshAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_refresh_at'],
      ),
      recordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_count'],
      )!,
    );
  }

  @override
  $CatalogueMetadataTable createAlias(String alias) {
    return $CatalogueMetadataTable(attachedDatabase, alias);
  }
}

class CatalogueMetadataData extends DataClass
    implements Insertable<CatalogueMetadataData> {
  /// The fixed singleton key (always 0).
  final int id;

  /// The timestamp of the last successful remote refresh.
  final DateTime? lastSuccessfulRefreshAt;

  /// The number of cached device records.
  final int recordCount;
  const CatalogueMetadataData({
    required this.id,
    this.lastSuccessfulRefreshAt,
    required this.recordCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSuccessfulRefreshAt != null) {
      map['last_successful_refresh_at'] = Variable<DateTime>(
        lastSuccessfulRefreshAt,
      );
    }
    map['record_count'] = Variable<int>(recordCount);
    return map;
  }

  CatalogueMetadataCompanion toCompanion(bool nullToAbsent) {
    return CatalogueMetadataCompanion(
      id: Value(id),
      lastSuccessfulRefreshAt: lastSuccessfulRefreshAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulRefreshAt),
      recordCount: Value(recordCount),
    );
  }

  factory CatalogueMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogueMetadataData(
      id: serializer.fromJson<int>(json['id']),
      lastSuccessfulRefreshAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulRefreshAt'],
      ),
      recordCount: serializer.fromJson<int>(json['recordCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSuccessfulRefreshAt': serializer.toJson<DateTime?>(
        lastSuccessfulRefreshAt,
      ),
      'recordCount': serializer.toJson<int>(recordCount),
    };
  }

  CatalogueMetadataData copyWith({
    int? id,
    Value<DateTime?> lastSuccessfulRefreshAt = const Value.absent(),
    int? recordCount,
  }) => CatalogueMetadataData(
    id: id ?? this.id,
    lastSuccessfulRefreshAt: lastSuccessfulRefreshAt.present
        ? lastSuccessfulRefreshAt.value
        : this.lastSuccessfulRefreshAt,
    recordCount: recordCount ?? this.recordCount,
  );
  CatalogueMetadataData copyWithCompanion(CatalogueMetadataCompanion data) {
    return CatalogueMetadataData(
      id: data.id.present ? data.id.value : this.id,
      lastSuccessfulRefreshAt: data.lastSuccessfulRefreshAt.present
          ? data.lastSuccessfulRefreshAt.value
          : this.lastSuccessfulRefreshAt,
      recordCount: data.recordCount.present
          ? data.recordCount.value
          : this.recordCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogueMetadataData(')
          ..write('id: $id, ')
          ..write('lastSuccessfulRefreshAt: $lastSuccessfulRefreshAt, ')
          ..write('recordCount: $recordCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastSuccessfulRefreshAt, recordCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogueMetadataData &&
          other.id == this.id &&
          other.lastSuccessfulRefreshAt == this.lastSuccessfulRefreshAt &&
          other.recordCount == this.recordCount);
}

class CatalogueMetadataCompanion
    extends UpdateCompanion<CatalogueMetadataData> {
  final Value<int> id;
  final Value<DateTime?> lastSuccessfulRefreshAt;
  final Value<int> recordCount;
  const CatalogueMetadataCompanion({
    this.id = const Value.absent(),
    this.lastSuccessfulRefreshAt = const Value.absent(),
    this.recordCount = const Value.absent(),
  });
  CatalogueMetadataCompanion.insert({
    this.id = const Value.absent(),
    this.lastSuccessfulRefreshAt = const Value.absent(),
    this.recordCount = const Value.absent(),
  });
  static Insertable<CatalogueMetadataData> custom({
    Expression<int>? id,
    Expression<DateTime>? lastSuccessfulRefreshAt,
    Expression<int>? recordCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSuccessfulRefreshAt != null)
        'last_successful_refresh_at': lastSuccessfulRefreshAt,
      if (recordCount != null) 'record_count': recordCount,
    });
  }

  CatalogueMetadataCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? lastSuccessfulRefreshAt,
    Value<int>? recordCount,
  }) {
    return CatalogueMetadataCompanion(
      id: id ?? this.id,
      lastSuccessfulRefreshAt:
          lastSuccessfulRefreshAt ?? this.lastSuccessfulRefreshAt,
      recordCount: recordCount ?? this.recordCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSuccessfulRefreshAt.present) {
      map['last_successful_refresh_at'] = Variable<DateTime>(
        lastSuccessfulRefreshAt.value,
      );
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogueMetadataCompanion(')
          ..write('id: $id, ')
          ..write('lastSuccessfulRefreshAt: $lastSuccessfulRefreshAt, ')
          ..write('recordCount: $recordCount')
          ..write(')'))
        .toString();
  }
}

class $LoanDraftsTable extends LoanDrafts
    with TableInfo<$LoanDraftsTable, LoanDraftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
  static const VerificationMeta _deviceSnapshotJsonMeta =
      const VerificationMeta('deviceSnapshotJson');
  @override
  late final GeneratedColumn<String> deviceSnapshotJson =
      GeneratedColumn<String>(
        'device_snapshot_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _borrowDateMeta = const VerificationMeta(
    'borrowDate',
  );
  @override
  late final GeneratedColumn<String> borrowDate = GeneratedColumn<String>(
    'borrow_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _returnDateMeta = const VerificationMeta(
    'returnDate',
  );
  @override
  late final GeneratedColumn<String> returnDate = GeneratedColumn<String>(
    'return_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _depositMeta = const VerificationMeta(
    'deposit',
  );
  @override
  late final GeneratedColumn<int> deposit = GeneratedColumn<int>(
    'deposit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    deviceSnapshotJson,
    studentId,
    borrowDate,
    returnDate,
    purpose,
    deposit,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanDraftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_snapshot_json')) {
      context.handle(
        _deviceSnapshotJsonMeta,
        deviceSnapshotJson.isAcceptableOrUnknown(
          data['device_snapshot_json']!,
          _deviceSnapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceSnapshotJsonMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    }
    if (data.containsKey('borrow_date')) {
      context.handle(
        _borrowDateMeta,
        borrowDate.isAcceptableOrUnknown(data['borrow_date']!, _borrowDateMeta),
      );
    }
    if (data.containsKey('return_date')) {
      context.handle(
        _returnDateMeta,
        returnDate.isAcceptableOrUnknown(data['return_date']!, _returnDateMeta),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('deposit')) {
      context.handle(
        _depositMeta,
        deposit.isAcceptableOrUnknown(data['deposit']!, _depositMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanDraftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanDraftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      deviceSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_snapshot_json'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      borrowDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}borrow_date'],
      ),
      returnDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}return_date'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      deposit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deposit'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LoanDraftsTable createAlias(String alias) {
    return $LoanDraftsTable(attachedDatabase, alias);
  }
}

class LoanDraftRow extends DataClass implements Insertable<LoanDraftRow> {
  /// The fixed singleton key (always 0).
  final int id;

  /// The selected device identifier.
  final String deviceId;

  /// The serialized device snapshot for safe restoration.
  final String deviceSnapshotJson;

  /// The entered student identifier.
  final String studentId;

  /// The chosen borrow date as an ISO date string, when set.
  final String? borrowDate;

  /// The chosen return date as an ISO date string, when set.
  final String? returnDate;

  /// The entered purpose.
  final String purpose;

  /// The derived deposit for the selected device.
  final int deposit;

  /// When the draft was last updated.
  final DateTime updatedAt;
  const LoanDraftRow({
    required this.id,
    required this.deviceId,
    required this.deviceSnapshotJson,
    required this.studentId,
    this.borrowDate,
    this.returnDate,
    required this.purpose,
    required this.deposit,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['device_snapshot_json'] = Variable<String>(deviceSnapshotJson);
    map['student_id'] = Variable<String>(studentId);
    if (!nullToAbsent || borrowDate != null) {
      map['borrow_date'] = Variable<String>(borrowDate);
    }
    if (!nullToAbsent || returnDate != null) {
      map['return_date'] = Variable<String>(returnDate);
    }
    map['purpose'] = Variable<String>(purpose);
    map['deposit'] = Variable<int>(deposit);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LoanDraftsCompanion toCompanion(bool nullToAbsent) {
    return LoanDraftsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      deviceSnapshotJson: Value(deviceSnapshotJson),
      studentId: Value(studentId),
      borrowDate: borrowDate == null && nullToAbsent
          ? const Value.absent()
          : Value(borrowDate),
      returnDate: returnDate == null && nullToAbsent
          ? const Value.absent()
          : Value(returnDate),
      purpose: Value(purpose),
      deposit: Value(deposit),
      updatedAt: Value(updatedAt),
    );
  }

  factory LoanDraftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanDraftRow(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceSnapshotJson: serializer.fromJson<String>(
        json['deviceSnapshotJson'],
      ),
      studentId: serializer.fromJson<String>(json['studentId']),
      borrowDate: serializer.fromJson<String?>(json['borrowDate']),
      returnDate: serializer.fromJson<String?>(json['returnDate']),
      purpose: serializer.fromJson<String>(json['purpose']),
      deposit: serializer.fromJson<int>(json['deposit']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceSnapshotJson': serializer.toJson<String>(deviceSnapshotJson),
      'studentId': serializer.toJson<String>(studentId),
      'borrowDate': serializer.toJson<String?>(borrowDate),
      'returnDate': serializer.toJson<String?>(returnDate),
      'purpose': serializer.toJson<String>(purpose),
      'deposit': serializer.toJson<int>(deposit),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LoanDraftRow copyWith({
    int? id,
    String? deviceId,
    String? deviceSnapshotJson,
    String? studentId,
    Value<String?> borrowDate = const Value.absent(),
    Value<String?> returnDate = const Value.absent(),
    String? purpose,
    int? deposit,
    DateTime? updatedAt,
  }) => LoanDraftRow(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    deviceSnapshotJson: deviceSnapshotJson ?? this.deviceSnapshotJson,
    studentId: studentId ?? this.studentId,
    borrowDate: borrowDate.present ? borrowDate.value : this.borrowDate,
    returnDate: returnDate.present ? returnDate.value : this.returnDate,
    purpose: purpose ?? this.purpose,
    deposit: deposit ?? this.deposit,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LoanDraftRow copyWithCompanion(LoanDraftsCompanion data) {
    return LoanDraftRow(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      deviceSnapshotJson: data.deviceSnapshotJson.present
          ? data.deviceSnapshotJson.value
          : this.deviceSnapshotJson,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      borrowDate: data.borrowDate.present
          ? data.borrowDate.value
          : this.borrowDate,
      returnDate: data.returnDate.present
          ? data.returnDate.value
          : this.returnDate,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      deposit: data.deposit.present ? data.deposit.value : this.deposit,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanDraftRow(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceSnapshotJson: $deviceSnapshotJson, ')
          ..write('studentId: $studentId, ')
          ..write('borrowDate: $borrowDate, ')
          ..write('returnDate: $returnDate, ')
          ..write('purpose: $purpose, ')
          ..write('deposit: $deposit, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    deviceSnapshotJson,
    studentId,
    borrowDate,
    returnDate,
    purpose,
    deposit,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanDraftRow &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.deviceSnapshotJson == this.deviceSnapshotJson &&
          other.studentId == this.studentId &&
          other.borrowDate == this.borrowDate &&
          other.returnDate == this.returnDate &&
          other.purpose == this.purpose &&
          other.deposit == this.deposit &&
          other.updatedAt == this.updatedAt);
}

class LoanDraftsCompanion extends UpdateCompanion<LoanDraftRow> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> deviceSnapshotJson;
  final Value<String> studentId;
  final Value<String?> borrowDate;
  final Value<String?> returnDate;
  final Value<String> purpose;
  final Value<int> deposit;
  final Value<DateTime> updatedAt;
  const LoanDraftsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceSnapshotJson = const Value.absent(),
    this.studentId = const Value.absent(),
    this.borrowDate = const Value.absent(),
    this.returnDate = const Value.absent(),
    this.purpose = const Value.absent(),
    this.deposit = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LoanDraftsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String deviceSnapshotJson,
    this.studentId = const Value.absent(),
    this.borrowDate = const Value.absent(),
    this.returnDate = const Value.absent(),
    this.purpose = const Value.absent(),
    this.deposit = const Value.absent(),
    required DateTime updatedAt,
  }) : deviceId = Value(deviceId),
       deviceSnapshotJson = Value(deviceSnapshotJson),
       updatedAt = Value(updatedAt);
  static Insertable<LoanDraftRow> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? deviceSnapshotJson,
    Expression<String>? studentId,
    Expression<String>? borrowDate,
    Expression<String>? returnDate,
    Expression<String>? purpose,
    Expression<int>? deposit,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceSnapshotJson != null)
        'device_snapshot_json': deviceSnapshotJson,
      if (studentId != null) 'student_id': studentId,
      if (borrowDate != null) 'borrow_date': borrowDate,
      if (returnDate != null) 'return_date': returnDate,
      if (purpose != null) 'purpose': purpose,
      if (deposit != null) 'deposit': deposit,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LoanDraftsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String>? deviceSnapshotJson,
    Value<String>? studentId,
    Value<String?>? borrowDate,
    Value<String?>? returnDate,
    Value<String>? purpose,
    Value<int>? deposit,
    Value<DateTime>? updatedAt,
  }) {
    return LoanDraftsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      deviceSnapshotJson: deviceSnapshotJson ?? this.deviceSnapshotJson,
      studentId: studentId ?? this.studentId,
      borrowDate: borrowDate ?? this.borrowDate,
      returnDate: returnDate ?? this.returnDate,
      purpose: purpose ?? this.purpose,
      deposit: deposit ?? this.deposit,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceSnapshotJson.present) {
      map['device_snapshot_json'] = Variable<String>(deviceSnapshotJson.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (borrowDate.present) {
      map['borrow_date'] = Variable<String>(borrowDate.value);
    }
    if (returnDate.present) {
      map['return_date'] = Variable<String>(returnDate.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (deposit.present) {
      map['deposit'] = Variable<int>(deposit.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanDraftsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceSnapshotJson: $deviceSnapshotJson, ')
          ..write('studentId: $studentId, ')
          ..write('borrowDate: $borrowDate, ')
          ..write('returnDate: $returnDate, ')
          ..write('purpose: $purpose, ')
          ..write('deposit: $deposit, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LoanSubmissionsTable extends LoanSubmissions
    with TableInfo<$LoanSubmissionsTable, LoanSubmissionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanSubmissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceSnapshotJsonMeta =
      const VerificationMeta('deviceSnapshotJson');
  @override
  late final GeneratedColumn<String> deviceSnapshotJson =
      GeneratedColumn<String>(
        'device_snapshot_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteCreatedAtMeta = const VerificationMeta(
    'remoteCreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> remoteCreatedAt =
      GeneratedColumn<DateTime>(
        'remote_created_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _remoteResponseJsonMeta =
      const VerificationMeta('remoteResponseJson');
  @override
  late final GeneratedColumn<String> remoteResponseJson =
      GeneratedColumn<String>(
        'remote_response_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    idempotencyKey,
    payloadJson,
    deviceSnapshotJson,
    state,
    attemptCount,
    createdAt,
    lastAttemptAt,
    completedAt,
    remoteId,
    remoteCreatedAt,
    remoteResponseJson,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_submissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoanSubmissionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('device_snapshot_json')) {
      context.handle(
        _deviceSnapshotJsonMeta,
        deviceSnapshotJson.isAcceptableOrUnknown(
          data['device_snapshot_json']!,
          _deviceSnapshotJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceSnapshotJsonMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('remote_created_at')) {
      context.handle(
        _remoteCreatedAtMeta,
        remoteCreatedAt.isAcceptableOrUnknown(
          data['remote_created_at']!,
          _remoteCreatedAtMeta,
        ),
      );
    }
    if (data.containsKey('remote_response_json')) {
      context.handle(
        _remoteResponseJsonMeta,
        remoteResponseJson.isAcceptableOrUnknown(
          data['remote_response_json']!,
          _remoteResponseJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  LoanSubmissionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanSubmissionRow(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      deviceSnapshotJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_snapshot_json'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      remoteCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remote_created_at'],
      ),
      remoteResponseJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_response_json'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $LoanSubmissionsTable createAlias(String alias) {
    return $LoanSubmissionsTable(attachedDatabase, alias);
  }
}

class LoanSubmissionRow extends DataClass
    implements Insertable<LoanSubmissionRow> {
  /// The stable local identifier.
  final String localId;

  /// The stable local idempotency key for retries.
  final String idempotencyKey;

  /// The immutable remote payload encoded as JSON.
  final String payloadJson;

  /// The serialized device snapshot for offline display.
  final String deviceSnapshotJson;

  /// The exhaustive submission state stored by its enum name.
  final String state;

  /// How many POST attempts have been made.
  final int attemptCount;

  /// When the submission was first created.
  final DateTime createdAt;

  /// When the last POST attempt started.
  final DateTime? lastAttemptAt;

  /// When the submission reached a terminal success.
  final DateTime? completedAt;

  /// The remote identifier once creation is confirmed.
  final String? remoteId;

  /// The remote creation time once confirmed.
  final DateTime? remoteCreatedAt;

  /// The serialized remote response once confirmed.
  final String? remoteResponseJson;

  /// The last error summary shown to the user.
  final String? lastError;
  const LoanSubmissionRow({
    required this.localId,
    required this.idempotencyKey,
    required this.payloadJson,
    required this.deviceSnapshotJson,
    required this.state,
    required this.attemptCount,
    required this.createdAt,
    this.lastAttemptAt,
    this.completedAt,
    this.remoteId,
    this.remoteCreatedAt,
    this.remoteResponseJson,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['payload_json'] = Variable<String>(payloadJson);
    map['device_snapshot_json'] = Variable<String>(deviceSnapshotJson);
    map['state'] = Variable<String>(state);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || remoteCreatedAt != null) {
      map['remote_created_at'] = Variable<DateTime>(remoteCreatedAt);
    }
    if (!nullToAbsent || remoteResponseJson != null) {
      map['remote_response_json'] = Variable<String>(remoteResponseJson);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  LoanSubmissionsCompanion toCompanion(bool nullToAbsent) {
    return LoanSubmissionsCompanion(
      localId: Value(localId),
      idempotencyKey: Value(idempotencyKey),
      payloadJson: Value(payloadJson),
      deviceSnapshotJson: Value(deviceSnapshotJson),
      state: Value(state),
      attemptCount: Value(attemptCount),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      remoteCreatedAt: remoteCreatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteCreatedAt),
      remoteResponseJson: remoteResponseJson == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteResponseJson),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory LoanSubmissionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanSubmissionRow(
      localId: serializer.fromJson<String>(json['localId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      deviceSnapshotJson: serializer.fromJson<String>(
        json['deviceSnapshotJson'],
      ),
      state: serializer.fromJson<String>(json['state']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      remoteCreatedAt: serializer.fromJson<DateTime?>(json['remoteCreatedAt']),
      remoteResponseJson: serializer.fromJson<String?>(
        json['remoteResponseJson'],
      ),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'deviceSnapshotJson': serializer.toJson<String>(deviceSnapshotJson),
      'state': serializer.toJson<String>(state),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'remoteId': serializer.toJson<String?>(remoteId),
      'remoteCreatedAt': serializer.toJson<DateTime?>(remoteCreatedAt),
      'remoteResponseJson': serializer.toJson<String?>(remoteResponseJson),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  LoanSubmissionRow copyWith({
    String? localId,
    String? idempotencyKey,
    String? payloadJson,
    String? deviceSnapshotJson,
    String? state,
    int? attemptCount,
    DateTime? createdAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> remoteId = const Value.absent(),
    Value<DateTime?> remoteCreatedAt = const Value.absent(),
    Value<String?> remoteResponseJson = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
  }) => LoanSubmissionRow(
    localId: localId ?? this.localId,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    payloadJson: payloadJson ?? this.payloadJson,
    deviceSnapshotJson: deviceSnapshotJson ?? this.deviceSnapshotJson,
    state: state ?? this.state,
    attemptCount: attemptCount ?? this.attemptCount,
    createdAt: createdAt ?? this.createdAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    remoteCreatedAt: remoteCreatedAt.present
        ? remoteCreatedAt.value
        : this.remoteCreatedAt,
    remoteResponseJson: remoteResponseJson.present
        ? remoteResponseJson.value
        : this.remoteResponseJson,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  LoanSubmissionRow copyWithCompanion(LoanSubmissionsCompanion data) {
    return LoanSubmissionRow(
      localId: data.localId.present ? data.localId.value : this.localId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      deviceSnapshotJson: data.deviceSnapshotJson.present
          ? data.deviceSnapshotJson.value
          : this.deviceSnapshotJson,
      state: data.state.present ? data.state.value : this.state,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      remoteCreatedAt: data.remoteCreatedAt.present
          ? data.remoteCreatedAt.value
          : this.remoteCreatedAt,
      remoteResponseJson: data.remoteResponseJson.present
          ? data.remoteResponseJson.value
          : this.remoteResponseJson,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanSubmissionRow(')
          ..write('localId: $localId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('deviceSnapshotJson: $deviceSnapshotJson, ')
          ..write('state: $state, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('remoteCreatedAt: $remoteCreatedAt, ')
          ..write('remoteResponseJson: $remoteResponseJson, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    idempotencyKey,
    payloadJson,
    deviceSnapshotJson,
    state,
    attemptCount,
    createdAt,
    lastAttemptAt,
    completedAt,
    remoteId,
    remoteCreatedAt,
    remoteResponseJson,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanSubmissionRow &&
          other.localId == this.localId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.payloadJson == this.payloadJson &&
          other.deviceSnapshotJson == this.deviceSnapshotJson &&
          other.state == this.state &&
          other.attemptCount == this.attemptCount &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.completedAt == this.completedAt &&
          other.remoteId == this.remoteId &&
          other.remoteCreatedAt == this.remoteCreatedAt &&
          other.remoteResponseJson == this.remoteResponseJson &&
          other.lastError == this.lastError);
}

class LoanSubmissionsCompanion extends UpdateCompanion<LoanSubmissionRow> {
  final Value<String> localId;
  final Value<String> idempotencyKey;
  final Value<String> payloadJson;
  final Value<String> deviceSnapshotJson;
  final Value<String> state;
  final Value<int> attemptCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime?> completedAt;
  final Value<String?> remoteId;
  final Value<DateTime?> remoteCreatedAt;
  final Value<String?> remoteResponseJson;
  final Value<String?> lastError;
  final Value<int> rowid;
  const LoanSubmissionsCompanion({
    this.localId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.deviceSnapshotJson = const Value.absent(),
    this.state = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.remoteCreatedAt = const Value.absent(),
    this.remoteResponseJson = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoanSubmissionsCompanion.insert({
    required String localId,
    required String idempotencyKey,
    required String payloadJson,
    required String deviceSnapshotJson,
    required String state,
    this.attemptCount = const Value.absent(),
    required DateTime createdAt,
    this.lastAttemptAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.remoteCreatedAt = const Value.absent(),
    this.remoteResponseJson = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localId = Value(localId),
       idempotencyKey = Value(idempotencyKey),
       payloadJson = Value(payloadJson),
       deviceSnapshotJson = Value(deviceSnapshotJson),
       state = Value(state),
       createdAt = Value(createdAt);
  static Insertable<LoanSubmissionRow> custom({
    Expression<String>? localId,
    Expression<String>? idempotencyKey,
    Expression<String>? payloadJson,
    Expression<String>? deviceSnapshotJson,
    Expression<String>? state,
    Expression<int>? attemptCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? completedAt,
    Expression<String>? remoteId,
    Expression<DateTime>? remoteCreatedAt,
    Expression<String>? remoteResponseJson,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (deviceSnapshotJson != null)
        'device_snapshot_json': deviceSnapshotJson,
      if (state != null) 'state': state,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (remoteId != null) 'remote_id': remoteId,
      if (remoteCreatedAt != null) 'remote_created_at': remoteCreatedAt,
      if (remoteResponseJson != null)
        'remote_response_json': remoteResponseJson,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoanSubmissionsCompanion copyWith({
    Value<String>? localId,
    Value<String>? idempotencyKey,
    Value<String>? payloadJson,
    Value<String>? deviceSnapshotJson,
    Value<String>? state,
    Value<int>? attemptCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime?>? completedAt,
    Value<String?>? remoteId,
    Value<DateTime?>? remoteCreatedAt,
    Value<String?>? remoteResponseJson,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return LoanSubmissionsCompanion(
      localId: localId ?? this.localId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      payloadJson: payloadJson ?? this.payloadJson,
      deviceSnapshotJson: deviceSnapshotJson ?? this.deviceSnapshotJson,
      state: state ?? this.state,
      attemptCount: attemptCount ?? this.attemptCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      completedAt: completedAt ?? this.completedAt,
      remoteId: remoteId ?? this.remoteId,
      remoteCreatedAt: remoteCreatedAt ?? this.remoteCreatedAt,
      remoteResponseJson: remoteResponseJson ?? this.remoteResponseJson,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (deviceSnapshotJson.present) {
      map['device_snapshot_json'] = Variable<String>(deviceSnapshotJson.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (remoteCreatedAt.present) {
      map['remote_created_at'] = Variable<DateTime>(remoteCreatedAt.value);
    }
    if (remoteResponseJson.present) {
      map['remote_response_json'] = Variable<String>(remoteResponseJson.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanSubmissionsCompanion(')
          ..write('localId: $localId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('deviceSnapshotJson: $deviceSnapshotJson, ')
          ..write('state: $state, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('remoteCreatedAt: $remoteCreatedAt, ')
          ..write('remoteResponseJson: $remoteResponseJson, ')
          ..write('lastError: $lastError, ')
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
  late final $CachedDevicesTable cachedDevices = $CachedDevicesTable(this);
  late final $CatalogueMetadataTable catalogueMetadata =
      $CatalogueMetadataTable(this);
  late final $LoanDraftsTable loanDrafts = $LoanDraftsTable(this);
  late final $LoanSubmissionsTable loanSubmissions = $LoanSubmissionsTable(
    this,
  );
  late final CompareDao compareDao = CompareDao(this as AppDatabase);
  late final CatalogueCacheDao catalogueCacheDao = CatalogueCacheDao(
    this as AppDatabase,
  );
  late final LoanDraftDao loanDraftDao = LoanDraftDao(this as AppDatabase);
  late final LoanSubmissionDao loanSubmissionDao = LoanSubmissionDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    compareSelections,
    cachedDevices,
    catalogueMetadata,
    loanDrafts,
    loanSubmissions,
  ];
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
typedef $$CachedDevicesTableCreateCompanionBuilder =
    CachedDevicesCompanion Function({
      required String deviceId,
      required String name,
      required String rawDataJson,
      Value<int?> estimatedValueMinor,
      Value<int?> year,
      required String category,
      required int sourceIndex,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedDevicesTableUpdateCompanionBuilder =
    CachedDevicesCompanion Function({
      Value<String> deviceId,
      Value<String> name,
      Value<String> rawDataJson,
      Value<int?> estimatedValueMinor,
      Value<int?> year,
      Value<String> category,
      Value<int> sourceIndex,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedDevicesTable> {
  $$CachedDevicesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedValueMinor => $composableBuilder(
    column: $table.estimatedValueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceIndex => $composableBuilder(
    column: $table.sourceIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedDevicesTable> {
  $$CachedDevicesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedValueMinor => $composableBuilder(
    column: $table.estimatedValueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceIndex => $composableBuilder(
    column: $table.sourceIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedDevicesTable> {
  $$CachedDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get rawDataJson => $composableBuilder(
    column: $table.rawDataJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedValueMinor => $composableBuilder(
    column: $table.estimatedValueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get sourceIndex => $composableBuilder(
    column: $table.sourceIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedDevicesTable,
          CachedDevice,
          $$CachedDevicesTableFilterComposer,
          $$CachedDevicesTableOrderingComposer,
          $$CachedDevicesTableAnnotationComposer,
          $$CachedDevicesTableCreateCompanionBuilder,
          $$CachedDevicesTableUpdateCompanionBuilder,
          (
            CachedDevice,
            BaseReferences<_$AppDatabase, $CachedDevicesTable, CachedDevice>,
          ),
          CachedDevice,
          PrefetchHooks Function()
        > {
  $$CachedDevicesTableTableManager(_$AppDatabase db, $CachedDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> rawDataJson = const Value.absent(),
                Value<int?> estimatedValueMinor = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> sourceIndex = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedDevicesCompanion(
                deviceId: deviceId,
                name: name,
                rawDataJson: rawDataJson,
                estimatedValueMinor: estimatedValueMinor,
                year: year,
                category: category,
                sourceIndex: sourceIndex,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String name,
                required String rawDataJson,
                Value<int?> estimatedValueMinor = const Value.absent(),
                Value<int?> year = const Value.absent(),
                required String category,
                required int sourceIndex,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedDevicesCompanion.insert(
                deviceId: deviceId,
                name: name,
                rawDataJson: rawDataJson,
                estimatedValueMinor: estimatedValueMinor,
                year: year,
                category: category,
                sourceIndex: sourceIndex,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedDevicesTable,
      CachedDevice,
      $$CachedDevicesTableFilterComposer,
      $$CachedDevicesTableOrderingComposer,
      $$CachedDevicesTableAnnotationComposer,
      $$CachedDevicesTableCreateCompanionBuilder,
      $$CachedDevicesTableUpdateCompanionBuilder,
      (
        CachedDevice,
        BaseReferences<_$AppDatabase, $CachedDevicesTable, CachedDevice>,
      ),
      CachedDevice,
      PrefetchHooks Function()
    >;
typedef $$CatalogueMetadataTableCreateCompanionBuilder =
    CatalogueMetadataCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSuccessfulRefreshAt,
      Value<int> recordCount,
    });
typedef $$CatalogueMetadataTableUpdateCompanionBuilder =
    CatalogueMetadataCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSuccessfulRefreshAt,
      Value<int> recordCount,
    });

class $$CatalogueMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogueMetadataTable> {
  $$CatalogueMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulRefreshAt => $composableBuilder(
    column: $table.lastSuccessfulRefreshAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordCount => $composableBuilder(
    column: $table.recordCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogueMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogueMetadataTable> {
  $$CatalogueMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulRefreshAt => $composableBuilder(
    column: $table.lastSuccessfulRefreshAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordCount => $composableBuilder(
    column: $table.recordCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogueMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogueMetadataTable> {
  $$CatalogueMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessfulRefreshAt => $composableBuilder(
    column: $table.lastSuccessfulRefreshAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordCount => $composableBuilder(
    column: $table.recordCount,
    builder: (column) => column,
  );
}

class $$CatalogueMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogueMetadataTable,
          CatalogueMetadataData,
          $$CatalogueMetadataTableFilterComposer,
          $$CatalogueMetadataTableOrderingComposer,
          $$CatalogueMetadataTableAnnotationComposer,
          $$CatalogueMetadataTableCreateCompanionBuilder,
          $$CatalogueMetadataTableUpdateCompanionBuilder,
          (
            CatalogueMetadataData,
            BaseReferences<
              _$AppDatabase,
              $CatalogueMetadataTable,
              CatalogueMetadataData
            >,
          ),
          CatalogueMetadataData,
          PrefetchHooks Function()
        > {
  $$CatalogueMetadataTableTableManager(
    _$AppDatabase db,
    $CatalogueMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogueMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogueMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogueMetadataTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSuccessfulRefreshAt = const Value.absent(),
                Value<int> recordCount = const Value.absent(),
              }) => CatalogueMetadataCompanion(
                id: id,
                lastSuccessfulRefreshAt: lastSuccessfulRefreshAt,
                recordCount: recordCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSuccessfulRefreshAt = const Value.absent(),
                Value<int> recordCount = const Value.absent(),
              }) => CatalogueMetadataCompanion.insert(
                id: id,
                lastSuccessfulRefreshAt: lastSuccessfulRefreshAt,
                recordCount: recordCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogueMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogueMetadataTable,
      CatalogueMetadataData,
      $$CatalogueMetadataTableFilterComposer,
      $$CatalogueMetadataTableOrderingComposer,
      $$CatalogueMetadataTableAnnotationComposer,
      $$CatalogueMetadataTableCreateCompanionBuilder,
      $$CatalogueMetadataTableUpdateCompanionBuilder,
      (
        CatalogueMetadataData,
        BaseReferences<
          _$AppDatabase,
          $CatalogueMetadataTable,
          CatalogueMetadataData
        >,
      ),
      CatalogueMetadataData,
      PrefetchHooks Function()
    >;
typedef $$LoanDraftsTableCreateCompanionBuilder =
    LoanDraftsCompanion Function({
      Value<int> id,
      required String deviceId,
      required String deviceSnapshotJson,
      Value<String> studentId,
      Value<String?> borrowDate,
      Value<String?> returnDate,
      Value<String> purpose,
      Value<int> deposit,
      required DateTime updatedAt,
    });
typedef $$LoanDraftsTableUpdateCompanionBuilder =
    LoanDraftsCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String> deviceSnapshotJson,
      Value<String> studentId,
      Value<String?> borrowDate,
      Value<String?> returnDate,
      Value<String> purpose,
      Value<int> deposit,
      Value<DateTime> updatedAt,
    });

class $$LoanDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanDraftsTable> {
  $$LoanDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceSnapshotJson => $composableBuilder(
    column: $table.deviceSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get borrowDate => $composableBuilder(
    column: $table.borrowDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnDate => $composableBuilder(
    column: $table.returnDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoanDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanDraftsTable> {
  $$LoanDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceSnapshotJson => $composableBuilder(
    column: $table.deviceSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get studentId => $composableBuilder(
    column: $table.studentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get borrowDate => $composableBuilder(
    column: $table.borrowDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnDate => $composableBuilder(
    column: $table.returnDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deposit => $composableBuilder(
    column: $table.deposit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoanDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanDraftsTable> {
  $$LoanDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get deviceSnapshotJson => $composableBuilder(
    column: $table.deviceSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get studentId =>
      $composableBuilder(column: $table.studentId, builder: (column) => column);

  GeneratedColumn<String> get borrowDate => $composableBuilder(
    column: $table.borrowDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get returnDate => $composableBuilder(
    column: $table.returnDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<int> get deposit =>
      $composableBuilder(column: $table.deposit, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LoanDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoanDraftsTable,
          LoanDraftRow,
          $$LoanDraftsTableFilterComposer,
          $$LoanDraftsTableOrderingComposer,
          $$LoanDraftsTableAnnotationComposer,
          $$LoanDraftsTableCreateCompanionBuilder,
          $$LoanDraftsTableUpdateCompanionBuilder,
          (
            LoanDraftRow,
            BaseReferences<_$AppDatabase, $LoanDraftsTable, LoanDraftRow>,
          ),
          LoanDraftRow,
          PrefetchHooks Function()
        > {
  $$LoanDraftsTableTableManager(_$AppDatabase db, $LoanDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> deviceSnapshotJson = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String?> borrowDate = const Value.absent(),
                Value<String?> returnDate = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<int> deposit = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LoanDraftsCompanion(
                id: id,
                deviceId: deviceId,
                deviceSnapshotJson: deviceSnapshotJson,
                studentId: studentId,
                borrowDate: borrowDate,
                returnDate: returnDate,
                purpose: purpose,
                deposit: deposit,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required String deviceSnapshotJson,
                Value<String> studentId = const Value.absent(),
                Value<String?> borrowDate = const Value.absent(),
                Value<String?> returnDate = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<int> deposit = const Value.absent(),
                required DateTime updatedAt,
              }) => LoanDraftsCompanion.insert(
                id: id,
                deviceId: deviceId,
                deviceSnapshotJson: deviceSnapshotJson,
                studentId: studentId,
                borrowDate: borrowDate,
                returnDate: returnDate,
                purpose: purpose,
                deposit: deposit,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoanDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoanDraftsTable,
      LoanDraftRow,
      $$LoanDraftsTableFilterComposer,
      $$LoanDraftsTableOrderingComposer,
      $$LoanDraftsTableAnnotationComposer,
      $$LoanDraftsTableCreateCompanionBuilder,
      $$LoanDraftsTableUpdateCompanionBuilder,
      (
        LoanDraftRow,
        BaseReferences<_$AppDatabase, $LoanDraftsTable, LoanDraftRow>,
      ),
      LoanDraftRow,
      PrefetchHooks Function()
    >;
typedef $$LoanSubmissionsTableCreateCompanionBuilder =
    LoanSubmissionsCompanion Function({
      required String localId,
      required String idempotencyKey,
      required String payloadJson,
      required String deviceSnapshotJson,
      required String state,
      Value<int> attemptCount,
      required DateTime createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime?> completedAt,
      Value<String?> remoteId,
      Value<DateTime?> remoteCreatedAt,
      Value<String?> remoteResponseJson,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$LoanSubmissionsTableUpdateCompanionBuilder =
    LoanSubmissionsCompanion Function({
      Value<String> localId,
      Value<String> idempotencyKey,
      Value<String> payloadJson,
      Value<String> deviceSnapshotJson,
      Value<String> state,
      Value<int> attemptCount,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime?> completedAt,
      Value<String?> remoteId,
      Value<DateTime?> remoteCreatedAt,
      Value<String?> remoteResponseJson,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$LoanSubmissionsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanSubmissionsTable> {
  $$LoanSubmissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceSnapshotJson => $composableBuilder(
    column: $table.deviceSnapshotJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remoteCreatedAt => $composableBuilder(
    column: $table.remoteCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteResponseJson => $composableBuilder(
    column: $table.remoteResponseJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoanSubmissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanSubmissionsTable> {
  $$LoanSubmissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceSnapshotJson => $composableBuilder(
    column: $table.deviceSnapshotJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remoteCreatedAt => $composableBuilder(
    column: $table.remoteCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteResponseJson => $composableBuilder(
    column: $table.remoteResponseJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoanSubmissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanSubmissionsTable> {
  $$LoanSubmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceSnapshotJson => $composableBuilder(
    column: $table.deviceSnapshotJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteCreatedAt => $composableBuilder(
    column: $table.remoteCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteResponseJson => $composableBuilder(
    column: $table.remoteResponseJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$LoanSubmissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoanSubmissionsTable,
          LoanSubmissionRow,
          $$LoanSubmissionsTableFilterComposer,
          $$LoanSubmissionsTableOrderingComposer,
          $$LoanSubmissionsTableAnnotationComposer,
          $$LoanSubmissionsTableCreateCompanionBuilder,
          $$LoanSubmissionsTableUpdateCompanionBuilder,
          (
            LoanSubmissionRow,
            BaseReferences<
              _$AppDatabase,
              $LoanSubmissionsTable,
              LoanSubmissionRow
            >,
          ),
          LoanSubmissionRow,
          PrefetchHooks Function()
        > {
  $$LoanSubmissionsTableTableManager(
    _$AppDatabase db,
    $LoanSubmissionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanSubmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanSubmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanSubmissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String> deviceSnapshotJson = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<DateTime?> remoteCreatedAt = const Value.absent(),
                Value<String?> remoteResponseJson = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LoanSubmissionsCompanion(
                localId: localId,
                idempotencyKey: idempotencyKey,
                payloadJson: payloadJson,
                deviceSnapshotJson: deviceSnapshotJson,
                state: state,
                attemptCount: attemptCount,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                completedAt: completedAt,
                remoteId: remoteId,
                remoteCreatedAt: remoteCreatedAt,
                remoteResponseJson: remoteResponseJson,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localId,
                required String idempotencyKey,
                required String payloadJson,
                required String deviceSnapshotJson,
                required String state,
                Value<int> attemptCount = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<DateTime?> remoteCreatedAt = const Value.absent(),
                Value<String?> remoteResponseJson = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LoanSubmissionsCompanion.insert(
                localId: localId,
                idempotencyKey: idempotencyKey,
                payloadJson: payloadJson,
                deviceSnapshotJson: deviceSnapshotJson,
                state: state,
                attemptCount: attemptCount,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
                completedAt: completedAt,
                remoteId: remoteId,
                remoteCreatedAt: remoteCreatedAt,
                remoteResponseJson: remoteResponseJson,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoanSubmissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoanSubmissionsTable,
      LoanSubmissionRow,
      $$LoanSubmissionsTableFilterComposer,
      $$LoanSubmissionsTableOrderingComposer,
      $$LoanSubmissionsTableAnnotationComposer,
      $$LoanSubmissionsTableCreateCompanionBuilder,
      $$LoanSubmissionsTableUpdateCompanionBuilder,
      (
        LoanSubmissionRow,
        BaseReferences<_$AppDatabase, $LoanSubmissionsTable, LoanSubmissionRow>,
      ),
      LoanSubmissionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompareSelectionsTableTableManager get compareSelections =>
      $$CompareSelectionsTableTableManager(_db, _db.compareSelections);
  $$CachedDevicesTableTableManager get cachedDevices =>
      $$CachedDevicesTableTableManager(_db, _db.cachedDevices);
  $$CatalogueMetadataTableTableManager get catalogueMetadata =>
      $$CatalogueMetadataTableTableManager(_db, _db.catalogueMetadata);
  $$LoanDraftsTableTableManager get loanDrafts =>
      $$LoanDraftsTableTableManager(_db, _db.loanDrafts);
  $$LoanSubmissionsTableTableManager get loanSubmissions =>
      $$LoanSubmissionsTableTableManager(_db, _db.loanSubmissions);
}

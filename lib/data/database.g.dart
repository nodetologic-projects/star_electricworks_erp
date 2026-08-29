// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstRateMeta = const VerificationMeta(
    'gstRate',
  );
  @override
  late final GeneratedColumn<double> gstRate = GeneratedColumn<double>(
    'gst_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reorderLevelMeta = const VerificationMeta(
    'reorderLevel',
  );
  @override
  late final GeneratedColumn<int> reorderLevel = GeneratedColumn<int>(
    'reorder_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sku,
    hsnCode,
    gstRate,
    unitPrice,
    stockQty,
    reorderLevel,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_hsnCodeMeta);
    }
    if (data.containsKey('gst_rate')) {
      context.handle(
        _gstRateMeta,
        gstRate.isAcceptableOrUnknown(data['gst_rate']!, _gstRateMeta),
      );
    } else if (isInserting) {
      context.missing(_gstRateMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_stockQtyMeta);
    }
    if (data.containsKey('reorder_level')) {
      context.handle(
        _reorderLevelMeta,
        reorderLevel.isAcceptableOrUnknown(
          data['reorder_level']!,
          _reorderLevelMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      )!,
      gstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_rate'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_qty'],
      )!,
      reorderLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reorder_level'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String sku;
  final String hsnCode;
  final double gstRate;
  final double unitPrice;
  final int stockQty;
  final int? reorderLevel;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.hsnCode,
    required this.gstRate,
    required this.unitPrice,
    required this.stockQty,
    this.reorderLevel,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sku'] = Variable<String>(sku);
    map['hsn_code'] = Variable<String>(hsnCode);
    map['gst_rate'] = Variable<double>(gstRate);
    map['unit_price'] = Variable<double>(unitPrice);
    map['stock_qty'] = Variable<int>(stockQty);
    if (!nullToAbsent || reorderLevel != null) {
      map['reorder_level'] = Variable<int>(reorderLevel);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      sku: Value(sku),
      hsnCode: Value(hsnCode),
      gstRate: Value(gstRate),
      unitPrice: Value(unitPrice),
      stockQty: Value(stockQty),
      reorderLevel: reorderLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(reorderLevel),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sku: serializer.fromJson<String>(json['sku']),
      hsnCode: serializer.fromJson<String>(json['hsnCode']),
      gstRate: serializer.fromJson<double>(json['gstRate']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      reorderLevel: serializer.fromJson<int?>(json['reorderLevel']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sku': serializer.toJson<String>(sku),
      'hsnCode': serializer.toJson<String>(hsnCode),
      'gstRate': serializer.toJson<double>(gstRate),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'stockQty': serializer.toJson<int>(stockQty),
      'reorderLevel': serializer.toJson<int?>(reorderLevel),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? sku,
    String? hsnCode,
    double? gstRate,
    double? unitPrice,
    int? stockQty,
    Value<int?> reorderLevel = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    sku: sku ?? this.sku,
    hsnCode: hsnCode ?? this.hsnCode,
    gstRate: gstRate ?? this.gstRate,
    unitPrice: unitPrice ?? this.unitPrice,
    stockQty: stockQty ?? this.stockQty,
    reorderLevel: reorderLevel.present ? reorderLevel.value : this.reorderLevel,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sku: data.sku.present ? data.sku.value : this.sku,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      gstRate: data.gstRate.present ? data.gstRate.value : this.gstRate,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      reorderLevel: data.reorderLevel.present
          ? data.reorderLevel.value
          : this.reorderLevel,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('gstRate: $gstRate, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sku,
    hsnCode,
    gstRate,
    unitPrice,
    stockQty,
    reorderLevel,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.sku == this.sku &&
          other.hsnCode == this.hsnCode &&
          other.gstRate == this.gstRate &&
          other.unitPrice == this.unitPrice &&
          other.stockQty == this.stockQty &&
          other.reorderLevel == this.reorderLevel &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> sku;
  final Value<String> hsnCode;
  final Value<double> gstRate;
  final Value<double> unitPrice;
  final Value<int> stockQty;
  final Value<int?> reorderLevel;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sku = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.gstRate = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String sku,
    required String hsnCode,
    required double gstRate,
    required double unitPrice,
    required int stockQty,
    this.reorderLevel = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       sku = Value(sku),
       hsnCode = Value(hsnCode),
       gstRate = Value(gstRate),
       unitPrice = Value(unitPrice),
       stockQty = Value(stockQty);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? sku,
    Expression<String>? hsnCode,
    Expression<double>? gstRate,
    Expression<double>? unitPrice,
    Expression<int>? stockQty,
    Expression<int>? reorderLevel,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (gstRate != null) 'gst_rate': gstRate,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (stockQty != null) 'stock_qty': stockQty,
      if (reorderLevel != null) 'reorder_level': reorderLevel,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? sku,
    Value<String>? hsnCode,
    Value<double>? gstRate,
    Value<double>? unitPrice,
    Value<int>? stockQty,
    Value<int?>? reorderLevel,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      hsnCode: hsnCode ?? this.hsnCode,
      gstRate: gstRate ?? this.gstRate,
      unitPrice: unitPrice ?? this.unitPrice,
      stockQty: stockQty ?? this.stockQty,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (gstRate.present) {
      map['gst_rate'] = Variable<double>(gstRate.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (reorderLevel.present) {
      map['reorder_level'] = Variable<int>(reorderLevel.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sku: $sku, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('gstRate: $gstRate, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('stockQty: $stockQty, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
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
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _panNumberMeta = const VerificationMeta(
    'panNumber',
  );
  @override
  late final GeneratedColumn<String> panNumber = GeneratedColumn<String>(
    'pan_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vendorCodeMeta = const VerificationMeta(
    'vendorCode',
  );
  @override
  late final GeneratedColumn<String> vendorCode = GeneratedColumn<String>(
    'vendor_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    state,
    gstin,
    panNumber,
    phone,
    email,
    vendorCode,
    createdAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    }
    if (data.containsKey('pan_number')) {
      context.handle(
        _panNumberMeta,
        panNumber.isAcceptableOrUnknown(data['pan_number']!, _panNumberMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('vendor_code')) {
      context.handle(
        _vendorCodeMeta,
        vendorCode.isAcceptableOrUnknown(data['vendor_code']!, _vendorCodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      ),
      panNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pan_number'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      vendorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String address;
  final String state;
  final String? gstin;
  final String? panNumber;
  final String phone;
  final String email;
  final String? vendorCode;
  final DateTime createdAt;
  final bool isActive;
  const Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.state,
    this.gstin,
    this.panNumber,
    required this.phone,
    required this.email,
    this.vendorCode,
    required this.createdAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || gstin != null) {
      map['gstin'] = Variable<String>(gstin);
    }
    if (!nullToAbsent || panNumber != null) {
      map['pan_number'] = Variable<String>(panNumber);
    }
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || vendorCode != null) {
      map['vendor_code'] = Variable<String>(vendorCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      state: Value(state),
      gstin: gstin == null && nullToAbsent
          ? const Value.absent()
          : Value(gstin),
      panNumber: panNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(panNumber),
      phone: Value(phone),
      email: Value(email),
      vendorCode: vendorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(vendorCode),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      state: serializer.fromJson<String>(json['state']),
      gstin: serializer.fromJson<String?>(json['gstin']),
      panNumber: serializer.fromJson<String?>(json['panNumber']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      vendorCode: serializer.fromJson<String?>(json['vendorCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'state': serializer.toJson<String>(state),
      'gstin': serializer.toJson<String?>(gstin),
      'panNumber': serializer.toJson<String?>(panNumber),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'vendorCode': serializer.toJson<String?>(vendorCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    String? address,
    String? state,
    Value<String?> gstin = const Value.absent(),
    Value<String?> panNumber = const Value.absent(),
    String? phone,
    String? email,
    Value<String?> vendorCode = const Value.absent(),
    DateTime? createdAt,
    bool? isActive,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    state: state ?? this.state,
    gstin: gstin.present ? gstin.value : this.gstin,
    panNumber: panNumber.present ? panNumber.value : this.panNumber,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    vendorCode: vendorCode.present ? vendorCode.value : this.vendorCode,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      state: data.state.present ? data.state.value : this.state,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      panNumber: data.panNumber.present ? data.panNumber.value : this.panNumber,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      vendorCode: data.vendorCode.present
          ? data.vendorCode.value
          : this.vendorCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('state: $state, ')
          ..write('gstin: $gstin, ')
          ..write('panNumber: $panNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('vendorCode: $vendorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    state,
    gstin,
    panNumber,
    phone,
    email,
    vendorCode,
    createdAt,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.state == this.state &&
          other.gstin == this.gstin &&
          other.panNumber == this.panNumber &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.vendorCode == this.vendorCode &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> state;
  final Value<String?> gstin;
  final Value<String?> panNumber;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> vendorCode;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.state = const Value.absent(),
    this.gstin = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.vendorCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String address,
    required String state,
    this.gstin = const Value.absent(),
    this.panNumber = const Value.absent(),
    required String phone,
    required String email,
    this.vendorCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       address = Value(address),
       state = Value(state),
       phone = Value(phone),
       email = Value(email);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? state,
    Expression<String>? gstin,
    Expression<String>? panNumber,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? vendorCode,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (state != null) 'state': state,
      if (gstin != null) 'gstin': gstin,
      if (panNumber != null) 'pan_number': panNumber,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (vendorCode != null) 'vendor_code': vendorCode,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? address,
    Value<String>? state,
    Value<String?>? gstin,
    Value<String?>? panNumber,
    Value<String>? phone,
    Value<String>? email,
    Value<String?>? vendorCode,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      state: state ?? this.state,
      gstin: gstin ?? this.gstin,
      panNumber: panNumber ?? this.panNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      vendorCode: vendorCode ?? this.vendorCode,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (panNumber.present) {
      map['pan_number'] = Variable<String>(panNumber.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (vendorCode.present) {
      map['vendor_code'] = Variable<String>(vendorCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('state: $state, ')
          ..write('gstin: $gstin, ')
          ..write('panNumber: $panNumber, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('vendorCode: $vendorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MotorJobsTable extends MotorJobs
    with TableInfo<$MotorJobsTable, MotorJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MotorJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _jobNoMeta = const VerificationMeta('jobNo');
  @override
  late final GeneratedColumn<String> jobNo = GeneratedColumn<String>(
    'job_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _motorDescriptionMeta = const VerificationMeta(
    'motorDescription',
  );
  @override
  late final GeneratedColumn<String> motorDescription = GeneratedColumn<String>(
    'motor_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _motorMakeMeta = const VerificationMeta(
    'motorMake',
  );
  @override
  late final GeneratedColumn<String> motorMake = GeneratedColumn<String>(
    'motor_make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hpMeta = const VerificationMeta('hp');
  @override
  late final GeneratedColumn<double> hp = GeneratedColumn<double>(
    'hp',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Phase?, String> phase =
      GeneratedColumn<String>(
        'phase',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Phase?>($MotorJobsTable.$converterphasen);
  static const VerificationMeta _dateReceivedMeta = const VerificationMeta(
    'dateReceived',
  );
  @override
  late final GeneratedColumn<DateTime> dateReceived = GeneratedColumn<DateTime>(
    'date_received',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobDescriptionMeta = const VerificationMeta(
    'jobDescription',
  );
  @override
  late final GeneratedColumn<String> jobDescription = GeneratedColumn<String>(
    'job_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MotorJobStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MotorJobStatus>($MotorJobsTable.$converterstatus);
  static const VerificationMeta _serviceChargeMeta = const VerificationMeta(
    'serviceCharge',
  );
  @override
  late final GeneratedColumn<double> serviceCharge = GeneratedColumn<double>(
    'service_charge',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sacCodeMeta = const VerificationMeta(
    'sacCode',
  );
  @override
  late final GeneratedColumn<String> sacCode = GeneratedColumn<String>(
    'sac_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpNumberMeta = const VerificationMeta(
    'gpNumber',
  );
  @override
  late final GeneratedColumn<String> gpNumber = GeneratedColumn<String>(
    'gp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpDateMeta = const VerificationMeta('gpDate');
  @override
  late final GeneratedColumn<DateTime> gpDate = GeneratedColumn<DateTime>(
    'gp_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dispatchDateMeta = const VerificationMeta(
    'dispatchDate',
  );
  @override
  late final GeneratedColumn<DateTime> dispatchDate = GeneratedColumn<DateTime>(
    'dispatch_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    jobNo,
    customerId,
    motorDescription,
    motorMake,
    hp,
    phase,
    dateReceived,
    jobDescription,
    status,
    serviceCharge,
    sacCode,
    gpNumber,
    gpDate,
    dispatchDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'motor_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MotorJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('job_no')) {
      context.handle(
        _jobNoMeta,
        jobNo.isAcceptableOrUnknown(data['job_no']!, _jobNoMeta),
      );
    } else if (isInserting) {
      context.missing(_jobNoMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('motor_description')) {
      context.handle(
        _motorDescriptionMeta,
        motorDescription.isAcceptableOrUnknown(
          data['motor_description']!,
          _motorDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_motorDescriptionMeta);
    }
    if (data.containsKey('motor_make')) {
      context.handle(
        _motorMakeMeta,
        motorMake.isAcceptableOrUnknown(data['motor_make']!, _motorMakeMeta),
      );
    }
    if (data.containsKey('hp')) {
      context.handle(_hpMeta, hp.isAcceptableOrUnknown(data['hp']!, _hpMeta));
    }
    if (data.containsKey('date_received')) {
      context.handle(
        _dateReceivedMeta,
        dateReceived.isAcceptableOrUnknown(
          data['date_received']!,
          _dateReceivedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateReceivedMeta);
    }
    if (data.containsKey('job_description')) {
      context.handle(
        _jobDescriptionMeta,
        jobDescription.isAcceptableOrUnknown(
          data['job_description']!,
          _jobDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jobDescriptionMeta);
    }
    if (data.containsKey('service_charge')) {
      context.handle(
        _serviceChargeMeta,
        serviceCharge.isAcceptableOrUnknown(
          data['service_charge']!,
          _serviceChargeMeta,
        ),
      );
    }
    if (data.containsKey('sac_code')) {
      context.handle(
        _sacCodeMeta,
        sacCode.isAcceptableOrUnknown(data['sac_code']!, _sacCodeMeta),
      );
    }
    if (data.containsKey('gp_number')) {
      context.handle(
        _gpNumberMeta,
        gpNumber.isAcceptableOrUnknown(data['gp_number']!, _gpNumberMeta),
      );
    }
    if (data.containsKey('gp_date')) {
      context.handle(
        _gpDateMeta,
        gpDate.isAcceptableOrUnknown(data['gp_date']!, _gpDateMeta),
      );
    }
    if (data.containsKey('dispatch_date')) {
      context.handle(
        _dispatchDateMeta,
        dispatchDate.isAcceptableOrUnknown(
          data['dispatch_date']!,
          _dispatchDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MotorJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MotorJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      jobNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_no'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      motorDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motor_description'],
      )!,
      motorMake: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motor_make'],
      ),
      hp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hp'],
      ),
      phase: $MotorJobsTable.$converterphasen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phase'],
        ),
      ),
      dateReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_received'],
      )!,
      jobDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_description'],
      )!,
      status: $MotorJobsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      serviceCharge: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}service_charge'],
      ),
      sacCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sac_code'],
      ),
      gpNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gp_number'],
      ),
      gpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}gp_date'],
      ),
      dispatchDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dispatch_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MotorJobsTable createAlias(String alias) {
    return $MotorJobsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Phase, String, String> $converterphase =
      const EnumNameConverter<Phase>(Phase.values);
  static JsonTypeConverter2<Phase?, String?, String?> $converterphasen =
      JsonTypeConverter2.asNullable($converterphase);
  static JsonTypeConverter2<MotorJobStatus, String, String> $converterstatus =
      const EnumNameConverter<MotorJobStatus>(MotorJobStatus.values);
}

class MotorJob extends DataClass implements Insertable<MotorJob> {
  final int id;
  final String jobNo;
  final int customerId;
  final String motorDescription;
  final String? motorMake;
  final double? hp;
  final Phase? phase;
  final DateTime dateReceived;
  final String jobDescription;
  final MotorJobStatus status;
  final double? serviceCharge;
  final String? sacCode;
  final String? gpNumber;
  final DateTime? gpDate;
  final DateTime? dispatchDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MotorJob({
    required this.id,
    required this.jobNo,
    required this.customerId,
    required this.motorDescription,
    this.motorMake,
    this.hp,
    this.phase,
    required this.dateReceived,
    required this.jobDescription,
    required this.status,
    this.serviceCharge,
    this.sacCode,
    this.gpNumber,
    this.gpDate,
    this.dispatchDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['job_no'] = Variable<String>(jobNo);
    map['customer_id'] = Variable<int>(customerId);
    map['motor_description'] = Variable<String>(motorDescription);
    if (!nullToAbsent || motorMake != null) {
      map['motor_make'] = Variable<String>(motorMake);
    }
    if (!nullToAbsent || hp != null) {
      map['hp'] = Variable<double>(hp);
    }
    if (!nullToAbsent || phase != null) {
      map['phase'] = Variable<String>(
        $MotorJobsTable.$converterphasen.toSql(phase),
      );
    }
    map['date_received'] = Variable<DateTime>(dateReceived);
    map['job_description'] = Variable<String>(jobDescription);
    {
      map['status'] = Variable<String>(
        $MotorJobsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || serviceCharge != null) {
      map['service_charge'] = Variable<double>(serviceCharge);
    }
    if (!nullToAbsent || sacCode != null) {
      map['sac_code'] = Variable<String>(sacCode);
    }
    if (!nullToAbsent || gpNumber != null) {
      map['gp_number'] = Variable<String>(gpNumber);
    }
    if (!nullToAbsent || gpDate != null) {
      map['gp_date'] = Variable<DateTime>(gpDate);
    }
    if (!nullToAbsent || dispatchDate != null) {
      map['dispatch_date'] = Variable<DateTime>(dispatchDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MotorJobsCompanion toCompanion(bool nullToAbsent) {
    return MotorJobsCompanion(
      id: Value(id),
      jobNo: Value(jobNo),
      customerId: Value(customerId),
      motorDescription: Value(motorDescription),
      motorMake: motorMake == null && nullToAbsent
          ? const Value.absent()
          : Value(motorMake),
      hp: hp == null && nullToAbsent ? const Value.absent() : Value(hp),
      phase: phase == null && nullToAbsent
          ? const Value.absent()
          : Value(phase),
      dateReceived: Value(dateReceived),
      jobDescription: Value(jobDescription),
      status: Value(status),
      serviceCharge: serviceCharge == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceCharge),
      sacCode: sacCode == null && nullToAbsent
          ? const Value.absent()
          : Value(sacCode),
      gpNumber: gpNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gpNumber),
      gpDate: gpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(gpDate),
      dispatchDate: dispatchDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dispatchDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MotorJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MotorJob(
      id: serializer.fromJson<int>(json['id']),
      jobNo: serializer.fromJson<String>(json['jobNo']),
      customerId: serializer.fromJson<int>(json['customerId']),
      motorDescription: serializer.fromJson<String>(json['motorDescription']),
      motorMake: serializer.fromJson<String?>(json['motorMake']),
      hp: serializer.fromJson<double?>(json['hp']),
      phase: $MotorJobsTable.$converterphasen.fromJson(
        serializer.fromJson<String?>(json['phase']),
      ),
      dateReceived: serializer.fromJson<DateTime>(json['dateReceived']),
      jobDescription: serializer.fromJson<String>(json['jobDescription']),
      status: $MotorJobsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      serviceCharge: serializer.fromJson<double?>(json['serviceCharge']),
      sacCode: serializer.fromJson<String?>(json['sacCode']),
      gpNumber: serializer.fromJson<String?>(json['gpNumber']),
      gpDate: serializer.fromJson<DateTime?>(json['gpDate']),
      dispatchDate: serializer.fromJson<DateTime?>(json['dispatchDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'jobNo': serializer.toJson<String>(jobNo),
      'customerId': serializer.toJson<int>(customerId),
      'motorDescription': serializer.toJson<String>(motorDescription),
      'motorMake': serializer.toJson<String?>(motorMake),
      'hp': serializer.toJson<double?>(hp),
      'phase': serializer.toJson<String?>(
        $MotorJobsTable.$converterphasen.toJson(phase),
      ),
      'dateReceived': serializer.toJson<DateTime>(dateReceived),
      'jobDescription': serializer.toJson<String>(jobDescription),
      'status': serializer.toJson<String>(
        $MotorJobsTable.$converterstatus.toJson(status),
      ),
      'serviceCharge': serializer.toJson<double?>(serviceCharge),
      'sacCode': serializer.toJson<String?>(sacCode),
      'gpNumber': serializer.toJson<String?>(gpNumber),
      'gpDate': serializer.toJson<DateTime?>(gpDate),
      'dispatchDate': serializer.toJson<DateTime?>(dispatchDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MotorJob copyWith({
    int? id,
    String? jobNo,
    int? customerId,
    String? motorDescription,
    Value<String?> motorMake = const Value.absent(),
    Value<double?> hp = const Value.absent(),
    Value<Phase?> phase = const Value.absent(),
    DateTime? dateReceived,
    String? jobDescription,
    MotorJobStatus? status,
    Value<double?> serviceCharge = const Value.absent(),
    Value<String?> sacCode = const Value.absent(),
    Value<String?> gpNumber = const Value.absent(),
    Value<DateTime?> gpDate = const Value.absent(),
    Value<DateTime?> dispatchDate = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => MotorJob(
    id: id ?? this.id,
    jobNo: jobNo ?? this.jobNo,
    customerId: customerId ?? this.customerId,
    motorDescription: motorDescription ?? this.motorDescription,
    motorMake: motorMake.present ? motorMake.value : this.motorMake,
    hp: hp.present ? hp.value : this.hp,
    phase: phase.present ? phase.value : this.phase,
    dateReceived: dateReceived ?? this.dateReceived,
    jobDescription: jobDescription ?? this.jobDescription,
    status: status ?? this.status,
    serviceCharge: serviceCharge.present
        ? serviceCharge.value
        : this.serviceCharge,
    sacCode: sacCode.present ? sacCode.value : this.sacCode,
    gpNumber: gpNumber.present ? gpNumber.value : this.gpNumber,
    gpDate: gpDate.present ? gpDate.value : this.gpDate,
    dispatchDate: dispatchDate.present ? dispatchDate.value : this.dispatchDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MotorJob copyWithCompanion(MotorJobsCompanion data) {
    return MotorJob(
      id: data.id.present ? data.id.value : this.id,
      jobNo: data.jobNo.present ? data.jobNo.value : this.jobNo,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      motorDescription: data.motorDescription.present
          ? data.motorDescription.value
          : this.motorDescription,
      motorMake: data.motorMake.present ? data.motorMake.value : this.motorMake,
      hp: data.hp.present ? data.hp.value : this.hp,
      phase: data.phase.present ? data.phase.value : this.phase,
      dateReceived: data.dateReceived.present
          ? data.dateReceived.value
          : this.dateReceived,
      jobDescription: data.jobDescription.present
          ? data.jobDescription.value
          : this.jobDescription,
      status: data.status.present ? data.status.value : this.status,
      serviceCharge: data.serviceCharge.present
          ? data.serviceCharge.value
          : this.serviceCharge,
      sacCode: data.sacCode.present ? data.sacCode.value : this.sacCode,
      gpNumber: data.gpNumber.present ? data.gpNumber.value : this.gpNumber,
      gpDate: data.gpDate.present ? data.gpDate.value : this.gpDate,
      dispatchDate: data.dispatchDate.present
          ? data.dispatchDate.value
          : this.dispatchDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MotorJob(')
          ..write('id: $id, ')
          ..write('jobNo: $jobNo, ')
          ..write('customerId: $customerId, ')
          ..write('motorDescription: $motorDescription, ')
          ..write('motorMake: $motorMake, ')
          ..write('hp: $hp, ')
          ..write('phase: $phase, ')
          ..write('dateReceived: $dateReceived, ')
          ..write('jobDescription: $jobDescription, ')
          ..write('status: $status, ')
          ..write('serviceCharge: $serviceCharge, ')
          ..write('sacCode: $sacCode, ')
          ..write('gpNumber: $gpNumber, ')
          ..write('gpDate: $gpDate, ')
          ..write('dispatchDate: $dispatchDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jobNo,
    customerId,
    motorDescription,
    motorMake,
    hp,
    phase,
    dateReceived,
    jobDescription,
    status,
    serviceCharge,
    sacCode,
    gpNumber,
    gpDate,
    dispatchDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MotorJob &&
          other.id == this.id &&
          other.jobNo == this.jobNo &&
          other.customerId == this.customerId &&
          other.motorDescription == this.motorDescription &&
          other.motorMake == this.motorMake &&
          other.hp == this.hp &&
          other.phase == this.phase &&
          other.dateReceived == this.dateReceived &&
          other.jobDescription == this.jobDescription &&
          other.status == this.status &&
          other.serviceCharge == this.serviceCharge &&
          other.sacCode == this.sacCode &&
          other.gpNumber == this.gpNumber &&
          other.gpDate == this.gpDate &&
          other.dispatchDate == this.dispatchDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MotorJobsCompanion extends UpdateCompanion<MotorJob> {
  final Value<int> id;
  final Value<String> jobNo;
  final Value<int> customerId;
  final Value<String> motorDescription;
  final Value<String?> motorMake;
  final Value<double?> hp;
  final Value<Phase?> phase;
  final Value<DateTime> dateReceived;
  final Value<String> jobDescription;
  final Value<MotorJobStatus> status;
  final Value<double?> serviceCharge;
  final Value<String?> sacCode;
  final Value<String?> gpNumber;
  final Value<DateTime?> gpDate;
  final Value<DateTime?> dispatchDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MotorJobsCompanion({
    this.id = const Value.absent(),
    this.jobNo = const Value.absent(),
    this.customerId = const Value.absent(),
    this.motorDescription = const Value.absent(),
    this.motorMake = const Value.absent(),
    this.hp = const Value.absent(),
    this.phase = const Value.absent(),
    this.dateReceived = const Value.absent(),
    this.jobDescription = const Value.absent(),
    this.status = const Value.absent(),
    this.serviceCharge = const Value.absent(),
    this.sacCode = const Value.absent(),
    this.gpNumber = const Value.absent(),
    this.gpDate = const Value.absent(),
    this.dispatchDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MotorJobsCompanion.insert({
    this.id = const Value.absent(),
    required String jobNo,
    required int customerId,
    required String motorDescription,
    this.motorMake = const Value.absent(),
    this.hp = const Value.absent(),
    this.phase = const Value.absent(),
    required DateTime dateReceived,
    required String jobDescription,
    required MotorJobStatus status,
    this.serviceCharge = const Value.absent(),
    this.sacCode = const Value.absent(),
    this.gpNumber = const Value.absent(),
    this.gpDate = const Value.absent(),
    this.dispatchDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : jobNo = Value(jobNo),
       customerId = Value(customerId),
       motorDescription = Value(motorDescription),
       dateReceived = Value(dateReceived),
       jobDescription = Value(jobDescription),
       status = Value(status);
  static Insertable<MotorJob> custom({
    Expression<int>? id,
    Expression<String>? jobNo,
    Expression<int>? customerId,
    Expression<String>? motorDescription,
    Expression<String>? motorMake,
    Expression<double>? hp,
    Expression<String>? phase,
    Expression<DateTime>? dateReceived,
    Expression<String>? jobDescription,
    Expression<String>? status,
    Expression<double>? serviceCharge,
    Expression<String>? sacCode,
    Expression<String>? gpNumber,
    Expression<DateTime>? gpDate,
    Expression<DateTime>? dispatchDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jobNo != null) 'job_no': jobNo,
      if (customerId != null) 'customer_id': customerId,
      if (motorDescription != null) 'motor_description': motorDescription,
      if (motorMake != null) 'motor_make': motorMake,
      if (hp != null) 'hp': hp,
      if (phase != null) 'phase': phase,
      if (dateReceived != null) 'date_received': dateReceived,
      if (jobDescription != null) 'job_description': jobDescription,
      if (status != null) 'status': status,
      if (serviceCharge != null) 'service_charge': serviceCharge,
      if (sacCode != null) 'sac_code': sacCode,
      if (gpNumber != null) 'gp_number': gpNumber,
      if (gpDate != null) 'gp_date': gpDate,
      if (dispatchDate != null) 'dispatch_date': dispatchDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MotorJobsCompanion copyWith({
    Value<int>? id,
    Value<String>? jobNo,
    Value<int>? customerId,
    Value<String>? motorDescription,
    Value<String?>? motorMake,
    Value<double?>? hp,
    Value<Phase?>? phase,
    Value<DateTime>? dateReceived,
    Value<String>? jobDescription,
    Value<MotorJobStatus>? status,
    Value<double?>? serviceCharge,
    Value<String?>? sacCode,
    Value<String?>? gpNumber,
    Value<DateTime?>? gpDate,
    Value<DateTime?>? dispatchDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MotorJobsCompanion(
      id: id ?? this.id,
      jobNo: jobNo ?? this.jobNo,
      customerId: customerId ?? this.customerId,
      motorDescription: motorDescription ?? this.motorDescription,
      motorMake: motorMake ?? this.motorMake,
      hp: hp ?? this.hp,
      phase: phase ?? this.phase,
      dateReceived: dateReceived ?? this.dateReceived,
      jobDescription: jobDescription ?? this.jobDescription,
      status: status ?? this.status,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      sacCode: sacCode ?? this.sacCode,
      gpNumber: gpNumber ?? this.gpNumber,
      gpDate: gpDate ?? this.gpDate,
      dispatchDate: dispatchDate ?? this.dispatchDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (jobNo.present) {
      map['job_no'] = Variable<String>(jobNo.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (motorDescription.present) {
      map['motor_description'] = Variable<String>(motorDescription.value);
    }
    if (motorMake.present) {
      map['motor_make'] = Variable<String>(motorMake.value);
    }
    if (hp.present) {
      map['hp'] = Variable<double>(hp.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(
        $MotorJobsTable.$converterphasen.toSql(phase.value),
      );
    }
    if (dateReceived.present) {
      map['date_received'] = Variable<DateTime>(dateReceived.value);
    }
    if (jobDescription.present) {
      map['job_description'] = Variable<String>(jobDescription.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $MotorJobsTable.$converterstatus.toSql(status.value),
      );
    }
    if (serviceCharge.present) {
      map['service_charge'] = Variable<double>(serviceCharge.value);
    }
    if (sacCode.present) {
      map['sac_code'] = Variable<String>(sacCode.value);
    }
    if (gpNumber.present) {
      map['gp_number'] = Variable<String>(gpNumber.value);
    }
    if (gpDate.present) {
      map['gp_date'] = Variable<DateTime>(gpDate.value);
    }
    if (dispatchDate.present) {
      map['dispatch_date'] = Variable<DateTime>(dispatchDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MotorJobsCompanion(')
          ..write('id: $id, ')
          ..write('jobNo: $jobNo, ')
          ..write('customerId: $customerId, ')
          ..write('motorDescription: $motorDescription, ')
          ..write('motorMake: $motorMake, ')
          ..write('hp: $hp, ')
          ..write('phase: $phase, ')
          ..write('dateReceived: $dateReceived, ')
          ..write('jobDescription: $jobDescription, ')
          ..write('status: $status, ')
          ..write('serviceCharge: $serviceCharge, ')
          ..write('sacCode: $sacCode, ')
          ..write('gpNumber: $gpNumber, ')
          ..write('gpDate: $gpDate, ')
          ..write('dispatchDate: $dispatchDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CopperStockTable extends CopperStock
    with TableInfo<$CopperStockTable, CopperStockData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CopperStockTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CopperType, String> copperType =
      GeneratedColumn<String>(
        'copper_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CopperType>($CopperStockTable.$convertercopperType);
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerKgMeta = const VerificationMeta(
    'pricePerKg',
  );
  @override
  late final GeneratedColumn<double> pricePerKg = GeneratedColumn<double>(
    'price_per_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstRateMeta = const VerificationMeta(
    'gstRate',
  );
  @override
  late final GeneratedColumn<double> gstRate = GeneratedColumn<double>(
    'gst_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockQtyKgMeta = const VerificationMeta(
    'stockQtyKg',
  );
  @override
  late final GeneratedColumn<double> stockQtyKg = GeneratedColumn<double>(
    'stock_qty_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reorderLevelKgMeta = const VerificationMeta(
    'reorderLevelKg',
  );
  @override
  late final GeneratedColumn<double> reorderLevelKg = GeneratedColumn<double>(
    'reorder_level_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    copperType,
    description,
    weightKg,
    pricePerKg,
    gstRate,
    hsnCode,
    stockQtyKg,
    reorderLevelKg,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'copper_stock';
  @override
  VerificationContext validateIntegrity(
    Insertable<CopperStockData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('price_per_kg')) {
      context.handle(
        _pricePerKgMeta,
        pricePerKg.isAcceptableOrUnknown(
          data['price_per_kg']!,
          _pricePerKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerKgMeta);
    }
    if (data.containsKey('gst_rate')) {
      context.handle(
        _gstRateMeta,
        gstRate.isAcceptableOrUnknown(data['gst_rate']!, _gstRateMeta),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('stock_qty_kg')) {
      context.handle(
        _stockQtyKgMeta,
        stockQtyKg.isAcceptableOrUnknown(
          data['stock_qty_kg']!,
          _stockQtyKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stockQtyKgMeta);
    }
    if (data.containsKey('reorder_level_kg')) {
      context.handle(
        _reorderLevelKgMeta,
        reorderLevelKg.isAcceptableOrUnknown(
          data['reorder_level_kg']!,
          _reorderLevelKgMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CopperStockData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CopperStockData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      copperType: $CopperStockTable.$convertercopperType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}copper_type'],
        )!,
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      pricePerKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_kg'],
      )!,
      gstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_rate'],
      ),
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      stockQtyKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_qty_kg'],
      )!,
      reorderLevelKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reorder_level_kg'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CopperStockTable createAlias(String alias) {
    return $CopperStockTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CopperType, String, String> $convertercopperType =
      const EnumNameConverter<CopperType>(CopperType.values);
}

class CopperStockData extends DataClass implements Insertable<CopperStockData> {
  final int id;
  final CopperType copperType;
  final String description;
  final double weightKg;
  final double pricePerKg;
  final double? gstRate;
  final String? hsnCode;
  final double stockQtyKg;
  final double? reorderLevelKg;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CopperStockData({
    required this.id,
    required this.copperType,
    required this.description,
    required this.weightKg,
    required this.pricePerKg,
    this.gstRate,
    this.hsnCode,
    required this.stockQtyKg,
    this.reorderLevelKg,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['copper_type'] = Variable<String>(
        $CopperStockTable.$convertercopperType.toSql(copperType),
      );
    }
    map['description'] = Variable<String>(description);
    map['weight_kg'] = Variable<double>(weightKg);
    map['price_per_kg'] = Variable<double>(pricePerKg);
    if (!nullToAbsent || gstRate != null) {
      map['gst_rate'] = Variable<double>(gstRate);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    map['stock_qty_kg'] = Variable<double>(stockQtyKg);
    if (!nullToAbsent || reorderLevelKg != null) {
      map['reorder_level_kg'] = Variable<double>(reorderLevelKg);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CopperStockCompanion toCompanion(bool nullToAbsent) {
    return CopperStockCompanion(
      id: Value(id),
      copperType: Value(copperType),
      description: Value(description),
      weightKg: Value(weightKg),
      pricePerKg: Value(pricePerKg),
      gstRate: gstRate == null && nullToAbsent
          ? const Value.absent()
          : Value(gstRate),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      stockQtyKg: Value(stockQtyKg),
      reorderLevelKg: reorderLevelKg == null && nullToAbsent
          ? const Value.absent()
          : Value(reorderLevelKg),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CopperStockData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CopperStockData(
      id: serializer.fromJson<int>(json['id']),
      copperType: $CopperStockTable.$convertercopperType.fromJson(
        serializer.fromJson<String>(json['copperType']),
      ),
      description: serializer.fromJson<String>(json['description']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      pricePerKg: serializer.fromJson<double>(json['pricePerKg']),
      gstRate: serializer.fromJson<double?>(json['gstRate']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      stockQtyKg: serializer.fromJson<double>(json['stockQtyKg']),
      reorderLevelKg: serializer.fromJson<double?>(json['reorderLevelKg']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'copperType': serializer.toJson<String>(
        $CopperStockTable.$convertercopperType.toJson(copperType),
      ),
      'description': serializer.toJson<String>(description),
      'weightKg': serializer.toJson<double>(weightKg),
      'pricePerKg': serializer.toJson<double>(pricePerKg),
      'gstRate': serializer.toJson<double?>(gstRate),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'stockQtyKg': serializer.toJson<double>(stockQtyKg),
      'reorderLevelKg': serializer.toJson<double?>(reorderLevelKg),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CopperStockData copyWith({
    int? id,
    CopperType? copperType,
    String? description,
    double? weightKg,
    double? pricePerKg,
    Value<double?> gstRate = const Value.absent(),
    Value<String?> hsnCode = const Value.absent(),
    double? stockQtyKg,
    Value<double?> reorderLevelKg = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CopperStockData(
    id: id ?? this.id,
    copperType: copperType ?? this.copperType,
    description: description ?? this.description,
    weightKg: weightKg ?? this.weightKg,
    pricePerKg: pricePerKg ?? this.pricePerKg,
    gstRate: gstRate.present ? gstRate.value : this.gstRate,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    stockQtyKg: stockQtyKg ?? this.stockQtyKg,
    reorderLevelKg: reorderLevelKg.present
        ? reorderLevelKg.value
        : this.reorderLevelKg,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CopperStockData copyWithCompanion(CopperStockCompanion data) {
    return CopperStockData(
      id: data.id.present ? data.id.value : this.id,
      copperType: data.copperType.present
          ? data.copperType.value
          : this.copperType,
      description: data.description.present
          ? data.description.value
          : this.description,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      pricePerKg: data.pricePerKg.present
          ? data.pricePerKg.value
          : this.pricePerKg,
      gstRate: data.gstRate.present ? data.gstRate.value : this.gstRate,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      stockQtyKg: data.stockQtyKg.present
          ? data.stockQtyKg.value
          : this.stockQtyKg,
      reorderLevelKg: data.reorderLevelKg.present
          ? data.reorderLevelKg.value
          : this.reorderLevelKg,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CopperStockData(')
          ..write('id: $id, ')
          ..write('copperType: $copperType, ')
          ..write('description: $description, ')
          ..write('weightKg: $weightKg, ')
          ..write('pricePerKg: $pricePerKg, ')
          ..write('gstRate: $gstRate, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('stockQtyKg: $stockQtyKg, ')
          ..write('reorderLevelKg: $reorderLevelKg, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    copperType,
    description,
    weightKg,
    pricePerKg,
    gstRate,
    hsnCode,
    stockQtyKg,
    reorderLevelKg,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CopperStockData &&
          other.id == this.id &&
          other.copperType == this.copperType &&
          other.description == this.description &&
          other.weightKg == this.weightKg &&
          other.pricePerKg == this.pricePerKg &&
          other.gstRate == this.gstRate &&
          other.hsnCode == this.hsnCode &&
          other.stockQtyKg == this.stockQtyKg &&
          other.reorderLevelKg == this.reorderLevelKg &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CopperStockCompanion extends UpdateCompanion<CopperStockData> {
  final Value<int> id;
  final Value<CopperType> copperType;
  final Value<String> description;
  final Value<double> weightKg;
  final Value<double> pricePerKg;
  final Value<double?> gstRate;
  final Value<String?> hsnCode;
  final Value<double> stockQtyKg;
  final Value<double?> reorderLevelKg;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CopperStockCompanion({
    this.id = const Value.absent(),
    this.copperType = const Value.absent(),
    this.description = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.pricePerKg = const Value.absent(),
    this.gstRate = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.stockQtyKg = const Value.absent(),
    this.reorderLevelKg = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CopperStockCompanion.insert({
    this.id = const Value.absent(),
    required CopperType copperType,
    required String description,
    required double weightKg,
    required double pricePerKg,
    this.gstRate = const Value.absent(),
    this.hsnCode = const Value.absent(),
    required double stockQtyKg,
    this.reorderLevelKg = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : copperType = Value(copperType),
       description = Value(description),
       weightKg = Value(weightKg),
       pricePerKg = Value(pricePerKg),
       stockQtyKg = Value(stockQtyKg);
  static Insertable<CopperStockData> custom({
    Expression<int>? id,
    Expression<String>? copperType,
    Expression<String>? description,
    Expression<double>? weightKg,
    Expression<double>? pricePerKg,
    Expression<double>? gstRate,
    Expression<String>? hsnCode,
    Expression<double>? stockQtyKg,
    Expression<double>? reorderLevelKg,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (copperType != null) 'copper_type': copperType,
      if (description != null) 'description': description,
      if (weightKg != null) 'weight_kg': weightKg,
      if (pricePerKg != null) 'price_per_kg': pricePerKg,
      if (gstRate != null) 'gst_rate': gstRate,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (stockQtyKg != null) 'stock_qty_kg': stockQtyKg,
      if (reorderLevelKg != null) 'reorder_level_kg': reorderLevelKg,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CopperStockCompanion copyWith({
    Value<int>? id,
    Value<CopperType>? copperType,
    Value<String>? description,
    Value<double>? weightKg,
    Value<double>? pricePerKg,
    Value<double?>? gstRate,
    Value<String?>? hsnCode,
    Value<double>? stockQtyKg,
    Value<double?>? reorderLevelKg,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CopperStockCompanion(
      id: id ?? this.id,
      copperType: copperType ?? this.copperType,
      description: description ?? this.description,
      weightKg: weightKg ?? this.weightKg,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      gstRate: gstRate ?? this.gstRate,
      hsnCode: hsnCode ?? this.hsnCode,
      stockQtyKg: stockQtyKg ?? this.stockQtyKg,
      reorderLevelKg: reorderLevelKg ?? this.reorderLevelKg,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (copperType.present) {
      map['copper_type'] = Variable<String>(
        $CopperStockTable.$convertercopperType.toSql(copperType.value),
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (pricePerKg.present) {
      map['price_per_kg'] = Variable<double>(pricePerKg.value);
    }
    if (gstRate.present) {
      map['gst_rate'] = Variable<double>(gstRate.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (stockQtyKg.present) {
      map['stock_qty_kg'] = Variable<double>(stockQtyKg.value);
    }
    if (reorderLevelKg.present) {
      map['reorder_level_kg'] = Variable<double>(reorderLevelKg.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CopperStockCompanion(')
          ..write('id: $id, ')
          ..write('copperType: $copperType, ')
          ..write('description: $description, ')
          ..write('weightKg: $weightKg, ')
          ..write('pricePerKg: $pricePerKg, ')
          ..write('gstRate: $gstRate, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('stockQtyKg: $stockQtyKg, ')
          ..write('reorderLevelKg: $reorderLevelKg, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceNoMeta = const VerificationMeta(
    'invoiceNo',
  );
  @override
  late final GeneratedColumn<String> invoiceNo = GeneratedColumn<String>(
    'invoice_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceType, String> invoiceType =
      GeneratedColumn<String>(
        'invoice_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InvoiceType>($InvoicesTable.$converterinvoiceType);
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> invoiceDate = GeneratedColumn<DateTime>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cgstAmountMeta = const VerificationMeta(
    'cgstAmount',
  );
  @override
  late final GeneratedColumn<double> cgstAmount = GeneratedColumn<double>(
    'cgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sgstAmountMeta = const VerificationMeta(
    'sgstAmount',
  );
  @override
  late final GeneratedColumn<double> sgstAmount = GeneratedColumn<double>(
    'sgst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _igstAmountMeta = const VerificationMeta(
    'igstAmount',
  );
  @override
  late final GeneratedColumn<double> igstAmount = GeneratedColumn<double>(
    'igst_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deliveryChargeMeta = const VerificationMeta(
    'deliveryCharge',
  );
  @override
  late final GeneratedColumn<double> deliveryCharge = GeneratedColumn<double>(
    'delivery_charge',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountInWordsMeta = const VerificationMeta(
    'amountInWords',
  );
  @override
  late final GeneratedColumn<String> amountInWords = GeneratedColumn<String>(
    'amount_in_words',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InvoiceStatus>($InvoicesTable.$converterstatus);
  static const VerificationMeta _requiresEWayBillMeta = const VerificationMeta(
    'requiresEWayBill',
  );
  @override
  late final GeneratedColumn<bool> requiresEWayBill = GeneratedColumn<bool>(
    'requires_e_way_bill',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_e_way_bill" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _requiresEInvoiceMeta = const VerificationMeta(
    'requiresEInvoice',
  );
  @override
  late final GeneratedColumn<bool> requiresEInvoice = GeneratedColumn<bool>(
    'requires_e_invoice',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_e_invoice" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _irnNumberMeta = const VerificationMeta(
    'irnNumber',
  );
  @override
  late final GeneratedColumn<String> irnNumber = GeneratedColumn<String>(
    'irn_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _signedPdfPathMeta = const VerificationMeta(
    'signedPdfPath',
  );
  @override
  late final GeneratedColumn<String> signedPdfPath = GeneratedColumn<String>(
    'signed_pdf_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderSentDateMeta = const VerificationMeta(
    'reminderSentDate',
  );
  @override
  late final GeneratedColumn<DateTime> reminderSentDate =
      GeneratedColumn<DateTime>(
        'reminder_sent_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _shipToNameMeta = const VerificationMeta(
    'shipToName',
  );
  @override
  late final GeneratedColumn<String> shipToName = GeneratedColumn<String>(
    'ship_to_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shipToAddressMeta = const VerificationMeta(
    'shipToAddress',
  );
  @override
  late final GeneratedColumn<String> shipToAddress = GeneratedColumn<String>(
    'ship_to_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeOfSupplyMeta = const VerificationMeta(
    'placeOfSupply',
  );
  @override
  late final GeneratedColumn<String> placeOfSupply = GeneratedColumn<String>(
    'place_of_supply',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _poNumberMeta = const VerificationMeta(
    'poNumber',
  );
  @override
  late final GeneratedColumn<String> poNumber = GeneratedColumn<String>(
    'po_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _poDateMeta = const VerificationMeta('poDate');
  @override
  late final GeneratedColumn<DateTime> poDate = GeneratedColumn<DateTime>(
    'po_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpNumberMeta = const VerificationMeta(
    'gpNumber',
  );
  @override
  late final GeneratedColumn<String> gpNumber = GeneratedColumn<String>(
    'gp_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gpDateMeta = const VerificationMeta('gpDate');
  @override
  late final GeneratedColumn<DateTime> gpDate = GeneratedColumn<DateTime>(
    'gp_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentTermDaysMeta = const VerificationMeta(
    'paymentTermDays',
  );
  @override
  late final GeneratedColumn<int> paymentTermDays = GeneratedColumn<int>(
    'payment_term_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNo,
    invoiceType,
    customerId,
    invoiceDate,
    dueDate,
    subtotal,
    cgstAmount,
    sgstAmount,
    igstAmount,
    discountAmount,
    deliveryCharge,
    grandTotal,
    amountInWords,
    status,
    requiresEWayBill,
    requiresEInvoice,
    irnNumber,
    signedPdfPath,
    notes,
    reminderSentDate,
    shipToName,
    shipToAddress,
    placeOfSupply,
    poNumber,
    poDate,
    gpNumber,
    gpDate,
    paymentTermDays,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_no')) {
      context.handle(
        _invoiceNoMeta,
        invoiceNo.isAcceptableOrUnknown(data['invoice_no']!, _invoiceNoMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceNoMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('cgst_amount')) {
      context.handle(
        _cgstAmountMeta,
        cgstAmount.isAcceptableOrUnknown(data['cgst_amount']!, _cgstAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_cgstAmountMeta);
    }
    if (data.containsKey('sgst_amount')) {
      context.handle(
        _sgstAmountMeta,
        sgstAmount.isAcceptableOrUnknown(data['sgst_amount']!, _sgstAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_sgstAmountMeta);
    }
    if (data.containsKey('igst_amount')) {
      context.handle(
        _igstAmountMeta,
        igstAmount.isAcceptableOrUnknown(data['igst_amount']!, _igstAmountMeta),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountAmountMeta);
    }
    if (data.containsKey('delivery_charge')) {
      context.handle(
        _deliveryChargeMeta,
        deliveryCharge.isAcceptableOrUnknown(
          data['delivery_charge']!,
          _deliveryChargeMeta,
        ),
      );
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('amount_in_words')) {
      context.handle(
        _amountInWordsMeta,
        amountInWords.isAcceptableOrUnknown(
          data['amount_in_words']!,
          _amountInWordsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountInWordsMeta);
    }
    if (data.containsKey('requires_e_way_bill')) {
      context.handle(
        _requiresEWayBillMeta,
        requiresEWayBill.isAcceptableOrUnknown(
          data['requires_e_way_bill']!,
          _requiresEWayBillMeta,
        ),
      );
    }
    if (data.containsKey('requires_e_invoice')) {
      context.handle(
        _requiresEInvoiceMeta,
        requiresEInvoice.isAcceptableOrUnknown(
          data['requires_e_invoice']!,
          _requiresEInvoiceMeta,
        ),
      );
    }
    if (data.containsKey('irn_number')) {
      context.handle(
        _irnNumberMeta,
        irnNumber.isAcceptableOrUnknown(data['irn_number']!, _irnNumberMeta),
      );
    }
    if (data.containsKey('signed_pdf_path')) {
      context.handle(
        _signedPdfPathMeta,
        signedPdfPath.isAcceptableOrUnknown(
          data['signed_pdf_path']!,
          _signedPdfPathMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('reminder_sent_date')) {
      context.handle(
        _reminderSentDateMeta,
        reminderSentDate.isAcceptableOrUnknown(
          data['reminder_sent_date']!,
          _reminderSentDateMeta,
        ),
      );
    }
    if (data.containsKey('ship_to_name')) {
      context.handle(
        _shipToNameMeta,
        shipToName.isAcceptableOrUnknown(
          data['ship_to_name']!,
          _shipToNameMeta,
        ),
      );
    }
    if (data.containsKey('ship_to_address')) {
      context.handle(
        _shipToAddressMeta,
        shipToAddress.isAcceptableOrUnknown(
          data['ship_to_address']!,
          _shipToAddressMeta,
        ),
      );
    }
    if (data.containsKey('place_of_supply')) {
      context.handle(
        _placeOfSupplyMeta,
        placeOfSupply.isAcceptableOrUnknown(
          data['place_of_supply']!,
          _placeOfSupplyMeta,
        ),
      );
    }
    if (data.containsKey('po_number')) {
      context.handle(
        _poNumberMeta,
        poNumber.isAcceptableOrUnknown(data['po_number']!, _poNumberMeta),
      );
    }
    if (data.containsKey('po_date')) {
      context.handle(
        _poDateMeta,
        poDate.isAcceptableOrUnknown(data['po_date']!, _poDateMeta),
      );
    }
    if (data.containsKey('gp_number')) {
      context.handle(
        _gpNumberMeta,
        gpNumber.isAcceptableOrUnknown(data['gp_number']!, _gpNumberMeta),
      );
    }
    if (data.containsKey('gp_date')) {
      context.handle(
        _gpDateMeta,
        gpDate.isAcceptableOrUnknown(data['gp_date']!, _gpDateMeta),
      );
    }
    if (data.containsKey('payment_term_days')) {
      context.handle(
        _paymentTermDaysMeta,
        paymentTermDays.isAcceptableOrUnknown(
          data['payment_term_days']!,
          _paymentTermDaysMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_no'],
      )!,
      invoiceType: $InvoicesTable.$converterinvoiceType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}invoice_type'],
        )!,
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}invoice_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      cgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cgst_amount'],
      )!,
      sgstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sgst_amount'],
      )!,
      igstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}igst_amount'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      )!,
      deliveryCharge: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delivery_charge'],
      ),
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grand_total'],
      )!,
      amountInWords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_in_words'],
      )!,
      status: $InvoicesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      requiresEWayBill: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_e_way_bill'],
      )!,
      requiresEInvoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_e_invoice'],
      )!,
      irnNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}irn_number'],
      ),
      signedPdfPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}signed_pdf_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      reminderSentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reminder_sent_date'],
      ),
      shipToName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ship_to_name'],
      ),
      shipToAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ship_to_address'],
      ),
      placeOfSupply: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_of_supply'],
      ),
      poNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_number'],
      ),
      poDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}po_date'],
      ),
      gpNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gp_number'],
      ),
      gpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}gp_date'],
      ),
      paymentTermDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_term_days'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvoiceType, String, String> $converterinvoiceType =
      const EnumNameConverter<InvoiceType>(InvoiceType.values);
  static JsonTypeConverter2<InvoiceStatus, String, String> $converterstatus =
      const EnumNameConverter<InvoiceStatus>(InvoiceStatus.values);
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final String invoiceNo;
  final InvoiceType invoiceType;
  final int customerId;
  final DateTime invoiceDate;
  final DateTime? dueDate;
  final double subtotal;
  final double cgstAmount;
  final double sgstAmount;

  /// Added for standard GST format completeness.
  /// Remains 0.0 for this business since all trade is intra-state (Gujarat),
  /// but required for the 3-column GST breakup on PDFs.
  final double igstAmount;
  final double discountAmount;
  final double? deliveryCharge;
  final double grandTotal;
  final String amountInWords;
  final InvoiceStatus status;
  final bool requiresEWayBill;
  final bool requiresEInvoice;
  final String? irnNumber;
  final String? signedPdfPath;
  final String? notes;
  final DateTime? reminderSentDate;
  final String? shipToName;
  final String? shipToAddress;
  final String? placeOfSupply;
  final String? poNumber;
  final DateTime? poDate;
  final String? gpNumber;
  final DateTime? gpDate;
  final int? paymentTermDays;
  final DateTime createdAt;
  const Invoice({
    required this.id,
    required this.invoiceNo,
    required this.invoiceType,
    required this.customerId,
    required this.invoiceDate,
    this.dueDate,
    required this.subtotal,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.igstAmount,
    required this.discountAmount,
    this.deliveryCharge,
    required this.grandTotal,
    required this.amountInWords,
    required this.status,
    required this.requiresEWayBill,
    required this.requiresEInvoice,
    this.irnNumber,
    this.signedPdfPath,
    this.notes,
    this.reminderSentDate,
    this.shipToName,
    this.shipToAddress,
    this.placeOfSupply,
    this.poNumber,
    this.poDate,
    this.gpNumber,
    this.gpDate,
    this.paymentTermDays,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_no'] = Variable<String>(invoiceNo);
    {
      map['invoice_type'] = Variable<String>(
        $InvoicesTable.$converterinvoiceType.toSql(invoiceType),
      );
    }
    map['customer_id'] = Variable<int>(customerId);
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['cgst_amount'] = Variable<double>(cgstAmount);
    map['sgst_amount'] = Variable<double>(sgstAmount);
    map['igst_amount'] = Variable<double>(igstAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    if (!nullToAbsent || deliveryCharge != null) {
      map['delivery_charge'] = Variable<double>(deliveryCharge);
    }
    map['grand_total'] = Variable<double>(grandTotal);
    map['amount_in_words'] = Variable<String>(amountInWords);
    {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatus.toSql(status),
      );
    }
    map['requires_e_way_bill'] = Variable<bool>(requiresEWayBill);
    map['requires_e_invoice'] = Variable<bool>(requiresEInvoice);
    if (!nullToAbsent || irnNumber != null) {
      map['irn_number'] = Variable<String>(irnNumber);
    }
    if (!nullToAbsent || signedPdfPath != null) {
      map['signed_pdf_path'] = Variable<String>(signedPdfPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || reminderSentDate != null) {
      map['reminder_sent_date'] = Variable<DateTime>(reminderSentDate);
    }
    if (!nullToAbsent || shipToName != null) {
      map['ship_to_name'] = Variable<String>(shipToName);
    }
    if (!nullToAbsent || shipToAddress != null) {
      map['ship_to_address'] = Variable<String>(shipToAddress);
    }
    if (!nullToAbsent || placeOfSupply != null) {
      map['place_of_supply'] = Variable<String>(placeOfSupply);
    }
    if (!nullToAbsent || poNumber != null) {
      map['po_number'] = Variable<String>(poNumber);
    }
    if (!nullToAbsent || poDate != null) {
      map['po_date'] = Variable<DateTime>(poDate);
    }
    if (!nullToAbsent || gpNumber != null) {
      map['gp_number'] = Variable<String>(gpNumber);
    }
    if (!nullToAbsent || gpDate != null) {
      map['gp_date'] = Variable<DateTime>(gpDate);
    }
    if (!nullToAbsent || paymentTermDays != null) {
      map['payment_term_days'] = Variable<int>(paymentTermDays);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNo: Value(invoiceNo),
      invoiceType: Value(invoiceType),
      customerId: Value(customerId),
      invoiceDate: Value(invoiceDate),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      subtotal: Value(subtotal),
      cgstAmount: Value(cgstAmount),
      sgstAmount: Value(sgstAmount),
      igstAmount: Value(igstAmount),
      discountAmount: Value(discountAmount),
      deliveryCharge: deliveryCharge == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryCharge),
      grandTotal: Value(grandTotal),
      amountInWords: Value(amountInWords),
      status: Value(status),
      requiresEWayBill: Value(requiresEWayBill),
      requiresEInvoice: Value(requiresEInvoice),
      irnNumber: irnNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(irnNumber),
      signedPdfPath: signedPdfPath == null && nullToAbsent
          ? const Value.absent()
          : Value(signedPdfPath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      reminderSentDate: reminderSentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderSentDate),
      shipToName: shipToName == null && nullToAbsent
          ? const Value.absent()
          : Value(shipToName),
      shipToAddress: shipToAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(shipToAddress),
      placeOfSupply: placeOfSupply == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfSupply),
      poNumber: poNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(poNumber),
      poDate: poDate == null && nullToAbsent
          ? const Value.absent()
          : Value(poDate),
      gpNumber: gpNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gpNumber),
      gpDate: gpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(gpDate),
      paymentTermDays: paymentTermDays == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentTermDays),
      createdAt: Value(createdAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNo: serializer.fromJson<String>(json['invoiceNo']),
      invoiceType: $InvoicesTable.$converterinvoiceType.fromJson(
        serializer.fromJson<String>(json['invoiceType']),
      ),
      customerId: serializer.fromJson<int>(json['customerId']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      cgstAmount: serializer.fromJson<double>(json['cgstAmount']),
      sgstAmount: serializer.fromJson<double>(json['sgstAmount']),
      igstAmount: serializer.fromJson<double>(json['igstAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      deliveryCharge: serializer.fromJson<double?>(json['deliveryCharge']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      amountInWords: serializer.fromJson<String>(json['amountInWords']),
      status: $InvoicesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      requiresEWayBill: serializer.fromJson<bool>(json['requiresEWayBill']),
      requiresEInvoice: serializer.fromJson<bool>(json['requiresEInvoice']),
      irnNumber: serializer.fromJson<String?>(json['irnNumber']),
      signedPdfPath: serializer.fromJson<String?>(json['signedPdfPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      reminderSentDate: serializer.fromJson<DateTime?>(
        json['reminderSentDate'],
      ),
      shipToName: serializer.fromJson<String?>(json['shipToName']),
      shipToAddress: serializer.fromJson<String?>(json['shipToAddress']),
      placeOfSupply: serializer.fromJson<String?>(json['placeOfSupply']),
      poNumber: serializer.fromJson<String?>(json['poNumber']),
      poDate: serializer.fromJson<DateTime?>(json['poDate']),
      gpNumber: serializer.fromJson<String?>(json['gpNumber']),
      gpDate: serializer.fromJson<DateTime?>(json['gpDate']),
      paymentTermDays: serializer.fromJson<int?>(json['paymentTermDays']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNo': serializer.toJson<String>(invoiceNo),
      'invoiceType': serializer.toJson<String>(
        $InvoicesTable.$converterinvoiceType.toJson(invoiceType),
      ),
      'customerId': serializer.toJson<int>(customerId),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'subtotal': serializer.toJson<double>(subtotal),
      'cgstAmount': serializer.toJson<double>(cgstAmount),
      'sgstAmount': serializer.toJson<double>(sgstAmount),
      'igstAmount': serializer.toJson<double>(igstAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'deliveryCharge': serializer.toJson<double?>(deliveryCharge),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'amountInWords': serializer.toJson<String>(amountInWords),
      'status': serializer.toJson<String>(
        $InvoicesTable.$converterstatus.toJson(status),
      ),
      'requiresEWayBill': serializer.toJson<bool>(requiresEWayBill),
      'requiresEInvoice': serializer.toJson<bool>(requiresEInvoice),
      'irnNumber': serializer.toJson<String?>(irnNumber),
      'signedPdfPath': serializer.toJson<String?>(signedPdfPath),
      'notes': serializer.toJson<String?>(notes),
      'reminderSentDate': serializer.toJson<DateTime?>(reminderSentDate),
      'shipToName': serializer.toJson<String?>(shipToName),
      'shipToAddress': serializer.toJson<String?>(shipToAddress),
      'placeOfSupply': serializer.toJson<String?>(placeOfSupply),
      'poNumber': serializer.toJson<String?>(poNumber),
      'poDate': serializer.toJson<DateTime?>(poDate),
      'gpNumber': serializer.toJson<String?>(gpNumber),
      'gpDate': serializer.toJson<DateTime?>(gpDate),
      'paymentTermDays': serializer.toJson<int?>(paymentTermDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Invoice copyWith({
    int? id,
    String? invoiceNo,
    InvoiceType? invoiceType,
    int? customerId,
    DateTime? invoiceDate,
    Value<DateTime?> dueDate = const Value.absent(),
    double? subtotal,
    double? cgstAmount,
    double? sgstAmount,
    double? igstAmount,
    double? discountAmount,
    Value<double?> deliveryCharge = const Value.absent(),
    double? grandTotal,
    String? amountInWords,
    InvoiceStatus? status,
    bool? requiresEWayBill,
    bool? requiresEInvoice,
    Value<String?> irnNumber = const Value.absent(),
    Value<String?> signedPdfPath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> reminderSentDate = const Value.absent(),
    Value<String?> shipToName = const Value.absent(),
    Value<String?> shipToAddress = const Value.absent(),
    Value<String?> placeOfSupply = const Value.absent(),
    Value<String?> poNumber = const Value.absent(),
    Value<DateTime?> poDate = const Value.absent(),
    Value<String?> gpNumber = const Value.absent(),
    Value<DateTime?> gpDate = const Value.absent(),
    Value<int?> paymentTermDays = const Value.absent(),
    DateTime? createdAt,
  }) => Invoice(
    id: id ?? this.id,
    invoiceNo: invoiceNo ?? this.invoiceNo,
    invoiceType: invoiceType ?? this.invoiceType,
    customerId: customerId ?? this.customerId,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    subtotal: subtotal ?? this.subtotal,
    cgstAmount: cgstAmount ?? this.cgstAmount,
    sgstAmount: sgstAmount ?? this.sgstAmount,
    igstAmount: igstAmount ?? this.igstAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    deliveryCharge: deliveryCharge.present
        ? deliveryCharge.value
        : this.deliveryCharge,
    grandTotal: grandTotal ?? this.grandTotal,
    amountInWords: amountInWords ?? this.amountInWords,
    status: status ?? this.status,
    requiresEWayBill: requiresEWayBill ?? this.requiresEWayBill,
    requiresEInvoice: requiresEInvoice ?? this.requiresEInvoice,
    irnNumber: irnNumber.present ? irnNumber.value : this.irnNumber,
    signedPdfPath: signedPdfPath.present
        ? signedPdfPath.value
        : this.signedPdfPath,
    notes: notes.present ? notes.value : this.notes,
    reminderSentDate: reminderSentDate.present
        ? reminderSentDate.value
        : this.reminderSentDate,
    shipToName: shipToName.present ? shipToName.value : this.shipToName,
    shipToAddress: shipToAddress.present
        ? shipToAddress.value
        : this.shipToAddress,
    placeOfSupply: placeOfSupply.present
        ? placeOfSupply.value
        : this.placeOfSupply,
    poNumber: poNumber.present ? poNumber.value : this.poNumber,
    poDate: poDate.present ? poDate.value : this.poDate,
    gpNumber: gpNumber.present ? gpNumber.value : this.gpNumber,
    gpDate: gpDate.present ? gpDate.value : this.gpDate,
    paymentTermDays: paymentTermDays.present
        ? paymentTermDays.value
        : this.paymentTermDays,
    createdAt: createdAt ?? this.createdAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNo: data.invoiceNo.present ? data.invoiceNo.value : this.invoiceNo,
      invoiceType: data.invoiceType.present
          ? data.invoiceType.value
          : this.invoiceType,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      cgstAmount: data.cgstAmount.present
          ? data.cgstAmount.value
          : this.cgstAmount,
      sgstAmount: data.sgstAmount.present
          ? data.sgstAmount.value
          : this.sgstAmount,
      igstAmount: data.igstAmount.present
          ? data.igstAmount.value
          : this.igstAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      deliveryCharge: data.deliveryCharge.present
          ? data.deliveryCharge.value
          : this.deliveryCharge,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      amountInWords: data.amountInWords.present
          ? data.amountInWords.value
          : this.amountInWords,
      status: data.status.present ? data.status.value : this.status,
      requiresEWayBill: data.requiresEWayBill.present
          ? data.requiresEWayBill.value
          : this.requiresEWayBill,
      requiresEInvoice: data.requiresEInvoice.present
          ? data.requiresEInvoice.value
          : this.requiresEInvoice,
      irnNumber: data.irnNumber.present ? data.irnNumber.value : this.irnNumber,
      signedPdfPath: data.signedPdfPath.present
          ? data.signedPdfPath.value
          : this.signedPdfPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      reminderSentDate: data.reminderSentDate.present
          ? data.reminderSentDate.value
          : this.reminderSentDate,
      shipToName: data.shipToName.present
          ? data.shipToName.value
          : this.shipToName,
      shipToAddress: data.shipToAddress.present
          ? data.shipToAddress.value
          : this.shipToAddress,
      placeOfSupply: data.placeOfSupply.present
          ? data.placeOfSupply.value
          : this.placeOfSupply,
      poNumber: data.poNumber.present ? data.poNumber.value : this.poNumber,
      poDate: data.poDate.present ? data.poDate.value : this.poDate,
      gpNumber: data.gpNumber.present ? data.gpNumber.value : this.gpNumber,
      gpDate: data.gpDate.present ? data.gpDate.value : this.gpDate,
      paymentTermDays: data.paymentTermDays.present
          ? data.paymentTermDays.value
          : this.paymentTermDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('invoiceType: $invoiceType, ')
          ..write('customerId: $customerId, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('subtotal: $subtotal, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('igstAmount: $igstAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('deliveryCharge: $deliveryCharge, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('status: $status, ')
          ..write('requiresEWayBill: $requiresEWayBill, ')
          ..write('requiresEInvoice: $requiresEInvoice, ')
          ..write('irnNumber: $irnNumber, ')
          ..write('signedPdfPath: $signedPdfPath, ')
          ..write('notes: $notes, ')
          ..write('reminderSentDate: $reminderSentDate, ')
          ..write('shipToName: $shipToName, ')
          ..write('shipToAddress: $shipToAddress, ')
          ..write('placeOfSupply: $placeOfSupply, ')
          ..write('poNumber: $poNumber, ')
          ..write('poDate: $poDate, ')
          ..write('gpNumber: $gpNumber, ')
          ..write('gpDate: $gpDate, ')
          ..write('paymentTermDays: $paymentTermDays, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    invoiceNo,
    invoiceType,
    customerId,
    invoiceDate,
    dueDate,
    subtotal,
    cgstAmount,
    sgstAmount,
    igstAmount,
    discountAmount,
    deliveryCharge,
    grandTotal,
    amountInWords,
    status,
    requiresEWayBill,
    requiresEInvoice,
    irnNumber,
    signedPdfPath,
    notes,
    reminderSentDate,
    shipToName,
    shipToAddress,
    placeOfSupply,
    poNumber,
    poDate,
    gpNumber,
    gpDate,
    paymentTermDays,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.invoiceNo == this.invoiceNo &&
          other.invoiceType == this.invoiceType &&
          other.customerId == this.customerId &&
          other.invoiceDate == this.invoiceDate &&
          other.dueDate == this.dueDate &&
          other.subtotal == this.subtotal &&
          other.cgstAmount == this.cgstAmount &&
          other.sgstAmount == this.sgstAmount &&
          other.igstAmount == this.igstAmount &&
          other.discountAmount == this.discountAmount &&
          other.deliveryCharge == this.deliveryCharge &&
          other.grandTotal == this.grandTotal &&
          other.amountInWords == this.amountInWords &&
          other.status == this.status &&
          other.requiresEWayBill == this.requiresEWayBill &&
          other.requiresEInvoice == this.requiresEInvoice &&
          other.irnNumber == this.irnNumber &&
          other.signedPdfPath == this.signedPdfPath &&
          other.notes == this.notes &&
          other.reminderSentDate == this.reminderSentDate &&
          other.shipToName == this.shipToName &&
          other.shipToAddress == this.shipToAddress &&
          other.placeOfSupply == this.placeOfSupply &&
          other.poNumber == this.poNumber &&
          other.poDate == this.poDate &&
          other.gpNumber == this.gpNumber &&
          other.gpDate == this.gpDate &&
          other.paymentTermDays == this.paymentTermDays &&
          other.createdAt == this.createdAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<String> invoiceNo;
  final Value<InvoiceType> invoiceType;
  final Value<int> customerId;
  final Value<DateTime> invoiceDate;
  final Value<DateTime?> dueDate;
  final Value<double> subtotal;
  final Value<double> cgstAmount;
  final Value<double> sgstAmount;
  final Value<double> igstAmount;
  final Value<double> discountAmount;
  final Value<double?> deliveryCharge;
  final Value<double> grandTotal;
  final Value<String> amountInWords;
  final Value<InvoiceStatus> status;
  final Value<bool> requiresEWayBill;
  final Value<bool> requiresEInvoice;
  final Value<String?> irnNumber;
  final Value<String?> signedPdfPath;
  final Value<String?> notes;
  final Value<DateTime?> reminderSentDate;
  final Value<String?> shipToName;
  final Value<String?> shipToAddress;
  final Value<String?> placeOfSupply;
  final Value<String?> poNumber;
  final Value<DateTime?> poDate;
  final Value<String?> gpNumber;
  final Value<DateTime?> gpDate;
  final Value<int?> paymentTermDays;
  final Value<DateTime> createdAt;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNo = const Value.absent(),
    this.invoiceType = const Value.absent(),
    this.customerId = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.cgstAmount = const Value.absent(),
    this.sgstAmount = const Value.absent(),
    this.igstAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.deliveryCharge = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.amountInWords = const Value.absent(),
    this.status = const Value.absent(),
    this.requiresEWayBill = const Value.absent(),
    this.requiresEInvoice = const Value.absent(),
    this.irnNumber = const Value.absent(),
    this.signedPdfPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.reminderSentDate = const Value.absent(),
    this.shipToName = const Value.absent(),
    this.shipToAddress = const Value.absent(),
    this.placeOfSupply = const Value.absent(),
    this.poNumber = const Value.absent(),
    this.poDate = const Value.absent(),
    this.gpNumber = const Value.absent(),
    this.gpDate = const Value.absent(),
    this.paymentTermDays = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNo,
    required InvoiceType invoiceType,
    required int customerId,
    required DateTime invoiceDate,
    this.dueDate = const Value.absent(),
    required double subtotal,
    required double cgstAmount,
    required double sgstAmount,
    this.igstAmount = const Value.absent(),
    required double discountAmount,
    this.deliveryCharge = const Value.absent(),
    required double grandTotal,
    required String amountInWords,
    required InvoiceStatus status,
    this.requiresEWayBill = const Value.absent(),
    this.requiresEInvoice = const Value.absent(),
    this.irnNumber = const Value.absent(),
    this.signedPdfPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.reminderSentDate = const Value.absent(),
    this.shipToName = const Value.absent(),
    this.shipToAddress = const Value.absent(),
    this.placeOfSupply = const Value.absent(),
    this.poNumber = const Value.absent(),
    this.poDate = const Value.absent(),
    this.gpNumber = const Value.absent(),
    this.gpDate = const Value.absent(),
    this.paymentTermDays = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : invoiceNo = Value(invoiceNo),
       invoiceType = Value(invoiceType),
       customerId = Value(customerId),
       invoiceDate = Value(invoiceDate),
       subtotal = Value(subtotal),
       cgstAmount = Value(cgstAmount),
       sgstAmount = Value(sgstAmount),
       discountAmount = Value(discountAmount),
       grandTotal = Value(grandTotal),
       amountInWords = Value(amountInWords),
       status = Value(status);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<String>? invoiceNo,
    Expression<String>? invoiceType,
    Expression<int>? customerId,
    Expression<DateTime>? invoiceDate,
    Expression<DateTime>? dueDate,
    Expression<double>? subtotal,
    Expression<double>? cgstAmount,
    Expression<double>? sgstAmount,
    Expression<double>? igstAmount,
    Expression<double>? discountAmount,
    Expression<double>? deliveryCharge,
    Expression<double>? grandTotal,
    Expression<String>? amountInWords,
    Expression<String>? status,
    Expression<bool>? requiresEWayBill,
    Expression<bool>? requiresEInvoice,
    Expression<String>? irnNumber,
    Expression<String>? signedPdfPath,
    Expression<String>? notes,
    Expression<DateTime>? reminderSentDate,
    Expression<String>? shipToName,
    Expression<String>? shipToAddress,
    Expression<String>? placeOfSupply,
    Expression<String>? poNumber,
    Expression<DateTime>? poDate,
    Expression<String>? gpNumber,
    Expression<DateTime>? gpDate,
    Expression<int>? paymentTermDays,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNo != null) 'invoice_no': invoiceNo,
      if (invoiceType != null) 'invoice_type': invoiceType,
      if (customerId != null) 'customer_id': customerId,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (dueDate != null) 'due_date': dueDate,
      if (subtotal != null) 'subtotal': subtotal,
      if (cgstAmount != null) 'cgst_amount': cgstAmount,
      if (sgstAmount != null) 'sgst_amount': sgstAmount,
      if (igstAmount != null) 'igst_amount': igstAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (deliveryCharge != null) 'delivery_charge': deliveryCharge,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (amountInWords != null) 'amount_in_words': amountInWords,
      if (status != null) 'status': status,
      if (requiresEWayBill != null) 'requires_e_way_bill': requiresEWayBill,
      if (requiresEInvoice != null) 'requires_e_invoice': requiresEInvoice,
      if (irnNumber != null) 'irn_number': irnNumber,
      if (signedPdfPath != null) 'signed_pdf_path': signedPdfPath,
      if (notes != null) 'notes': notes,
      if (reminderSentDate != null) 'reminder_sent_date': reminderSentDate,
      if (shipToName != null) 'ship_to_name': shipToName,
      if (shipToAddress != null) 'ship_to_address': shipToAddress,
      if (placeOfSupply != null) 'place_of_supply': placeOfSupply,
      if (poNumber != null) 'po_number': poNumber,
      if (poDate != null) 'po_date': poDate,
      if (gpNumber != null) 'gp_number': gpNumber,
      if (gpDate != null) 'gp_date': gpDate,
      if (paymentTermDays != null) 'payment_term_days': paymentTermDays,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceNo,
    Value<InvoiceType>? invoiceType,
    Value<int>? customerId,
    Value<DateTime>? invoiceDate,
    Value<DateTime?>? dueDate,
    Value<double>? subtotal,
    Value<double>? cgstAmount,
    Value<double>? sgstAmount,
    Value<double>? igstAmount,
    Value<double>? discountAmount,
    Value<double?>? deliveryCharge,
    Value<double>? grandTotal,
    Value<String>? amountInWords,
    Value<InvoiceStatus>? status,
    Value<bool>? requiresEWayBill,
    Value<bool>? requiresEInvoice,
    Value<String?>? irnNumber,
    Value<String?>? signedPdfPath,
    Value<String?>? notes,
    Value<DateTime?>? reminderSentDate,
    Value<String?>? shipToName,
    Value<String?>? shipToAddress,
    Value<String?>? placeOfSupply,
    Value<String?>? poNumber,
    Value<DateTime?>? poDate,
    Value<String?>? gpNumber,
    Value<DateTime?>? gpDate,
    Value<int?>? paymentTermDays,
    Value<DateTime>? createdAt,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      invoiceType: invoiceType ?? this.invoiceType,
      customerId: customerId ?? this.customerId,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      subtotal: subtotal ?? this.subtotal,
      cgstAmount: cgstAmount ?? this.cgstAmount,
      sgstAmount: sgstAmount ?? this.sgstAmount,
      igstAmount: igstAmount ?? this.igstAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      grandTotal: grandTotal ?? this.grandTotal,
      amountInWords: amountInWords ?? this.amountInWords,
      status: status ?? this.status,
      requiresEWayBill: requiresEWayBill ?? this.requiresEWayBill,
      requiresEInvoice: requiresEInvoice ?? this.requiresEInvoice,
      irnNumber: irnNumber ?? this.irnNumber,
      signedPdfPath: signedPdfPath ?? this.signedPdfPath,
      notes: notes ?? this.notes,
      reminderSentDate: reminderSentDate ?? this.reminderSentDate,
      shipToName: shipToName ?? this.shipToName,
      shipToAddress: shipToAddress ?? this.shipToAddress,
      placeOfSupply: placeOfSupply ?? this.placeOfSupply,
      poNumber: poNumber ?? this.poNumber,
      poDate: poDate ?? this.poDate,
      gpNumber: gpNumber ?? this.gpNumber,
      gpDate: gpDate ?? this.gpDate,
      paymentTermDays: paymentTermDays ?? this.paymentTermDays,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNo.present) {
      map['invoice_no'] = Variable<String>(invoiceNo.value);
    }
    if (invoiceType.present) {
      map['invoice_type'] = Variable<String>(
        $InvoicesTable.$converterinvoiceType.toSql(invoiceType.value),
      );
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<DateTime>(invoiceDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (cgstAmount.present) {
      map['cgst_amount'] = Variable<double>(cgstAmount.value);
    }
    if (sgstAmount.present) {
      map['sgst_amount'] = Variable<double>(sgstAmount.value);
    }
    if (igstAmount.present) {
      map['igst_amount'] = Variable<double>(igstAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (deliveryCharge.present) {
      map['delivery_charge'] = Variable<double>(deliveryCharge.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (amountInWords.present) {
      map['amount_in_words'] = Variable<String>(amountInWords.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatus.toSql(status.value),
      );
    }
    if (requiresEWayBill.present) {
      map['requires_e_way_bill'] = Variable<bool>(requiresEWayBill.value);
    }
    if (requiresEInvoice.present) {
      map['requires_e_invoice'] = Variable<bool>(requiresEInvoice.value);
    }
    if (irnNumber.present) {
      map['irn_number'] = Variable<String>(irnNumber.value);
    }
    if (signedPdfPath.present) {
      map['signed_pdf_path'] = Variable<String>(signedPdfPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (reminderSentDate.present) {
      map['reminder_sent_date'] = Variable<DateTime>(reminderSentDate.value);
    }
    if (shipToName.present) {
      map['ship_to_name'] = Variable<String>(shipToName.value);
    }
    if (shipToAddress.present) {
      map['ship_to_address'] = Variable<String>(shipToAddress.value);
    }
    if (placeOfSupply.present) {
      map['place_of_supply'] = Variable<String>(placeOfSupply.value);
    }
    if (poNumber.present) {
      map['po_number'] = Variable<String>(poNumber.value);
    }
    if (poDate.present) {
      map['po_date'] = Variable<DateTime>(poDate.value);
    }
    if (gpNumber.present) {
      map['gp_number'] = Variable<String>(gpNumber.value);
    }
    if (gpDate.present) {
      map['gp_date'] = Variable<DateTime>(gpDate.value);
    }
    if (paymentTermDays.present) {
      map['payment_term_days'] = Variable<int>(paymentTermDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNo: $invoiceNo, ')
          ..write('invoiceType: $invoiceType, ')
          ..write('customerId: $customerId, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('subtotal: $subtotal, ')
          ..write('cgstAmount: $cgstAmount, ')
          ..write('sgstAmount: $sgstAmount, ')
          ..write('igstAmount: $igstAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('deliveryCharge: $deliveryCharge, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('status: $status, ')
          ..write('requiresEWayBill: $requiresEWayBill, ')
          ..write('requiresEInvoice: $requiresEInvoice, ')
          ..write('irnNumber: $irnNumber, ')
          ..write('signedPdfPath: $signedPdfPath, ')
          ..write('notes: $notes, ')
          ..write('reminderSentDate: $reminderSentDate, ')
          ..write('shipToName: $shipToName, ')
          ..write('shipToAddress: $shipToAddress, ')
          ..write('placeOfSupply: $placeOfSupply, ')
          ..write('poNumber: $poNumber, ')
          ..write('poDate: $poDate, ')
          ..write('gpNumber: $gpNumber, ')
          ..write('gpDate: $gpDate, ')
          ..write('paymentTermDays: $paymentTermDays, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $InvoiceItemsTable extends InvoiceItems
    with TableInfo<$InvoiceItemsTable, InvoiceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemSourceType, String>
  itemSourceType = GeneratedColumn<String>(
    'item_source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ItemSourceType>($InvoiceItemsTable.$converteritemSourceType);
  static const VerificationMeta _motorJobIdMeta = const VerificationMeta(
    'motorJobId',
  );
  @override
  late final GeneratedColumn<int> motorJobId = GeneratedColumn<int>(
    'motor_job_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES motor_jobs (id)',
    ),
  );
  static const VerificationMeta _copperStockIdMeta = const VerificationMeta(
    'copperStockId',
  );
  @override
  late final GeneratedColumn<int> copperStockId = GeneratedColumn<int>(
    'copper_stock_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES copper_stock (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateRsMeta = const VerificationMeta('rateRs');
  @override
  late final GeneratedColumn<String> rateRs = GeneratedColumn<String>(
    'rate_rs',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hsnCodeMeta = const VerificationMeta(
    'hsnCode',
  );
  @override
  late final GeneratedColumn<String> hsnCode = GeneratedColumn<String>(
    'hsn_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstRateMeta = const VerificationMeta(
    'gstRate',
  );
  @override
  late final GeneratedColumn<double> gstRate = GeneratedColumn<double>(
    'gst_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    itemSourceType,
    motorJobId,
    copperStockId,
    description,
    rateRs,
    hsnCode,
    qty,
    unitPrice,
    gstRate,
    lineTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('motor_job_id')) {
      context.handle(
        _motorJobIdMeta,
        motorJobId.isAcceptableOrUnknown(
          data['motor_job_id']!,
          _motorJobIdMeta,
        ),
      );
    }
    if (data.containsKey('copper_stock_id')) {
      context.handle(
        _copperStockIdMeta,
        copperStockId.isAcceptableOrUnknown(
          data['copper_stock_id']!,
          _copperStockIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('rate_rs')) {
      context.handle(
        _rateRsMeta,
        rateRs.isAcceptableOrUnknown(data['rate_rs']!, _rateRsMeta),
      );
    }
    if (data.containsKey('hsn_code')) {
      context.handle(
        _hsnCodeMeta,
        hsnCode.isAcceptableOrUnknown(data['hsn_code']!, _hsnCodeMeta),
      );
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('gst_rate')) {
      context.handle(
        _gstRateMeta,
        gstRate.isAcceptableOrUnknown(data['gst_rate']!, _gstRateMeta),
      );
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      itemSourceType: $InvoiceItemsTable.$converteritemSourceType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}item_source_type'],
        )!,
      ),
      motorJobId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motor_job_id'],
      ),
      copperStockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}copper_stock_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      rateRs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate_rs'],
      ),
      hsnCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hsn_code'],
      ),
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      gstRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_rate'],
      ),
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_total'],
      )!,
    );
  }

  @override
  $InvoiceItemsTable createAlias(String alias) {
    return $InvoiceItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemSourceType, String, String>
  $converteritemSourceType = const EnumNameConverter<ItemSourceType>(
    ItemSourceType.values,
  );
}

class InvoiceItem extends DataClass implements Insertable<InvoiceItem> {
  final int id;
  final int invoiceId;
  final ItemSourceType itemSourceType;
  final int? motorJobId;
  final int? copperStockId;
  final String description;
  final String? rateRs;
  final String? hsnCode;
  final double? qty;
  final double unitPrice;
  final double? gstRate;
  final double lineTotal;
  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.itemSourceType,
    this.motorJobId,
    this.copperStockId,
    required this.description,
    this.rateRs,
    this.hsnCode,
    this.qty,
    required this.unitPrice,
    this.gstRate,
    required this.lineTotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    {
      map['item_source_type'] = Variable<String>(
        $InvoiceItemsTable.$converteritemSourceType.toSql(itemSourceType),
      );
    }
    if (!nullToAbsent || motorJobId != null) {
      map['motor_job_id'] = Variable<int>(motorJobId);
    }
    if (!nullToAbsent || copperStockId != null) {
      map['copper_stock_id'] = Variable<int>(copperStockId);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || rateRs != null) {
      map['rate_rs'] = Variable<String>(rateRs);
    }
    if (!nullToAbsent || hsnCode != null) {
      map['hsn_code'] = Variable<String>(hsnCode);
    }
    if (!nullToAbsent || qty != null) {
      map['qty'] = Variable<double>(qty);
    }
    map['unit_price'] = Variable<double>(unitPrice);
    if (!nullToAbsent || gstRate != null) {
      map['gst_rate'] = Variable<double>(gstRate);
    }
    map['line_total'] = Variable<double>(lineTotal);
    return map;
  }

  InvoiceItemsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceItemsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      itemSourceType: Value(itemSourceType),
      motorJobId: motorJobId == null && nullToAbsent
          ? const Value.absent()
          : Value(motorJobId),
      copperStockId: copperStockId == null && nullToAbsent
          ? const Value.absent()
          : Value(copperStockId),
      description: Value(description),
      rateRs: rateRs == null && nullToAbsent
          ? const Value.absent()
          : Value(rateRs),
      hsnCode: hsnCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnCode),
      qty: qty == null && nullToAbsent ? const Value.absent() : Value(qty),
      unitPrice: Value(unitPrice),
      gstRate: gstRate == null && nullToAbsent
          ? const Value.absent()
          : Value(gstRate),
      lineTotal: Value(lineTotal),
    );
  }

  factory InvoiceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceItem(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      itemSourceType: $InvoiceItemsTable.$converteritemSourceType.fromJson(
        serializer.fromJson<String>(json['itemSourceType']),
      ),
      motorJobId: serializer.fromJson<int?>(json['motorJobId']),
      copperStockId: serializer.fromJson<int?>(json['copperStockId']),
      description: serializer.fromJson<String>(json['description']),
      rateRs: serializer.fromJson<String?>(json['rateRs']),
      hsnCode: serializer.fromJson<String?>(json['hsnCode']),
      qty: serializer.fromJson<double?>(json['qty']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      gstRate: serializer.fromJson<double?>(json['gstRate']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'itemSourceType': serializer.toJson<String>(
        $InvoiceItemsTable.$converteritemSourceType.toJson(itemSourceType),
      ),
      'motorJobId': serializer.toJson<int?>(motorJobId),
      'copperStockId': serializer.toJson<int?>(copperStockId),
      'description': serializer.toJson<String>(description),
      'rateRs': serializer.toJson<String?>(rateRs),
      'hsnCode': serializer.toJson<String?>(hsnCode),
      'qty': serializer.toJson<double?>(qty),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'gstRate': serializer.toJson<double?>(gstRate),
      'lineTotal': serializer.toJson<double>(lineTotal),
    };
  }

  InvoiceItem copyWith({
    int? id,
    int? invoiceId,
    ItemSourceType? itemSourceType,
    Value<int?> motorJobId = const Value.absent(),
    Value<int?> copperStockId = const Value.absent(),
    String? description,
    Value<String?> rateRs = const Value.absent(),
    Value<String?> hsnCode = const Value.absent(),
    Value<double?> qty = const Value.absent(),
    double? unitPrice,
    Value<double?> gstRate = const Value.absent(),
    double? lineTotal,
  }) => InvoiceItem(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    itemSourceType: itemSourceType ?? this.itemSourceType,
    motorJobId: motorJobId.present ? motorJobId.value : this.motorJobId,
    copperStockId: copperStockId.present
        ? copperStockId.value
        : this.copperStockId,
    description: description ?? this.description,
    rateRs: rateRs.present ? rateRs.value : this.rateRs,
    hsnCode: hsnCode.present ? hsnCode.value : this.hsnCode,
    qty: qty.present ? qty.value : this.qty,
    unitPrice: unitPrice ?? this.unitPrice,
    gstRate: gstRate.present ? gstRate.value : this.gstRate,
    lineTotal: lineTotal ?? this.lineTotal,
  );
  InvoiceItem copyWithCompanion(InvoiceItemsCompanion data) {
    return InvoiceItem(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      itemSourceType: data.itemSourceType.present
          ? data.itemSourceType.value
          : this.itemSourceType,
      motorJobId: data.motorJobId.present
          ? data.motorJobId.value
          : this.motorJobId,
      copperStockId: data.copperStockId.present
          ? data.copperStockId.value
          : this.copperStockId,
      description: data.description.present
          ? data.description.value
          : this.description,
      rateRs: data.rateRs.present ? data.rateRs.value : this.rateRs,
      hsnCode: data.hsnCode.present ? data.hsnCode.value : this.hsnCode,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      gstRate: data.gstRate.present ? data.gstRate.value : this.gstRate,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItem(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemSourceType: $itemSourceType, ')
          ..write('motorJobId: $motorJobId, ')
          ..write('copperStockId: $copperStockId, ')
          ..write('description: $description, ')
          ..write('rateRs: $rateRs, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('gstRate: $gstRate, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    itemSourceType,
    motorJobId,
    copperStockId,
    description,
    rateRs,
    hsnCode,
    qty,
    unitPrice,
    gstRate,
    lineTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceItem &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.itemSourceType == this.itemSourceType &&
          other.motorJobId == this.motorJobId &&
          other.copperStockId == this.copperStockId &&
          other.description == this.description &&
          other.rateRs == this.rateRs &&
          other.hsnCode == this.hsnCode &&
          other.qty == this.qty &&
          other.unitPrice == this.unitPrice &&
          other.gstRate == this.gstRate &&
          other.lineTotal == this.lineTotal);
}

class InvoiceItemsCompanion extends UpdateCompanion<InvoiceItem> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<ItemSourceType> itemSourceType;
  final Value<int?> motorJobId;
  final Value<int?> copperStockId;
  final Value<String> description;
  final Value<String?> rateRs;
  final Value<String?> hsnCode;
  final Value<double?> qty;
  final Value<double> unitPrice;
  final Value<double?> gstRate;
  final Value<double> lineTotal;
  const InvoiceItemsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.itemSourceType = const Value.absent(),
    this.motorJobId = const Value.absent(),
    this.copperStockId = const Value.absent(),
    this.description = const Value.absent(),
    this.rateRs = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.gstRate = const Value.absent(),
    this.lineTotal = const Value.absent(),
  });
  InvoiceItemsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required ItemSourceType itemSourceType,
    this.motorJobId = const Value.absent(),
    this.copperStockId = const Value.absent(),
    required String description,
    this.rateRs = const Value.absent(),
    this.hsnCode = const Value.absent(),
    this.qty = const Value.absent(),
    required double unitPrice,
    this.gstRate = const Value.absent(),
    required double lineTotal,
  }) : invoiceId = Value(invoiceId),
       itemSourceType = Value(itemSourceType),
       description = Value(description),
       unitPrice = Value(unitPrice),
       lineTotal = Value(lineTotal);
  static Insertable<InvoiceItem> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<String>? itemSourceType,
    Expression<int>? motorJobId,
    Expression<int>? copperStockId,
    Expression<String>? description,
    Expression<String>? rateRs,
    Expression<String>? hsnCode,
    Expression<double>? qty,
    Expression<double>? unitPrice,
    Expression<double>? gstRate,
    Expression<double>? lineTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (itemSourceType != null) 'item_source_type': itemSourceType,
      if (motorJobId != null) 'motor_job_id': motorJobId,
      if (copperStockId != null) 'copper_stock_id': copperStockId,
      if (description != null) 'description': description,
      if (rateRs != null) 'rate_rs': rateRs,
      if (hsnCode != null) 'hsn_code': hsnCode,
      if (qty != null) 'qty': qty,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (gstRate != null) 'gst_rate': gstRate,
      if (lineTotal != null) 'line_total': lineTotal,
    });
  }

  InvoiceItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<ItemSourceType>? itemSourceType,
    Value<int?>? motorJobId,
    Value<int?>? copperStockId,
    Value<String>? description,
    Value<String?>? rateRs,
    Value<String?>? hsnCode,
    Value<double?>? qty,
    Value<double>? unitPrice,
    Value<double?>? gstRate,
    Value<double>? lineTotal,
  }) {
    return InvoiceItemsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      itemSourceType: itemSourceType ?? this.itemSourceType,
      motorJobId: motorJobId ?? this.motorJobId,
      copperStockId: copperStockId ?? this.copperStockId,
      description: description ?? this.description,
      rateRs: rateRs ?? this.rateRs,
      hsnCode: hsnCode ?? this.hsnCode,
      qty: qty ?? this.qty,
      unitPrice: unitPrice ?? this.unitPrice,
      gstRate: gstRate ?? this.gstRate,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (itemSourceType.present) {
      map['item_source_type'] = Variable<String>(
        $InvoiceItemsTable.$converteritemSourceType.toSql(itemSourceType.value),
      );
    }
    if (motorJobId.present) {
      map['motor_job_id'] = Variable<int>(motorJobId.value);
    }
    if (copperStockId.present) {
      map['copper_stock_id'] = Variable<int>(copperStockId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rateRs.present) {
      map['rate_rs'] = Variable<String>(rateRs.value);
    }
    if (hsnCode.present) {
      map['hsn_code'] = Variable<String>(hsnCode.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (gstRate.present) {
      map['gst_rate'] = Variable<double>(gstRate.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceItemsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('itemSourceType: $itemSourceType, ')
          ..write('motorJobId: $motorJobId, ')
          ..write('copperStockId: $copperStockId, ')
          ..write('description: $description, ')
          ..write('rateRs: $rateRs, ')
          ..write('hsnCode: $hsnCode, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('gstRate: $gstRate, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _copperStockIdMeta = const VerificationMeta(
    'copperStockId',
  );
  @override
  late final GeneratedColumn<int> copperStockId = GeneratedColumn<int>(
    'copper_stock_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES copper_stock (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MovementType, String>
  movementType = GeneratedColumn<String>(
    'movement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MovementType>($StockMovementsTable.$convertermovementType);
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceInvoiceIdMeta =
      const VerificationMeta('referenceInvoiceId');
  @override
  late final GeneratedColumn<int> referenceInvoiceId = GeneratedColumn<int>(
    'reference_invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    copperStockId,
    movementType,
    weightKg,
    referenceInvoiceId,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('copper_stock_id')) {
      context.handle(
        _copperStockIdMeta,
        copperStockId.isAcceptableOrUnknown(
          data['copper_stock_id']!,
          _copperStockIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_copperStockIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reference_invoice_id')) {
      context.handle(
        _referenceInvoiceIdMeta,
        referenceInvoiceId.isAcceptableOrUnknown(
          data['reference_invoice_id']!,
          _referenceInvoiceIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      copperStockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}copper_stock_id'],
      )!,
      movementType: $StockMovementsTable.$convertermovementType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}movement_type'],
        )!,
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      referenceInvoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reference_invoice_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MovementType, String, String>
  $convertermovementType = const EnumNameConverter<MovementType>(
    MovementType.values,
  );
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final int id;
  final int copperStockId;
  final MovementType movementType;
  final double weightKg;
  final int? referenceInvoiceId;
  final String? notes;
  final DateTime createdAt;
  const StockMovement({
    required this.id,
    required this.copperStockId,
    required this.movementType,
    required this.weightKg,
    this.referenceInvoiceId,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['copper_stock_id'] = Variable<int>(copperStockId);
    {
      map['movement_type'] = Variable<String>(
        $StockMovementsTable.$convertermovementType.toSql(movementType),
      );
    }
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || referenceInvoiceId != null) {
      map['reference_invoice_id'] = Variable<int>(referenceInvoiceId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      copperStockId: Value(copperStockId),
      movementType: Value(movementType),
      weightKg: Value(weightKg),
      referenceInvoiceId: referenceInvoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceInvoiceId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<int>(json['id']),
      copperStockId: serializer.fromJson<int>(json['copperStockId']),
      movementType: $StockMovementsTable.$convertermovementType.fromJson(
        serializer.fromJson<String>(json['movementType']),
      ),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      referenceInvoiceId: serializer.fromJson<int?>(json['referenceInvoiceId']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'copperStockId': serializer.toJson<int>(copperStockId),
      'movementType': serializer.toJson<String>(
        $StockMovementsTable.$convertermovementType.toJson(movementType),
      ),
      'weightKg': serializer.toJson<double>(weightKg),
      'referenceInvoiceId': serializer.toJson<int?>(referenceInvoiceId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith({
    int? id,
    int? copperStockId,
    MovementType? movementType,
    double? weightKg,
    Value<int?> referenceInvoiceId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => StockMovement(
    id: id ?? this.id,
    copperStockId: copperStockId ?? this.copperStockId,
    movementType: movementType ?? this.movementType,
    weightKg: weightKg ?? this.weightKg,
    referenceInvoiceId: referenceInvoiceId.present
        ? referenceInvoiceId.value
        : this.referenceInvoiceId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      copperStockId: data.copperStockId.present
          ? data.copperStockId.value
          : this.copperStockId,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      referenceInvoiceId: data.referenceInvoiceId.present
          ? data.referenceInvoiceId.value
          : this.referenceInvoiceId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('copperStockId: $copperStockId, ')
          ..write('movementType: $movementType, ')
          ..write('weightKg: $weightKg, ')
          ..write('referenceInvoiceId: $referenceInvoiceId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    copperStockId,
    movementType,
    weightKg,
    referenceInvoiceId,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.copperStockId == this.copperStockId &&
          other.movementType == this.movementType &&
          other.weightKg == this.weightKg &&
          other.referenceInvoiceId == this.referenceInvoiceId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<int> id;
  final Value<int> copperStockId;
  final Value<MovementType> movementType;
  final Value<double> weightKg;
  final Value<int?> referenceInvoiceId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.copperStockId = const Value.absent(),
    this.movementType = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.referenceInvoiceId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int copperStockId,
    required MovementType movementType,
    required double weightKg,
    this.referenceInvoiceId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : copperStockId = Value(copperStockId),
       movementType = Value(movementType),
       weightKg = Value(weightKg);
  static Insertable<StockMovement> custom({
    Expression<int>? id,
    Expression<int>? copperStockId,
    Expression<String>? movementType,
    Expression<double>? weightKg,
    Expression<int>? referenceInvoiceId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (copperStockId != null) 'copper_stock_id': copperStockId,
      if (movementType != null) 'movement_type': movementType,
      if (weightKg != null) 'weight_kg': weightKg,
      if (referenceInvoiceId != null)
        'reference_invoice_id': referenceInvoiceId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StockMovementsCompanion copyWith({
    Value<int>? id,
    Value<int>? copperStockId,
    Value<MovementType>? movementType,
    Value<double>? weightKg,
    Value<int?>? referenceInvoiceId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      copperStockId: copperStockId ?? this.copperStockId,
      movementType: movementType ?? this.movementType,
      weightKg: weightKg ?? this.weightKg,
      referenceInvoiceId: referenceInvoiceId ?? this.referenceInvoiceId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (copperStockId.present) {
      map['copper_stock_id'] = Variable<int>(copperStockId.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(
        $StockMovementsTable.$convertermovementType.toSql(movementType.value),
      );
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (referenceInvoiceId.present) {
      map['reference_invoice_id'] = Variable<int>(referenceInvoiceId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('copperStockId: $copperStockId, ')
          ..write('movementType: $movementType, ')
          ..write('weightKg: $weightKg, ')
          ..write('referenceInvoiceId: $referenceInvoiceId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CompanySettingsTable extends CompanySettings
    with TableInfo<$CompanySettingsTable, CompanySetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompanySettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstinMeta = const VerificationMeta('gstin');
  @override
  late final GeneratedColumn<String> gstin = GeneratedColumn<String>(
    'gstin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankAccountNoMeta = const VerificationMeta(
    'bankAccountNo',
  );
  @override
  late final GeneratedColumn<String> bankAccountNo = GeneratedColumn<String>(
    'bank_account_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankIfscMeta = const VerificationMeta(
    'bankIfsc',
  );
  @override
  late final GeneratedColumn<String> bankIfsc = GeneratedColumn<String>(
    'bank_ifsc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _upiIdMeta = const VerificationMeta('upiId');
  @override
  late final GeneratedColumn<String> upiId = GeneratedColumn<String>(
    'upi_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dscCertPathMeta = const VerificationMeta(
    'dscCertPath',
  );
  @override
  late final GeneratedColumn<String> dscCertPath = GeneratedColumn<String>(
    'dsc_cert_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DscSigningMethod?, String>
  dscSigningMethod =
      GeneratedColumn<String>(
        'dsc_signing_method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DscSigningMethod?>(
        $CompanySettingsTable.$converterdscSigningMethodn,
      );
  static const VerificationMeta _dscPkcs11DllPathMeta = const VerificationMeta(
    'dscPkcs11DllPath',
  );
  @override
  late final GeneratedColumn<String> dscPkcs11DllPath = GeneratedColumn<String>(
    'dsc_pkcs11_dll_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eInvoiceApplicableMeta =
      const VerificationMeta('eInvoiceApplicable');
  @override
  late final GeneratedColumn<bool> eInvoiceApplicable = GeneratedColumn<bool>(
    'e_invoice_applicable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("e_invoice_applicable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRegisteredMeta = const VerificationMeta(
    'isRegistered',
  );
  @override
  late final GeneratedColumn<bool> isRegistered = GeneratedColumn<bool>(
    'is_registered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_registered" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyName,
    address,
    phone,
    email,
    gstin,
    bankName,
    bankAccountNo,
    bankIfsc,
    upiId,
    dscCertPath,
    dscSigningMethod,
    dscPkcs11DllPath,
    eInvoiceApplicable,
    logoPath,
    isRegistered,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'company_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompanySetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('gstin')) {
      context.handle(
        _gstinMeta,
        gstin.isAcceptableOrUnknown(data['gstin']!, _gstinMeta),
      );
    } else if (isInserting) {
      context.missing(_gstinMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('bank_account_no')) {
      context.handle(
        _bankAccountNoMeta,
        bankAccountNo.isAcceptableOrUnknown(
          data['bank_account_no']!,
          _bankAccountNoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bankAccountNoMeta);
    }
    if (data.containsKey('bank_ifsc')) {
      context.handle(
        _bankIfscMeta,
        bankIfsc.isAcceptableOrUnknown(data['bank_ifsc']!, _bankIfscMeta),
      );
    } else if (isInserting) {
      context.missing(_bankIfscMeta);
    }
    if (data.containsKey('upi_id')) {
      context.handle(
        _upiIdMeta,
        upiId.isAcceptableOrUnknown(data['upi_id']!, _upiIdMeta),
      );
    }
    if (data.containsKey('dsc_cert_path')) {
      context.handle(
        _dscCertPathMeta,
        dscCertPath.isAcceptableOrUnknown(
          data['dsc_cert_path']!,
          _dscCertPathMeta,
        ),
      );
    }
    if (data.containsKey('dsc_pkcs11_dll_path')) {
      context.handle(
        _dscPkcs11DllPathMeta,
        dscPkcs11DllPath.isAcceptableOrUnknown(
          data['dsc_pkcs11_dll_path']!,
          _dscPkcs11DllPathMeta,
        ),
      );
    }
    if (data.containsKey('e_invoice_applicable')) {
      context.handle(
        _eInvoiceApplicableMeta,
        eInvoiceApplicable.isAcceptableOrUnknown(
          data['e_invoice_applicable']!,
          _eInvoiceApplicableMeta,
        ),
      );
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('is_registered')) {
      context.handle(
        _isRegisteredMeta,
        isRegistered.isAcceptableOrUnknown(
          data['is_registered']!,
          _isRegisteredMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompanySetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompanySetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      gstin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gstin'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      bankAccountNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_account_no'],
      )!,
      bankIfsc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_ifsc'],
      )!,
      upiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}upi_id'],
      ),
      dscCertPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dsc_cert_path'],
      ),
      dscSigningMethod: $CompanySettingsTable.$converterdscSigningMethodn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}dsc_signing_method'],
            ),
          ),
      dscPkcs11DllPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dsc_pkcs11_dll_path'],
      ),
      eInvoiceApplicable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}e_invoice_applicable'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      isRegistered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_registered'],
      )!,
    );
  }

  @override
  $CompanySettingsTable createAlias(String alias) {
    return $CompanySettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DscSigningMethod, String, String>
  $converterdscSigningMethod = const EnumNameConverter<DscSigningMethod>(
    DscSigningMethod.values,
  );
  static JsonTypeConverter2<DscSigningMethod?, String?, String?>
  $converterdscSigningMethodn = JsonTypeConverter2.asNullable(
    $converterdscSigningMethod,
  );
}

class CompanySetting extends DataClass implements Insertable<CompanySetting> {
  final int id;
  final String companyName;
  final String address;
  final String phone;
  final String email;
  final String gstin;
  final String bankName;
  final String bankAccountNo;
  final String bankIfsc;
  final String? upiId;
  final String? dscCertPath;
  final DscSigningMethod? dscSigningMethod;
  final String? dscPkcs11DllPath;
  final bool eInvoiceApplicable;
  final String? logoPath;
  final bool isRegistered;
  const CompanySetting({
    required this.id,
    required this.companyName,
    required this.address,
    required this.phone,
    required this.email,
    required this.gstin,
    required this.bankName,
    required this.bankAccountNo,
    required this.bankIfsc,
    this.upiId,
    this.dscCertPath,
    this.dscSigningMethod,
    this.dscPkcs11DllPath,
    required this.eInvoiceApplicable,
    this.logoPath,
    required this.isRegistered,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_name'] = Variable<String>(companyName);
    map['address'] = Variable<String>(address);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['gstin'] = Variable<String>(gstin);
    map['bank_name'] = Variable<String>(bankName);
    map['bank_account_no'] = Variable<String>(bankAccountNo);
    map['bank_ifsc'] = Variable<String>(bankIfsc);
    if (!nullToAbsent || upiId != null) {
      map['upi_id'] = Variable<String>(upiId);
    }
    if (!nullToAbsent || dscCertPath != null) {
      map['dsc_cert_path'] = Variable<String>(dscCertPath);
    }
    if (!nullToAbsent || dscSigningMethod != null) {
      map['dsc_signing_method'] = Variable<String>(
        $CompanySettingsTable.$converterdscSigningMethodn.toSql(
          dscSigningMethod,
        ),
      );
    }
    if (!nullToAbsent || dscPkcs11DllPath != null) {
      map['dsc_pkcs11_dll_path'] = Variable<String>(dscPkcs11DllPath);
    }
    map['e_invoice_applicable'] = Variable<bool>(eInvoiceApplicable);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    map['is_registered'] = Variable<bool>(isRegistered);
    return map;
  }

  CompanySettingsCompanion toCompanion(bool nullToAbsent) {
    return CompanySettingsCompanion(
      id: Value(id),
      companyName: Value(companyName),
      address: Value(address),
      phone: Value(phone),
      email: Value(email),
      gstin: Value(gstin),
      bankName: Value(bankName),
      bankAccountNo: Value(bankAccountNo),
      bankIfsc: Value(bankIfsc),
      upiId: upiId == null && nullToAbsent
          ? const Value.absent()
          : Value(upiId),
      dscCertPath: dscCertPath == null && nullToAbsent
          ? const Value.absent()
          : Value(dscCertPath),
      dscSigningMethod: dscSigningMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(dscSigningMethod),
      dscPkcs11DllPath: dscPkcs11DllPath == null && nullToAbsent
          ? const Value.absent()
          : Value(dscPkcs11DllPath),
      eInvoiceApplicable: Value(eInvoiceApplicable),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      isRegistered: Value(isRegistered),
    );
  }

  factory CompanySetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompanySetting(
      id: serializer.fromJson<int>(json['id']),
      companyName: serializer.fromJson<String>(json['companyName']),
      address: serializer.fromJson<String>(json['address']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      gstin: serializer.fromJson<String>(json['gstin']),
      bankName: serializer.fromJson<String>(json['bankName']),
      bankAccountNo: serializer.fromJson<String>(json['bankAccountNo']),
      bankIfsc: serializer.fromJson<String>(json['bankIfsc']),
      upiId: serializer.fromJson<String?>(json['upiId']),
      dscCertPath: serializer.fromJson<String?>(json['dscCertPath']),
      dscSigningMethod: $CompanySettingsTable.$converterdscSigningMethodn
          .fromJson(serializer.fromJson<String?>(json['dscSigningMethod'])),
      dscPkcs11DllPath: serializer.fromJson<String?>(json['dscPkcs11DllPath']),
      eInvoiceApplicable: serializer.fromJson<bool>(json['eInvoiceApplicable']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      isRegistered: serializer.fromJson<bool>(json['isRegistered']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyName': serializer.toJson<String>(companyName),
      'address': serializer.toJson<String>(address),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'gstin': serializer.toJson<String>(gstin),
      'bankName': serializer.toJson<String>(bankName),
      'bankAccountNo': serializer.toJson<String>(bankAccountNo),
      'bankIfsc': serializer.toJson<String>(bankIfsc),
      'upiId': serializer.toJson<String?>(upiId),
      'dscCertPath': serializer.toJson<String?>(dscCertPath),
      'dscSigningMethod': serializer.toJson<String?>(
        $CompanySettingsTable.$converterdscSigningMethodn.toJson(
          dscSigningMethod,
        ),
      ),
      'dscPkcs11DllPath': serializer.toJson<String?>(dscPkcs11DllPath),
      'eInvoiceApplicable': serializer.toJson<bool>(eInvoiceApplicable),
      'logoPath': serializer.toJson<String?>(logoPath),
      'isRegistered': serializer.toJson<bool>(isRegistered),
    };
  }

  CompanySetting copyWith({
    int? id,
    String? companyName,
    String? address,
    String? phone,
    String? email,
    String? gstin,
    String? bankName,
    String? bankAccountNo,
    String? bankIfsc,
    Value<String?> upiId = const Value.absent(),
    Value<String?> dscCertPath = const Value.absent(),
    Value<DscSigningMethod?> dscSigningMethod = const Value.absent(),
    Value<String?> dscPkcs11DllPath = const Value.absent(),
    bool? eInvoiceApplicable,
    Value<String?> logoPath = const Value.absent(),
    bool? isRegistered,
  }) => CompanySetting(
    id: id ?? this.id,
    companyName: companyName ?? this.companyName,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    gstin: gstin ?? this.gstin,
    bankName: bankName ?? this.bankName,
    bankAccountNo: bankAccountNo ?? this.bankAccountNo,
    bankIfsc: bankIfsc ?? this.bankIfsc,
    upiId: upiId.present ? upiId.value : this.upiId,
    dscCertPath: dscCertPath.present ? dscCertPath.value : this.dscCertPath,
    dscSigningMethod: dscSigningMethod.present
        ? dscSigningMethod.value
        : this.dscSigningMethod,
    dscPkcs11DllPath: dscPkcs11DllPath.present
        ? dscPkcs11DllPath.value
        : this.dscPkcs11DllPath,
    eInvoiceApplicable: eInvoiceApplicable ?? this.eInvoiceApplicable,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    isRegistered: isRegistered ?? this.isRegistered,
  );
  CompanySetting copyWithCompanion(CompanySettingsCompanion data) {
    return CompanySetting(
      id: data.id.present ? data.id.value : this.id,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      gstin: data.gstin.present ? data.gstin.value : this.gstin,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      bankAccountNo: data.bankAccountNo.present
          ? data.bankAccountNo.value
          : this.bankAccountNo,
      bankIfsc: data.bankIfsc.present ? data.bankIfsc.value : this.bankIfsc,
      upiId: data.upiId.present ? data.upiId.value : this.upiId,
      dscCertPath: data.dscCertPath.present
          ? data.dscCertPath.value
          : this.dscCertPath,
      dscSigningMethod: data.dscSigningMethod.present
          ? data.dscSigningMethod.value
          : this.dscSigningMethod,
      dscPkcs11DllPath: data.dscPkcs11DllPath.present
          ? data.dscPkcs11DllPath.value
          : this.dscPkcs11DllPath,
      eInvoiceApplicable: data.eInvoiceApplicable.present
          ? data.eInvoiceApplicable.value
          : this.eInvoiceApplicable,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      isRegistered: data.isRegistered.present
          ? data.isRegistered.value
          : this.isRegistered,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompanySetting(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('gstin: $gstin, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountNo: $bankAccountNo, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('upiId: $upiId, ')
          ..write('dscCertPath: $dscCertPath, ')
          ..write('dscSigningMethod: $dscSigningMethod, ')
          ..write('dscPkcs11DllPath: $dscPkcs11DllPath, ')
          ..write('eInvoiceApplicable: $eInvoiceApplicable, ')
          ..write('logoPath: $logoPath, ')
          ..write('isRegistered: $isRegistered')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyName,
    address,
    phone,
    email,
    gstin,
    bankName,
    bankAccountNo,
    bankIfsc,
    upiId,
    dscCertPath,
    dscSigningMethod,
    dscPkcs11DllPath,
    eInvoiceApplicable,
    logoPath,
    isRegistered,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompanySetting &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.gstin == this.gstin &&
          other.bankName == this.bankName &&
          other.bankAccountNo == this.bankAccountNo &&
          other.bankIfsc == this.bankIfsc &&
          other.upiId == this.upiId &&
          other.dscCertPath == this.dscCertPath &&
          other.dscSigningMethod == this.dscSigningMethod &&
          other.dscPkcs11DllPath == this.dscPkcs11DllPath &&
          other.eInvoiceApplicable == this.eInvoiceApplicable &&
          other.logoPath == this.logoPath &&
          other.isRegistered == this.isRegistered);
}

class CompanySettingsCompanion extends UpdateCompanion<CompanySetting> {
  final Value<int> id;
  final Value<String> companyName;
  final Value<String> address;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> gstin;
  final Value<String> bankName;
  final Value<String> bankAccountNo;
  final Value<String> bankIfsc;
  final Value<String?> upiId;
  final Value<String?> dscCertPath;
  final Value<DscSigningMethod?> dscSigningMethod;
  final Value<String?> dscPkcs11DllPath;
  final Value<bool> eInvoiceApplicable;
  final Value<String?> logoPath;
  final Value<bool> isRegistered;
  const CompanySettingsCompanion({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.gstin = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountNo = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.upiId = const Value.absent(),
    this.dscCertPath = const Value.absent(),
    this.dscSigningMethod = const Value.absent(),
    this.dscPkcs11DllPath = const Value.absent(),
    this.eInvoiceApplicable = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.isRegistered = const Value.absent(),
  });
  CompanySettingsCompanion.insert({
    this.id = const Value.absent(),
    required String companyName,
    required String address,
    required String phone,
    required String email,
    required String gstin,
    required String bankName,
    required String bankAccountNo,
    required String bankIfsc,
    this.upiId = const Value.absent(),
    this.dscCertPath = const Value.absent(),
    this.dscSigningMethod = const Value.absent(),
    this.dscPkcs11DllPath = const Value.absent(),
    this.eInvoiceApplicable = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.isRegistered = const Value.absent(),
  }) : companyName = Value(companyName),
       address = Value(address),
       phone = Value(phone),
       email = Value(email),
       gstin = Value(gstin),
       bankName = Value(bankName),
       bankAccountNo = Value(bankAccountNo),
       bankIfsc = Value(bankIfsc);
  static Insertable<CompanySetting> custom({
    Expression<int>? id,
    Expression<String>? companyName,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? gstin,
    Expression<String>? bankName,
    Expression<String>? bankAccountNo,
    Expression<String>? bankIfsc,
    Expression<String>? upiId,
    Expression<String>? dscCertPath,
    Expression<String>? dscSigningMethod,
    Expression<String>? dscPkcs11DllPath,
    Expression<bool>? eInvoiceApplicable,
    Expression<String>? logoPath,
    Expression<bool>? isRegistered,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (gstin != null) 'gstin': gstin,
      if (bankName != null) 'bank_name': bankName,
      if (bankAccountNo != null) 'bank_account_no': bankAccountNo,
      if (bankIfsc != null) 'bank_ifsc': bankIfsc,
      if (upiId != null) 'upi_id': upiId,
      if (dscCertPath != null) 'dsc_cert_path': dscCertPath,
      if (dscSigningMethod != null) 'dsc_signing_method': dscSigningMethod,
      if (dscPkcs11DllPath != null) 'dsc_pkcs11_dll_path': dscPkcs11DllPath,
      if (eInvoiceApplicable != null)
        'e_invoice_applicable': eInvoiceApplicable,
      if (logoPath != null) 'logo_path': logoPath,
      if (isRegistered != null) 'is_registered': isRegistered,
    });
  }

  CompanySettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? companyName,
    Value<String>? address,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? gstin,
    Value<String>? bankName,
    Value<String>? bankAccountNo,
    Value<String>? bankIfsc,
    Value<String?>? upiId,
    Value<String?>? dscCertPath,
    Value<DscSigningMethod?>? dscSigningMethod,
    Value<String?>? dscPkcs11DllPath,
    Value<bool>? eInvoiceApplicable,
    Value<String?>? logoPath,
    Value<bool>? isRegistered,
  }) {
    return CompanySettingsCompanion(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      bankName: bankName ?? this.bankName,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      upiId: upiId ?? this.upiId,
      dscCertPath: dscCertPath ?? this.dscCertPath,
      dscSigningMethod: dscSigningMethod ?? this.dscSigningMethod,
      dscPkcs11DllPath: dscPkcs11DllPath ?? this.dscPkcs11DllPath,
      eInvoiceApplicable: eInvoiceApplicable ?? this.eInvoiceApplicable,
      logoPath: logoPath ?? this.logoPath,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (gstin.present) {
      map['gstin'] = Variable<String>(gstin.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (bankAccountNo.present) {
      map['bank_account_no'] = Variable<String>(bankAccountNo.value);
    }
    if (bankIfsc.present) {
      map['bank_ifsc'] = Variable<String>(bankIfsc.value);
    }
    if (upiId.present) {
      map['upi_id'] = Variable<String>(upiId.value);
    }
    if (dscCertPath.present) {
      map['dsc_cert_path'] = Variable<String>(dscCertPath.value);
    }
    if (dscSigningMethod.present) {
      map['dsc_signing_method'] = Variable<String>(
        $CompanySettingsTable.$converterdscSigningMethodn.toSql(
          dscSigningMethod.value,
        ),
      );
    }
    if (dscPkcs11DllPath.present) {
      map['dsc_pkcs11_dll_path'] = Variable<String>(dscPkcs11DllPath.value);
    }
    if (eInvoiceApplicable.present) {
      map['e_invoice_applicable'] = Variable<bool>(eInvoiceApplicable.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (isRegistered.present) {
      map['is_registered'] = Variable<bool>(isRegistered.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompanySettingsCompanion(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('gstin: $gstin, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountNo: $bankAccountNo, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('upiId: $upiId, ')
          ..write('dscCertPath: $dscCertPath, ')
          ..write('dscSigningMethod: $dscSigningMethod, ')
          ..write('dscPkcs11DllPath: $dscPkcs11DllPath, ')
          ..write('eInvoiceApplicable: $eInvoiceApplicable, ')
          ..write('logoPath: $logoPath, ')
          ..write('isRegistered: $isRegistered')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyWageMeta = const VerificationMeta(
    'dailyWage',
  );
  @override
  late final GeneratedColumn<double> dailyWage = GeneratedColumn<double>(
    'daily_wage',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _joiningDateMeta = const VerificationMeta(
    'joiningDate',
  );
  @override
  late final GeneratedColumn<DateTime> joiningDate = GeneratedColumn<DateTime>(
    'joining_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    role,
    phone,
    dailyWage,
    joiningDate,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('daily_wage')) {
      context.handle(
        _dailyWageMeta,
        dailyWage.isAcceptableOrUnknown(data['daily_wage']!, _dailyWageMeta),
      );
    }
    if (data.containsKey('joining_date')) {
      context.handle(
        _joiningDateMeta,
        joiningDate.isAcceptableOrUnknown(
          data['joining_date']!,
          _joiningDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_joiningDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      dailyWage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_wage'],
      ),
      joiningDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joining_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String name;
  final String? role;
  final String? phone;
  final double? dailyWage;
  final DateTime joiningDate;
  final bool isActive;
  final DateTime createdAt;
  const Employee({
    required this.id,
    required this.name,
    this.role,
    this.phone,
    this.dailyWage,
    required this.joiningDate,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || role != null) {
      map['role'] = Variable<String>(role);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || dailyWage != null) {
      map['daily_wage'] = Variable<double>(dailyWage);
    }
    map['joining_date'] = Variable<DateTime>(joiningDate);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      dailyWage: dailyWage == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyWage),
      joiningDate: Value(joiningDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String?>(json['role']),
      phone: serializer.fromJson<String?>(json['phone']),
      dailyWage: serializer.fromJson<double?>(json['dailyWage']),
      joiningDate: serializer.fromJson<DateTime>(json['joiningDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String?>(role),
      'phone': serializer.toJson<String?>(phone),
      'dailyWage': serializer.toJson<double?>(dailyWage),
      'joiningDate': serializer.toJson<DateTime>(joiningDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Employee copyWith({
    int? id,
    String? name,
    Value<String?> role = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<double?> dailyWage = const Value.absent(),
    DateTime? joiningDate,
    bool? isActive,
    DateTime? createdAt,
  }) => Employee(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role.present ? role.value : this.role,
    phone: phone.present ? phone.value : this.phone,
    dailyWage: dailyWage.present ? dailyWage.value : this.dailyWage,
    joiningDate: joiningDate ?? this.joiningDate,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      dailyWage: data.dailyWage.present ? data.dailyWage.value : this.dailyWage,
      joiningDate: data.joiningDate.present
          ? data.joiningDate.value
          : this.joiningDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('dailyWage: $dailyWage, ')
          ..write('joiningDate: $joiningDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    role,
    phone,
    dailyWage,
    joiningDate,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.dailyWage == this.dailyWage &&
          other.joiningDate == this.joiningDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> role;
  final Value<String?> phone;
  final Value<double?> dailyWage;
  final Value<DateTime> joiningDate;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.dailyWage = const Value.absent(),
    this.joiningDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.dailyWage = const Value.absent(),
    required DateTime joiningDate,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       joiningDate = Value(joiningDate);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<double>? dailyWage,
    Expression<DateTime>? joiningDate,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (dailyWage != null) 'daily_wage': dailyWage,
      if (joiningDate != null) 'joining_date': joiningDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? role,
    Value<String?>? phone,
    Value<double?>? dailyWage,
    Value<DateTime>? joiningDate,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      dailyWage: dailyWage ?? this.dailyWage,
      joiningDate: joiningDate ?? this.joiningDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (dailyWage.present) {
      map['daily_wage'] = Variable<double>(dailyWage.value);
    }
    if (joiningDate.present) {
      map['joining_date'] = Variable<DateTime>(joiningDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('dailyWage: $dailyWage, ')
          ..write('joiningDate: $joiningDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AttendanceRecordsTable extends AttendanceRecords
    with TableInfo<$AttendanceRecordsTable, AttendanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AttendanceStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AttendanceStatus>(
        $AttendanceRecordsTable.$converterstatus,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    date,
    status,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {employeeId, date},
  ];
  @override
  AttendanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      status: $AttendanceRecordsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttendanceRecordsTable createAlias(String alias) {
    return $AttendanceRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AttendanceStatus, String, String> $converterstatus =
      const EnumNameConverter<AttendanceStatus>(AttendanceStatus.values);
}

class AttendanceRecord extends DataClass
    implements Insertable<AttendanceRecord> {
  final int id;
  final int employeeId;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;
  final DateTime createdAt;
  const AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.status,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['date'] = Variable<DateTime>(date);
    {
      map['status'] = Variable<String>(
        $AttendanceRecordsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttendanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceRecordsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      date: Value(date),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory AttendanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRecord(
      id: serializer.fromJson<int>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: $AttendanceRecordsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(
        $AttendanceRecordsTable.$converterstatus.toJson(status),
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AttendanceRecord copyWith({
    int? id,
    int? employeeId,
    DateTime? date,
    AttendanceStatus? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => AttendanceRecord(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    date: date ?? this.date,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  AttendanceRecord copyWithCompanion(AttendanceRecordsCompanion data) {
    return AttendanceRecord(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecord(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, employeeId, date, status, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRecord &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.date == this.date &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class AttendanceRecordsCompanion extends UpdateCompanion<AttendanceRecord> {
  final Value<int> id;
  final Value<int> employeeId;
  final Value<DateTime> date;
  final Value<AttendanceStatus> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const AttendanceRecordsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttendanceRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    required DateTime date,
    required AttendanceStatus status,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : employeeId = Value(employeeId),
       date = Value(date),
       status = Value(status);
  static Insertable<AttendanceRecord> custom({
    Expression<int>? id,
    Expression<int>? employeeId,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttendanceRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? employeeId,
    Value<DateTime>? date,
    Value<AttendanceStatus>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return AttendanceRecordsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $AttendanceRecordsTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FinancialYearSequenceTable extends FinancialYearSequence
    with TableInfo<$FinancialYearSequenceTable, FinancialYearSequenceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialYearSequenceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceTypePrefixMeta = const VerificationMeta(
    'invoiceTypePrefix',
  );
  @override
  late final GeneratedColumn<String> invoiceTypePrefix =
      GeneratedColumn<String>(
        'invoice_type_prefix',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _financialYearLabelMeta =
      const VerificationMeta('financialYearLabel');
  @override
  late final GeneratedColumn<String> financialYearLabel =
      GeneratedColumn<String>(
        'financial_year_label',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastNumberMeta = const VerificationMeta(
    'lastNumber',
  );
  @override
  late final GeneratedColumn<int> lastNumber = GeneratedColumn<int>(
    'last_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceTypePrefix,
    financialYearLabel,
    lastNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_year_sequence';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialYearSequenceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_type_prefix')) {
      context.handle(
        _invoiceTypePrefixMeta,
        invoiceTypePrefix.isAcceptableOrUnknown(
          data['invoice_type_prefix']!,
          _invoiceTypePrefixMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceTypePrefixMeta);
    }
    if (data.containsKey('financial_year_label')) {
      context.handle(
        _financialYearLabelMeta,
        financialYearLabel.isAcceptableOrUnknown(
          data['financial_year_label']!,
          _financialYearLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_financialYearLabelMeta);
    }
    if (data.containsKey('last_number')) {
      context.handle(
        _lastNumberMeta,
        lastNumber.isAcceptableOrUnknown(data['last_number']!, _lastNumberMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialYearSequenceData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialYearSequenceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceTypePrefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_type_prefix'],
      )!,
      financialYearLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}financial_year_label'],
      )!,
      lastNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_number'],
      )!,
    );
  }

  @override
  $FinancialYearSequenceTable createAlias(String alias) {
    return $FinancialYearSequenceTable(attachedDatabase, alias);
  }
}

class FinancialYearSequenceData extends DataClass
    implements Insertable<FinancialYearSequenceData> {
  final int id;
  final String invoiceTypePrefix;
  final String financialYearLabel;
  final int lastNumber;
  const FinancialYearSequenceData({
    required this.id,
    required this.invoiceTypePrefix,
    required this.financialYearLabel,
    required this.lastNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_type_prefix'] = Variable<String>(invoiceTypePrefix);
    map['financial_year_label'] = Variable<String>(financialYearLabel);
    map['last_number'] = Variable<int>(lastNumber);
    return map;
  }

  FinancialYearSequenceCompanion toCompanion(bool nullToAbsent) {
    return FinancialYearSequenceCompanion(
      id: Value(id),
      invoiceTypePrefix: Value(invoiceTypePrefix),
      financialYearLabel: Value(financialYearLabel),
      lastNumber: Value(lastNumber),
    );
  }

  factory FinancialYearSequenceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialYearSequenceData(
      id: serializer.fromJson<int>(json['id']),
      invoiceTypePrefix: serializer.fromJson<String>(json['invoiceTypePrefix']),
      financialYearLabel: serializer.fromJson<String>(
        json['financialYearLabel'],
      ),
      lastNumber: serializer.fromJson<int>(json['lastNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceTypePrefix': serializer.toJson<String>(invoiceTypePrefix),
      'financialYearLabel': serializer.toJson<String>(financialYearLabel),
      'lastNumber': serializer.toJson<int>(lastNumber),
    };
  }

  FinancialYearSequenceData copyWith({
    int? id,
    String? invoiceTypePrefix,
    String? financialYearLabel,
    int? lastNumber,
  }) => FinancialYearSequenceData(
    id: id ?? this.id,
    invoiceTypePrefix: invoiceTypePrefix ?? this.invoiceTypePrefix,
    financialYearLabel: financialYearLabel ?? this.financialYearLabel,
    lastNumber: lastNumber ?? this.lastNumber,
  );
  FinancialYearSequenceData copyWithCompanion(
    FinancialYearSequenceCompanion data,
  ) {
    return FinancialYearSequenceData(
      id: data.id.present ? data.id.value : this.id,
      invoiceTypePrefix: data.invoiceTypePrefix.present
          ? data.invoiceTypePrefix.value
          : this.invoiceTypePrefix,
      financialYearLabel: data.financialYearLabel.present
          ? data.financialYearLabel.value
          : this.financialYearLabel,
      lastNumber: data.lastNumber.present
          ? data.lastNumber.value
          : this.lastNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialYearSequenceData(')
          ..write('id: $id, ')
          ..write('invoiceTypePrefix: $invoiceTypePrefix, ')
          ..write('financialYearLabel: $financialYearLabel, ')
          ..write('lastNumber: $lastNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, invoiceTypePrefix, financialYearLabel, lastNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialYearSequenceData &&
          other.id == this.id &&
          other.invoiceTypePrefix == this.invoiceTypePrefix &&
          other.financialYearLabel == this.financialYearLabel &&
          other.lastNumber == this.lastNumber);
}

class FinancialYearSequenceCompanion
    extends UpdateCompanion<FinancialYearSequenceData> {
  final Value<int> id;
  final Value<String> invoiceTypePrefix;
  final Value<String> financialYearLabel;
  final Value<int> lastNumber;
  const FinancialYearSequenceCompanion({
    this.id = const Value.absent(),
    this.invoiceTypePrefix = const Value.absent(),
    this.financialYearLabel = const Value.absent(),
    this.lastNumber = const Value.absent(),
  });
  FinancialYearSequenceCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceTypePrefix,
    required String financialYearLabel,
    this.lastNumber = const Value.absent(),
  }) : invoiceTypePrefix = Value(invoiceTypePrefix),
       financialYearLabel = Value(financialYearLabel);
  static Insertable<FinancialYearSequenceData> custom({
    Expression<int>? id,
    Expression<String>? invoiceTypePrefix,
    Expression<String>? financialYearLabel,
    Expression<int>? lastNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceTypePrefix != null) 'invoice_type_prefix': invoiceTypePrefix,
      if (financialYearLabel != null)
        'financial_year_label': financialYearLabel,
      if (lastNumber != null) 'last_number': lastNumber,
    });
  }

  FinancialYearSequenceCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceTypePrefix,
    Value<String>? financialYearLabel,
    Value<int>? lastNumber,
  }) {
    return FinancialYearSequenceCompanion(
      id: id ?? this.id,
      invoiceTypePrefix: invoiceTypePrefix ?? this.invoiceTypePrefix,
      financialYearLabel: financialYearLabel ?? this.financialYearLabel,
      lastNumber: lastNumber ?? this.lastNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceTypePrefix.present) {
      map['invoice_type_prefix'] = Variable<String>(invoiceTypePrefix.value);
    }
    if (financialYearLabel.present) {
      map['financial_year_label'] = Variable<String>(financialYearLabel.value);
    }
    if (lastNumber.present) {
      map['last_number'] = Variable<int>(lastNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialYearSequenceCompanion(')
          ..write('id: $id, ')
          ..write('invoiceTypePrefix: $invoiceTypePrefix, ')
          ..write('financialYearLabel: $financialYearLabel, ')
          ..write('lastNumber: $lastNumber')
          ..write(')'))
        .toString();
  }
}

class $CashCategoriesTable extends CashCategories
    with TableInfo<$CashCategoriesTable, CashCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CashCategoriesTable createAlias(String alias) {
    return $CashCategoriesTable(attachedDatabase, alias);
  }
}

class CashCategory extends DataClass implements Insertable<CashCategory> {
  final int id;
  final String name;
  final DateTime createdAt;
  const CashCategory({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CashCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory CashCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashCategory copyWith({int? id, String? name, DateTime? createdAt}) =>
      CashCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  CashCategory copyWithCompanion(CashCategoriesCompanion data) {
    return CashCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CashCategoriesCompanion extends UpdateCompanion<CashCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const CashCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CashCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CashCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CashCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return CashCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CashTransactionsTable extends CashTransactions
    with TableInfo<$CashTransactionsTable, CashTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CashTransactionType, String>
  transactionType =
      GeneratedColumn<String>(
        'transaction_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CashTransactionType>(
        $CashTransactionsTable.$convertertransactionType,
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionType,
    amount,
    category,
    description,
    transactionDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionType: $CashTransactionsTable.$convertertransactionType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}transaction_type'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CashTransactionsTable createAlias(String alias) {
    return $CashTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CashTransactionType, String, String>
  $convertertransactionType = const EnumNameConverter<CashTransactionType>(
    CashTransactionType.values,
  );
}

class CashTransaction extends DataClass implements Insertable<CashTransaction> {
  final int id;
  final CashTransactionType transactionType;
  final double amount;
  final String category;
  final String? description;
  final DateTime transactionDate;
  final DateTime createdAt;
  const CashTransaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.category,
    this.description,
    required this.transactionDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['transaction_type'] = Variable<String>(
        $CashTransactionsTable.$convertertransactionType.toSql(transactionType),
      );
    }
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashTransactionsCompanion toCompanion(bool nullToAbsent) {
    return CashTransactionsCompanion(
      id: Value(id),
      transactionType: Value(transactionType),
      amount: Value(amount),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      transactionDate: Value(transactionDate),
      createdAt: Value(createdAt),
    );
  }

  factory CashTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashTransaction(
      id: serializer.fromJson<int>(json['id']),
      transactionType: $CashTransactionsTable.$convertertransactionType
          .fromJson(serializer.fromJson<String>(json['transactionType'])),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionType': serializer.toJson<String>(
        $CashTransactionsTable.$convertertransactionType.toJson(
          transactionType,
        ),
      ),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashTransaction copyWith({
    int? id,
    CashTransactionType? transactionType,
    double? amount,
    String? category,
    Value<String?> description = const Value.absent(),
    DateTime? transactionDate,
    DateTime? createdAt,
  }) => CashTransaction(
    id: id ?? this.id,
    transactionType: transactionType ?? this.transactionType,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    description: description.present ? description.value : this.description,
    transactionDate: transactionDate ?? this.transactionDate,
    createdAt: createdAt ?? this.createdAt,
  );
  CashTransaction copyWithCompanion(CashTransactionsCompanion data) {
    return CashTransaction(
      id: data.id.present ? data.id.value : this.id,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashTransaction(')
          ..write('id: $id, ')
          ..write('transactionType: $transactionType, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionType,
    amount,
    category,
    description,
    transactionDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashTransaction &&
          other.id == this.id &&
          other.transactionType == this.transactionType &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.description == this.description &&
          other.transactionDate == this.transactionDate &&
          other.createdAt == this.createdAt);
}

class CashTransactionsCompanion extends UpdateCompanion<CashTransaction> {
  final Value<int> id;
  final Value<CashTransactionType> transactionType;
  final Value<double> amount;
  final Value<String> category;
  final Value<String?> description;
  final Value<DateTime> transactionDate;
  final Value<DateTime> createdAt;
  const CashTransactionsCompanion({
    this.id = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CashTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required CashTransactionType transactionType,
    required double amount,
    required String category,
    this.description = const Value.absent(),
    required DateTime transactionDate,
    this.createdAt = const Value.absent(),
  }) : transactionType = Value(transactionType),
       amount = Value(amount),
       category = Value(category),
       transactionDate = Value(transactionDate);
  static Insertable<CashTransaction> custom({
    Expression<int>? id,
    Expression<String>? transactionType,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionType != null) 'transaction_type': transactionType,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CashTransactionsCompanion copyWith({
    Value<int>? id,
    Value<CashTransactionType>? transactionType,
    Value<double>? amount,
    Value<String>? category,
    Value<String?>? description,
    Value<DateTime>? transactionDate,
    Value<DateTime>? createdAt,
  }) {
    return CashTransactionsCompanion(
      id: id ?? this.id,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(
        $CashTransactionsTable.$convertertransactionType.toSql(
          transactionType.value,
        ),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('transactionType: $transactionType, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode, String> paymentMode =
      GeneratedColumn<String>(
        'payment_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaymentMode>($PaymentsTable.$converterpaymentMode);
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceNoMeta = const VerificationMeta(
    'referenceNo',
  );
  @override
  late final GeneratedColumn<String> referenceNo = GeneratedColumn<String>(
    'reference_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceId,
    amount,
    paymentMode,
    paymentDate,
    referenceNo,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentDateMeta);
    }
    if (data.containsKey('reference_no')) {
      context.handle(
        _referenceNoMeta,
        referenceNo.isAcceptableOrUnknown(
          data['reference_no']!,
          _referenceNoMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invoice_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      paymentMode: $PaymentsTable.$converterpaymentMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_mode'],
        )!,
      ),
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      )!,
      referenceNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_no'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMode, String, String> $converterpaymentMode =
      const EnumNameConverter<PaymentMode>(PaymentMode.values);
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int invoiceId;
  final double amount;
  final PaymentMode paymentMode;
  final DateTime paymentDate;
  final String? referenceNo;
  final String? notes;
  final DateTime createdAt;
  const Payment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.paymentMode,
    required this.paymentDate,
    this.referenceNo,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['amount'] = Variable<double>(amount);
    {
      map['payment_mode'] = Variable<String>(
        $PaymentsTable.$converterpaymentMode.toSql(paymentMode),
      );
    }
    map['payment_date'] = Variable<DateTime>(paymentDate);
    if (!nullToAbsent || referenceNo != null) {
      map['reference_no'] = Variable<String>(referenceNo);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      amount: Value(amount),
      paymentMode: Value(paymentMode),
      paymentDate: Value(paymentDate),
      referenceNo: referenceNo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNo),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMode: $PaymentsTable.$converterpaymentMode.fromJson(
        serializer.fromJson<String>(json['paymentMode']),
      ),
      paymentDate: serializer.fromJson<DateTime>(json['paymentDate']),
      referenceNo: serializer.fromJson<String?>(json['referenceNo']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'amount': serializer.toJson<double>(amount),
      'paymentMode': serializer.toJson<String>(
        $PaymentsTable.$converterpaymentMode.toJson(paymentMode),
      ),
      'paymentDate': serializer.toJson<DateTime>(paymentDate),
      'referenceNo': serializer.toJson<String?>(referenceNo),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith({
    int? id,
    int? invoiceId,
    double? amount,
    PaymentMode? paymentMode,
    DateTime? paymentDate,
    Value<String?> referenceNo = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Payment(
    id: id ?? this.id,
    invoiceId: invoiceId ?? this.invoiceId,
    amount: amount ?? this.amount,
    paymentMode: paymentMode ?? this.paymentMode,
    paymentDate: paymentDate ?? this.paymentDate,
    referenceNo: referenceNo.present ? referenceNo.value : this.referenceNo,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      referenceNo: data.referenceNo.present
          ? data.referenceNo.value
          : this.referenceNo,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('referenceNo: $referenceNo, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceId,
    amount,
    paymentMode,
    paymentDate,
    referenceNo,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.amount == this.amount &&
          other.paymentMode == this.paymentMode &&
          other.paymentDate == this.paymentDate &&
          other.referenceNo == this.referenceNo &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<double> amount;
  final Value<PaymentMode> paymentMode;
  final Value<DateTime> paymentDate;
  final Value<String?> referenceNo;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.referenceNo = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required double amount,
    required PaymentMode paymentMode,
    required DateTime paymentDate,
    this.referenceNo = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : invoiceId = Value(invoiceId),
       amount = Value(amount),
       paymentMode = Value(paymentMode),
       paymentDate = Value(paymentDate);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<double>? amount,
    Expression<String>? paymentMode,
    Expression<DateTime>? paymentDate,
    Expression<String>? referenceNo,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (amount != null) 'amount': amount,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (referenceNo != null) 'reference_no': referenceNo,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? invoiceId,
    Value<double>? amount,
    Value<PaymentMode>? paymentMode,
    Value<DateTime>? paymentDate,
    Value<String?>? referenceNo,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      amount: amount ?? this.amount,
      paymentMode: paymentMode ?? this.paymentMode,
      paymentDate: paymentDate ?? this.paymentDate,
      referenceNo: referenceNo ?? this.referenceNo,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(
        $PaymentsTable.$converterpaymentMode.toSql(paymentMode.value),
      );
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (referenceNo.present) {
      map['reference_no'] = Variable<String>(referenceNo.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('amount: $amount, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('referenceNo: $referenceNo, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $QuotationsTable extends Quotations
    with TableInfo<$QuotationsTable, Quotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quoteNoMeta = const VerificationMeta(
    'quoteNo',
  );
  @override
  late final GeneratedColumn<String> quoteNo = GeneratedColumn<String>(
    'quote_no',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _prospectiveCustomerNameMeta =
      const VerificationMeta('prospectiveCustomerName');
  @override
  late final GeneratedColumn<String> prospectiveCustomerName =
      GeneratedColumn<String>(
        'prospective_customer_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _prospectiveCustomerPhoneMeta =
      const VerificationMeta('prospectiveCustomerPhone');
  @override
  late final GeneratedColumn<String> prospectiveCustomerPhone =
      GeneratedColumn<String>(
        'prospective_customer_phone',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _motorJobIdMeta = const VerificationMeta(
    'motorJobId',
  );
  @override
  late final GeneratedColumn<int> motorJobId = GeneratedColumn<int>(
    'motor_job_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES motor_jobs (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedAmountMeta = const VerificationMeta(
    'estimatedAmount',
  );
  @override
  late final GeneratedColumn<double> estimatedAmount = GeneratedColumn<double>(
    'estimated_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuotationStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<QuotationStatus>($QuotationsTable.$converterstatus);
  static const VerificationMeta _convertedInvoiceIdMeta =
      const VerificationMeta('convertedInvoiceId');
  @override
  late final GeneratedColumn<int> convertedInvoiceId = GeneratedColumn<int>(
    'converted_invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id)',
    ),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quoteNo,
    customerId,
    prospectiveCustomerName,
    prospectiveCustomerPhone,
    motorJobId,
    description,
    estimatedAmount,
    validUntil,
    status,
    convertedInvoiceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quotation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quote_no')) {
      context.handle(
        _quoteNoMeta,
        quoteNo.isAcceptableOrUnknown(data['quote_no']!, _quoteNoMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteNoMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('prospective_customer_name')) {
      context.handle(
        _prospectiveCustomerNameMeta,
        prospectiveCustomerName.isAcceptableOrUnknown(
          data['prospective_customer_name']!,
          _prospectiveCustomerNameMeta,
        ),
      );
    }
    if (data.containsKey('prospective_customer_phone')) {
      context.handle(
        _prospectiveCustomerPhoneMeta,
        prospectiveCustomerPhone.isAcceptableOrUnknown(
          data['prospective_customer_phone']!,
          _prospectiveCustomerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('motor_job_id')) {
      context.handle(
        _motorJobIdMeta,
        motorJobId.isAcceptableOrUnknown(
          data['motor_job_id']!,
          _motorJobIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('estimated_amount')) {
      context.handle(
        _estimatedAmountMeta,
        estimatedAmount.isAcceptableOrUnknown(
          data['estimated_amount']!,
          _estimatedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedAmountMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('converted_invoice_id')) {
      context.handle(
        _convertedInvoiceIdMeta,
        convertedInvoiceId.isAcceptableOrUnknown(
          data['converted_invoice_id']!,
          _convertedInvoiceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quotation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quoteNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_no'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      prospectiveCustomerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prospective_customer_name'],
      ),
      prospectiveCustomerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prospective_customer_phone'],
      ),
      motorJobId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motor_job_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      estimatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_amount'],
      )!,
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_until'],
      ),
      status: $QuotationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      convertedInvoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}converted_invoice_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuotationsTable createAlias(String alias) {
    return $QuotationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuotationStatus, String, String> $converterstatus =
      const EnumNameConverter<QuotationStatus>(QuotationStatus.values);
}

class Quotation extends DataClass implements Insertable<Quotation> {
  final int id;
  final String quoteNo;
  final int? customerId;
  final String? prospectiveCustomerName;
  final String? prospectiveCustomerPhone;
  final int? motorJobId;
  final String description;
  final double estimatedAmount;
  final DateTime? validUntil;
  final QuotationStatus status;
  final int? convertedInvoiceId;
  final DateTime createdAt;
  const Quotation({
    required this.id,
    required this.quoteNo,
    this.customerId,
    this.prospectiveCustomerName,
    this.prospectiveCustomerPhone,
    this.motorJobId,
    required this.description,
    required this.estimatedAmount,
    this.validUntil,
    required this.status,
    this.convertedInvoiceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quote_no'] = Variable<String>(quoteNo);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    if (!nullToAbsent || prospectiveCustomerName != null) {
      map['prospective_customer_name'] = Variable<String>(
        prospectiveCustomerName,
      );
    }
    if (!nullToAbsent || prospectiveCustomerPhone != null) {
      map['prospective_customer_phone'] = Variable<String>(
        prospectiveCustomerPhone,
      );
    }
    if (!nullToAbsent || motorJobId != null) {
      map['motor_job_id'] = Variable<int>(motorJobId);
    }
    map['description'] = Variable<String>(description);
    map['estimated_amount'] = Variable<double>(estimatedAmount);
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<DateTime>(validUntil);
    }
    {
      map['status'] = Variable<String>(
        $QuotationsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || convertedInvoiceId != null) {
      map['converted_invoice_id'] = Variable<int>(convertedInvoiceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuotationsCompanion toCompanion(bool nullToAbsent) {
    return QuotationsCompanion(
      id: Value(id),
      quoteNo: Value(quoteNo),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      prospectiveCustomerName: prospectiveCustomerName == null && nullToAbsent
          ? const Value.absent()
          : Value(prospectiveCustomerName),
      prospectiveCustomerPhone: prospectiveCustomerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(prospectiveCustomerPhone),
      motorJobId: motorJobId == null && nullToAbsent
          ? const Value.absent()
          : Value(motorJobId),
      description: Value(description),
      estimatedAmount: Value(estimatedAmount),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      status: Value(status),
      convertedInvoiceId: convertedInvoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(convertedInvoiceId),
      createdAt: Value(createdAt),
    );
  }

  factory Quotation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quotation(
      id: serializer.fromJson<int>(json['id']),
      quoteNo: serializer.fromJson<String>(json['quoteNo']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      prospectiveCustomerName: serializer.fromJson<String?>(
        json['prospectiveCustomerName'],
      ),
      prospectiveCustomerPhone: serializer.fromJson<String?>(
        json['prospectiveCustomerPhone'],
      ),
      motorJobId: serializer.fromJson<int?>(json['motorJobId']),
      description: serializer.fromJson<String>(json['description']),
      estimatedAmount: serializer.fromJson<double>(json['estimatedAmount']),
      validUntil: serializer.fromJson<DateTime?>(json['validUntil']),
      status: $QuotationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      convertedInvoiceId: serializer.fromJson<int?>(json['convertedInvoiceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quoteNo': serializer.toJson<String>(quoteNo),
      'customerId': serializer.toJson<int?>(customerId),
      'prospectiveCustomerName': serializer.toJson<String?>(
        prospectiveCustomerName,
      ),
      'prospectiveCustomerPhone': serializer.toJson<String?>(
        prospectiveCustomerPhone,
      ),
      'motorJobId': serializer.toJson<int?>(motorJobId),
      'description': serializer.toJson<String>(description),
      'estimatedAmount': serializer.toJson<double>(estimatedAmount),
      'validUntil': serializer.toJson<DateTime?>(validUntil),
      'status': serializer.toJson<String>(
        $QuotationsTable.$converterstatus.toJson(status),
      ),
      'convertedInvoiceId': serializer.toJson<int?>(convertedInvoiceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Quotation copyWith({
    int? id,
    String? quoteNo,
    Value<int?> customerId = const Value.absent(),
    Value<String?> prospectiveCustomerName = const Value.absent(),
    Value<String?> prospectiveCustomerPhone = const Value.absent(),
    Value<int?> motorJobId = const Value.absent(),
    String? description,
    double? estimatedAmount,
    Value<DateTime?> validUntil = const Value.absent(),
    QuotationStatus? status,
    Value<int?> convertedInvoiceId = const Value.absent(),
    DateTime? createdAt,
  }) => Quotation(
    id: id ?? this.id,
    quoteNo: quoteNo ?? this.quoteNo,
    customerId: customerId.present ? customerId.value : this.customerId,
    prospectiveCustomerName: prospectiveCustomerName.present
        ? prospectiveCustomerName.value
        : this.prospectiveCustomerName,
    prospectiveCustomerPhone: prospectiveCustomerPhone.present
        ? prospectiveCustomerPhone.value
        : this.prospectiveCustomerPhone,
    motorJobId: motorJobId.present ? motorJobId.value : this.motorJobId,
    description: description ?? this.description,
    estimatedAmount: estimatedAmount ?? this.estimatedAmount,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    status: status ?? this.status,
    convertedInvoiceId: convertedInvoiceId.present
        ? convertedInvoiceId.value
        : this.convertedInvoiceId,
    createdAt: createdAt ?? this.createdAt,
  );
  Quotation copyWithCompanion(QuotationsCompanion data) {
    return Quotation(
      id: data.id.present ? data.id.value : this.id,
      quoteNo: data.quoteNo.present ? data.quoteNo.value : this.quoteNo,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      prospectiveCustomerName: data.prospectiveCustomerName.present
          ? data.prospectiveCustomerName.value
          : this.prospectiveCustomerName,
      prospectiveCustomerPhone: data.prospectiveCustomerPhone.present
          ? data.prospectiveCustomerPhone.value
          : this.prospectiveCustomerPhone,
      motorJobId: data.motorJobId.present
          ? data.motorJobId.value
          : this.motorJobId,
      description: data.description.present
          ? data.description.value
          : this.description,
      estimatedAmount: data.estimatedAmount.present
          ? data.estimatedAmount.value
          : this.estimatedAmount,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      status: data.status.present ? data.status.value : this.status,
      convertedInvoiceId: data.convertedInvoiceId.present
          ? data.convertedInvoiceId.value
          : this.convertedInvoiceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quotation(')
          ..write('id: $id, ')
          ..write('quoteNo: $quoteNo, ')
          ..write('customerId: $customerId, ')
          ..write('prospectiveCustomerName: $prospectiveCustomerName, ')
          ..write('prospectiveCustomerPhone: $prospectiveCustomerPhone, ')
          ..write('motorJobId: $motorJobId, ')
          ..write('description: $description, ')
          ..write('estimatedAmount: $estimatedAmount, ')
          ..write('validUntil: $validUntil, ')
          ..write('status: $status, ')
          ..write('convertedInvoiceId: $convertedInvoiceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quoteNo,
    customerId,
    prospectiveCustomerName,
    prospectiveCustomerPhone,
    motorJobId,
    description,
    estimatedAmount,
    validUntil,
    status,
    convertedInvoiceId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quotation &&
          other.id == this.id &&
          other.quoteNo == this.quoteNo &&
          other.customerId == this.customerId &&
          other.prospectiveCustomerName == this.prospectiveCustomerName &&
          other.prospectiveCustomerPhone == this.prospectiveCustomerPhone &&
          other.motorJobId == this.motorJobId &&
          other.description == this.description &&
          other.estimatedAmount == this.estimatedAmount &&
          other.validUntil == this.validUntil &&
          other.status == this.status &&
          other.convertedInvoiceId == this.convertedInvoiceId &&
          other.createdAt == this.createdAt);
}

class QuotationsCompanion extends UpdateCompanion<Quotation> {
  final Value<int> id;
  final Value<String> quoteNo;
  final Value<int?> customerId;
  final Value<String?> prospectiveCustomerName;
  final Value<String?> prospectiveCustomerPhone;
  final Value<int?> motorJobId;
  final Value<String> description;
  final Value<double> estimatedAmount;
  final Value<DateTime?> validUntil;
  final Value<QuotationStatus> status;
  final Value<int?> convertedInvoiceId;
  final Value<DateTime> createdAt;
  const QuotationsCompanion({
    this.id = const Value.absent(),
    this.quoteNo = const Value.absent(),
    this.customerId = const Value.absent(),
    this.prospectiveCustomerName = const Value.absent(),
    this.prospectiveCustomerPhone = const Value.absent(),
    this.motorJobId = const Value.absent(),
    this.description = const Value.absent(),
    this.estimatedAmount = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.status = const Value.absent(),
    this.convertedInvoiceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuotationsCompanion.insert({
    this.id = const Value.absent(),
    required String quoteNo,
    this.customerId = const Value.absent(),
    this.prospectiveCustomerName = const Value.absent(),
    this.prospectiveCustomerPhone = const Value.absent(),
    this.motorJobId = const Value.absent(),
    required String description,
    required double estimatedAmount,
    this.validUntil = const Value.absent(),
    required QuotationStatus status,
    this.convertedInvoiceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : quoteNo = Value(quoteNo),
       description = Value(description),
       estimatedAmount = Value(estimatedAmount),
       status = Value(status);
  static Insertable<Quotation> custom({
    Expression<int>? id,
    Expression<String>? quoteNo,
    Expression<int>? customerId,
    Expression<String>? prospectiveCustomerName,
    Expression<String>? prospectiveCustomerPhone,
    Expression<int>? motorJobId,
    Expression<String>? description,
    Expression<double>? estimatedAmount,
    Expression<DateTime>? validUntil,
    Expression<String>? status,
    Expression<int>? convertedInvoiceId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteNo != null) 'quote_no': quoteNo,
      if (customerId != null) 'customer_id': customerId,
      if (prospectiveCustomerName != null)
        'prospective_customer_name': prospectiveCustomerName,
      if (prospectiveCustomerPhone != null)
        'prospective_customer_phone': prospectiveCustomerPhone,
      if (motorJobId != null) 'motor_job_id': motorJobId,
      if (description != null) 'description': description,
      if (estimatedAmount != null) 'estimated_amount': estimatedAmount,
      if (validUntil != null) 'valid_until': validUntil,
      if (status != null) 'status': status,
      if (convertedInvoiceId != null)
        'converted_invoice_id': convertedInvoiceId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuotationsCompanion copyWith({
    Value<int>? id,
    Value<String>? quoteNo,
    Value<int?>? customerId,
    Value<String?>? prospectiveCustomerName,
    Value<String?>? prospectiveCustomerPhone,
    Value<int?>? motorJobId,
    Value<String>? description,
    Value<double>? estimatedAmount,
    Value<DateTime?>? validUntil,
    Value<QuotationStatus>? status,
    Value<int?>? convertedInvoiceId,
    Value<DateTime>? createdAt,
  }) {
    return QuotationsCompanion(
      id: id ?? this.id,
      quoteNo: quoteNo ?? this.quoteNo,
      customerId: customerId ?? this.customerId,
      prospectiveCustomerName:
          prospectiveCustomerName ?? this.prospectiveCustomerName,
      prospectiveCustomerPhone:
          prospectiveCustomerPhone ?? this.prospectiveCustomerPhone,
      motorJobId: motorJobId ?? this.motorJobId,
      description: description ?? this.description,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      convertedInvoiceId: convertedInvoiceId ?? this.convertedInvoiceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (quoteNo.present) {
      map['quote_no'] = Variable<String>(quoteNo.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (prospectiveCustomerName.present) {
      map['prospective_customer_name'] = Variable<String>(
        prospectiveCustomerName.value,
      );
    }
    if (prospectiveCustomerPhone.present) {
      map['prospective_customer_phone'] = Variable<String>(
        prospectiveCustomerPhone.value,
      );
    }
    if (motorJobId.present) {
      map['motor_job_id'] = Variable<int>(motorJobId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (estimatedAmount.present) {
      map['estimated_amount'] = Variable<double>(estimatedAmount.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $QuotationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (convertedInvoiceId.present) {
      map['converted_invoice_id'] = Variable<int>(convertedInvoiceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotationsCompanion(')
          ..write('id: $id, ')
          ..write('quoteNo: $quoteNo, ')
          ..write('customerId: $customerId, ')
          ..write('prospectiveCustomerName: $prospectiveCustomerName, ')
          ..write('prospectiveCustomerPhone: $prospectiveCustomerPhone, ')
          ..write('motorJobId: $motorJobId, ')
          ..write('description: $description, ')
          ..write('estimatedAmount: $estimatedAmount, ')
          ..write('validUntil: $validUntil, ')
          ..write('status: $status, ')
          ..write('convertedInvoiceId: $convertedInvoiceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DeletedRecordsLogTable extends DeletedRecordsLog
    with TableInfo<$DeletedRecordsLogTable, DeletedRecordsLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeletedRecordsLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<String> deletedAt = GeneratedColumn<String>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snapshotMeta = const VerificationMeta(
    'snapshot',
  );
  @override
  late final GeneratedColumn<String> snapshot = GeneratedColumn<String>(
    'snapshot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    deletedAt,
    snapshot,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deleted_records_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeletedRecordsLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    if (data.containsKey('snapshot')) {
      context.handle(
        _snapshotMeta,
        snapshot.isAcceptableOrUnknown(data['snapshot']!, _snapshotMeta),
      );
    } else if (isInserting) {
      context.missing(_snapshotMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeletedRecordsLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeletedRecordsLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deleted_at'],
      )!,
      snapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snapshot'],
      )!,
    );
  }

  @override
  $DeletedRecordsLogTable createAlias(String alias) {
    return $DeletedRecordsLogTable(attachedDatabase, alias);
  }
}

class DeletedRecordsLogData extends DataClass
    implements Insertable<DeletedRecordsLogData> {
  final int id;
  final String entityType;
  final int entityId;
  final String deletedAt;
  final String snapshot;
  const DeletedRecordsLogData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.deletedAt,
    required this.snapshot,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    map['deleted_at'] = Variable<String>(deletedAt);
    map['snapshot'] = Variable<String>(snapshot);
    return map;
  }

  DeletedRecordsLogCompanion toCompanion(bool nullToAbsent) {
    return DeletedRecordsLogCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      deletedAt: Value(deletedAt),
      snapshot: Value(snapshot),
    );
  }

  factory DeletedRecordsLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeletedRecordsLogData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      deletedAt: serializer.fromJson<String>(json['deletedAt']),
      snapshot: serializer.fromJson<String>(json['snapshot']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'deletedAt': serializer.toJson<String>(deletedAt),
      'snapshot': serializer.toJson<String>(snapshot),
    };
  }

  DeletedRecordsLogData copyWith({
    int? id,
    String? entityType,
    int? entityId,
    String? deletedAt,
    String? snapshot,
  }) => DeletedRecordsLogData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    deletedAt: deletedAt ?? this.deletedAt,
    snapshot: snapshot ?? this.snapshot,
  );
  DeletedRecordsLogData copyWithCompanion(DeletedRecordsLogCompanion data) {
    return DeletedRecordsLogData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      snapshot: data.snapshot.present ? data.snapshot.value : this.snapshot,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeletedRecordsLogData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('snapshot: $snapshot')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, deletedAt, snapshot);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeletedRecordsLogData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.deletedAt == this.deletedAt &&
          other.snapshot == this.snapshot);
}

class DeletedRecordsLogCompanion
    extends UpdateCompanion<DeletedRecordsLogData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String> deletedAt;
  final Value<String> snapshot;
  const DeletedRecordsLogCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.snapshot = const Value.absent(),
  });
  DeletedRecordsLogCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required int entityId,
    required String deletedAt,
    required String snapshot,
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       deletedAt = Value(deletedAt),
       snapshot = Value(snapshot);
  static Insertable<DeletedRecordsLogData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? deletedAt,
    Expression<String>? snapshot,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (snapshot != null) 'snapshot': snapshot,
    });
  }

  DeletedRecordsLogCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String>? deletedAt,
    Value<String>? snapshot,
  }) {
    return DeletedRecordsLogCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      deletedAt: deletedAt ?? this.deletedAt,
      snapshot: snapshot ?? this.snapshot,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<String>(deletedAt.value);
    }
    if (snapshot.present) {
      map['snapshot'] = Variable<String>(snapshot.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeletedRecordsLogCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('snapshot: $snapshot')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vendorNameMeta = const VerificationMeta(
    'vendorName',
  );
  @override
  late final GeneratedColumn<String> vendorName = GeneratedColumn<String>(
    'vendor_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMode?, String>
  paymentMode = GeneratedColumn<String>(
    'payment_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<PaymentMode?>($PurchasesTable.$converterpaymentModen);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billImagePathMeta = const VerificationMeta(
    'billImagePath',
  );
  @override
  late final GeneratedColumn<String> billImagePath = GeneratedColumn<String>(
    'bill_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vendorName,
    purchaseDate,
    paymentMode,
    notes,
    billImagePath,
    totalAmount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Purchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vendor_name')) {
      context.handle(
        _vendorNameMeta,
        vendorName.isAcceptableOrUnknown(data['vendor_name']!, _vendorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_vendorNameMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('bill_image_path')) {
      context.handle(
        _billImagePathMeta,
        billImagePath.isAcceptableOrUnknown(
          data['bill_image_path']!,
          _billImagePathMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vendorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vendor_name'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      paymentMode: $PurchasesTable.$converterpaymentModen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_mode'],
        ),
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      billImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bill_image_path'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMode, String, String> $converterpaymentMode =
      const EnumNameConverter<PaymentMode>(PaymentMode.values);
  static JsonTypeConverter2<PaymentMode?, String?, String?>
  $converterpaymentModen = JsonTypeConverter2.asNullable($converterpaymentMode);
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final int id;
  final String vendorName;
  final DateTime purchaseDate;
  final PaymentMode? paymentMode;
  final String? notes;
  final String? billImagePath;
  final double totalAmount;
  final DateTime createdAt;
  const Purchase({
    required this.id,
    required this.vendorName,
    required this.purchaseDate,
    this.paymentMode,
    this.notes,
    this.billImagePath,
    required this.totalAmount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vendor_name'] = Variable<String>(vendorName);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || paymentMode != null) {
      map['payment_mode'] = Variable<String>(
        $PurchasesTable.$converterpaymentModen.toSql(paymentMode),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || billImagePath != null) {
      map['bill_image_path'] = Variable<String>(billImagePath);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      vendorName: Value(vendorName),
      purchaseDate: Value(purchaseDate),
      paymentMode: paymentMode == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMode),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      billImagePath: billImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(billImagePath),
      totalAmount: Value(totalAmount),
      createdAt: Value(createdAt),
    );
  }

  factory Purchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<int>(json['id']),
      vendorName: serializer.fromJson<String>(json['vendorName']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      paymentMode: $PurchasesTable.$converterpaymentModen.fromJson(
        serializer.fromJson<String?>(json['paymentMode']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      billImagePath: serializer.fromJson<String?>(json['billImagePath']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vendorName': serializer.toJson<String>(vendorName),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'paymentMode': serializer.toJson<String?>(
        $PurchasesTable.$converterpaymentModen.toJson(paymentMode),
      ),
      'notes': serializer.toJson<String?>(notes),
      'billImagePath': serializer.toJson<String?>(billImagePath),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Purchase copyWith({
    int? id,
    String? vendorName,
    DateTime? purchaseDate,
    Value<PaymentMode?> paymentMode = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> billImagePath = const Value.absent(),
    double? totalAmount,
    DateTime? createdAt,
  }) => Purchase(
    id: id ?? this.id,
    vendorName: vendorName ?? this.vendorName,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    paymentMode: paymentMode.present ? paymentMode.value : this.paymentMode,
    notes: notes.present ? notes.value : this.notes,
    billImagePath: billImagePath.present
        ? billImagePath.value
        : this.billImagePath,
    totalAmount: totalAmount ?? this.totalAmount,
    createdAt: createdAt ?? this.createdAt,
  );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      vendorName: data.vendorName.present
          ? data.vendorName.value
          : this.vendorName,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      paymentMode: data.paymentMode.present
          ? data.paymentMode.value
          : this.paymentMode,
      notes: data.notes.present ? data.notes.value : this.notes,
      billImagePath: data.billImagePath.present
          ? data.billImagePath.value
          : this.billImagePath,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('vendorName: $vendorName, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
          ..write('billImagePath: $billImagePath, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vendorName,
    purchaseDate,
    paymentMode,
    notes,
    billImagePath,
    totalAmount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.vendorName == this.vendorName &&
          other.purchaseDate == this.purchaseDate &&
          other.paymentMode == this.paymentMode &&
          other.notes == this.notes &&
          other.billImagePath == this.billImagePath &&
          other.totalAmount == this.totalAmount &&
          other.createdAt == this.createdAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<int> id;
  final Value<String> vendorName;
  final Value<DateTime> purchaseDate;
  final Value<PaymentMode?> paymentMode;
  final Value<String?> notes;
  final Value<String?> billImagePath;
  final Value<double> totalAmount;
  final Value<DateTime> createdAt;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.vendorName = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.billImagePath = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchasesCompanion.insert({
    this.id = const Value.absent(),
    required String vendorName,
    required DateTime purchaseDate,
    this.paymentMode = const Value.absent(),
    this.notes = const Value.absent(),
    this.billImagePath = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vendorName = Value(vendorName),
       purchaseDate = Value(purchaseDate);
  static Insertable<Purchase> custom({
    Expression<int>? id,
    Expression<String>? vendorName,
    Expression<DateTime>? purchaseDate,
    Expression<String>? paymentMode,
    Expression<String>? notes,
    Expression<String>? billImagePath,
    Expression<double>? totalAmount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vendorName != null) 'vendor_name': vendorName,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (paymentMode != null) 'payment_mode': paymentMode,
      if (notes != null) 'notes': notes,
      if (billImagePath != null) 'bill_image_path': billImagePath,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchasesCompanion copyWith({
    Value<int>? id,
    Value<String>? vendorName,
    Value<DateTime>? purchaseDate,
    Value<PaymentMode?>? paymentMode,
    Value<String?>? notes,
    Value<String?>? billImagePath,
    Value<double>? totalAmount,
    Value<DateTime>? createdAt,
  }) {
    return PurchasesCompanion(
      id: id ?? this.id,
      vendorName: vendorName ?? this.vendorName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      paymentMode: paymentMode ?? this.paymentMode,
      notes: notes ?? this.notes,
      billImagePath: billImagePath ?? this.billImagePath,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vendorName.present) {
      map['vendor_name'] = Variable<String>(vendorName.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (paymentMode.present) {
      map['payment_mode'] = Variable<String>(
        $PurchasesTable.$converterpaymentModen.toSql(paymentMode.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (billImagePath.present) {
      map['bill_image_path'] = Variable<String>(billImagePath.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('vendorName: $vendorName, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('paymentMode: $paymentMode, ')
          ..write('notes: $notes, ')
          ..write('billImagePath: $billImagePath, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchases (id)',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gstAmountMeta = const VerificationMeta(
    'gstAmount',
  );
  @override
  late final GeneratedColumn<double> gstAmount = GeneratedColumn<double>(
    'gst_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    category,
    description,
    amount,
    gstAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('gst_amount')) {
      context.handle(
        _gstAmountMeta,
        gstAmount.isAcceptableOrUnknown(data['gst_amount']!, _gstAmountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      gstAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gst_amount'],
      ),
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final int id;
  final int purchaseId;
  final String category;
  final String description;
  final double amount;
  final double? gstAmount;
  const PurchaseItem({
    required this.id,
    required this.purchaseId,
    required this.category,
    required this.description,
    required this.amount,
    this.gstAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || gstAmount != null) {
      map['gst_amount'] = Variable<double>(gstAmount);
    }
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      category: Value(category),
      description: Value(description),
      amount: Value(amount),
      gstAmount: gstAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(gstAmount),
    );
  }

  factory PurchaseItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      gstAmount: serializer.fromJson<double?>(json['gstAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'gstAmount': serializer.toJson<double?>(gstAmount),
    };
  }

  PurchaseItem copyWith({
    int? id,
    int? purchaseId,
    String? category,
    String? description,
    double? amount,
    Value<double?> gstAmount = const Value.absent(),
  }) => PurchaseItem(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    category: category ?? this.category,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    gstAmount: gstAmount.present ? gstAmount.value : this.gstAmount,
  );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      gstAmount: data.gstAmount.present ? data.gstAmount.value : this.gstAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('gstAmount: $gstAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseId, category, description, amount, gstAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.category == this.category &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.gstAmount == this.gstAmount);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<int> id;
  final Value<int> purchaseId;
  final Value<String> category;
  final Value<String> description;
  final Value<double> amount;
  final Value<double?> gstAmount;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.gstAmount = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseId,
    required String category,
    required String description,
    required double amount,
    this.gstAmount = const Value.absent(),
  }) : purchaseId = Value(purchaseId),
       category = Value(category),
       description = Value(description),
       amount = Value(amount);
  static Insertable<PurchaseItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseId,
    Expression<String>? category,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<double>? gstAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (gstAmount != null) 'gst_amount': gstAmount,
    });
  }

  PurchaseItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? purchaseId,
    Value<String>? category,
    Value<String>? description,
    Value<double>? amount,
    Value<double?>? gstAmount,
  }) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      gstAmount: gstAmount ?? this.gstAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (gstAmount.present) {
      map['gst_amount'] = Variable<double>(gstAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('gstAmount: $gstAmount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $MotorJobsTable motorJobs = $MotorJobsTable(this);
  late final $CopperStockTable copperStock = $CopperStockTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceItemsTable invoiceItems = $InvoiceItemsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $CompanySettingsTable companySettings = $CompanySettingsTable(
    this,
  );
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $AttendanceRecordsTable attendanceRecords =
      $AttendanceRecordsTable(this);
  late final $FinancialYearSequenceTable financialYearSequence =
      $FinancialYearSequenceTable(this);
  late final $CashCategoriesTable cashCategories = $CashCategoriesTable(this);
  late final $CashTransactionsTable cashTransactions = $CashTransactionsTable(
    this,
  );
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $QuotationsTable quotations = $QuotationsTable(this);
  late final $DeletedRecordsLogTable deletedRecordsLog =
      $DeletedRecordsLogTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    customers,
    motorJobs,
    copperStock,
    invoices,
    invoiceItems,
    stockMovements,
    companySettings,
    employees,
    attendanceRecords,
    financialYearSequence,
    cashCategories,
    cashTransactions,
    payments,
    quotations,
    deletedRecordsLog,
    purchases,
    purchaseItems,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      required String sku,
      required String hsnCode,
      required double gstRate,
      required double unitPrice,
      required int stockQty,
      Value<int?> reorderLevel,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> sku,
      Value<String> hsnCode,
      Value<double> gstRate,
      Value<double> unitPrice,
      Value<int> stockQty,
      Value<int?> reorderLevel,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get gstRate =>
      $composableBuilder(column: $table.gstRate, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<int> get reorderLevel => $composableBuilder(
    column: $table.reorderLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String> hsnCode = const Value.absent(),
                Value<double> gstRate = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<int> stockQty = const Value.absent(),
                Value<int?> reorderLevel = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                sku: sku,
                hsnCode: hsnCode,
                gstRate: gstRate,
                unitPrice: unitPrice,
                stockQty: stockQty,
                reorderLevel: reorderLevel,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String sku,
                required String hsnCode,
                required double gstRate,
                required double unitPrice,
                required int stockQty,
                Value<int?> reorderLevel = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                sku: sku,
                hsnCode: hsnCode,
                gstRate: gstRate,
                unitPrice: unitPrice,
                stockQty: stockQty,
                reorderLevel: reorderLevel,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String name,
      required String address,
      required String state,
      Value<String?> gstin,
      Value<String?> panNumber,
      required String phone,
      required String email,
      Value<String?> vendorCode,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> address,
      Value<String> state,
      Value<String?> gstin,
      Value<String?> panNumber,
      Value<String> phone,
      Value<String> email,
      Value<String?> vendorCode,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MotorJobsTable, List<MotorJob>>
  _motorJobsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.motorJobs,
    aliasName: 'customers__id__motor_jobs__customer_id',
  );

  $$MotorJobsTableProcessedTableManager get motorJobsRefs {
    final manager = $$MotorJobsTableTableManager(
      $_db,
      $_db.motorJobs,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_motorJobsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: 'customers__id__invoices__customer_id',
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuotationsTable, List<Quotation>>
  _quotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quotations,
    aliasName: 'customers__id__quotations__customer_id',
  );

  $$QuotationsTableProcessedTableManager get quotationsRefs {
    final manager = $$QuotationsTableTableManager(
      $_db,
      $_db.quotations,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vendorCode => $composableBuilder(
    column: $table.vendorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> motorJobsRefs(
    Expression<bool> Function($$MotorJobsTableFilterComposer f) f,
  ) {
    final $$MotorJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableFilterComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quotationsRefs(
    Expression<bool> Function($$QuotationsTableFilterComposer f) f,
  ) {
    final $$QuotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotations,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableFilterComposer(
            $db: $db,
            $table: $db.quotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get panNumber => $composableBuilder(
    column: $table.panNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vendorCode => $composableBuilder(
    column: $table.vendorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get panNumber =>
      $composableBuilder(column: $table.panNumber, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get vendorCode => $composableBuilder(
    column: $table.vendorCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> motorJobsRefs<T extends Object>(
    Expression<T> Function($$MotorJobsTableAnnotationComposer a) f,
  ) {
    final $$MotorJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quotationsRefs<T extends Object>(
    Expression<T> Function($$QuotationsTableAnnotationComposer a) f,
  ) {
    final $$QuotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotations,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.quotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({
            bool motorJobsRefs,
            bool invoicesRefs,
            bool quotationsRefs,
          })
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> gstin = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> vendorCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                address: address,
                state: state,
                gstin: gstin,
                panNumber: panNumber,
                phone: phone,
                email: email,
                vendorCode: vendorCode,
                createdAt: createdAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String address,
                required String state,
                Value<String?> gstin = const Value.absent(),
                Value<String?> panNumber = const Value.absent(),
                required String phone,
                required String email,
                Value<String?> vendorCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                address: address,
                state: state,
                gstin: gstin,
                panNumber: panNumber,
                phone: phone,
                email: email,
                vendorCode: vendorCode,
                createdAt: createdAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                motorJobsRefs = false,
                invoicesRefs = false,
                quotationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (motorJobsRefs) db.motorJobs,
                    if (invoicesRefs) db.invoices,
                    if (quotationsRefs) db.quotations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (motorJobsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          MotorJob
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._motorJobsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).motorJobsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quotationsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Quotation
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._quotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).quotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({
        bool motorJobsRefs,
        bool invoicesRefs,
        bool quotationsRefs,
      })
    >;
typedef $$MotorJobsTableCreateCompanionBuilder =
    MotorJobsCompanion Function({
      Value<int> id,
      required String jobNo,
      required int customerId,
      required String motorDescription,
      Value<String?> motorMake,
      Value<double?> hp,
      Value<Phase?> phase,
      required DateTime dateReceived,
      required String jobDescription,
      required MotorJobStatus status,
      Value<double?> serviceCharge,
      Value<String?> sacCode,
      Value<String?> gpNumber,
      Value<DateTime?> gpDate,
      Value<DateTime?> dispatchDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$MotorJobsTableUpdateCompanionBuilder =
    MotorJobsCompanion Function({
      Value<int> id,
      Value<String> jobNo,
      Value<int> customerId,
      Value<String> motorDescription,
      Value<String?> motorMake,
      Value<double?> hp,
      Value<Phase?> phase,
      Value<DateTime> dateReceived,
      Value<String> jobDescription,
      Value<MotorJobStatus> status,
      Value<double?> serviceCharge,
      Value<String?> sacCode,
      Value<String?> gpNumber,
      Value<DateTime?> gpDate,
      Value<DateTime?> dispatchDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$MotorJobsTableReferences
    extends BaseReferences<_$AppDatabase, $MotorJobsTable, MotorJob> {
  $$MotorJobsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('motor_jobs__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
  _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceItems,
    aliasName: 'motor_jobs__id__invoice_items__motor_job_id',
  );

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager(
      $_db,
      $_db.invoiceItems,
    ).filter((f) => f.motorJobId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuotationsTable, List<Quotation>>
  _quotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quotations,
    aliasName: 'motor_jobs__id__quotations__motor_job_id',
  );

  $$QuotationsTableProcessedTableManager get quotationsRefs {
    final manager = $$QuotationsTableTableManager(
      $_db,
      $_db.quotations,
    ).filter((f) => f.motorJobId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MotorJobsTableFilterComposer
    extends Composer<_$AppDatabase, $MotorJobsTable> {
  $$MotorJobsTableFilterComposer({
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

  ColumnFilters<String> get jobNo => $composableBuilder(
    column: $table.jobNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motorDescription => $composableBuilder(
    column: $table.motorDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motorMake => $composableBuilder(
    column: $table.motorMake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Phase?, Phase, String> get phase =>
      $composableBuilder(
        column: $table.phase,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get dateReceived => $composableBuilder(
    column: $table.dateReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobDescription => $composableBuilder(
    column: $table.jobDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MotorJobStatus, MotorJobStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get serviceCharge => $composableBuilder(
    column: $table.serviceCharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sacCode => $composableBuilder(
    column: $table.sacCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gpNumber => $composableBuilder(
    column: $table.gpNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get gpDate => $composableBuilder(
    column: $table.gpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dispatchDate => $composableBuilder(
    column: $table.dispatchDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceItemsRefs(
    Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.motorJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quotationsRefs(
    Expression<bool> Function($$QuotationsTableFilterComposer f) f,
  ) {
    final $$QuotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotations,
      getReferencedColumn: (t) => t.motorJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableFilterComposer(
            $db: $db,
            $table: $db.quotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MotorJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $MotorJobsTable> {
  $$MotorJobsTableOrderingComposer({
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

  ColumnOrderings<String> get jobNo => $composableBuilder(
    column: $table.jobNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motorDescription => $composableBuilder(
    column: $table.motorDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motorMake => $composableBuilder(
    column: $table.motorMake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateReceived => $composableBuilder(
    column: $table.dateReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobDescription => $composableBuilder(
    column: $table.jobDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get serviceCharge => $composableBuilder(
    column: $table.serviceCharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sacCode => $composableBuilder(
    column: $table.sacCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpNumber => $composableBuilder(
    column: $table.gpNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get gpDate => $composableBuilder(
    column: $table.gpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dispatchDate => $composableBuilder(
    column: $table.dispatchDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MotorJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MotorJobsTable> {
  $$MotorJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get jobNo =>
      $composableBuilder(column: $table.jobNo, builder: (column) => column);

  GeneratedColumn<String> get motorDescription => $composableBuilder(
    column: $table.motorDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motorMake =>
      $composableBuilder(column: $table.motorMake, builder: (column) => column);

  GeneratedColumn<double> get hp =>
      $composableBuilder(column: $table.hp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Phase?, String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<DateTime> get dateReceived => $composableBuilder(
    column: $table.dateReceived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jobDescription => $composableBuilder(
    column: $table.jobDescription,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MotorJobStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get serviceCharge => $composableBuilder(
    column: $table.serviceCharge,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sacCode =>
      $composableBuilder(column: $table.sacCode, builder: (column) => column);

  GeneratedColumn<String> get gpNumber =>
      $composableBuilder(column: $table.gpNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get gpDate =>
      $composableBuilder(column: $table.gpDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dispatchDate => $composableBuilder(
    column: $table.dispatchDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.motorJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quotationsRefs<T extends Object>(
    Expression<T> Function($$QuotationsTableAnnotationComposer a) f,
  ) {
    final $$QuotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotations,
      getReferencedColumn: (t) => t.motorJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.quotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MotorJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MotorJobsTable,
          MotorJob,
          $$MotorJobsTableFilterComposer,
          $$MotorJobsTableOrderingComposer,
          $$MotorJobsTableAnnotationComposer,
          $$MotorJobsTableCreateCompanionBuilder,
          $$MotorJobsTableUpdateCompanionBuilder,
          (MotorJob, $$MotorJobsTableReferences),
          MotorJob,
          PrefetchHooks Function({
            bool customerId,
            bool invoiceItemsRefs,
            bool quotationsRefs,
          })
        > {
  $$MotorJobsTableTableManager(_$AppDatabase db, $MotorJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MotorJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MotorJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MotorJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> jobNo = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<String> motorDescription = const Value.absent(),
                Value<String?> motorMake = const Value.absent(),
                Value<double?> hp = const Value.absent(),
                Value<Phase?> phase = const Value.absent(),
                Value<DateTime> dateReceived = const Value.absent(),
                Value<String> jobDescription = const Value.absent(),
                Value<MotorJobStatus> status = const Value.absent(),
                Value<double?> serviceCharge = const Value.absent(),
                Value<String?> sacCode = const Value.absent(),
                Value<String?> gpNumber = const Value.absent(),
                Value<DateTime?> gpDate = const Value.absent(),
                Value<DateTime?> dispatchDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MotorJobsCompanion(
                id: id,
                jobNo: jobNo,
                customerId: customerId,
                motorDescription: motorDescription,
                motorMake: motorMake,
                hp: hp,
                phase: phase,
                dateReceived: dateReceived,
                jobDescription: jobDescription,
                status: status,
                serviceCharge: serviceCharge,
                sacCode: sacCode,
                gpNumber: gpNumber,
                gpDate: gpDate,
                dispatchDate: dispatchDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String jobNo,
                required int customerId,
                required String motorDescription,
                Value<String?> motorMake = const Value.absent(),
                Value<double?> hp = const Value.absent(),
                Value<Phase?> phase = const Value.absent(),
                required DateTime dateReceived,
                required String jobDescription,
                required MotorJobStatus status,
                Value<double?> serviceCharge = const Value.absent(),
                Value<String?> sacCode = const Value.absent(),
                Value<String?> gpNumber = const Value.absent(),
                Value<DateTime?> gpDate = const Value.absent(),
                Value<DateTime?> dispatchDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MotorJobsCompanion.insert(
                id: id,
                jobNo: jobNo,
                customerId: customerId,
                motorDescription: motorDescription,
                motorMake: motorMake,
                hp: hp,
                phase: phase,
                dateReceived: dateReceived,
                jobDescription: jobDescription,
                status: status,
                serviceCharge: serviceCharge,
                sacCode: sacCode,
                gpNumber: gpNumber,
                gpDate: gpDate,
                dispatchDate: dispatchDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MotorJobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                invoiceItemsRefs = false,
                quotationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsRefs) db.invoiceItems,
                    if (quotationsRefs) db.quotations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$MotorJobsTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$MotorJobsTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsRefs)
                        await $_getPrefetchedData<
                          MotorJob,
                          $MotorJobsTable,
                          InvoiceItem
                        >(
                          currentTable: table,
                          referencedTable: $$MotorJobsTableReferences
                              ._invoiceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MotorJobsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.motorJobId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quotationsRefs)
                        await $_getPrefetchedData<
                          MotorJob,
                          $MotorJobsTable,
                          Quotation
                        >(
                          currentTable: table,
                          referencedTable: $$MotorJobsTableReferences
                              ._quotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MotorJobsTableReferences(
                                db,
                                table,
                                p0,
                              ).quotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.motorJobId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MotorJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MotorJobsTable,
      MotorJob,
      $$MotorJobsTableFilterComposer,
      $$MotorJobsTableOrderingComposer,
      $$MotorJobsTableAnnotationComposer,
      $$MotorJobsTableCreateCompanionBuilder,
      $$MotorJobsTableUpdateCompanionBuilder,
      (MotorJob, $$MotorJobsTableReferences),
      MotorJob,
      PrefetchHooks Function({
        bool customerId,
        bool invoiceItemsRefs,
        bool quotationsRefs,
      })
    >;
typedef $$CopperStockTableCreateCompanionBuilder =
    CopperStockCompanion Function({
      Value<int> id,
      required CopperType copperType,
      required String description,
      required double weightKg,
      required double pricePerKg,
      Value<double?> gstRate,
      Value<String?> hsnCode,
      required double stockQtyKg,
      Value<double?> reorderLevelKg,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CopperStockTableUpdateCompanionBuilder =
    CopperStockCompanion Function({
      Value<int> id,
      Value<CopperType> copperType,
      Value<String> description,
      Value<double> weightKg,
      Value<double> pricePerKg,
      Value<double?> gstRate,
      Value<String?> hsnCode,
      Value<double> stockQtyKg,
      Value<double?> reorderLevelKg,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CopperStockTableReferences
    extends BaseReferences<_$AppDatabase, $CopperStockTable, CopperStockData> {
  $$CopperStockTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
  _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceItems,
    aliasName: 'copper_stock__id__invoice_items__copper_stock_id',
  );

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager(
      $_db,
      $_db.invoiceItems,
    ).filter((f) => f.copperStockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'copper_stock__id__stock_movements__copper_stock_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager(
      $_db,
      $_db.stockMovements,
    ).filter((f) => f.copperStockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CopperStockTableFilterComposer
    extends Composer<_$AppDatabase, $CopperStockTable> {
  $$CopperStockTableFilterComposer({
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

  ColumnWithTypeConverterFilters<CopperType, CopperType, String>
  get copperType => $composableBuilder(
    column: $table.copperType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerKg => $composableBuilder(
    column: $table.pricePerKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockQtyKg => $composableBuilder(
    column: $table.stockQtyKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reorderLevelKg => $composableBuilder(
    column: $table.reorderLevelKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> invoiceItemsRefs(
    Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.copperStockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.copperStockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CopperStockTableOrderingComposer
    extends Composer<_$AppDatabase, $CopperStockTable> {
  $$CopperStockTableOrderingComposer({
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

  ColumnOrderings<String> get copperType => $composableBuilder(
    column: $table.copperType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerKg => $composableBuilder(
    column: $table.pricePerKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockQtyKg => $composableBuilder(
    column: $table.stockQtyKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reorderLevelKg => $composableBuilder(
    column: $table.reorderLevelKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CopperStockTableAnnotationComposer
    extends Composer<_$AppDatabase, $CopperStockTable> {
  $$CopperStockTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CopperType, String> get copperType =>
      $composableBuilder(
        column: $table.copperType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get pricePerKg => $composableBuilder(
    column: $table.pricePerKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get gstRate =>
      $composableBuilder(column: $table.gstRate, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get stockQtyKg => $composableBuilder(
    column: $table.stockQtyKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get reorderLevelKg => $composableBuilder(
    column: $table.reorderLevelKg,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> invoiceItemsRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.copperStockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.copperStockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CopperStockTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CopperStockTable,
          CopperStockData,
          $$CopperStockTableFilterComposer,
          $$CopperStockTableOrderingComposer,
          $$CopperStockTableAnnotationComposer,
          $$CopperStockTableCreateCompanionBuilder,
          $$CopperStockTableUpdateCompanionBuilder,
          (CopperStockData, $$CopperStockTableReferences),
          CopperStockData,
          PrefetchHooks Function({
            bool invoiceItemsRefs,
            bool stockMovementsRefs,
          })
        > {
  $$CopperStockTableTableManager(_$AppDatabase db, $CopperStockTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CopperStockTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CopperStockTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CopperStockTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<CopperType> copperType = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> pricePerKg = const Value.absent(),
                Value<double?> gstRate = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double> stockQtyKg = const Value.absent(),
                Value<double?> reorderLevelKg = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CopperStockCompanion(
                id: id,
                copperType: copperType,
                description: description,
                weightKg: weightKg,
                pricePerKg: pricePerKg,
                gstRate: gstRate,
                hsnCode: hsnCode,
                stockQtyKg: stockQtyKg,
                reorderLevelKg: reorderLevelKg,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required CopperType copperType,
                required String description,
                required double weightKg,
                required double pricePerKg,
                Value<double?> gstRate = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                required double stockQtyKg,
                Value<double?> reorderLevelKg = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CopperStockCompanion.insert(
                id: id,
                copperType: copperType,
                description: description,
                weightKg: weightKg,
                pricePerKg: pricePerKg,
                gstRate: gstRate,
                hsnCode: hsnCode,
                stockQtyKg: stockQtyKg,
                reorderLevelKg: reorderLevelKg,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CopperStockTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({invoiceItemsRefs = false, stockMovementsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsRefs) db.invoiceItems,
                    if (stockMovementsRefs) db.stockMovements,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsRefs)
                        await $_getPrefetchedData<
                          CopperStockData,
                          $CopperStockTable,
                          InvoiceItem
                        >(
                          currentTable: table,
                          referencedTable: $$CopperStockTableReferences
                              ._invoiceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CopperStockTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.copperStockId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedData<
                          CopperStockData,
                          $CopperStockTable,
                          StockMovement
                        >(
                          currentTable: table,
                          referencedTable: $$CopperStockTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CopperStockTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.copperStockId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CopperStockTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CopperStockTable,
      CopperStockData,
      $$CopperStockTableFilterComposer,
      $$CopperStockTableOrderingComposer,
      $$CopperStockTableAnnotationComposer,
      $$CopperStockTableCreateCompanionBuilder,
      $$CopperStockTableUpdateCompanionBuilder,
      (CopperStockData, $$CopperStockTableReferences),
      CopperStockData,
      PrefetchHooks Function({bool invoiceItemsRefs, bool stockMovementsRefs})
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      required String invoiceNo,
      required InvoiceType invoiceType,
      required int customerId,
      required DateTime invoiceDate,
      Value<DateTime?> dueDate,
      required double subtotal,
      required double cgstAmount,
      required double sgstAmount,
      Value<double> igstAmount,
      required double discountAmount,
      Value<double?> deliveryCharge,
      required double grandTotal,
      required String amountInWords,
      required InvoiceStatus status,
      Value<bool> requiresEWayBill,
      Value<bool> requiresEInvoice,
      Value<String?> irnNumber,
      Value<String?> signedPdfPath,
      Value<String?> notes,
      Value<DateTime?> reminderSentDate,
      Value<String?> shipToName,
      Value<String?> shipToAddress,
      Value<String?> placeOfSupply,
      Value<String?> poNumber,
      Value<DateTime?> poDate,
      Value<String?> gpNumber,
      Value<DateTime?> gpDate,
      Value<int?> paymentTermDays,
      Value<DateTime> createdAt,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<String> invoiceNo,
      Value<InvoiceType> invoiceType,
      Value<int> customerId,
      Value<DateTime> invoiceDate,
      Value<DateTime?> dueDate,
      Value<double> subtotal,
      Value<double> cgstAmount,
      Value<double> sgstAmount,
      Value<double> igstAmount,
      Value<double> discountAmount,
      Value<double?> deliveryCharge,
      Value<double> grandTotal,
      Value<String> amountInWords,
      Value<InvoiceStatus> status,
      Value<bool> requiresEWayBill,
      Value<bool> requiresEInvoice,
      Value<String?> irnNumber,
      Value<String?> signedPdfPath,
      Value<String?> notes,
      Value<DateTime?> reminderSentDate,
      Value<String?> shipToName,
      Value<String?> shipToAddress,
      Value<String?> placeOfSupply,
      Value<String?> poNumber,
      Value<DateTime?> poDate,
      Value<String?> gpNumber,
      Value<DateTime?> gpDate,
      Value<int?> paymentTermDays,
      Value<DateTime> createdAt,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$AppDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('invoices__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceItemsTable, List<InvoiceItem>>
  _invoiceItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceItems,
    aliasName: 'invoices__id__invoice_items__invoice_id',
  );

  $$InvoiceItemsTableProcessedTableManager get invoiceItemsRefs {
    final manager = $$InvoiceItemsTableTableManager(
      $_db,
      $_db.invoiceItems,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
  _stockMovementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMovements,
    aliasName: 'invoices__id__stock_movements__reference_invoice_id',
  );

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter(
          (f) => f.referenceInvoiceId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'invoices__id__payments__invoice_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuotationsTable, List<Quotation>>
  _quotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quotations,
    aliasName: 'invoices__id__quotations__converted_invoice_id',
  );

  $$QuotationsTableProcessedTableManager get quotationsRefs {
    final manager = $$QuotationsTableTableManager($_db, $_db.quotations).filter(
      (f) => f.convertedInvoiceId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_quotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
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

  ColumnFilters<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InvoiceType, InvoiceType, String>
  get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get igstAmount => $composableBuilder(
    column: $table.igstAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deliveryCharge => $composableBuilder(
    column: $table.deliveryCharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountInWords => $composableBuilder(
    column: $table.amountInWords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InvoiceStatus, InvoiceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get requiresEWayBill => $composableBuilder(
    column: $table.requiresEWayBill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresEInvoice => $composableBuilder(
    column: $table.requiresEInvoice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get irnNumber => $composableBuilder(
    column: $table.irnNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get signedPdfPath => $composableBuilder(
    column: $table.signedPdfPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reminderSentDate => $composableBuilder(
    column: $table.reminderSentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shipToName => $composableBuilder(
    column: $table.shipToName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shipToAddress => $composableBuilder(
    column: $table.shipToAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeOfSupply => $composableBuilder(
    column: $table.placeOfSupply,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poNumber => $composableBuilder(
    column: $table.poNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get poDate => $composableBuilder(
    column: $table.poDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gpNumber => $composableBuilder(
    column: $table.gpNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get gpDate => $composableBuilder(
    column: $table.gpDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentTermDays => $composableBuilder(
    column: $table.paymentTermDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceItemsRefs(
    Expression<bool> Function($$InvoiceItemsTableFilterComposer f) f,
  ) {
    final $$InvoiceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
    Expression<bool> Function($$StockMovementsTableFilterComposer f) f,
  ) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.referenceInvoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableFilterComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quotationsRefs(
    Expression<bool> Function($$QuotationsTableFilterComposer f) f,
  ) {
    final $$QuotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotations,
      getReferencedColumn: (t) => t.convertedInvoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableFilterComposer(
            $db: $db,
            $table: $db.quotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
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

  ColumnOrderings<String> get invoiceNo => $composableBuilder(
    column: $table.invoiceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceType => $composableBuilder(
    column: $table.invoiceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get igstAmount => $composableBuilder(
    column: $table.igstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deliveryCharge => $composableBuilder(
    column: $table.deliveryCharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountInWords => $composableBuilder(
    column: $table.amountInWords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresEWayBill => $composableBuilder(
    column: $table.requiresEWayBill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresEInvoice => $composableBuilder(
    column: $table.requiresEInvoice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get irnNumber => $composableBuilder(
    column: $table.irnNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get signedPdfPath => $composableBuilder(
    column: $table.signedPdfPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reminderSentDate => $composableBuilder(
    column: $table.reminderSentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shipToName => $composableBuilder(
    column: $table.shipToName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shipToAddress => $composableBuilder(
    column: $table.shipToAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeOfSupply => $composableBuilder(
    column: $table.placeOfSupply,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poNumber => $composableBuilder(
    column: $table.poNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get poDate => $composableBuilder(
    column: $table.poDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gpNumber => $composableBuilder(
    column: $table.gpNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get gpDate => $composableBuilder(
    column: $table.gpDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentTermDays => $composableBuilder(
    column: $table.paymentTermDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNo =>
      $composableBuilder(column: $table.invoiceNo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InvoiceType, String> get invoiceType =>
      $composableBuilder(
        column: $table.invoiceType,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get cgstAmount => $composableBuilder(
    column: $table.cgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sgstAmount => $composableBuilder(
    column: $table.sgstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get igstAmount => $composableBuilder(
    column: $table.igstAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get deliveryCharge => $composableBuilder(
    column: $table.deliveryCharge,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amountInWords => $composableBuilder(
    column: $table.amountInWords,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InvoiceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get requiresEWayBill => $composableBuilder(
    column: $table.requiresEWayBill,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresEInvoice => $composableBuilder(
    column: $table.requiresEInvoice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get irnNumber =>
      $composableBuilder(column: $table.irnNumber, builder: (column) => column);

  GeneratedColumn<String> get signedPdfPath => $composableBuilder(
    column: $table.signedPdfPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get reminderSentDate => $composableBuilder(
    column: $table.reminderSentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shipToName => $composableBuilder(
    column: $table.shipToName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shipToAddress => $composableBuilder(
    column: $table.shipToAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeOfSupply => $composableBuilder(
    column: $table.placeOfSupply,
    builder: (column) => column,
  );

  GeneratedColumn<String> get poNumber =>
      $composableBuilder(column: $table.poNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get poDate =>
      $composableBuilder(column: $table.poDate, builder: (column) => column);

  GeneratedColumn<String> get gpNumber =>
      $composableBuilder(column: $table.gpNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get gpDate =>
      $composableBuilder(column: $table.gpDate, builder: (column) => column);

  GeneratedColumn<int> get paymentTermDays => $composableBuilder(
    column: $table.paymentTermDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceItemsRefs<T extends Object>(
    Expression<T> Function($$InvoiceItemsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceItems,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
    Expression<T> Function($$StockMovementsTableAnnotationComposer a) f,
  ) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMovements,
      getReferencedColumn: (t) => t.referenceInvoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovementsTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMovements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quotationsRefs<T extends Object>(
    Expression<T> Function($$QuotationsTableAnnotationComposer a) f,
  ) {
    final $$QuotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quotations,
      getReferencedColumn: (t) => t.convertedInvoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.quotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({
            bool customerId,
            bool invoiceItemsRefs,
            bool stockMovementsRefs,
            bool paymentsRefs,
            bool quotationsRefs,
          })
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceNo = const Value.absent(),
                Value<InvoiceType> invoiceType = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<DateTime> invoiceDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> cgstAmount = const Value.absent(),
                Value<double> sgstAmount = const Value.absent(),
                Value<double> igstAmount = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double?> deliveryCharge = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<String> amountInWords = const Value.absent(),
                Value<InvoiceStatus> status = const Value.absent(),
                Value<bool> requiresEWayBill = const Value.absent(),
                Value<bool> requiresEInvoice = const Value.absent(),
                Value<String?> irnNumber = const Value.absent(),
                Value<String?> signedPdfPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> reminderSentDate = const Value.absent(),
                Value<String?> shipToName = const Value.absent(),
                Value<String?> shipToAddress = const Value.absent(),
                Value<String?> placeOfSupply = const Value.absent(),
                Value<String?> poNumber = const Value.absent(),
                Value<DateTime?> poDate = const Value.absent(),
                Value<String?> gpNumber = const Value.absent(),
                Value<DateTime?> gpDate = const Value.absent(),
                Value<int?> paymentTermDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNo: invoiceNo,
                invoiceType: invoiceType,
                customerId: customerId,
                invoiceDate: invoiceDate,
                dueDate: dueDate,
                subtotal: subtotal,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                igstAmount: igstAmount,
                discountAmount: discountAmount,
                deliveryCharge: deliveryCharge,
                grandTotal: grandTotal,
                amountInWords: amountInWords,
                status: status,
                requiresEWayBill: requiresEWayBill,
                requiresEInvoice: requiresEInvoice,
                irnNumber: irnNumber,
                signedPdfPath: signedPdfPath,
                notes: notes,
                reminderSentDate: reminderSentDate,
                shipToName: shipToName,
                shipToAddress: shipToAddress,
                placeOfSupply: placeOfSupply,
                poNumber: poNumber,
                poDate: poDate,
                gpNumber: gpNumber,
                gpDate: gpDate,
                paymentTermDays: paymentTermDays,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceNo,
                required InvoiceType invoiceType,
                required int customerId,
                required DateTime invoiceDate,
                Value<DateTime?> dueDate = const Value.absent(),
                required double subtotal,
                required double cgstAmount,
                required double sgstAmount,
                Value<double> igstAmount = const Value.absent(),
                required double discountAmount,
                Value<double?> deliveryCharge = const Value.absent(),
                required double grandTotal,
                required String amountInWords,
                required InvoiceStatus status,
                Value<bool> requiresEWayBill = const Value.absent(),
                Value<bool> requiresEInvoice = const Value.absent(),
                Value<String?> irnNumber = const Value.absent(),
                Value<String?> signedPdfPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> reminderSentDate = const Value.absent(),
                Value<String?> shipToName = const Value.absent(),
                Value<String?> shipToAddress = const Value.absent(),
                Value<String?> placeOfSupply = const Value.absent(),
                Value<String?> poNumber = const Value.absent(),
                Value<DateTime?> poDate = const Value.absent(),
                Value<String?> gpNumber = const Value.absent(),
                Value<DateTime?> gpDate = const Value.absent(),
                Value<int?> paymentTermDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNo: invoiceNo,
                invoiceType: invoiceType,
                customerId: customerId,
                invoiceDate: invoiceDate,
                dueDate: dueDate,
                subtotal: subtotal,
                cgstAmount: cgstAmount,
                sgstAmount: sgstAmount,
                igstAmount: igstAmount,
                discountAmount: discountAmount,
                deliveryCharge: deliveryCharge,
                grandTotal: grandTotal,
                amountInWords: amountInWords,
                status: status,
                requiresEWayBill: requiresEWayBill,
                requiresEInvoice: requiresEInvoice,
                irnNumber: irnNumber,
                signedPdfPath: signedPdfPath,
                notes: notes,
                reminderSentDate: reminderSentDate,
                shipToName: shipToName,
                shipToAddress: shipToAddress,
                placeOfSupply: placeOfSupply,
                poNumber: poNumber,
                poDate: poDate,
                gpNumber: gpNumber,
                gpDate: gpDate,
                paymentTermDays: paymentTermDays,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                invoiceItemsRefs = false,
                stockMovementsRefs = false,
                paymentsRefs = false,
                quotationsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceItemsRefs) db.invoiceItems,
                    if (stockMovementsRefs) db.stockMovements,
                    if (paymentsRefs) db.payments,
                    if (quotationsRefs) db.quotations,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$InvoicesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceItemsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceItem
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockMovementsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          StockMovement
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._stockMovementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.referenceInvoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quotationsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          Quotation
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._quotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).quotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.convertedInvoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({
        bool customerId,
        bool invoiceItemsRefs,
        bool stockMovementsRefs,
        bool paymentsRefs,
        bool quotationsRefs,
      })
    >;
typedef $$InvoiceItemsTableCreateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<int> id,
      required int invoiceId,
      required ItemSourceType itemSourceType,
      Value<int?> motorJobId,
      Value<int?> copperStockId,
      required String description,
      Value<String?> rateRs,
      Value<String?> hsnCode,
      Value<double?> qty,
      required double unitPrice,
      Value<double?> gstRate,
      required double lineTotal,
    });
typedef $$InvoiceItemsTableUpdateCompanionBuilder =
    InvoiceItemsCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<ItemSourceType> itemSourceType,
      Value<int?> motorJobId,
      Value<int?> copperStockId,
      Value<String> description,
      Value<String?> rateRs,
      Value<String?> hsnCode,
      Value<double?> qty,
      Value<double> unitPrice,
      Value<double?> gstRate,
      Value<double> lineTotal,
    });

final class $$InvoiceItemsTableReferences
    extends BaseReferences<_$AppDatabase, $InvoiceItemsTable, InvoiceItem> {
  $$InvoiceItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('invoice_items__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MotorJobsTable _motorJobIdTable(_$AppDatabase db) =>
      db.motorJobs.createAlias('invoice_items__motor_job_id__motor_jobs__id');

  $$MotorJobsTableProcessedTableManager? get motorJobId {
    final $_column = $_itemColumn<int>('motor_job_id');
    if ($_column == null) return null;
    final manager = $$MotorJobsTableTableManager(
      $_db,
      $_db.motorJobs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_motorJobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CopperStockTable _copperStockIdTable(_$AppDatabase db) => db
      .copperStock
      .createAlias('invoice_items__copper_stock_id__copper_stock__id');

  $$CopperStockTableProcessedTableManager? get copperStockId {
    final $_column = $_itemColumn<int>('copper_stock_id');
    if ($_column == null) return null;
    final manager = $$CopperStockTableTableManager(
      $_db,
      $_db.copperStock,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_copperStockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ItemSourceType, ItemSourceType, String>
  get itemSourceType => $composableBuilder(
    column: $table.itemSourceType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rateRs => $composableBuilder(
    column: $table.rateRs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MotorJobsTableFilterComposer get motorJobId {
    final $$MotorJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.motorJobId,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableFilterComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CopperStockTableFilterComposer get copperStockId {
    final $$CopperStockTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copperStockId,
      referencedTable: $db.copperStock,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopperStockTableFilterComposer(
            $db: $db,
            $table: $db.copperStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableOrderingComposer({
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

  ColumnOrderings<String> get itemSourceType => $composableBuilder(
    column: $table.itemSourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateRs => $composableBuilder(
    column: $table.rateRs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsnCode => $composableBuilder(
    column: $table.hsnCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstRate => $composableBuilder(
    column: $table.gstRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MotorJobsTableOrderingComposer get motorJobId {
    final $$MotorJobsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.motorJobId,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableOrderingComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CopperStockTableOrderingComposer get copperStockId {
    final $$CopperStockTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copperStockId,
      referencedTable: $db.copperStock,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopperStockTableOrderingComposer(
            $db: $db,
            $table: $db.copperStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceItemsTable> {
  $$InvoiceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemSourceType, String> get itemSourceType =>
      $composableBuilder(
        column: $table.itemSourceType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rateRs =>
      $composableBuilder(column: $table.rateRs, builder: (column) => column);

  GeneratedColumn<String> get hsnCode =>
      $composableBuilder(column: $table.hsnCode, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get gstRate =>
      $composableBuilder(column: $table.gstRate, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MotorJobsTableAnnotationComposer get motorJobId {
    final $$MotorJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.motorJobId,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CopperStockTableAnnotationComposer get copperStockId {
    final $$CopperStockTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copperStockId,
      referencedTable: $db.copperStock,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopperStockTableAnnotationComposer(
            $db: $db,
            $table: $db.copperStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceItemsTable,
          InvoiceItem,
          $$InvoiceItemsTableFilterComposer,
          $$InvoiceItemsTableOrderingComposer,
          $$InvoiceItemsTableAnnotationComposer,
          $$InvoiceItemsTableCreateCompanionBuilder,
          $$InvoiceItemsTableUpdateCompanionBuilder,
          (InvoiceItem, $$InvoiceItemsTableReferences),
          InvoiceItem,
          PrefetchHooks Function({
            bool invoiceId,
            bool motorJobId,
            bool copperStockId,
          })
        > {
  $$InvoiceItemsTableTableManager(_$AppDatabase db, $InvoiceItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<ItemSourceType> itemSourceType = const Value.absent(),
                Value<int?> motorJobId = const Value.absent(),
                Value<int?> copperStockId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> rateRs = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double?> qty = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<double?> gstRate = const Value.absent(),
                Value<double> lineTotal = const Value.absent(),
              }) => InvoiceItemsCompanion(
                id: id,
                invoiceId: invoiceId,
                itemSourceType: itemSourceType,
                motorJobId: motorJobId,
                copperStockId: copperStockId,
                description: description,
                rateRs: rateRs,
                hsnCode: hsnCode,
                qty: qty,
                unitPrice: unitPrice,
                gstRate: gstRate,
                lineTotal: lineTotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                required ItemSourceType itemSourceType,
                Value<int?> motorJobId = const Value.absent(),
                Value<int?> copperStockId = const Value.absent(),
                required String description,
                Value<String?> rateRs = const Value.absent(),
                Value<String?> hsnCode = const Value.absent(),
                Value<double?> qty = const Value.absent(),
                required double unitPrice,
                Value<double?> gstRate = const Value.absent(),
                required double lineTotal,
              }) => InvoiceItemsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                itemSourceType: itemSourceType,
                motorJobId: motorJobId,
                copperStockId: copperStockId,
                description: description,
                rateRs: rateRs,
                hsnCode: hsnCode,
                qty: qty,
                unitPrice: unitPrice,
                gstRate: gstRate,
                lineTotal: lineTotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({invoiceId = false, motorJobId = false, copperStockId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (invoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.invoiceId,
                                    referencedTable:
                                        $$InvoiceItemsTableReferences
                                            ._invoiceIdTable(db),
                                    referencedColumn:
                                        $$InvoiceItemsTableReferences
                                            ._invoiceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (motorJobId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.motorJobId,
                                    referencedTable:
                                        $$InvoiceItemsTableReferences
                                            ._motorJobIdTable(db),
                                    referencedColumn:
                                        $$InvoiceItemsTableReferences
                                            ._motorJobIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (copperStockId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.copperStockId,
                                    referencedTable:
                                        $$InvoiceItemsTableReferences
                                            ._copperStockIdTable(db),
                                    referencedColumn:
                                        $$InvoiceItemsTableReferences
                                            ._copperStockIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$InvoiceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceItemsTable,
      InvoiceItem,
      $$InvoiceItemsTableFilterComposer,
      $$InvoiceItemsTableOrderingComposer,
      $$InvoiceItemsTableAnnotationComposer,
      $$InvoiceItemsTableCreateCompanionBuilder,
      $$InvoiceItemsTableUpdateCompanionBuilder,
      (InvoiceItem, $$InvoiceItemsTableReferences),
      InvoiceItem,
      PrefetchHooks Function({
        bool invoiceId,
        bool motorJobId,
        bool copperStockId,
      })
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<int> id,
      required int copperStockId,
      required MovementType movementType,
      required double weightKg,
      Value<int?> referenceInvoiceId,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<int> id,
      Value<int> copperStockId,
      Value<MovementType> movementType,
      Value<double> weightKg,
      Value<int?> referenceInvoiceId,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CopperStockTable _copperStockIdTable(_$AppDatabase db) => db
      .copperStock
      .createAlias('stock_movements__copper_stock_id__copper_stock__id');

  $$CopperStockTableProcessedTableManager get copperStockId {
    final $_column = $_itemColumn<int>('copper_stock_id')!;

    final manager = $$CopperStockTableTableManager(
      $_db,
      $_db.copperStock,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_copperStockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _referenceInvoiceIdTable(_$AppDatabase db) => db
      .invoices
      .createAlias('stock_movements__reference_invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager? get referenceInvoiceId {
    final $_column = $_itemColumn<int>('reference_invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_referenceInvoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MovementType, MovementType, String>
  get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CopperStockTableFilterComposer get copperStockId {
    final $$CopperStockTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copperStockId,
      referencedTable: $db.copperStock,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopperStockTableFilterComposer(
            $db: $db,
            $table: $db.copperStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get referenceInvoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.referenceInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
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

  ColumnOrderings<String> get movementType => $composableBuilder(
    column: $table.movementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CopperStockTableOrderingComposer get copperStockId {
    final $$CopperStockTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copperStockId,
      referencedTable: $db.copperStock,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopperStockTableOrderingComposer(
            $db: $db,
            $table: $db.copperStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get referenceInvoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.referenceInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MovementType, String> get movementType =>
      $composableBuilder(
        column: $table.movementType,
        builder: (column) => column,
      );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CopperStockTableAnnotationComposer get copperStockId {
    final $$CopperStockTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.copperStockId,
      referencedTable: $db.copperStock,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CopperStockTableAnnotationComposer(
            $db: $db,
            $table: $db.copperStock,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get referenceInvoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.referenceInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovement,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (StockMovement, $$StockMovementsTableReferences),
          StockMovement,
          PrefetchHooks Function({bool copperStockId, bool referenceInvoiceId})
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> copperStockId = const Value.absent(),
                Value<MovementType> movementType = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int?> referenceInvoiceId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                copperStockId: copperStockId,
                movementType: movementType,
                weightKg: weightKg,
                referenceInvoiceId: referenceInvoiceId,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int copperStockId,
                required MovementType movementType,
                required double weightKg,
                Value<int?> referenceInvoiceId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                copperStockId: copperStockId,
                movementType: movementType,
                weightKg: weightKg,
                referenceInvoiceId: referenceInvoiceId,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockMovementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({copperStockId = false, referenceInvoiceId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (copperStockId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.copperStockId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._copperStockIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._copperStockIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (referenceInvoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.referenceInvoiceId,
                                    referencedTable:
                                        $$StockMovementsTableReferences
                                            ._referenceInvoiceIdTable(db),
                                    referencedColumn:
                                        $$StockMovementsTableReferences
                                            ._referenceInvoiceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovement,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (StockMovement, $$StockMovementsTableReferences),
      StockMovement,
      PrefetchHooks Function({bool copperStockId, bool referenceInvoiceId})
    >;
typedef $$CompanySettingsTableCreateCompanionBuilder =
    CompanySettingsCompanion Function({
      Value<int> id,
      required String companyName,
      required String address,
      required String phone,
      required String email,
      required String gstin,
      required String bankName,
      required String bankAccountNo,
      required String bankIfsc,
      Value<String?> upiId,
      Value<String?> dscCertPath,
      Value<DscSigningMethod?> dscSigningMethod,
      Value<String?> dscPkcs11DllPath,
      Value<bool> eInvoiceApplicable,
      Value<String?> logoPath,
      Value<bool> isRegistered,
    });
typedef $$CompanySettingsTableUpdateCompanionBuilder =
    CompanySettingsCompanion Function({
      Value<int> id,
      Value<String> companyName,
      Value<String> address,
      Value<String> phone,
      Value<String> email,
      Value<String> gstin,
      Value<String> bankName,
      Value<String> bankAccountNo,
      Value<String> bankIfsc,
      Value<String?> upiId,
      Value<String?> dscCertPath,
      Value<DscSigningMethod?> dscSigningMethod,
      Value<String?> dscPkcs11DllPath,
      Value<bool> eInvoiceApplicable,
      Value<String?> logoPath,
      Value<bool> isRegistered,
    });

class $$CompanySettingsTableFilterComposer
    extends Composer<_$AppDatabase, $CompanySettingsTable> {
  $$CompanySettingsTableFilterComposer({
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

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankAccountNo => $composableBuilder(
    column: $table.bankAccountNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dscCertPath => $composableBuilder(
    column: $table.dscCertPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DscSigningMethod?, DscSigningMethod, String>
  get dscSigningMethod => $composableBuilder(
    column: $table.dscSigningMethod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get dscPkcs11DllPath => $composableBuilder(
    column: $table.dscPkcs11DllPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eInvoiceApplicable => $composableBuilder(
    column: $table.eInvoiceApplicable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRegistered => $composableBuilder(
    column: $table.isRegistered,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompanySettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompanySettingsTable> {
  $$CompanySettingsTableOrderingComposer({
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

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gstin => $composableBuilder(
    column: $table.gstin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankAccountNo => $composableBuilder(
    column: $table.bankAccountNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankIfsc => $composableBuilder(
    column: $table.bankIfsc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get upiId => $composableBuilder(
    column: $table.upiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dscCertPath => $composableBuilder(
    column: $table.dscCertPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dscSigningMethod => $composableBuilder(
    column: $table.dscSigningMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dscPkcs11DllPath => $composableBuilder(
    column: $table.dscPkcs11DllPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eInvoiceApplicable => $composableBuilder(
    column: $table.eInvoiceApplicable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRegistered => $composableBuilder(
    column: $table.isRegistered,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompanySettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompanySettingsTable> {
  $$CompanySettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get gstin =>
      $composableBuilder(column: $table.gstin, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get bankAccountNo => $composableBuilder(
    column: $table.bankAccountNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bankIfsc =>
      $composableBuilder(column: $table.bankIfsc, builder: (column) => column);

  GeneratedColumn<String> get upiId =>
      $composableBuilder(column: $table.upiId, builder: (column) => column);

  GeneratedColumn<String> get dscCertPath => $composableBuilder(
    column: $table.dscCertPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DscSigningMethod?, String>
  get dscSigningMethod => $composableBuilder(
    column: $table.dscSigningMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dscPkcs11DllPath => $composableBuilder(
    column: $table.dscPkcs11DllPath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eInvoiceApplicable => $composableBuilder(
    column: $table.eInvoiceApplicable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<bool> get isRegistered => $composableBuilder(
    column: $table.isRegistered,
    builder: (column) => column,
  );
}

class $$CompanySettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompanySettingsTable,
          CompanySetting,
          $$CompanySettingsTableFilterComposer,
          $$CompanySettingsTableOrderingComposer,
          $$CompanySettingsTableAnnotationComposer,
          $$CompanySettingsTableCreateCompanionBuilder,
          $$CompanySettingsTableUpdateCompanionBuilder,
          (
            CompanySetting,
            BaseReferences<
              _$AppDatabase,
              $CompanySettingsTable,
              CompanySetting
            >,
          ),
          CompanySetting,
          PrefetchHooks Function()
        > {
  $$CompanySettingsTableTableManager(
    _$AppDatabase db,
    $CompanySettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompanySettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompanySettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompanySettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> gstin = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String> bankAccountNo = const Value.absent(),
                Value<String> bankIfsc = const Value.absent(),
                Value<String?> upiId = const Value.absent(),
                Value<String?> dscCertPath = const Value.absent(),
                Value<DscSigningMethod?> dscSigningMethod =
                    const Value.absent(),
                Value<String?> dscPkcs11DllPath = const Value.absent(),
                Value<bool> eInvoiceApplicable = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<bool> isRegistered = const Value.absent(),
              }) => CompanySettingsCompanion(
                id: id,
                companyName: companyName,
                address: address,
                phone: phone,
                email: email,
                gstin: gstin,
                bankName: bankName,
                bankAccountNo: bankAccountNo,
                bankIfsc: bankIfsc,
                upiId: upiId,
                dscCertPath: dscCertPath,
                dscSigningMethod: dscSigningMethod,
                dscPkcs11DllPath: dscPkcs11DllPath,
                eInvoiceApplicable: eInvoiceApplicable,
                logoPath: logoPath,
                isRegistered: isRegistered,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String companyName,
                required String address,
                required String phone,
                required String email,
                required String gstin,
                required String bankName,
                required String bankAccountNo,
                required String bankIfsc,
                Value<String?> upiId = const Value.absent(),
                Value<String?> dscCertPath = const Value.absent(),
                Value<DscSigningMethod?> dscSigningMethod =
                    const Value.absent(),
                Value<String?> dscPkcs11DllPath = const Value.absent(),
                Value<bool> eInvoiceApplicable = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<bool> isRegistered = const Value.absent(),
              }) => CompanySettingsCompanion.insert(
                id: id,
                companyName: companyName,
                address: address,
                phone: phone,
                email: email,
                gstin: gstin,
                bankName: bankName,
                bankAccountNo: bankAccountNo,
                bankIfsc: bankIfsc,
                upiId: upiId,
                dscCertPath: dscCertPath,
                dscSigningMethod: dscSigningMethod,
                dscPkcs11DllPath: dscPkcs11DllPath,
                eInvoiceApplicable: eInvoiceApplicable,
                logoPath: logoPath,
                isRegistered: isRegistered,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompanySettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompanySettingsTable,
      CompanySetting,
      $$CompanySettingsTableFilterComposer,
      $$CompanySettingsTableOrderingComposer,
      $$CompanySettingsTableAnnotationComposer,
      $$CompanySettingsTableCreateCompanionBuilder,
      $$CompanySettingsTableUpdateCompanionBuilder,
      (
        CompanySetting,
        BaseReferences<_$AppDatabase, $CompanySettingsTable, CompanySetting>,
      ),
      CompanySetting,
      PrefetchHooks Function()
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> role,
      Value<String?> phone,
      Value<double?> dailyWage,
      required DateTime joiningDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> role,
      Value<String?> phone,
      Value<double?> dailyWage,
      Value<DateTime> joiningDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttendanceRecordsTable, List<AttendanceRecord>>
  _attendanceRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.attendanceRecords,
        aliasName: 'employees__id__attendance_records__employee_id',
      );

  $$AttendanceRecordsTableProcessedTableManager get attendanceRecordsRefs {
    final manager = $$AttendanceRecordsTableTableManager(
      $_db,
      $_db.attendanceRecords,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _attendanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyWage => $composableBuilder(
    column: $table.dailyWage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joiningDate => $composableBuilder(
    column: $table.joiningDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> attendanceRecordsRefs(
    Expression<bool> Function($$AttendanceRecordsTableFilterComposer f) f,
  ) {
    final $$AttendanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendanceRecords,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.attendanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyWage => $composableBuilder(
    column: $table.dailyWage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joiningDate => $composableBuilder(
    column: $table.joiningDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<double> get dailyWage =>
      $composableBuilder(column: $table.dailyWage, builder: (column) => column);

  GeneratedColumn<DateTime> get joiningDate => $composableBuilder(
    column: $table.joiningDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> attendanceRecordsRefs<T extends Object>(
    Expression<T> Function($$AttendanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$AttendanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.attendanceRecords,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AttendanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.attendanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({bool attendanceRecordsRefs})
        > {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> role = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<double?> dailyWage = const Value.absent(),
                Value<DateTime> joiningDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                name: name,
                role: role,
                phone: phone,
                dailyWage: dailyWage,
                joiningDate: joiningDate,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> role = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<double?> dailyWage = const Value.absent(),
                required DateTime joiningDate,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                name: name,
                role: role,
                phone: phone,
                dailyWage: dailyWage,
                joiningDate: joiningDate,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attendanceRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attendanceRecordsRefs) db.attendanceRecords,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendanceRecordsRefs)
                    await $_getPrefetchedData<
                      Employee,
                      $EmployeesTable,
                      AttendanceRecord
                    >(
                      currentTable: table,
                      referencedTable: $$EmployeesTableReferences
                          ._attendanceRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmployeesTableReferences(
                            db,
                            table,
                            p0,
                          ).attendanceRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.employeeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({bool attendanceRecordsRefs})
    >;
typedef $$AttendanceRecordsTableCreateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      Value<int> id,
      required int employeeId,
      required DateTime date,
      required AttendanceStatus status,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$AttendanceRecordsTableUpdateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      Value<int> id,
      Value<int> employeeId,
      Value<DateTime> date,
      Value<AttendanceStatus> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$AttendanceRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AttendanceRecordsTable,
          AttendanceRecord
        > {
  $$AttendanceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias('attendance_records__employee_id__employees__id');

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AttendanceStatus, AttendanceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AttendanceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceRecordsTable,
          AttendanceRecord,
          $$AttendanceRecordsTableFilterComposer,
          $$AttendanceRecordsTableOrderingComposer,
          $$AttendanceRecordsTableAnnotationComposer,
          $$AttendanceRecordsTableCreateCompanionBuilder,
          $$AttendanceRecordsTableUpdateCompanionBuilder,
          (AttendanceRecord, $$AttendanceRecordsTableReferences),
          AttendanceRecord,
          PrefetchHooks Function({bool employeeId})
        > {
  $$AttendanceRecordsTableTableManager(
    _$AppDatabase db,
    $AttendanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<AttendanceStatus> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttendanceRecordsCompanion(
                id: id,
                employeeId: employeeId,
                date: date,
                status: status,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int employeeId,
                required DateTime date,
                required AttendanceStatus status,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttendanceRecordsCompanion.insert(
                id: id,
                employeeId: employeeId,
                date: date,
                status: status,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable:
                                    $$AttendanceRecordsTableReferences
                                        ._employeeIdTable(db),
                                referencedColumn:
                                    $$AttendanceRecordsTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceRecordsTable,
      AttendanceRecord,
      $$AttendanceRecordsTableFilterComposer,
      $$AttendanceRecordsTableOrderingComposer,
      $$AttendanceRecordsTableAnnotationComposer,
      $$AttendanceRecordsTableCreateCompanionBuilder,
      $$AttendanceRecordsTableUpdateCompanionBuilder,
      (AttendanceRecord, $$AttendanceRecordsTableReferences),
      AttendanceRecord,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$FinancialYearSequenceTableCreateCompanionBuilder =
    FinancialYearSequenceCompanion Function({
      Value<int> id,
      required String invoiceTypePrefix,
      required String financialYearLabel,
      Value<int> lastNumber,
    });
typedef $$FinancialYearSequenceTableUpdateCompanionBuilder =
    FinancialYearSequenceCompanion Function({
      Value<int> id,
      Value<String> invoiceTypePrefix,
      Value<String> financialYearLabel,
      Value<int> lastNumber,
    });

class $$FinancialYearSequenceTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialYearSequenceTable> {
  $$FinancialYearSequenceTableFilterComposer({
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

  ColumnFilters<String> get invoiceTypePrefix => $composableBuilder(
    column: $table.invoiceTypePrefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get financialYearLabel => $composableBuilder(
    column: $table.financialYearLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastNumber => $composableBuilder(
    column: $table.lastNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinancialYearSequenceTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialYearSequenceTable> {
  $$FinancialYearSequenceTableOrderingComposer({
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

  ColumnOrderings<String> get invoiceTypePrefix => $composableBuilder(
    column: $table.invoiceTypePrefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get financialYearLabel => $composableBuilder(
    column: $table.financialYearLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastNumber => $composableBuilder(
    column: $table.lastNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinancialYearSequenceTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialYearSequenceTable> {
  $$FinancialYearSequenceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceTypePrefix => $composableBuilder(
    column: $table.invoiceTypePrefix,
    builder: (column) => column,
  );

  GeneratedColumn<String> get financialYearLabel => $composableBuilder(
    column: $table.financialYearLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastNumber => $composableBuilder(
    column: $table.lastNumber,
    builder: (column) => column,
  );
}

class $$FinancialYearSequenceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialYearSequenceTable,
          FinancialYearSequenceData,
          $$FinancialYearSequenceTableFilterComposer,
          $$FinancialYearSequenceTableOrderingComposer,
          $$FinancialYearSequenceTableAnnotationComposer,
          $$FinancialYearSequenceTableCreateCompanionBuilder,
          $$FinancialYearSequenceTableUpdateCompanionBuilder,
          (
            FinancialYearSequenceData,
            BaseReferences<
              _$AppDatabase,
              $FinancialYearSequenceTable,
              FinancialYearSequenceData
            >,
          ),
          FinancialYearSequenceData,
          PrefetchHooks Function()
        > {
  $$FinancialYearSequenceTableTableManager(
    _$AppDatabase db,
    $FinancialYearSequenceTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialYearSequenceTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FinancialYearSequenceTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinancialYearSequenceTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceTypePrefix = const Value.absent(),
                Value<String> financialYearLabel = const Value.absent(),
                Value<int> lastNumber = const Value.absent(),
              }) => FinancialYearSequenceCompanion(
                id: id,
                invoiceTypePrefix: invoiceTypePrefix,
                financialYearLabel: financialYearLabel,
                lastNumber: lastNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceTypePrefix,
                required String financialYearLabel,
                Value<int> lastNumber = const Value.absent(),
              }) => FinancialYearSequenceCompanion.insert(
                id: id,
                invoiceTypePrefix: invoiceTypePrefix,
                financialYearLabel: financialYearLabel,
                lastNumber: lastNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinancialYearSequenceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialYearSequenceTable,
      FinancialYearSequenceData,
      $$FinancialYearSequenceTableFilterComposer,
      $$FinancialYearSequenceTableOrderingComposer,
      $$FinancialYearSequenceTableAnnotationComposer,
      $$FinancialYearSequenceTableCreateCompanionBuilder,
      $$FinancialYearSequenceTableUpdateCompanionBuilder,
      (
        FinancialYearSequenceData,
        BaseReferences<
          _$AppDatabase,
          $FinancialYearSequenceTable,
          FinancialYearSequenceData
        >,
      ),
      FinancialYearSequenceData,
      PrefetchHooks Function()
    >;
typedef $$CashCategoriesTableCreateCompanionBuilder =
    CashCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$CashCategoriesTableUpdateCompanionBuilder =
    CashCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

class $$CashCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CashCategoriesTable> {
  $$CashCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashCategoriesTable> {
  $$CashCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashCategoriesTable> {
  $$CashCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CashCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashCategoriesTable,
          CashCategory,
          $$CashCategoriesTableFilterComposer,
          $$CashCategoriesTableOrderingComposer,
          $$CashCategoriesTableAnnotationComposer,
          $$CashCategoriesTableCreateCompanionBuilder,
          $$CashCategoriesTableUpdateCompanionBuilder,
          (
            CashCategory,
            BaseReferences<_$AppDatabase, $CashCategoriesTable, CashCategory>,
          ),
          CashCategory,
          PrefetchHooks Function()
        > {
  $$CashCategoriesTableTableManager(
    _$AppDatabase db,
    $CashCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CashCategoriesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CashCategoriesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashCategoriesTable,
      CashCategory,
      $$CashCategoriesTableFilterComposer,
      $$CashCategoriesTableOrderingComposer,
      $$CashCategoriesTableAnnotationComposer,
      $$CashCategoriesTableCreateCompanionBuilder,
      $$CashCategoriesTableUpdateCompanionBuilder,
      (
        CashCategory,
        BaseReferences<_$AppDatabase, $CashCategoriesTable, CashCategory>,
      ),
      CashCategory,
      PrefetchHooks Function()
    >;
typedef $$CashTransactionsTableCreateCompanionBuilder =
    CashTransactionsCompanion Function({
      Value<int> id,
      required CashTransactionType transactionType,
      required double amount,
      required String category,
      Value<String?> description,
      required DateTime transactionDate,
      Value<DateTime> createdAt,
    });
typedef $$CashTransactionsTableUpdateCompanionBuilder =
    CashTransactionsCompanion Function({
      Value<int> id,
      Value<CashTransactionType> transactionType,
      Value<double> amount,
      Value<String> category,
      Value<String?> description,
      Value<DateTime> transactionDate,
      Value<DateTime> createdAt,
    });

class $$CashTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $CashTransactionsTable> {
  $$CashTransactionsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<
    CashTransactionType,
    CashTransactionType,
    String
  >
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashTransactionsTable> {
  $$CashTransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashTransactionsTable> {
  $$CashTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CashTransactionType, String>
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CashTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashTransactionsTable,
          CashTransaction,
          $$CashTransactionsTableFilterComposer,
          $$CashTransactionsTableOrderingComposer,
          $$CashTransactionsTableAnnotationComposer,
          $$CashTransactionsTableCreateCompanionBuilder,
          $$CashTransactionsTableUpdateCompanionBuilder,
          (
            CashTransaction,
            BaseReferences<
              _$AppDatabase,
              $CashTransactionsTable,
              CashTransaction
            >,
          ),
          CashTransaction,
          PrefetchHooks Function()
        > {
  $$CashTransactionsTableTableManager(
    _$AppDatabase db,
    $CashTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<CashTransactionType> transactionType =
                    const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CashTransactionsCompanion(
                id: id,
                transactionType: transactionType,
                amount: amount,
                category: category,
                description: description,
                transactionDate: transactionDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required CashTransactionType transactionType,
                required double amount,
                required String category,
                Value<String?> description = const Value.absent(),
                required DateTime transactionDate,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CashTransactionsCompanion.insert(
                id: id,
                transactionType: transactionType,
                amount: amount,
                category: category,
                description: description,
                transactionDate: transactionDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashTransactionsTable,
      CashTransaction,
      $$CashTransactionsTableFilterComposer,
      $$CashTransactionsTableOrderingComposer,
      $$CashTransactionsTableAnnotationComposer,
      $$CashTransactionsTableCreateCompanionBuilder,
      $$CashTransactionsTableUpdateCompanionBuilder,
      (
        CashTransaction,
        BaseReferences<_$AppDatabase, $CashTransactionsTable, CashTransaction>,
      ),
      CashTransaction,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      required int invoiceId,
      required double amount,
      required PaymentMode paymentMode,
      required DateTime paymentDate,
      Value<String?> referenceNo,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<int> id,
      Value<int> invoiceId,
      Value<double> amount,
      Value<PaymentMode> paymentMode,
      Value<DateTime> paymentDate,
      Value<String?> referenceNo,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InvoicesTable _invoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('payments__invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<int>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode, PaymentMode, String>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMode, String> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceNo => $composableBuilder(
    column: $table.referenceNo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool invoiceId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> invoiceId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<PaymentMode> paymentMode = const Value.absent(),
                Value<DateTime> paymentDate = const Value.absent(),
                Value<String?> referenceNo = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                invoiceId: invoiceId,
                amount: amount,
                paymentMode: paymentMode,
                paymentDate: paymentDate,
                referenceNo: referenceNo,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int invoiceId,
                required double amount,
                required PaymentMode paymentMode,
                required DateTime paymentDate,
                Value<String?> referenceNo = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                invoiceId: invoiceId,
                amount: amount,
                paymentMode: paymentMode,
                paymentDate: paymentDate,
                referenceNo: referenceNo,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$PaymentsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn: $$PaymentsTableReferences
                                    ._invoiceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool invoiceId})
    >;
typedef $$QuotationsTableCreateCompanionBuilder =
    QuotationsCompanion Function({
      Value<int> id,
      required String quoteNo,
      Value<int?> customerId,
      Value<String?> prospectiveCustomerName,
      Value<String?> prospectiveCustomerPhone,
      Value<int?> motorJobId,
      required String description,
      required double estimatedAmount,
      Value<DateTime?> validUntil,
      required QuotationStatus status,
      Value<int?> convertedInvoiceId,
      Value<DateTime> createdAt,
    });
typedef $$QuotationsTableUpdateCompanionBuilder =
    QuotationsCompanion Function({
      Value<int> id,
      Value<String> quoteNo,
      Value<int?> customerId,
      Value<String?> prospectiveCustomerName,
      Value<String?> prospectiveCustomerPhone,
      Value<int?> motorJobId,
      Value<String> description,
      Value<double> estimatedAmount,
      Value<DateTime?> validUntil,
      Value<QuotationStatus> status,
      Value<int?> convertedInvoiceId,
      Value<DateTime> createdAt,
    });

final class $$QuotationsTableReferences
    extends BaseReferences<_$AppDatabase, $QuotationsTable, Quotation> {
  $$QuotationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('quotations__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MotorJobsTable _motorJobIdTable(_$AppDatabase db) =>
      db.motorJobs.createAlias('quotations__motor_job_id__motor_jobs__id');

  $$MotorJobsTableProcessedTableManager? get motorJobId {
    final $_column = $_itemColumn<int>('motor_job_id');
    if ($_column == null) return null;
    final manager = $$MotorJobsTableTableManager(
      $_db,
      $_db.motorJobs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_motorJobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _convertedInvoiceIdTable(_$AppDatabase db) =>
      db.invoices.createAlias('quotations__converted_invoice_id__invoices__id');

  $$InvoicesTableProcessedTableManager? get convertedInvoiceId {
    final $_column = $_itemColumn<int>('converted_invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_convertedInvoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuotationsTableFilterComposer
    extends Composer<_$AppDatabase, $QuotationsTable> {
  $$QuotationsTableFilterComposer({
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

  ColumnFilters<String> get quoteNo => $composableBuilder(
    column: $table.quoteNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prospectiveCustomerName => $composableBuilder(
    column: $table.prospectiveCustomerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prospectiveCustomerPhone => $composableBuilder(
    column: $table.prospectiveCustomerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuotationStatus, QuotationStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MotorJobsTableFilterComposer get motorJobId {
    final $$MotorJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.motorJobId,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableFilterComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get convertedInvoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.convertedInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotationsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotationsTable> {
  $$QuotationsTableOrderingComposer({
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

  ColumnOrderings<String> get quoteNo => $composableBuilder(
    column: $table.quoteNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prospectiveCustomerName => $composableBuilder(
    column: $table.prospectiveCustomerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prospectiveCustomerPhone => $composableBuilder(
    column: $table.prospectiveCustomerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MotorJobsTableOrderingComposer get motorJobId {
    final $$MotorJobsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.motorJobId,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableOrderingComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get convertedInvoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.convertedInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotationsTable> {
  $$QuotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quoteNo =>
      $composableBuilder(column: $table.quoteNo, builder: (column) => column);

  GeneratedColumn<String> get prospectiveCustomerName => $composableBuilder(
    column: $table.prospectiveCustomerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prospectiveCustomerPhone => $composableBuilder(
    column: $table.prospectiveCustomerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuotationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MotorJobsTableAnnotationComposer get motorJobId {
    final $$MotorJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.motorJobId,
      referencedTable: $db.motorJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MotorJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.motorJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get convertedInvoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.convertedInvoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuotationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotationsTable,
          Quotation,
          $$QuotationsTableFilterComposer,
          $$QuotationsTableOrderingComposer,
          $$QuotationsTableAnnotationComposer,
          $$QuotationsTableCreateCompanionBuilder,
          $$QuotationsTableUpdateCompanionBuilder,
          (Quotation, $$QuotationsTableReferences),
          Quotation,
          PrefetchHooks Function({
            bool customerId,
            bool motorJobId,
            bool convertedInvoiceId,
          })
        > {
  $$QuotationsTableTableManager(_$AppDatabase db, $QuotationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> quoteNo = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String?> prospectiveCustomerName = const Value.absent(),
                Value<String?> prospectiveCustomerPhone = const Value.absent(),
                Value<int?> motorJobId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> estimatedAmount = const Value.absent(),
                Value<DateTime?> validUntil = const Value.absent(),
                Value<QuotationStatus> status = const Value.absent(),
                Value<int?> convertedInvoiceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuotationsCompanion(
                id: id,
                quoteNo: quoteNo,
                customerId: customerId,
                prospectiveCustomerName: prospectiveCustomerName,
                prospectiveCustomerPhone: prospectiveCustomerPhone,
                motorJobId: motorJobId,
                description: description,
                estimatedAmount: estimatedAmount,
                validUntil: validUntil,
                status: status,
                convertedInvoiceId: convertedInvoiceId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String quoteNo,
                Value<int?> customerId = const Value.absent(),
                Value<String?> prospectiveCustomerName = const Value.absent(),
                Value<String?> prospectiveCustomerPhone = const Value.absent(),
                Value<int?> motorJobId = const Value.absent(),
                required String description,
                required double estimatedAmount,
                Value<DateTime?> validUntil = const Value.absent(),
                required QuotationStatus status,
                Value<int?> convertedInvoiceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => QuotationsCompanion.insert(
                id: id,
                quoteNo: quoteNo,
                customerId: customerId,
                prospectiveCustomerName: prospectiveCustomerName,
                prospectiveCustomerPhone: prospectiveCustomerPhone,
                motorJobId: motorJobId,
                description: description,
                estimatedAmount: estimatedAmount,
                validUntil: validUntil,
                status: status,
                convertedInvoiceId: convertedInvoiceId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuotationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                motorJobId = false,
                convertedInvoiceId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$QuotationsTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn:
                                        $$QuotationsTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (motorJobId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.motorJobId,
                                    referencedTable: $$QuotationsTableReferences
                                        ._motorJobIdTable(db),
                                    referencedColumn:
                                        $$QuotationsTableReferences
                                            ._motorJobIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (convertedInvoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.convertedInvoiceId,
                                    referencedTable: $$QuotationsTableReferences
                                        ._convertedInvoiceIdTable(db),
                                    referencedColumn:
                                        $$QuotationsTableReferences
                                            ._convertedInvoiceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$QuotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotationsTable,
      Quotation,
      $$QuotationsTableFilterComposer,
      $$QuotationsTableOrderingComposer,
      $$QuotationsTableAnnotationComposer,
      $$QuotationsTableCreateCompanionBuilder,
      $$QuotationsTableUpdateCompanionBuilder,
      (Quotation, $$QuotationsTableReferences),
      Quotation,
      PrefetchHooks Function({
        bool customerId,
        bool motorJobId,
        bool convertedInvoiceId,
      })
    >;
typedef $$DeletedRecordsLogTableCreateCompanionBuilder =
    DeletedRecordsLogCompanion Function({
      Value<int> id,
      required String entityType,
      required int entityId,
      required String deletedAt,
      required String snapshot,
    });
typedef $$DeletedRecordsLogTableUpdateCompanionBuilder =
    DeletedRecordsLogCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<int> entityId,
      Value<String> deletedAt,
      Value<String> snapshot,
    });

class $$DeletedRecordsLogTableFilterComposer
    extends Composer<_$AppDatabase, $DeletedRecordsLogTable> {
  $$DeletedRecordsLogTableFilterComposer({
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

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snapshot => $composableBuilder(
    column: $table.snapshot,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeletedRecordsLogTableOrderingComposer
    extends Composer<_$AppDatabase, $DeletedRecordsLogTable> {
  $$DeletedRecordsLogTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snapshot => $composableBuilder(
    column: $table.snapshot,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeletedRecordsLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeletedRecordsLogTable> {
  $$DeletedRecordsLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get snapshot =>
      $composableBuilder(column: $table.snapshot, builder: (column) => column);
}

class $$DeletedRecordsLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeletedRecordsLogTable,
          DeletedRecordsLogData,
          $$DeletedRecordsLogTableFilterComposer,
          $$DeletedRecordsLogTableOrderingComposer,
          $$DeletedRecordsLogTableAnnotationComposer,
          $$DeletedRecordsLogTableCreateCompanionBuilder,
          $$DeletedRecordsLogTableUpdateCompanionBuilder,
          (
            DeletedRecordsLogData,
            BaseReferences<
              _$AppDatabase,
              $DeletedRecordsLogTable,
              DeletedRecordsLogData
            >,
          ),
          DeletedRecordsLogData,
          PrefetchHooks Function()
        > {
  $$DeletedRecordsLogTableTableManager(
    _$AppDatabase db,
    $DeletedRecordsLogTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeletedRecordsLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeletedRecordsLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeletedRecordsLogTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String> deletedAt = const Value.absent(),
                Value<String> snapshot = const Value.absent(),
              }) => DeletedRecordsLogCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                deletedAt: deletedAt,
                snapshot: snapshot,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required int entityId,
                required String deletedAt,
                required String snapshot,
              }) => DeletedRecordsLogCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                deletedAt: deletedAt,
                snapshot: snapshot,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeletedRecordsLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeletedRecordsLogTable,
      DeletedRecordsLogData,
      $$DeletedRecordsLogTableFilterComposer,
      $$DeletedRecordsLogTableOrderingComposer,
      $$DeletedRecordsLogTableAnnotationComposer,
      $$DeletedRecordsLogTableCreateCompanionBuilder,
      $$DeletedRecordsLogTableUpdateCompanionBuilder,
      (
        DeletedRecordsLogData,
        BaseReferences<
          _$AppDatabase,
          $DeletedRecordsLogTable,
          DeletedRecordsLogData
        >,
      ),
      DeletedRecordsLogData,
      PrefetchHooks Function()
    >;
typedef $$PurchasesTableCreateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      required String vendorName,
      required DateTime purchaseDate,
      Value<PaymentMode?> paymentMode,
      Value<String?> notes,
      Value<String?> billImagePath,
      Value<double> totalAmount,
      Value<DateTime> createdAt,
    });
typedef $$PurchasesTableUpdateCompanionBuilder =
    PurchasesCompanion Function({
      Value<int> id,
      Value<String> vendorName,
      Value<DateTime> purchaseDate,
      Value<PaymentMode?> paymentMode,
      Value<String?> notes,
      Value<String?> billImagePath,
      Value<double> totalAmount,
      Value<DateTime> createdAt,
    });

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
  _purchaseItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.purchaseItems,
    aliasName: 'purchases__id__purchase_items__purchase_id',
  );

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager(
      $_db,
      $_db.purchaseItems,
    ).filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
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

  ColumnFilters<String> get vendorName => $composableBuilder(
    column: $table.vendorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMode?, PaymentMode, String>
  get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billImagePath => $composableBuilder(
    column: $table.billImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> purchaseItemsRefs(
    Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f,
  ) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableFilterComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
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

  ColumnOrderings<String> get vendorName => $composableBuilder(
    column: $table.vendorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMode => $composableBuilder(
    column: $table.paymentMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billImagePath => $composableBuilder(
    column: $table.billImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vendorName => $composableBuilder(
    column: $table.vendorName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentMode?, String> get paymentMode =>
      $composableBuilder(
        column: $table.paymentMode,
        builder: (column) => column,
      );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get billImagePath => $composableBuilder(
    column: $table.billImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> purchaseItemsRefs<T extends Object>(
    Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f,
  ) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.purchaseItems,
      getReferencedColumn: (t) => t.purchaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchasesTable,
          Purchase,
          $$PurchasesTableFilterComposer,
          $$PurchasesTableOrderingComposer,
          $$PurchasesTableAnnotationComposer,
          $$PurchasesTableCreateCompanionBuilder,
          $$PurchasesTableUpdateCompanionBuilder,
          (Purchase, $$PurchasesTableReferences),
          Purchase,
          PrefetchHooks Function({bool purchaseItemsRefs})
        > {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> vendorName = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<PaymentMode?> paymentMode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> billImagePath = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchasesCompanion(
                id: id,
                vendorName: vendorName,
                purchaseDate: purchaseDate,
                paymentMode: paymentMode,
                notes: notes,
                billImagePath: billImagePath,
                totalAmount: totalAmount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String vendorName,
                required DateTime purchaseDate,
                Value<PaymentMode?> paymentMode = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> billImagePath = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PurchasesCompanion.insert(
                id: id,
                vendorName: vendorName,
                purchaseDate: purchaseDate,
                paymentMode: paymentMode,
                notes: notes,
                billImagePath: billImagePath,
                totalAmount: totalAmount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchaseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseItemsRefs) db.purchaseItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<
                      Purchase,
                      $PurchasesTable,
                      PurchaseItem
                    >(
                      currentTable: table,
                      referencedTable: $$PurchasesTableReferences
                          ._purchaseItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PurchasesTableReferences(
                            db,
                            table,
                            p0,
                          ).purchaseItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.purchaseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchasesTable,
      Purchase,
      $$PurchasesTableFilterComposer,
      $$PurchasesTableOrderingComposer,
      $$PurchasesTableAnnotationComposer,
      $$PurchasesTableCreateCompanionBuilder,
      $$PurchasesTableUpdateCompanionBuilder,
      (Purchase, $$PurchasesTableReferences),
      Purchase,
      PrefetchHooks Function({bool purchaseItemsRefs})
    >;
typedef $$PurchaseItemsTableCreateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<int> id,
      required int purchaseId,
      required String category,
      required String description,
      required double amount,
      Value<double?> gstAmount,
    });
typedef $$PurchaseItemsTableUpdateCompanionBuilder =
    PurchaseItemsCompanion Function({
      Value<int> id,
      Value<int> purchaseId,
      Value<String> category,
      Value<String> description,
      Value<double> amount,
      Value<double?> gstAmount,
    });

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias('purchase_items__purchase_id__purchases__id');

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<int>('purchase_id')!;

    final manager = $$PurchasesTableTableManager(
      $_db,
      $_db.purchases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gstAmount => $composableBuilder(
    column: $table.gstAmount,
    builder: (column) => ColumnFilters(column),
  );

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableFilterComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gstAmount => $composableBuilder(
    column: $table.gstAmount,
    builder: (column) => ColumnOrderings(column),
  );

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableOrderingComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get gstAmount =>
      $composableBuilder(column: $table.gstAmount, builder: (column) => column);

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseId,
      referencedTable: $db.purchases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchasesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PurchaseItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseItemsTable,
          PurchaseItem,
          $$PurchaseItemsTableFilterComposer,
          $$PurchaseItemsTableOrderingComposer,
          $$PurchaseItemsTableAnnotationComposer,
          $$PurchaseItemsTableCreateCompanionBuilder,
          $$PurchaseItemsTableUpdateCompanionBuilder,
          (PurchaseItem, $$PurchaseItemsTableReferences),
          PurchaseItem,
          PrefetchHooks Function({bool purchaseId})
        > {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> purchaseId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double?> gstAmount = const Value.absent(),
              }) => PurchaseItemsCompanion(
                id: id,
                purchaseId: purchaseId,
                category: category,
                description: description,
                amount: amount,
                gstAmount: gstAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int purchaseId,
                required String category,
                required String description,
                required double amount,
                Value<double?> gstAmount = const Value.absent(),
              }) => PurchaseItemsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                category: category,
                description: description,
                amount: amount,
                gstAmount: gstAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PurchaseItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({purchaseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (purchaseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.purchaseId,
                                referencedTable: $$PurchaseItemsTableReferences
                                    ._purchaseIdTable(db),
                                referencedColumn: $$PurchaseItemsTableReferences
                                    ._purchaseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseItemsTable,
      PurchaseItem,
      $$PurchaseItemsTableFilterComposer,
      $$PurchaseItemsTableOrderingComposer,
      $$PurchaseItemsTableAnnotationComposer,
      $$PurchaseItemsTableCreateCompanionBuilder,
      $$PurchaseItemsTableUpdateCompanionBuilder,
      (PurchaseItem, $$PurchaseItemsTableReferences),
      PurchaseItem,
      PrefetchHooks Function({bool purchaseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$MotorJobsTableTableManager get motorJobs =>
      $$MotorJobsTableTableManager(_db, _db.motorJobs);
  $$CopperStockTableTableManager get copperStock =>
      $$CopperStockTableTableManager(_db, _db.copperStock);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceItemsTableTableManager get invoiceItems =>
      $$InvoiceItemsTableTableManager(_db, _db.invoiceItems);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$CompanySettingsTableTableManager get companySettings =>
      $$CompanySettingsTableTableManager(_db, _db.companySettings);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$AttendanceRecordsTableTableManager get attendanceRecords =>
      $$AttendanceRecordsTableTableManager(_db, _db.attendanceRecords);
  $$FinancialYearSequenceTableTableManager get financialYearSequence =>
      $$FinancialYearSequenceTableTableManager(_db, _db.financialYearSequence);
  $$CashCategoriesTableTableManager get cashCategories =>
      $$CashCategoriesTableTableManager(_db, _db.cashCategories);
  $$CashTransactionsTableTableManager get cashTransactions =>
      $$CashTransactionsTableTableManager(_db, _db.cashTransactions);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$QuotationsTableTableManager get quotations =>
      $$QuotationsTableTableManager(_db, _db.quotations);
  $$DeletedRecordsLogTableTableManager get deletedRecordsLog =>
      $$DeletedRecordsLogTableTableManager(_db, _db.deletedRecordsLog);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
}

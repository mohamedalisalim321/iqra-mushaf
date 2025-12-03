// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSurahCollection on Isar {
  IsarCollection<Surah> get surahs => this.collection();
}

const SurahSchema = CollectionSchema(
  name: r'Surah',
  id: -5819800798527960797,
  properties: {
    r'letters': PropertySchema(
      id: 0,
      name: r'letters',
      type: IsarType.long,
    ),
    r'revelationOrder': PropertySchema(
      id: 1,
      name: r'revelationOrder',
      type: IsarType.long,
    ),
    r'surahIndex': PropertySchema(
      id: 2,
      name: r'surahIndex',
      type: IsarType.long,
    ),
    r'surahName': PropertySchema(
      id: 3,
      name: r'surahName',
      type: IsarType.string,
    ),
    r'surahNameTr': PropertySchema(
      id: 4,
      name: r'surahNameTr',
      type: IsarType.string,
    ),
    r'surahType': PropertySchema(
      id: 5,
      name: r'surahType',
      type: IsarType.string,
    ),
    r'versesCount': PropertySchema(
      id: 6,
      name: r'versesCount',
      type: IsarType.long,
    ),
    r'words': PropertySchema(
      id: 7,
      name: r'words',
      type: IsarType.long,
    )
  },
  estimateSize: _surahEstimateSize,
  serialize: _surahSerialize,
  deserialize: _surahDeserialize,
  deserializeProp: _surahDeserializeProp,
  idName: r'id',
  indexes: {
    r'surahName': IndexSchema(
      id: -1901455052265938044,
      name: r'surahName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahName',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'surahNameTr': IndexSchema(
      id: 6267411816581025481,
      name: r'surahNameTr',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahNameTr',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'surahType': IndexSchema(
      id: 571434597675178281,
      name: r'surahType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahType',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'surahIndex': IndexSchema(
      id: -4295384286817959383,
      name: r'surahIndex',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'versesCount': IndexSchema(
      id: 4484923994961064560,
      name: r'versesCount',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'versesCount',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'verses': LinkSchema(
      id: 7283189436415443004,
      name: r'verses',
      target: r'Verse',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _surahGetId,
  getLinks: _surahGetLinks,
  attach: _surahAttach,
  version: '3.1.0+1',
);

int _surahEstimateSize(
  Surah object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.surahName.length * 3;
  bytesCount += 3 + object.surahNameTr.length * 3;
  bytesCount += 3 + object.surahType.length * 3;
  return bytesCount;
}

void _surahSerialize(
  Surah object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.letters);
  writer.writeLong(offsets[1], object.revelationOrder);
  writer.writeLong(offsets[2], object.surahIndex);
  writer.writeString(offsets[3], object.surahName);
  writer.writeString(offsets[4], object.surahNameTr);
  writer.writeString(offsets[5], object.surahType);
  writer.writeLong(offsets[6], object.versesCount);
  writer.writeLong(offsets[7], object.words);
}

Surah _surahDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Surah();
  object.id = id;
  object.letters = reader.readLong(offsets[0]);
  object.revelationOrder = reader.readLong(offsets[1]);
  object.surahIndex = reader.readLong(offsets[2]);
  object.surahName = reader.readString(offsets[3]);
  object.surahNameTr = reader.readString(offsets[4]);
  object.surahType = reader.readString(offsets[5]);
  object.versesCount = reader.readLong(offsets[6]);
  object.words = reader.readLong(offsets[7]);
  return object;
}

P _surahDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _surahGetId(Surah object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _surahGetLinks(Surah object) {
  return [object.verses];
}

void _surahAttach(IsarCollection<dynamic> col, Id id, Surah object) {
  object.id = id;
  object.verses.attach(col, col.isar.collection<Verse>(), r'verses', id);
}

extension SurahByIndex on IsarCollection<Surah> {
  Future<Surah?> getBySurahIndex(int surahIndex) {
    return getByIndex(r'surahIndex', [surahIndex]);
  }

  Surah? getBySurahIndexSync(int surahIndex) {
    return getByIndexSync(r'surahIndex', [surahIndex]);
  }

  Future<bool> deleteBySurahIndex(int surahIndex) {
    return deleteByIndex(r'surahIndex', [surahIndex]);
  }

  bool deleteBySurahIndexSync(int surahIndex) {
    return deleteByIndexSync(r'surahIndex', [surahIndex]);
  }

  Future<List<Surah?>> getAllBySurahIndex(List<int> surahIndexValues) {
    final values = surahIndexValues.map((e) => [e]).toList();
    return getAllByIndex(r'surahIndex', values);
  }

  List<Surah?> getAllBySurahIndexSync(List<int> surahIndexValues) {
    final values = surahIndexValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'surahIndex', values);
  }

  Future<int> deleteAllBySurahIndex(List<int> surahIndexValues) {
    final values = surahIndexValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'surahIndex', values);
  }

  int deleteAllBySurahIndexSync(List<int> surahIndexValues) {
    final values = surahIndexValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'surahIndex', values);
  }

  Future<Id> putBySurahIndex(Surah object) {
    return putByIndex(r'surahIndex', object);
  }

  Id putBySurahIndexSync(Surah object, {bool saveLinks = true}) {
    return putByIndexSync(r'surahIndex', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySurahIndex(List<Surah> objects) {
    return putAllByIndex(r'surahIndex', objects);
  }

  List<Id> putAllBySurahIndexSync(List<Surah> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'surahIndex', objects, saveLinks: saveLinks);
  }
}

extension SurahQueryWhereSort on QueryBuilder<Surah, Surah, QWhere> {
  QueryBuilder<Surah, Surah, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhere> anySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'surahIndex'),
      );
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhere> anyVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'versesCount'),
      );
    });
  }
}

extension SurahQueryWhere on QueryBuilder<Surah, Surah, QWhereClause> {
  QueryBuilder<Surah, Surah, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahNameEqualTo(
      String surahName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahName',
        value: [surahName],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahNameNotEqualTo(
      String surahName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahName',
              lower: [],
              upper: [surahName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahName',
              lower: [surahName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahName',
              lower: [surahName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahName',
              lower: [],
              upper: [surahName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahNameTrEqualTo(
      String surahNameTr) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahNameTr',
        value: [surahNameTr],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahNameTrNotEqualTo(
      String surahNameTr) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNameTr',
              lower: [],
              upper: [surahNameTr],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNameTr',
              lower: [surahNameTr],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNameTr',
              lower: [surahNameTr],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNameTr',
              lower: [],
              upper: [surahNameTr],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahTypeEqualTo(
      String surahType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahType',
        value: [surahType],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahTypeNotEqualTo(
      String surahType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahType',
              lower: [],
              upper: [surahType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahType',
              lower: [surahType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahType',
              lower: [surahType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahType',
              lower: [],
              upper: [surahType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahIndexEqualTo(
      int surahIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahIndex',
        value: [surahIndex],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahIndexNotEqualTo(
      int surahIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahIndex',
              lower: [],
              upper: [surahIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahIndex',
              lower: [surahIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahIndex',
              lower: [surahIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahIndex',
              lower: [],
              upper: [surahIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahIndexGreaterThan(
    int surahIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahIndex',
        lower: [surahIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahIndexLessThan(
    int surahIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahIndex',
        lower: [],
        upper: [surahIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> surahIndexBetween(
    int lowerSurahIndex,
    int upperSurahIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahIndex',
        lower: [lowerSurahIndex],
        includeLower: includeLower,
        upper: [upperSurahIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> versesCountEqualTo(
      int versesCount) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'versesCount',
        value: [versesCount],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> versesCountNotEqualTo(
      int versesCount) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'versesCount',
              lower: [],
              upper: [versesCount],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'versesCount',
              lower: [versesCount],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'versesCount',
              lower: [versesCount],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'versesCount',
              lower: [],
              upper: [versesCount],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> versesCountGreaterThan(
    int versesCount, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'versesCount',
        lower: [versesCount],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> versesCountLessThan(
    int versesCount, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'versesCount',
        lower: [],
        upper: [versesCount],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterWhereClause> versesCountBetween(
    int lowerVersesCount,
    int upperVersesCount, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'versesCount',
        lower: [lowerVersesCount],
        includeLower: includeLower,
        upper: [upperVersesCount],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SurahQueryFilter on QueryBuilder<Surah, Surah, QFilterCondition> {
  QueryBuilder<Surah, Surah, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> lettersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letters',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> lettersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letters',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> lettersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letters',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> lettersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> revelationOrderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelationOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> revelationOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revelationOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> revelationOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revelationOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> revelationOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revelationOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'surahName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'surahName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'surahName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'surahName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahName',
        value: '',
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surahName',
        value: '',
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNameTr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNameTr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNameTr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNameTr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'surahNameTr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'surahNameTr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'surahNameTr',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'surahNameTr',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNameTr',
        value: '',
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahNameTrIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surahNameTr',
        value: '',
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'surahType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'surahType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'surahType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'surahType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahType',
        value: '',
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> surahTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surahType',
        value: '',
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesCountEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'versesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'versesCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'versesCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> wordsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'words',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> wordsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'words',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> wordsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'words',
        value: value,
      ));
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> wordsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'words',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SurahQueryObject on QueryBuilder<Surah, Surah, QFilterCondition> {}

extension SurahQueryLinks on QueryBuilder<Surah, Surah, QFilterCondition> {
  QueryBuilder<Surah, Surah, QAfterFilterCondition> verses(
      FilterQuery<Verse> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'verses');
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'verses', length, true, length, true);
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'verses', 0, true, 0, true);
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'verses', 0, false, 999999, true);
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'verses', 0, true, length, include);
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'verses', length, include, 999999, true);
    });
  }

  QueryBuilder<Surah, Surah, QAfterFilterCondition> versesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'verses', lower, includeLower, upper, includeUpper);
    });
  }
}

extension SurahQuerySortBy on QueryBuilder<Surah, Surah, QSortBy> {
  QueryBuilder<Surah, Surah, QAfterSortBy> sortByLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letters', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByLettersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letters', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByRevelationOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationOrder', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByRevelationOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationOrder', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahNameTr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNameTr', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahNameTrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNameTr', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahType', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortBySurahTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahType', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByVersesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'words', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> sortByWordsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'words', Sort.desc);
    });
  }
}

extension SurahQuerySortThenBy on QueryBuilder<Surah, Surah, QSortThenBy> {
  QueryBuilder<Surah, Surah, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letters', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByLettersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letters', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByRevelationOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationOrder', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByRevelationOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelationOrder', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahNameTr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNameTr', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahNameTrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNameTr', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahType', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenBySurahTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahType', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByVersesCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesCount', Sort.desc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'words', Sort.asc);
    });
  }

  QueryBuilder<Surah, Surah, QAfterSortBy> thenByWordsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'words', Sort.desc);
    });
  }
}

extension SurahQueryWhereDistinct on QueryBuilder<Surah, Surah, QDistinct> {
  QueryBuilder<Surah, Surah, QDistinct> distinctByLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letters');
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctByRevelationOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revelationOrder');
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahIndex');
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctBySurahName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctBySurahNameTr(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNameTr', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctBySurahType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctByVersesCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'versesCount');
    });
  }

  QueryBuilder<Surah, Surah, QDistinct> distinctByWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'words');
    });
  }
}

extension SurahQueryProperty on QueryBuilder<Surah, Surah, QQueryProperty> {
  QueryBuilder<Surah, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Surah, int, QQueryOperations> lettersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letters');
    });
  }

  QueryBuilder<Surah, int, QQueryOperations> revelationOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revelationOrder');
    });
  }

  QueryBuilder<Surah, int, QQueryOperations> surahIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahIndex');
    });
  }

  QueryBuilder<Surah, String, QQueryOperations> surahNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahName');
    });
  }

  QueryBuilder<Surah, String, QQueryOperations> surahNameTrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNameTr');
    });
  }

  QueryBuilder<Surah, String, QQueryOperations> surahTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahType');
    });
  }

  QueryBuilder<Surah, int, QQueryOperations> versesCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versesCount');
    });
  }

  QueryBuilder<Surah, int, QQueryOperations> wordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'words');
    });
  }
}

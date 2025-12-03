// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVerseDataCollection on Isar {
  IsarCollection<VerseData> get verseDatas => this.collection();
}

const VerseDataSchema = CollectionSchema(
  name: r'VerseData',
  id: -2079873903839649780,
  properties: {
    r'irab': PropertySchema(
      id: 0,
      name: r'irab',
      type: IsarType.string,
    ),
    r'sarf': PropertySchema(
      id: 1,
      name: r'sarf',
      type: IsarType.string,
    ),
    r'surahNumber': PropertySchema(
      id: 2,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'verseNumber': PropertySchema(
      id: 3,
      name: r'verseNumber',
      type: IsarType.long,
    ),
    r'wordMeaning': PropertySchema(
      id: 4,
      name: r'wordMeaning',
      type: IsarType.string,
    ),
    r'wordNumber': PropertySchema(
      id: 5,
      name: r'wordNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _verseDataEstimateSize,
  serialize: _verseDataSerialize,
  deserialize: _verseDataDeserialize,
  deserializeProp: _verseDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'surahNumber': IndexSchema(
      id: 9024003441292455669,
      name: r'surahNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'surahNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'verseNumber': IndexSchema(
      id: 4187590259546384965,
      name: r'verseNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'verseNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'wordNumber': IndexSchema(
      id: 9022083973110192111,
      name: r'wordNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'wordNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'sarf': IndexSchema(
      id: -937242930999910678,
      name: r'sarf',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sarf',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'irab': IndexSchema(
      id: 5103487296632384825,
      name: r'irab',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'irab',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'wordMeaning': IndexSchema(
      id: 5417588819744166599,
      name: r'wordMeaning',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'wordMeaning',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _verseDataGetId,
  getLinks: _verseDataGetLinks,
  attach: _verseDataAttach,
  version: '3.1.0+1',
);

int _verseDataEstimateSize(
  VerseData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.irab.length * 3;
  bytesCount += 3 + object.sarf.length * 3;
  bytesCount += 3 + object.wordMeaning.length * 3;
  return bytesCount;
}

void _verseDataSerialize(
  VerseData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.irab);
  writer.writeString(offsets[1], object.sarf);
  writer.writeLong(offsets[2], object.surahNumber);
  writer.writeLong(offsets[3], object.verseNumber);
  writer.writeString(offsets[4], object.wordMeaning);
  writer.writeLong(offsets[5], object.wordNumber);
}

VerseData _verseDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VerseData();
  object.id = id;
  object.irab = reader.readString(offsets[0]);
  object.sarf = reader.readString(offsets[1]);
  object.surahNumber = reader.readLong(offsets[2]);
  object.verseNumber = reader.readLong(offsets[3]);
  object.wordMeaning = reader.readString(offsets[4]);
  object.wordNumber = reader.readLong(offsets[5]);
  return object;
}

P _verseDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _verseDataGetId(VerseData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _verseDataGetLinks(VerseData object) {
  return [];
}

void _verseDataAttach(IsarCollection<dynamic> col, Id id, VerseData object) {
  object.id = id;
}

extension VerseDataQueryWhereSort
    on QueryBuilder<VerseData, VerseData, QWhere> {
  QueryBuilder<VerseData, VerseData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhere> anySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'surahNumber'),
      );
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhere> anyVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'verseNumber'),
      );
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhere> anyWordNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'wordNumber'),
      );
    });
  }
}

extension VerseDataQueryWhere
    on QueryBuilder<VerseData, VerseData, QWhereClause> {
  QueryBuilder<VerseData, VerseData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> idBetween(
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

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> surahNumberEqualTo(
      int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahNumber',
        value: [surahNumber],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> surahNumberNotEqualTo(
      int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [],
              upper: [surahNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [surahNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [surahNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'surahNumber',
              lower: [],
              upper: [surahNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> surahNumberGreaterThan(
    int surahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber',
        lower: [surahNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> surahNumberLessThan(
    int surahNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber',
        lower: [],
        upper: [surahNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> surahNumberBetween(
    int lowerSurahNumber,
    int upperSurahNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'surahNumber',
        lower: [lowerSurahNumber],
        includeLower: includeLower,
        upper: [upperSurahNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> verseNumberEqualTo(
      int verseNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'verseNumber',
        value: [verseNumber],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> verseNumberNotEqualTo(
      int verseNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseNumber',
              lower: [],
              upper: [verseNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseNumber',
              lower: [verseNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseNumber',
              lower: [verseNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verseNumber',
              lower: [],
              upper: [verseNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> verseNumberGreaterThan(
    int verseNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'verseNumber',
        lower: [verseNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> verseNumberLessThan(
    int verseNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'verseNumber',
        lower: [],
        upper: [verseNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> verseNumberBetween(
    int lowerVerseNumber,
    int upperVerseNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'verseNumber',
        lower: [lowerVerseNumber],
        includeLower: includeLower,
        upper: [upperVerseNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordNumberEqualTo(
      int wordNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'wordNumber',
        value: [wordNumber],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordNumberNotEqualTo(
      int wordNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordNumber',
              lower: [],
              upper: [wordNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordNumber',
              lower: [wordNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordNumber',
              lower: [wordNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordNumber',
              lower: [],
              upper: [wordNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordNumberGreaterThan(
    int wordNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'wordNumber',
        lower: [wordNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordNumberLessThan(
    int wordNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'wordNumber',
        lower: [],
        upper: [wordNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordNumberBetween(
    int lowerWordNumber,
    int upperWordNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'wordNumber',
        lower: [lowerWordNumber],
        includeLower: includeLower,
        upper: [upperWordNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> sarfEqualTo(
      String sarf) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sarf',
        value: [sarf],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> sarfNotEqualTo(
      String sarf) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sarf',
              lower: [],
              upper: [sarf],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sarf',
              lower: [sarf],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sarf',
              lower: [sarf],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sarf',
              lower: [],
              upper: [sarf],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> irabEqualTo(
      String irab) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'irab',
        value: [irab],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> irabNotEqualTo(
      String irab) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'irab',
              lower: [],
              upper: [irab],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'irab',
              lower: [irab],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'irab',
              lower: [irab],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'irab',
              lower: [],
              upper: [irab],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordMeaningEqualTo(
      String wordMeaning) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'wordMeaning',
        value: [wordMeaning],
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterWhereClause> wordMeaningNotEqualTo(
      String wordMeaning) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordMeaning',
              lower: [],
              upper: [wordMeaning],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordMeaning',
              lower: [wordMeaning],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordMeaning',
              lower: [wordMeaning],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordMeaning',
              lower: [],
              upper: [wordMeaning],
              includeUpper: false,
            ));
      }
    });
  }
}

extension VerseDataQueryFilter
    on QueryBuilder<VerseData, VerseData, QFilterCondition> {
  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'irab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'irab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'irab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'irab',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'irab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'irab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'irab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'irab',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'irab',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> irabIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'irab',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sarf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sarf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sarf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sarf',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sarf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sarf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sarf',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sarf',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sarf',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> sarfIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sarf',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> surahNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> verseNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      verseNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> verseNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> verseNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordMeaningEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordMeaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      wordMeaningGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordMeaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordMeaningLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordMeaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordMeaningBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordMeaning',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      wordMeaningStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wordMeaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordMeaningEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wordMeaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordMeaningContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wordMeaning',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordMeaningMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wordMeaning',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      wordMeaningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordMeaning',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      wordMeaningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wordMeaning',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition>
      wordNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterFilterCondition> wordNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VerseDataQueryObject
    on QueryBuilder<VerseData, VerseData, QFilterCondition> {}

extension VerseDataQueryLinks
    on QueryBuilder<VerseData, VerseData, QFilterCondition> {}

extension VerseDataQuerySortBy on QueryBuilder<VerseData, VerseData, QSortBy> {
  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByIrab() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'irab', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByIrabDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'irab', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortBySarf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sarf', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortBySarfDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sarf', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByWordMeaning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMeaning', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByWordMeaningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMeaning', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByWordNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordNumber', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> sortByWordNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordNumber', Sort.desc);
    });
  }
}

extension VerseDataQuerySortThenBy
    on QueryBuilder<VerseData, VerseData, QSortThenBy> {
  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByIrab() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'irab', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByIrabDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'irab', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenBySarf() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sarf', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenBySarfDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sarf', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByWordMeaning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMeaning', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByWordMeaningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMeaning', Sort.desc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByWordNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordNumber', Sort.asc);
    });
  }

  QueryBuilder<VerseData, VerseData, QAfterSortBy> thenByWordNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordNumber', Sort.desc);
    });
  }
}

extension VerseDataQueryWhereDistinct
    on QueryBuilder<VerseData, VerseData, QDistinct> {
  QueryBuilder<VerseData, VerseData, QDistinct> distinctByIrab(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'irab', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseData, VerseData, QDistinct> distinctBySarf(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sarf', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseData, VerseData, QDistinct> distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<VerseData, VerseData, QDistinct> distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }

  QueryBuilder<VerseData, VerseData, QDistinct> distinctByWordMeaning(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordMeaning', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseData, VerseData, QDistinct> distinctByWordNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordNumber');
    });
  }
}

extension VerseDataQueryProperty
    on QueryBuilder<VerseData, VerseData, QQueryProperty> {
  QueryBuilder<VerseData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VerseData, String, QQueryOperations> irabProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'irab');
    });
  }

  QueryBuilder<VerseData, String, QQueryOperations> sarfProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sarf');
    });
  }

  QueryBuilder<VerseData, int, QQueryOperations> surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<VerseData, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }

  QueryBuilder<VerseData, String, QQueryOperations> wordMeaningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordMeaning');
    });
  }

  QueryBuilder<VerseData, int, QQueryOperations> wordNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordNumber');
    });
  }
}

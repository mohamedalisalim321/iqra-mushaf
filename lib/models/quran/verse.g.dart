// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVerseCollection on Isar {
  IsarCollection<Verse> get verses => this.collection();
}

const VerseSchema = CollectionSchema(
  name: r'Verse',
  id: 6982547837312371642,
  properties: {
    r'normalVerse': PropertySchema(
      id: 0,
      name: r'normalVerse',
      type: IsarType.string,
    ),
    r'qcfData': PropertySchema(
      id: 1,
      name: r'qcfData',
      type: IsarType.string,
    ),
    r'qcfV4Data': PropertySchema(
      id: 2,
      name: r'qcfV4Data',
      type: IsarType.string,
    ),
    r'surahName': PropertySchema(
      id: 3,
      name: r'surahName',
      type: IsarType.string,
    ),
    r'surahNumber': PropertySchema(
      id: 4,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'verseNumber': PropertySchema(
      id: 5,
      name: r'verseNumber',
      type: IsarType.long,
    ),
    r'verseText': PropertySchema(
      id: 6,
      name: r'verseText',
      type: IsarType.string,
    )
  },
  estimateSize: _verseEstimateSize,
  serialize: _verseSerialize,
  deserialize: _verseDeserialize,
  deserializeProp: _verseDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _verseGetId,
  getLinks: _verseGetLinks,
  attach: _verseAttach,
  version: '3.1.0+1',
);

int _verseEstimateSize(
  Verse object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.normalVerse.length * 3;
  bytesCount += 3 + object.qcfData.length * 3;
  bytesCount += 3 + object.qcfV4Data.length * 3;
  bytesCount += 3 + object.surahName.length * 3;
  bytesCount += 3 + object.verseText.length * 3;
  return bytesCount;
}

void _verseSerialize(
  Verse object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.normalVerse);
  writer.writeString(offsets[1], object.qcfData);
  writer.writeString(offsets[2], object.qcfV4Data);
  writer.writeString(offsets[3], object.surahName);
  writer.writeLong(offsets[4], object.surahNumber);
  writer.writeLong(offsets[5], object.verseNumber);
  writer.writeString(offsets[6], object.verseText);
}

Verse _verseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Verse();
  object.id = id;
  object.normalVerse = reader.readString(offsets[0]);
  object.qcfData = reader.readString(offsets[1]);
  object.qcfV4Data = reader.readString(offsets[2]);
  object.surahName = reader.readString(offsets[3]);
  object.surahNumber = reader.readLong(offsets[4]);
  object.verseNumber = reader.readLong(offsets[5]);
  object.verseText = reader.readString(offsets[6]);
  return object;
}

P _verseDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _verseGetId(Verse object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _verseGetLinks(Verse object) {
  return [];
}

void _verseAttach(IsarCollection<dynamic> col, Id id, Verse object) {
  object.id = id;
}

extension VerseQueryWhereSort on QueryBuilder<Verse, Verse, QWhere> {
  QueryBuilder<Verse, Verse, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhere> anySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'surahNumber'),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhere> anyVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'verseNumber'),
      );
    });
  }
}

extension VerseQueryWhere on QueryBuilder<Verse, Verse, QWhereClause> {
  QueryBuilder<Verse, Verse, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> idBetween(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> surahNumberEqualTo(
      int surahNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'surahNumber',
        value: [surahNumber],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> surahNumberNotEqualTo(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> surahNumberGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> surahNumberLessThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> surahNumberBetween(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseNumberEqualTo(
      int verseNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'verseNumber',
        value: [verseNumber],
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseNumberNotEqualTo(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseNumberGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseNumberLessThan(
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

  QueryBuilder<Verse, Verse, QAfterWhereClause> verseNumberBetween(
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
}

extension VerseQueryFilter on QueryBuilder<Verse, Verse, QFilterCondition> {
  QueryBuilder<Verse, Verse, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalVerse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'normalVerse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'normalVerse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'normalVerse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'normalVerse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'normalVerse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'normalVerse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'normalVerse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'normalVerse',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> normalVerseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'normalVerse',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qcfData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qcfData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qcfData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qcfData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qcfData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qcfData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qcfData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qcfData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qcfData',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qcfData',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qcfV4Data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qcfV4Data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qcfV4Data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qcfV4Data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qcfV4Data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qcfV4Data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qcfV4Data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qcfV4Data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qcfV4Data',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> qcfV4DataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qcfV4Data',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameEqualTo(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameStartsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameEndsWith(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameContains(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameMatches(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahName',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'surahName',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNumberGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNumberLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> surahNumberBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberGreaterThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberLessThan(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseNumberBetween(
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

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseText',
        value: '',
      ));
    });
  }

  QueryBuilder<Verse, Verse, QAfterFilterCondition> verseTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseText',
        value: '',
      ));
    });
  }
}

extension VerseQueryObject on QueryBuilder<Verse, Verse, QFilterCondition> {}

extension VerseQueryLinks on QueryBuilder<Verse, Verse, QFilterCondition> {}

extension VerseQuerySortBy on QueryBuilder<Verse, Verse, QSortBy> {
  QueryBuilder<Verse, Verse, QAfterSortBy> sortByNormalVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalVerse', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByNormalVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalVerse', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByQcfData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfData', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByQcfDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfData', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByQcfV4Data() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfV4Data', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByQcfV4DataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfV4Data', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortBySurahName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortBySurahNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> sortByVerseTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.desc);
    });
  }
}

extension VerseQuerySortThenBy on QueryBuilder<Verse, Verse, QSortThenBy> {
  QueryBuilder<Verse, Verse, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByNormalVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalVerse', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByNormalVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'normalVerse', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByQcfData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfData', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByQcfDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfData', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByQcfV4Data() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfV4Data', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByQcfV4DataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qcfV4Data', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenBySurahName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenBySurahNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahName', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.asc);
    });
  }

  QueryBuilder<Verse, Verse, QAfterSortBy> thenByVerseTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.desc);
    });
  }
}

extension VerseQueryWhereDistinct on QueryBuilder<Verse, Verse, QDistinct> {
  QueryBuilder<Verse, Verse, QDistinct> distinctByNormalVerse(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'normalVerse', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByQcfData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qcfData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByQcfV4Data(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qcfV4Data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctBySurahName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }

  QueryBuilder<Verse, Verse, QDistinct> distinctByVerseText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseText', caseSensitive: caseSensitive);
    });
  }
}

extension VerseQueryProperty on QueryBuilder<Verse, Verse, QQueryProperty> {
  QueryBuilder<Verse, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> normalVerseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'normalVerse');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> qcfDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qcfData');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> qcfV4DataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qcfV4Data');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> surahNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahName');
    });
  }

  QueryBuilder<Verse, int, QQueryOperations> surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<Verse, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }

  QueryBuilder<Verse, String, QQueryOperations> verseTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseText');
    });
  }
}

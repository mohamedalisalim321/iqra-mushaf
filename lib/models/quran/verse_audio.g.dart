// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_audio.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVerseAudioCollection on Isar {
  IsarCollection<VerseAudio> get verseAudios => this.collection();
}

const VerseAudioSchema = CollectionSchema(
  name: r'VerseAudio',
  id: 1053557419322970233,
  properties: {
    r'filePath': PropertySchema(
      id: 0,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'reciterIdentifier': PropertySchema(
      id: 1,
      name: r'reciterIdentifier',
      type: IsarType.string,
    ),
    r'surahId': PropertySchema(
      id: 2,
      name: r'surahId',
      type: IsarType.long,
    ),
    r'verseId': PropertySchema(
      id: 3,
      name: r'verseId',
      type: IsarType.long,
    )
  },
  estimateSize: _verseAudioEstimateSize,
  serialize: _verseAudioSerialize,
  deserialize: _verseAudioDeserialize,
  deserializeProp: _verseAudioDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _verseAudioGetId,
  getLinks: _verseAudioGetLinks,
  attach: _verseAudioAttach,
  version: '3.1.0+1',
);

int _verseAudioEstimateSize(
  VerseAudio object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.filePath.length * 3;
  bytesCount += 3 + object.reciterIdentifier.length * 3;
  return bytesCount;
}

void _verseAudioSerialize(
  VerseAudio object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.filePath);
  writer.writeString(offsets[1], object.reciterIdentifier);
  writer.writeLong(offsets[2], object.surahId);
  writer.writeLong(offsets[3], object.verseId);
}

VerseAudio _verseAudioDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VerseAudio();
  object.filePath = reader.readString(offsets[0]);
  object.id = id;
  object.reciterIdentifier = reader.readString(offsets[1]);
  object.surahId = reader.readLong(offsets[2]);
  object.verseId = reader.readLong(offsets[3]);
  return object;
}

P _verseAudioDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _verseAudioGetId(VerseAudio object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _verseAudioGetLinks(VerseAudio object) {
  return [];
}

void _verseAudioAttach(IsarCollection<dynamic> col, Id id, VerseAudio object) {
  object.id = id;
}

extension VerseAudioQueryWhereSort
    on QueryBuilder<VerseAudio, VerseAudio, QWhere> {
  QueryBuilder<VerseAudio, VerseAudio, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VerseAudioQueryWhere
    on QueryBuilder<VerseAudio, VerseAudio, QWhereClause> {
  QueryBuilder<VerseAudio, VerseAudio, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<VerseAudio, VerseAudio, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterWhereClause> idBetween(
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
}

extension VerseAudioQueryFilter
    on QueryBuilder<VerseAudio, VerseAudio, QFilterCondition> {
  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> filePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      filePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> filePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> filePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> filePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> filePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reciterIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reciterIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reciterIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reciterIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reciterIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reciterIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reciterIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reciterIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      reciterIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reciterIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> surahIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      surahIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> surahIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahId',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> surahIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> verseIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseId',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition>
      verseIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseId',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> verseIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseId',
        value: value,
      ));
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterFilterCondition> verseIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VerseAudioQueryObject
    on QueryBuilder<VerseAudio, VerseAudio, QFilterCondition> {}

extension VerseAudioQueryLinks
    on QueryBuilder<VerseAudio, VerseAudio, QFilterCondition> {}

extension VerseAudioQuerySortBy
    on QueryBuilder<VerseAudio, VerseAudio, QSortBy> {
  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortByReciterIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterIdentifier', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy>
      sortByReciterIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterIdentifier', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortBySurahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortByVerseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseId', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> sortByVerseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseId', Sort.desc);
    });
  }
}

extension VerseAudioQuerySortThenBy
    on QueryBuilder<VerseAudio, VerseAudio, QSortThenBy> {
  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenByFilePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenByFilePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filePath', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenByReciterIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterIdentifier', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy>
      thenByReciterIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reciterIdentifier', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenBySurahIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahId', Sort.desc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenByVerseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseId', Sort.asc);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QAfterSortBy> thenByVerseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseId', Sort.desc);
    });
  }
}

extension VerseAudioQueryWhereDistinct
    on QueryBuilder<VerseAudio, VerseAudio, QDistinct> {
  QueryBuilder<VerseAudio, VerseAudio, QDistinct> distinctByFilePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QDistinct> distinctByReciterIdentifier(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reciterIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QDistinct> distinctBySurahId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahId');
    });
  }

  QueryBuilder<VerseAudio, VerseAudio, QDistinct> distinctByVerseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseId');
    });
  }
}

extension VerseAudioQueryProperty
    on QueryBuilder<VerseAudio, VerseAudio, QQueryProperty> {
  QueryBuilder<VerseAudio, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VerseAudio, String, QQueryOperations> filePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filePath');
    });
  }

  QueryBuilder<VerseAudio, String, QQueryOperations>
      reciterIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reciterIdentifier');
    });
  }

  QueryBuilder<VerseAudio, int, QQueryOperations> surahIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahId');
    });
  }

  QueryBuilder<VerseAudio, int, QQueryOperations> verseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseId');
    });
  }
}

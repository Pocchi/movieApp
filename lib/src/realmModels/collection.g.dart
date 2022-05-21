// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Collection extends _Collection with RealmEntity, RealmObject {
  Collection(
    int id, {
    String? title,
    String? posterPath,
  }) {
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'title', title);
    RealmObject.set(this, 'posterPath', posterPath);
  }

  Collection._();

  @override
  int get id => RealmObject.get<int>(this, 'id') as int;
  @override
  set id(int value) => throw RealmUnsupportedSetError();

  @override
  String? get title => RealmObject.get<String>(this, 'title') as String?;
  @override
  set title(String? value) => RealmObject.set(this, 'title', value);

  @override
  String? get posterPath =>
      RealmObject.get<String>(this, 'posterPath') as String?;
  @override
  set posterPath(String? value) => RealmObject.set(this, 'posterPath', value);

  @override
  Stream<RealmObjectChanges<Collection>> get changes =>
      RealmObject.getChanges<Collection>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(Collection._);
    return const SchemaObject(Collection, [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string, optional: true),
      SchemaProperty('posterPath', RealmPropertyType.string, optional: true),
    ]);
  }
}

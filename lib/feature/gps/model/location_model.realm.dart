// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class LocationModel extends _LocationModel
    with RealmEntity, RealmObjectBase, RealmObject {
  LocationModel(
    int? timestamp, {
    double? long,
    double? lat,
  }) {
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'long', long);
    RealmObjectBase.set(this, 'lat', lat);
  }

  LocationModel._();

  @override
  int? get timestamp => RealmObjectBase.get<int>(this, 'timestamp') as int?;
  @override
  set timestamp(int? value) => RealmObjectBase.set(this, 'timestamp', value);

  @override
  double? get long => RealmObjectBase.get<double>(this, 'long') as double?;
  @override
  set long(double? value) => RealmObjectBase.set(this, 'long', value);

  @override
  double? get lat => RealmObjectBase.get<double>(this, 'lat') as double?;
  @override
  set lat(double? value) => RealmObjectBase.set(this, 'lat', value);

  @override
  Stream<RealmObjectChanges<LocationModel>> get changes =>
      RealmObjectBase.getChanges<LocationModel>(this);

  @override
  Stream<RealmObjectChanges<LocationModel>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LocationModel>(this, keyPaths);

  @override
  LocationModel freeze() => RealmObjectBase.freezeObject<LocationModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'timestamp': timestamp.toEJson(),
      'long': long.toEJson(),
      'lat': lat.toEJson(),
    };
  }

  static EJsonValue _toEJson(LocationModel value) => value.toEJson();
  static LocationModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'timestamp': EJsonValue timestamp,
      } =>
        LocationModel(
          fromEJson(ejson['timestamp']),
          long: fromEJson(ejson['long']),
          lat: fromEJson(ejson['lat']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LocationModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
        ObjectType.realmObject, LocationModel, 'LocationModel', [
      SchemaProperty('timestamp', RealmPropertyType.int,
          optional: true, primaryKey: true),
      SchemaProperty('long', RealmPropertyType.double, optional: true),
      SchemaProperty('lat', RealmPropertyType.double, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

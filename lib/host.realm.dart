// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Host extends _Host with RealmEntity, RealmObjectBase, RealmObject {
  Host(
    ObjectId id,
    String hostname,
    String ip,
    bool status,
    DateTime lastOnline,
    DateTime lastOffline,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'hostname', hostname);
    RealmObjectBase.set(this, 'ip', ip);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'lastOnline', lastOnline);
    RealmObjectBase.set(this, 'lastOffline', lastOffline);
  }

  Host._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get hostname =>
      RealmObjectBase.get<String>(this, 'hostname') as String;
  @override
  set hostname(String value) => RealmObjectBase.set(this, 'hostname', value);

  @override
  String get ip => RealmObjectBase.get<String>(this, 'ip') as String;
  @override
  set ip(String value) => RealmObjectBase.set(this, 'ip', value);

  @override
  bool get status => RealmObjectBase.get<bool>(this, 'status') as bool;
  @override
  set status(bool value) => RealmObjectBase.set(this, 'status', value);

  @override
  DateTime get lastOnline =>
      RealmObjectBase.get<DateTime>(this, 'lastOnline') as DateTime;
  @override
  set lastOnline(DateTime value) =>
      RealmObjectBase.set(this, 'lastOnline', value);

  @override
  DateTime get lastOffline =>
      RealmObjectBase.get<DateTime>(this, 'lastOffline') as DateTime;
  @override
  set lastOffline(DateTime value) =>
      RealmObjectBase.set(this, 'lastOffline', value);

  @override
  Stream<RealmObjectChanges<Host>> get changes =>
      RealmObjectBase.getChanges<Host>(this);

  @override
  Stream<RealmObjectChanges<Host>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Host>(this, keyPaths);

  @override
  Host freeze() => RealmObjectBase.freezeObject<Host>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'hostname': hostname.toEJson(),
      'ip': ip.toEJson(),
      'status': status.toEJson(),
      'lastOnline': lastOnline.toEJson(),
      'lastOffline': lastOffline.toEJson(),
    };
  }

  static EJsonValue _toEJson(Host value) => value.toEJson();
  static Host _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'hostname': EJsonValue hostname,
        'ip': EJsonValue ip,
        'status': EJsonValue status,
        'lastOnline': EJsonValue lastOnline,
        'lastOffline': EJsonValue lastOffline,
      } =>
        Host(
          fromEJson(id),
          fromEJson(hostname),
          fromEJson(ip),
          fromEJson(status),
          fromEJson(lastOnline),
          fromEJson(lastOffline),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Host._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Host, 'Host', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('hostname', RealmPropertyType.string),
      SchemaProperty('ip', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.bool),
      SchemaProperty('lastOnline', RealmPropertyType.timestamp),
      SchemaProperty('lastOffline', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

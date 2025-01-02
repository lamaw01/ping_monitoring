import 'package:realm/realm.dart'; // import realm package

part 'host.realm.dart'; // declare a part file.

@RealmModel()
class _Host {
  @PrimaryKey()
  late ObjectId id;
  late String hostname;
  late String ip;
  late bool status;
  late DateTime lastOnline;
  late DateTime lastOffline;
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ping_monitoring/host.dart';
import 'package:realm/realm.dart';

class HostProvider with ChangeNotifier {
  // final List<Host> _hostsDummy = <Host>[
  //   Host(
  //     ObjectId(),
  //     'Google.com',
  //     'google.com',
  //     true,
  //     DateTime.now(),
  //     DateTime.now(),
  //   ),
  //   Host(
  //     ObjectId(),
  //     'Parasat AD Main',
  //     '172.21.3.39',
  //     true,
  //     DateTime.now(),
  //     DateTime.now(),
  //   ),
  //   Host(
  //     ObjectId(),
  //     'Archive Server',
  //     '172.16.3.66',
  //     true,
  //     DateTime.now(),
  //     DateTime.now(),
  //   ),
  //   Host(
  //     ObjectId(),
  //     'Google DNS',
  //     '8.8.8.8',
  //     true,
  //     DateTime.now(),
  //     DateTime.now(),
  //   ),
  //   Host(
  //     ObjectId(),
  //     'Test Host',
  //     '192.168.1.1',
  //     true,
  //     DateTime.now(),
  //     DateTime.now(),
  //   ),
  // ];

  final _realmHost = Realm(Configuration.local([Host.schema], schemaVersion: 2));
  RealmResults<Host> get hosts => _realmHost.all<Host>();

  // void initData() {
  //   _realmHost.write(() {
  //     _realmHost.addAll<Host>(_hostsDummy);
  //   });
  //   log('_realmHost length ${hosts.length}');
  //   notifyListeners();
  // }

  void deleteAllHost() {
    _realmHost.write(() {
      _realmHost.deleteAll<Host>();
    });
    log('_realmHost length ${hosts.length}');
    notifyListeners();
  }

  void addHost(Host host) {
    final where = hosts.where((e) => e.ip == host.ip);
    if (where.isEmpty) {
      _realmHost.write(() {
        _realmHost.add(host);
      });
    }
    log('_realmHost length ${hosts.length}');
    notifyListeners();
  }

  void updateHost(Host host,
      {String? hostname, String? ip, bool? status, DateTime? lastOnline, DateTime? lastOffline}) {
    debugPrint("$status ${host.ip} ${host.status}");
    _realmHost.write(() {
      _realmHost.add(
          host
            ..hostname = hostname ?? host.hostname
            ..ip = ip ?? host.ip
            ..status = status ?? host.status
            ..lastOnline = lastOnline ?? host.lastOnline
            ..lastOffline = lastOffline ?? host.lastOffline,
          update: true);
    });
    notifyListeners();
  }

  void deleteHost(Host host) {
    _realmHost.write(() {
      _realmHost.delete(host);
    });
    log('_realmHost length ${hosts.length}');
    notifyListeners();
  }
}

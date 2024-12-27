import 'package:flutter/material.dart';
import 'package:ping_monitoring/host.dart';

class HostProvider with ChangeNotifier {
  final List<Host> _hosts = <Host>[
    Host(
      hostname: 'Google.com',
      ip: 'google.com',
      status: true,
      lastOnline: DateTime.now(),
      lastOffline: DateTime.now(),
    ),
    Host(
      hostname: 'Parasat AD Main',
      ip: '172.21.3.39',
      status: true,
      lastOnline: DateTime.now(),
      lastOffline: DateTime.now(),
    ),
    Host(
      hostname: 'Archive Server',
      ip: '172.16.3.66',
      status: true,
      lastOnline: DateTime.now(),
      lastOffline: DateTime.now(),
    ),
    Host(
      hostname: 'Google DNS',
      ip: '8.8.8.8',
      status: true,
      lastOnline: DateTime.now(),
      lastOffline: DateTime.now(),
    ),
    Host(
      hostname: 'Test Host',
      ip: '192.168.1.1',
      status: true,
      lastOnline: DateTime.now(),
      lastOffline: DateTime.now(),
    ),
  ];

  List<Host> get hosts => _hosts;

  void changeStatus(int index, bool status) {
    _hosts[index].status = status;
    notifyListeners();
  }

  void changeIp(int index, String ip) {
    _hosts[index].ip = ip;
    notifyListeners();
  }

  void changeLastOffline(int index, DateTime dateTime) {
    _hosts[index].lastOffline = dateTime;
    notifyListeners();
  }

  void changeLastOnline(int index, DateTime dateTime) {
    _hosts[index].lastOnline = dateTime;
    notifyListeners();
  }
}

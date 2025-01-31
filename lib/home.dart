import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import 'custom_grid_delegate.dart';
import 'host.dart';
import 'host_provider.dart';
import 'host_widget.dart';
import 'settings_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _showAddDialog() async {
    final hostnameController = TextEditingController();
    final ipController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new host'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: hostnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: "Hostname",
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: ipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: "IP",
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Provider.of<HostProvider>(context, listen: false).addHost(Host(
                  ObjectId(),
                  hostnameController.text,
                  ipController.text,
                  true,
                  DateTime.now(),
                  DateTime.now(),
                ));
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDetailDialog(Host host) async {
    final hostnameController = TextEditingController(text: host.hostname);
    final ipController = TextEditingController(text: host.ip);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Host detail'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: hostnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: "Hostname",
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: ipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: "IP",
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Provider.of<HostProvider>(context, listen: false).deleteHost(host);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                Provider.of<HostProvider>(context, listen: false).updateHost(
                  host,
                  hostname: hostnameController.text,
                  ip: ipController.text,
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSettingsDialog() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    const List<int> pingIntervalValueList = <int>[10, 20, 30, 60];
    int pingIntervalValue = settings.pingInterval;

    const List<double> uiSizeValueList = <double>[150.0, 175.0, 200.0, 225.0, 250.0, 275.0, 300.0];
    double uiSizeValue = settings.uiSize;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: StatefulBuilder(
            builder: ((BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Interval'),
                      const SizedBox(width: 5.0),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          style: const TextStyle(color: Colors.black),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          borderRadius: BorderRadius.circular(5.0),
                          value: pingIntervalValue,
                          onChanged: (value) {
                            setState(() {
                              pingIntervalValue = value ?? pingIntervalValue;
                            });
                          },
                          items: pingIntervalValueList.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('UI size'),
                      const SizedBox(width: 5.0),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          style: const TextStyle(color: Colors.black),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          borderRadius: BorderRadius.circular(5.0),
                          value: uiSizeValue,
                          onChanged: (value) {
                            setState(() {
                              uiSizeValue = value ?? uiSizeValue;
                            });
                          },
                          items: uiSizeValueList.map<DropdownMenuItem<double>>((double value) {
                            return DropdownMenuItem<double>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                settings.updateInterval(pingIntervalValue);
                settings.updateUiSize(uiSizeValue);
                debugPrint('_pingInterval ${settings.pingInterval} || _uiSize ${settings.uiSize}');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ping Monitoring by MIS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          )
        ],
      ),
      body: Consumer<HostProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            gridDelegate: CustomGridDelegate(dimension: settings.uiSize),
            itemCount: provider.hosts.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: InkWell(
                  onTap: () {
                    _showDetailDialog(provider.hosts[index]);
                  },
                  child: HostWidget(
                    host: provider.hosts[index],
                    dataProvider: provider,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddDialog();
        },
      ),
    );
  }
}

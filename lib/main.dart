import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ping_monitoring/host_provider.dart';
import 'package:ping_monitoring/host.dart';
import 'package:provider/provider.dart';
import 'package:process_run/shell.dart';
import 'package:realm/realm.dart';

import 'custom_grid_delegate.dart';
import 'settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HostProvider>(
          create: (_) => HostProvider(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// int _pingInterval = 10;
// double _uiSize = 150.0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      title: 'UC-1 Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Ping Monitoring by MIS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer timer;

  Future<void> _showAddDialog() async {
    final hostnameController = TextEditingController();
    final ipController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
      barrierDismissible: false, // user must tap button!
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
    // final intervalController = TextEditingController(text: settings.interval.toString());
    const List<int> pingIntervalValueList = <int>[10, 20, 30, 60];
    int pingIntervalValue = settings.pingInterval;

    const List<double> uiSizeValueList = <double>[150.0, 175.0, 200.0, 225.0, 250.0, 275.0, 300.0];
    double uiSizeValue = settings.uiSize;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: StatefulBuilder(
            builder: ((BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TextField(
                  //   controller: intervalController,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //     labelText: "Ping Interval",
                  //     filled: true,
                  //     fillColor: Colors.white70,
                  //   ),
                  // ),
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
              onPressed: () async {
                // settings.updateInterval(intervalController.text);
                await settings.updateInterval(pingIntervalValue);
                await settings.updateUiSize(uiSizeValue);
                // _pingInterval = pingIntervalValue;
                // _uiSize = uiSizeValue;
                debugPrint('_pingInterval ${settings.pingInterval} || _uiSize ${settings.uiSize}');
                // ignore: use_build_context_synchronously
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
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('7Seas'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Dahilayan'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('CCTVs'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      body: Consumer<HostProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            gridDelegate: CustomGridDelegate(dimension: settings.uiSize),
            itemCount: provider.hosts.length,
            itemBuilder: (contex, index) {
              return GridTile(
                child: InkWell(
                  onTap: () {
                    _showDetailDialog(provider.hosts[index]);
                  },
                  child: HostWidget(
                    host: provider.hosts[index],
                    index: index,
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

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class HostWidget extends StatefulWidget {
  const HostWidget({super.key, required this.host, required this.index, required this.dataProvider});
  final Host host;
  final int index;
  final HostProvider dataProvider;

  @override
  State<HostWidget> createState() => _HostWidgetState();
}

class _HostWidgetState extends State<HostWidget> {
  late Timer timer;
  final dateFormat = DateFormat('yyyy/MM/dd HH:mm:ss');
  final currentTime = DateTime.now();

  final _shell = Shell(
      options: ShellOptions(
          verbose: false, noStderrResult: false, noStdoutResult: false, commandVerbose: false, commentVerbose: false));

  String _timeAge(DateTime dateTime) {
    return Jiffy.parseFromDateTime(dateTime).from(Jiffy.parseFromDateTime(DateTime.now()));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SettingsProvider>(context, listen: false).initSettings();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      timer = Timer.periodic(Duration(seconds: provider.pingInterval), (Timer t) async {
        final result = await _shell.run('''

      @echo off & ping -n 1 -4 ${widget.host.ip} | FindStr "TTL" >nul && (echo win) || (echo fail)

      ''');

        // If failed ping change status to false
        if (result.outText == 'fail' && widget.host.status) {
          widget.dataProvider.updateHost(widget.host, status: false, lastOnline: currentTime);
        }
        // If success ping change status to true
        else if (result.outText == 'win' && widget.host.status == false) {
          widget.dataProvider.updateHost(widget.host, status: true, lastOffline: currentTime);
        }

        log('${result.outText} - ${widget.host.ip} - ${widget.host.hostname} - ${widget.host.status}');
      });

      return Container(
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(3.0),
        color: widget.host.status ? Colors.green : Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AutoSizeText(
                widget.host.hostname,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
                maxLines: 2,
              ),
              AutoSizeText(
                widget.host.ip,
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                maxLines: 2,
              ),
              if (widget.host.status) ...[
                AutoSizeText(
                  "Last Offline: ${_timeAge(widget.host.lastOffline)}",
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  maxLines: 2,
                ),
              ] else ...[
                AutoSizeText(
                  "Last Online: ${_timeAge(widget.host.lastOnline)}",
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  maxLines: 2,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

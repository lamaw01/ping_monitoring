import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ping_monitoring/host_provider.dart';
import 'package:ping_monitoring/host.dart';
import 'package:provider/provider.dart';
import 'package:process_run/shell.dart';

import 'custom_grid_delegate.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HostProvider>(
          create: (_) => HostProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

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

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => setState(() {}));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
            gridDelegate: CustomGridDelegate(dimension: 240.0),
            itemCount: provider.hosts.length,
            itemBuilder: (contex, index) {
              return GridTile(
                child: InkWell(
                  onTap: () {
                    provider.changeStatus(index, !provider.hosts[index].status);
                    provider.changeLastOffline(index, DateTime.now());
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

    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      final result = await _shell.run('''

      @echo off & ping -n 1 -4 ${widget.host.ip} | FindStr "TTL" >nul && (echo win) || (echo fail)

      ''');

      // If failed ping change status to false
      if (result.outText == 'fail' && widget.host.status) {
        widget.dataProvider.changeStatus(widget.index, false);
        widget.dataProvider.changeLastOnline(widget.index, currentTime);
      }
      // If success ping change status to true
      else if (result.outText == 'win' && widget.host.status == false) {
        widget.dataProvider.changeStatus(widget.index, true);
        widget.dataProvider.changeLastOffline(widget.index, currentTime);
      }

      log('${result.outText} - ${widget.host.ip} - ${widget.host.hostname} - ${widget.host.status}');
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(3.0),
      color: widget.host.status ? Colors.green : Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.host.hostname, style: const TextStyle(fontSize: 18.0, color: Colors.white)),
            Text(widget.host.ip, style: const TextStyle(fontSize: 16.0, color: Colors.white)),
            if (widget.host.status) ...[
              Text("Last Offline: ${_timeAge(widget.host.lastOffline)}",
                  style: const TextStyle(fontSize: 14.0, color: Colors.white)),
            ] else ...[
              Text("Last Online: ${_timeAge(widget.host.lastOnline)}",
                  style: const TextStyle(fontSize: 14.0, color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  @override
  Widget build(BuildContext context) {
    // final dataProvider = Provider.of<DataProvider>(context, listen: false);
    // final hosts = Provider.of<DataProvider>(context).hosts;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        // actions: [
        // IconButton(
        //   onPressed: () async {
        //     final result = await shell.run('''

        //     @echo off & ping -n 1 -4 172.21.2.39 | FindStr "TTL" >nul && (echo win) || (echo fail)

        //     ''');
        //     log(result.outText);
        //   },
        //   icon: const Icon(Icons.settings),
        // ),
        // ],
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
      // body: GridView.count(
      //   childAspectRatio: (1.75 / 1),
      //   crossAxisCount: 7,
      //   children: List.generate(200, (index) {
      //     return Container(
      //       color: index % 2 == 1 ? Colors.red : Colors.green,
      //       margin: const EdgeInsets.all(3.0),
      //       padding: const EdgeInsets.all(3.0),
      //       child: Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           children: [
      //             if (index % 2 == 1) ...[
      //               const Text('Google.com', style: TextStyle(fontSize: 18.0, color: Colors.white)),
      //               const Text('8.8.8.8', style: TextStyle(fontSize: 16.0, color: Colors.white)),
      //               const Text('Last Online: 1 hour', style: TextStyle(fontSize: 14.0, color: Colors.white)),
      //             ] else ...[
      //               const Text('AD Main', style: TextStyle(fontSize: 18.0, color: Colors.white)),
      //               const Text('172.21.3.39', style: TextStyle(fontSize: 16.0, color: Colors.white)),
      //               const Text('Last Offline: September 12, 2024',
      //                   style: TextStyle(fontSize: 14.0, color: Colors.white)),
      //             ],
      //           ],
      //         ),
      //       ),
      //     );
      //   }),
      // ),
      body: Consumer<HostProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            gridDelegate: CustomGridDelegate(dimension: 240.0),
            itemCount: provider.hosts.length,
            itemBuilder: (contex, index) {
              return GridTile(
                child: InkWell(
                  onTap: () {
                    // dataProvider.changeIp(index, '192.168.1.1');
                    provider.changeStatus(index, !provider.hosts[index].status);
                  },
                  child: HostWidget(
                    host: provider.hosts[index],
                    index: index,
                    dataProvider: provider,
                  ),
                ),
                // child: Container(
                //   margin: const EdgeInsets.all(3.0),
                //   padding: const EdgeInsets.all(3.0),
                //   color: hosts[index].status ? Colors.green : Colors.red,
                //   child: Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Text(hosts[index].hostname, style: const TextStyle(fontSize: 18.0, color: Colors.white)),
                //         Text(hosts[index].ip, style: const TextStyle(fontSize: 16.0, color: Colors.white)),
                //         if (hosts[index].status) ...[
                //           Text("Last Offline: ${hosts[index].lastOffline}",
                //               style: const TextStyle(fontSize: 14.0, color: Colors.white)),
                //         ] else ...[
                //           Text("Last Online: ${hosts[index].lastOnline}",
                //               style: const TextStyle(fontSize: 14.0, color: Colors.white)),
                //         ],
                //       ],
                //     ),
                //   ),
                // ),
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

  final shell = Shell(
      options: ShellOptions(
          verbose: false, noStderrResult: false, noStdoutResult: false, commandVerbose: false, commentVerbose: false));

  @override
  void initState() {
    super.initState();
    final String ip = widget.host.ip;
    final String hostname = widget.host.hostname;
    final bool status = widget.host.status;

    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      final result = await shell.run('''

      @echo off & ping -n 1 -4 $ip | FindStr "TTL" >nul && (echo win) || (echo fail)

      ''');

      log('${result.outText} - $ip - $hostname - $status');

      if (result.outText == 'fail') {
        widget.dataProvider.changeStatus(widget.index, false);
      } else if (widget.dataProvider.hosts[widget.index].status) {
        widget.dataProvider.changeStatus(widget.index, true);
      }
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
              Text("Last Offline: ${dateFormat.format(widget.host.lastOffline)}",
                  style: const TextStyle(fontSize: 14.0, color: Colors.white)),
            ] else ...[
              Text("Last Online: ${dateFormat.format(widget.host.lastOffline)}",
                  style: const TextStyle(fontSize: 14.0, color: Colors.white)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:process_run/shell.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

import 'host.dart';
import 'host_provider.dart';
import 'settings_provider.dart';

class HostWidget extends StatefulWidget {
  const HostWidget({super.key, required this.host, required this.dataProvider});
  final Host host;
  final HostProvider dataProvider;

  @override
  State<HostWidget> createState() => _HostWidgetState();
}

class _HostWidgetState extends State<HostWidget> {
  // final _currentTime = DateTime.now();

  final _shell = Shell(
      options: ShellOptions(
          verbose: false, noStderrResult: false, noStdoutResult: false, commandVerbose: false, commentVerbose: false));

  String _timeAge(DateTime dateTime) {
    return Jiffy.parseFromDateTime(dateTime).from(Jiffy.parseFromDateTime(DateTime.now()));
  }

  Future<void> pingHost() async {
    final result = await _shell.run('''

    @echo off & ping -n 1 -4 ${widget.host.ip} | FindStr "TTL" >nul && (echo win) || (echo fail)

    ''');

    // If failed ping change status to false
    if (result.outText == 'fail' && widget.host.status) {
      widget.dataProvider
          .updateHost(widget.host, status: false, lastOnline: DateTime.now(), lastOffline: DateTime.now());
    }
    // If success ping change status to true
    else if (result.outText == 'win' && widget.host.status == false) {
      widget.dataProvider
          .updateHost(widget.host, status: true, lastOffline: DateTime.now(), lastOnline: DateTime.now());
    }

    log('${result.outText} - ${widget.host.ip} - ${widget.host.hostname} - ${widget.host.status}');
  }

  Future<Widget> widgetCallback() async {
    await pingHost();
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, child) {
      return TimerBuilder.periodic(
        Duration(seconds: provider.pingInterval),
        builder: (context) {
          return FutureBuilder<Widget>(
            future: widgetCallback(),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              return const Placeholder();
            },
          );
        },
      );
    });
  }
}

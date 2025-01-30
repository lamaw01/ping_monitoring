import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'settings_provider.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SettingsProvider>(context, listen: false).initSettings().then((_) async {
        await Future.delayed(const Duration(milliseconds: 1000));
        return Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Loading...'),
              CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

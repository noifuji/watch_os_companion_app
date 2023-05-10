import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watch_os_connectivity/flutter_watch_os_connectivity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int counter = 0;
  final FlutterWatchOsConnectivity _flutterWatchOsConnectivity =
      FlutterWatchOsConnectivity();

  void incrementCounter() {
    counter++;
    sendMessage("$counter");
  }

  Future<void> sendMessage(String txt) async {
    bool isReachable = await _flutterWatchOsConnectivity.getReachability();
    if (isReachable) {
      await _flutterWatchOsConnectivity.sendMessage({"COUNTER": txt});
    } else {
      if (kDebugMode) {
        print("No reachable watches.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _flutterWatchOsConnectivity.configureAndActivateSession();
    _flutterWatchOsConnectivity.activationStateChanged
        .listen((activationState) {
      if (activationState == ActivationState.activated) {
        if (kDebugMode) {
          print("activationDidCompleteWith state= ${activationState.name}");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Sample App',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_call_native/image_fetch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var channel = const MethodChannel('com.example.winter/native');
  Uint8List? imageBytes;

  void showToast() async {
    try {
      final result = await channel
          .invokeMethod('ShowToast', {'message': 'Hello from Flutter'});
      setState(() {
        imageBytes = result;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Winter Call Native'),
      ),
      body: const ImageFetcherWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String text = "Common, press the button!";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              children: [
                Text(text),
                OutlinedButton(onPressed: changeButtonText, child: const Text("Don't do it!")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeButtonText() async {
    setState(() {
      text = 'You button perv';
    });
    print('test');
    ApiService api = ApiService(baseUrl: "http://api.matakom.com");
    final message = await api.get("");
    setState(() {
      text = message;
    });
  } 
}

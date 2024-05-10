import 'package:flutter/material.dart';
import 'package:flython/flython.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade800),
        useMaterial3: true,
      ),
      home: Placeholder(),
    );
  }
}

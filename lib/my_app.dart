import 'package:flutter/material.dart';
import 'package:os_prototype/business_logic/services/flython_services.dart';
import 'package:os_prototype/screens/home_screen/home_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await FlythonServices.initialize();
      await FlythonServices.listAllProcesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "os_prototype",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade800),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

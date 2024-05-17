import 'package:flutter/material.dart';
import 'package:os_prototype/business_logic/services/flython_services.dart';
import 'package:os_prototype/my_app.dart';

Future<void> main() async {
  await FlythonServices.initialize();
  runApp(
    const MyApp(),
  );
}

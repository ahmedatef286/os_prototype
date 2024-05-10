import 'package:flutter/material.dart';
import 'package:flython/flython.dart';
import 'package:os_prototype/my_app.dart';

Future<void> main() async {
  runApp(MyApp());
}
/*
      final pyapp = Flython();
      await pyapp.initialize("python", 'lib/business_logic/python/project.py', false);

//
      final test = await pyapp.runCommand('list_running_processes');
      print(test);

//
      pyapp.finalize();

 */
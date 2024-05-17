import 'package:flython/flython.dart';
import 'package:os_prototype/business_logic/models/process.dart';

class FlythonServices {
  static Flython? pyapp;

  static Future<void> initialize() async {
    pyapp = Flython();
    await pyapp!.initialize("python3", 'main.py', false);
  }

  static Future<List<Process>> listAllProcesses() async {
    final list = ((await pyapp!.runCommand({'type': 'listRunningProcessess'}))
            as Map<String, dynamic>)
        .entries
        .map<Process>((e) => Process.fromMap(e))
        .toList();

    return list;
  }

  static Future<void> killProcess(String name) async {
    await pyapp!.runCommand({'type': 'kill', 'name': name});
  }

  static Future<dynamic> systemUtilzation() async {
    final Map<String, dynamic> response =
        await pyapp!.runCommand({'type': "system"});
    return response;
  }

  static Future<void> setPriority(int pid, String newPriority) async {
    int p = 0;
    switch (newPriority) {
      case "low":
        p = 18;
        break;

      case "below_normal":
        p = 9;
        break;

      case "normal":
        p = 0;
        break;

      case "above_normal":
        p = -9;
        break;

      case "high":
        p = -15;
        break;

      case "realtime":
        p = -20;
        break;
    }
    final response = (await pyapp!
        .runCommand({'type': 'setPriority', 'pid': pid, 'priority': p}));

    return response;
  }

  static void exit() {
    if (pyapp != null) pyapp!.finalize();
  }
}

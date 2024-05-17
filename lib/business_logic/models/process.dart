class Process {
  String name;
  int pid;
  dynamic status;
  double memoryPercent;
  double cpuPercent;
  int priority;

  Process(this.name, this.pid, this.status, this.cpuPercent, this.memoryPercent,
      this.priority);

  factory Process.fromMap(MapEntry<String, dynamic> map) {
    return Process(map.key, map.value[0], map.value[1], map.value[2],
        map.value[3], map.value[4]);
  }
}

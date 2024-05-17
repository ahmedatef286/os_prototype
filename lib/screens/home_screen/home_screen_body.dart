// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:os_prototype/business_logic/models/process.dart';
import 'package:os_prototype/business_logic/services/flython_services.dart';
import 'package:os_prototype/style/style.dart';
import 'package:pie_chart/pie_chart.dart';

class ProcessManagerBody extends StatefulWidget {
  const ProcessManagerBody({
    super.key,
  });

  @override
  State<ProcessManagerBody> createState() => _ProcessManagerBodyState();
}

class _ProcessManagerBodyState extends State<ProcessManagerBody>
    with SingleTickerProviderStateMixin {
  //ui
  double bodyWidth = 1195;
  double innerBodyHeight = 622;
  double headHeight = 60;

  //
  List<Process> procesesList = [];
  Process? focusedProcess;
  String? searchKey;

  Map<String, dynamic> systemStats = {};

  late Timer refreshTimer;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      procesesList = await FlythonServices.listAllProcesses();
      systemStats = await FlythonServices.systemUtilzation();
      setState(() {});
      refresh();
    });
  }

  void refresh() {
    refreshTimer = Timer(const Duration(milliseconds: 500), () async {
      final tempProcesesList = await FlythonServices.listAllProcesses();
      final tempSystemUtilzation = await FlythonServices.systemUtilzation();
      procesesList.clear();
      if (searchKey != null) {
        procesesList = tempProcesesList
            .where((element) =>
                element.name.contains(searchKey!) ||
                "${element.pid}".contains(searchKey!))
            .toList();
      } else {
        procesesList = tempProcesesList;
        systemStats = tempSystemUtilzation;
      }
      setState(() {});
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        processManagerHead(),
        Row(
          children: [
            SizedBox(
              width: bodyWidth * 0.6,
              height: innerBodyHeight,
              child: procesesList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                      color: CustomStyle.colorPalette.dimWhite,
                    ))
                  : ListView.builder(
                      itemCount: procesesList.length + 1,
                      itemBuilder: (context, index) {
                        return index == 0
                            ? processTile()
                            : processTile(process: procesesList[index - 1]);
                      }),
            ),
            visualizerAndControls(),
          ],
        )
      ],
    );
  }

  Container visualizerAndControls() {
    return Container(
      width: bodyWidth * 0.4,
      height: innerBodyHeight,
      child: systemStats.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: CustomStyle.colorPalette.dimWhite,
              ),
            )
          : TabBarView(
              controller: tabController,
              children: [
                SizedBox(
                  height: innerBodyHeight * 0.6,
                  width: bodyWidth * 0.4,
                  child: Column(
                    children: [
                      PieChart(
                          legendOptions: LegendOptions(
                            showLegends: true,
                            legendTextStyle: TextStyle(
                                color: CustomStyle.colorPalette.fullWhite,
                                fontSize: CustomStyle.fontSizes.subMediumFont),
                          ),
                          colorList: const [
                            Color(0xff36273c),
                            Color(0xff4c2759),
                          ],
                          dataMap: {
                            "System CPU": 100.0 - systemStats['cpu_percent'],
                            "CPU Utalized": systemStats['cpu_percent']
                          }),
                      SizedBox(
                        height: innerBodyHeight * 0.05,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        " System CPU Utilization % ",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.mediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.05,
                      ),
                      Text(
                        " Logical Cores : ${systemStats['logical_cores']}",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.025,
                      ),
                      Text(
                        " Physical Cores : ${systemStats['physical_cores']}",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.025,
                      ),
                      Text(
                        " Current CPU Frequency : ${systemStats['cpu_frequency'][0]} HZ ",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: innerBodyHeight * 0.6,
                  width: bodyWidth * 0.4,
                  child: Column(
                    children: [
                      PieChart(
                          legendOptions: LegendOptions(
                            showLegends: true,
                            legendTextStyle: TextStyle(
                                color: CustomStyle.colorPalette.fullWhite,
                                fontSize: CustomStyle.fontSizes.subMediumFont),
                          ),
                          colorList: const [
                            Color(0xff36273c),
                            Color(0xff4c2759),
                          ],
                          dataMap: {
                            "System Memory":
                                100.0 - systemStats['memory_percent'],
                            "Memory Utalized": systemStats['memory_percent']
                          }),
                      SizedBox(
                        height: innerBodyHeight * 0.05,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        " System Memory Utilization % ",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.mediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.05,
                      ),
                      Text(
                        " Total Memory : ${systemStats['memory_total']} B",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.025,
                      ),
                      Text(
                        " Available Memory : ${systemStats['memory_total'] - systemStats['memory_used']} B",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.025,
                      ),
                      Text(
                        " Used Memory : ${systemStats['memory_used']} B",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: innerBodyHeight * 0.6,
                  width: bodyWidth * 0.4,
                  child: Column(
                    children: [
                      PieChart(
                          legendOptions: LegendOptions(
                            showLegends: true,
                            legendTextStyle: TextStyle(
                                color: CustomStyle.colorPalette.fullWhite,
                                fontSize: CustomStyle.fontSizes.subMediumFont),
                          ),
                          colorList: const [
                            Color(0xff36273c),
                            Color(0xff4c2759),
                          ],
                          dataMap: {
                            "System Disk": 100.0 -
                                ((systemStats['disk_used'] /
                                        systemStats['disk_total']) *
                                    100),
                            "Disk Utalized": ((systemStats['disk_used'] /
                                    systemStats['disk_total']) *
                                100)
                          }),
                      SizedBox(
                        height: innerBodyHeight * 0.05,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        " System Disk Utilization % ",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.mediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.05,
                      ),
                      Text(
                        " Total Disk : ${systemStats['disk_total']} B",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.025,
                      ),
                      Text(
                        " Available Disk : ${systemStats['disk_total'] - systemStats['disk_used']} B",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                      SizedBox(
                        height: innerBodyHeight * 0.025,
                      ),
                      Text(
                        " Used Disk : ${systemStats['disk_used']} B",
                        style: TextStyle(
                            color: CustomStyle.colorPalette.fullWhite,
                            fontSize: CustomStyle.fontSizes.subMediumFont),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget processTile({Process? process}) {
    return InkWell(
      splashColor: CustomStyle.colorPalette.midGrey,
      //this disables the first tile containing labels from being clickable
      onTap: process == null
          ? null
          : () {
              focusedProcess = process;
              setState(() {});
            },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: focusedProcess != null &&
                    process != null &&
                    focusedProcess!.name == process.name
                ? CustomStyle.colorPalette.lightGrey
                : null,
            border: Border.all(
                width: 1,
                color: CustomStyle.colorPalette.dimWhite.withOpacity(0.15))),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Text(
                textAlign: TextAlign.center,
                process?.name ?? "Name",
                style: TextStyle(
                    color: CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.smallFont),
              ),
            ),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: CustomStyle.colorPalette.dimWhite.withOpacity(0.15)),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                textAlign: TextAlign.center,
                "${process?.pid ?? "PID"}",
                style: TextStyle(
                    color: CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.smallFont),
              ),
            ),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: CustomStyle.colorPalette.dimWhite.withOpacity(0.15)),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                process?.status ?? "Status",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.smallFont),
              ),
            ),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: CustomStyle.colorPalette.dimWhite.withOpacity(0.15)),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                textAlign: TextAlign.center,
                "${process?.priority ?? "Priority"}",
                style: TextStyle(
                    color: CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.smallFont),
              ),
            ),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: CustomStyle.colorPalette.dimWhite.withOpacity(0.15)),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                textAlign: TextAlign.center,
                process?.memoryPercent.toStringAsFixed(9) ?? "Memory %",
                style: TextStyle(
                    color: CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.smallFont),
              ),
            ),
            VerticalDivider(
                width: 1,
                thickness: 1,
                color: CustomStyle.colorPalette.dimWhite.withOpacity(0.15)),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                textAlign: TextAlign.center,
                process?.cpuPercent.toStringAsFixed(6) ?? "CPU %",
                style: TextStyle(
                    color: CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.smallFont),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container processManagerHead() {
    return Container(
      decoration: BoxDecoration(
        color: CustomStyle.colorPalette.midGrey,
      ),
      height: headHeight,
      width: bodyWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Processes",
            style: TextStyle(
                color: CustomStyle.colorPalette.fullWhite,
                fontSize: CustomStyle.fontSizes.mediumFont),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 68),
                child: SizedBox(
                    width: 400,
                    height: 35,
                    child: TextField(
                      onChanged: (value) {
                        searchKey = value;
                        if (searchKey!.trim().isEmpty) {
                          searchKey = null;
                          return;
                        }
                        setState(() {});
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomStyle.colorPalette.fullWhite,
                          fontSize: CustomStyle.fontSizes.subMediumFont),
                      decoration: InputDecoration(
                          icon: const Icon(Icons.search),
                          hintText: "Search for process by name or pid",
                          hintStyle: TextStyle(
                              color: CustomStyle.colorPalette.dimWhite,
                              fontSize: CustomStyle.fontSizes.subMediumFont),
                          filled: true,
                          fillColor: CustomStyle.colorPalette.lightGrey,
                          border: const OutlineInputBorder()),
                    )),
              ),
            ),
          ),
          TextButton(
              onPressed: () async {
                if (focusedProcess == null) return;
                await FlythonServices.killProcess(focusedProcess!.name);
                refresh();
              },
              child: Text("End Task",
                  style: TextStyle(
                      color: focusedProcess == null
                          ? CustomStyle.colorPalette.midGrey
                          : CustomStyle.colorPalette.fullWhite.withOpacity(0.9),
                      fontSize: CustomStyle.fontSizes.subMediumFont))),
          PopupMenuButton(
            color: CustomStyle.colorPalette.lightGrey,
            surfaceTintColor: Colors.transparent,
            child: Text("Set Priority",
                style: TextStyle(
                    color: focusedProcess == null
                        ? CustomStyle.colorPalette.midGrey
                        : CustomStyle.colorPalette.fullWhite,
                    fontSize: CustomStyle.fontSizes.subMediumFont)),
            onSelected: (value) async {
              if (focusedProcess == null) return;

              await FlythonServices.setPriority(focusedProcess!.pid, value);
              refresh();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: "low",
                child: Text(
                  'low',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: "below_normal",
                child: Text(
                  'below_normal',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: "normal",
                child: Text(
                  'normal',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: "above_normal",
                child: Text(
                  'above_normal',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: "high",
                child: Text(
                  'high',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              const PopupMenuItem(
                value: "real_time",
                child: Text(
                  'real_time',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}

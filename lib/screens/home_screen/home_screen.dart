import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:os_prototype/screens/home_screen/home_screen_body.dart';
import 'package:os_prototype/style/style.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.colorPalette.darkGrey,
      body: Row(
        children: [
          SidebarX(
            showToggleButton: false,
            theme: SidebarXTheme(
                padding: const EdgeInsets.only(top: 7),
                decoration:
                    BoxDecoration(color: CustomStyle.colorPalette.midGrey)),
            controller: SidebarXController(selectedIndex: 0),
            items: const [
              SidebarXItem(
                icon: Icons.home,
                label: 'Home',
              ),
            ],
          ),
          const ProcessManagerBody()
        ],
      ),
    );
  }
}

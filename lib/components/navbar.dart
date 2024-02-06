import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_mobile/pages/FocusFood.dart';
import 'package:project_mobile/pages/task.dart';
import 'package:project_mobile/pages/profile.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../pages/workzone.dart';

class Navbar extends StatefulWidget {
  static const roueName = '/';
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    const Workzone(),
    const TaskPage(),
    const Focusfood(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    final isMainPage = Provider.of<MainPageProvider>(context).isMainPage;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Visibility(
        visible: isMainPage,
        child: Container(
          color: HexColor('#FFFFFF'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
            child: GNav(
                backgroundColor: HexColor('#FFFFFF'),
                color: HexColor('#333333'),
                activeColor: HexColor('#333333'),
                tabBackgroundColor: HexColor('#FFD700'),
                gap: 8,
                padding: const EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Icons.timer_outlined,
                    text: 'Work Zone',
                  ),
                  GButton(
                    icon: Icons.task_outlined,
                    text: 'Task',
                  ),
                  GButton(
                    icon: Icons.food_bank_outlined,
                    text: 'Focus Food',
                  ),
                  GButton(
                    icon: Icons.account_circle_outlined,
                    text: 'Proflie',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}

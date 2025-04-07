import 'package:flutter/material.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/home_screen.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/mini_games_screen.dart';
import 'package:ios_fl_n_casinobarriere_3282/pages/progress_screen.dart';

class TabsScreen extends StatefulWidget {
  final int initialIndex;

  const TabsScreen({super.key, this.initialIndex = 0});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MiniGamesScreen(),
    ProgressScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTabIcon(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(top: isSelected ? 0 : 40),
      child: Image.asset(
        fit: BoxFit.contain,
        assetPath,
        width: 60,
        height: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          backgroundColor: const Color(0xFF252525),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.transparent,
          unselectedItemColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: _buildTabIcon('assets/images/1.png', 0),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildTabIcon('assets/images/2.png', 1),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _buildTabIcon('assets/images/3.png', 2),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

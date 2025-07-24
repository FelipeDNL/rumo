import 'package:flutter/material.dart';
import 'package:rumo/features/home/screens/browse/browse_screen.dart';
import 'package:rumo/features/home/screens/map/map_screen.dart';
import 'package:rumo/features/home/screens/profile/profile.dart';
import 'package:rumo/core/asset_icons.dart';
import 'package:rumo/features/home/widgets/bottom_nav_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MapScreen(),
    Placeholder(),
    BrowseScreen(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomNavItem(
              icon: AssetIcons.map,
              label: 'Mapa',
              selected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
            BottomNavItem(
              icon: AssetIcons.diary,
              label: 'Diários',
              selected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: Color(0xFFDDE1FF)),
              onPressed: () {},
              icon: Icon(Icons.add, color: Color(0xFF4E61F6), size: 20),
            ),
            BottomNavItem(
              icon: AssetIcons.compass,
              label: 'Explorar',
              selected: _selectedIndex == 2,
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            BottomNavItem(
              icon: AssetIcons.userCircle,
              label: 'Perfil',
              selected: _selectedIndex == 3,
              onTap: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rumo/features/navigation_bar/map/map_screen.dart';
import 'package:rumo/features/navigation_bar/profile/profile.dart';
import 'package:rumo/core/asset_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MapScreen(),
    Placeholder(),
    Placeholder(), // Placeholder for Diaries
    Placeholder(), // Placeholder for Add
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(AssetIcons.map),
            label: 'Mapa',
            selectedIcon: SvgPicture.asset(
              AssetIcons.map,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            icon: SvgPicture.asset(AssetIcons.diary),
            label: 'Diários',
            selectedIcon: SvgPicture.asset(
              AssetIcons.diary,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            icon: (IconTheme(
              data: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
                size: 35,
              ),
              child: Icon(Icons.add),
            )),
            label: 'Adicionar',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(AssetIcons.compass),
            label: 'Explorar',
            selectedIcon: SvgPicture.asset(
              AssetIcons.compass,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          NavigationDestination(
            icon: SvgPicture.asset(AssetIcons.userCircle),
            label: 'Perfil',
            selectedIcon: SvgPicture.asset(
              AssetIcons.userCircle,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rumo/features/navigation_bar/map/map_screen.dart';
import 'package:rumo/core/navigation_menu.dart';

class NavBarRoutes {
  static const String mapScreen = '/map';
  static const String navigationMenu = '/main-page';

  static final Map<String, Widget Function(BuildContext)> routes = {
  mapScreen: (context) => const MapScreen(),
  navigationMenu: (context) => const NavigationMenu(),
};
}
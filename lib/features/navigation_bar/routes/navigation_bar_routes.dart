import 'package:flutter/material.dart';
import 'package:rumo/features/navigation_bar/map/map_screen.dart';

class NavBarRoutes {
  static const String mapScreen = '/map';

  static final Map<String, Widget Function(BuildContext)> routes = {
    mapScreen: (context) => const MapScreen(),
  };
}
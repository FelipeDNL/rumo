import 'package:flutter/material.dart';
import 'package:rumo/features/home/screens/map/map_screen.dart';
import 'package:rumo/features/home/screens/home_screen.dart';
import 'package:rumo/features/home/screens/profile/profile.dart';

class HomeRoutes {
  static const String homeScreen = "/home";
  static const String mapScreen = '/map';
  static const String profile = '/profile';
  

  static final Map<String, Widget Function(BuildContext)> routes = {
  homeScreen: (context) => const NavigationMenu(),
  mapScreen: (context) => const MapScreen(),
  profile: (context) => const Profile()
  };
}

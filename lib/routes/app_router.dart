import 'package:flutter/material.dart';
import 'package:rumo/features/auth/routes/auth_routes.dart';
import 'package:rumo/features/onboarding/routes/onboarding_routes.dart';
import 'package:rumo/features/map/routes/map_screen_routes.dart';

class AppRouter {
  static final Map<String, Widget Function(BuildContext)> routes = {
    ...OnboardingRoutes.routes,
    ...AuthRoutes.routes,
    ...MapScreenRoutes.routes,
  };
}
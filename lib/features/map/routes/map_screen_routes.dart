import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rumo/features/map/map_screen.dart';

class MapScreenRoutes {
  static const String mapScreen = '/map';

  static final Map<String, Widget Function(BuildContext)> routes = {
    mapScreen: (context) => AuthGuard(child: const MapScreen()),
  };
}

// Widget de proteção de rota
class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Usuário não logado, redireciona para login
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    // Usuário logado, mostra a tela protegida
    return child;
  }
}
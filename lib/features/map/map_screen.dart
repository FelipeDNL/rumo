//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: Column(
              
            ),
          ),
        ],
      ),
    );
  }
}

/*

ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!mounted) return; // Garante que o widget ainda está ativo
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuário desconectado com sucesso!'),
              ),
            );
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('Logout'),
        ),

 */

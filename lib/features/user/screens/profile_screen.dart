import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumo/features/onboarding/routes/onboarding_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 50, left: 24, right: 24),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Perfil',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24),
                              SizedBox(
                                width: double.maxFinite,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      246,
                                      246,
                                      246,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.all(14),
                                    child: Row(
                                      spacing: 16,
                                      children: [
                                        SizedBox(
                                          // camera
                                          width: 50,
                                          height: 50,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                            ),
                                          ),
                                        ),
                                        Text('Toque para trocar foto'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 17),
                              SizedBox(
                                width: double.maxFinite,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      246,
                                      246,
                                      246,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.all(14),
                                    child: Row(
                                      children: [
                                        Text('Nome: '),
                                        Text(
                                          'Nome Aqui', // exemplo, substitua conforme necessário
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              SizedBox(
                                width: double.maxFinite,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      246,
                                      246,
                                      246,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.all(14),
                                    child: Row(
                                      children: [
                                        Text('Cidade: '),
                                        Text(
                                          'Cidade Aqui', // exemplo, substitua conforme necessário
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                width: double.maxFinite,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 13),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Sair da conta',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Tem certeza que deseja sair da sua conta?',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 24),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  FilledButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('Cancelar'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await FirebaseAuth.instance.signOut();
                                                      if (context.mounted) {
                                                        Navigator.of(context).popUntil((_) => false);
                                                        Navigator.pushNamed(
                                                          context,
                                                          OnboardingRoutes.onboardingScreen,
                                                        );
                                                      }
                                                    },
                                                    child: Text('Sair'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Sair',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

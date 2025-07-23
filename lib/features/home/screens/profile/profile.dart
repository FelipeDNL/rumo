import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/',
                                    ); // Troque pela sua rota de login
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


/*
child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            color: Colors.blueGrey[50],
                          ),
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Row(
                                children: [
                                  SizedBox( //camera icone
                                    width: 50,
                                    height: 50,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(
                                          100.0,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                      ),
                                    ),
                                  ),
                                  Text('Pressione aqui para trocar foto'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(child: Text('Nome: ')),
                  SizedBox(child: Text('Cidade: ')),
                ],
              ),

 */
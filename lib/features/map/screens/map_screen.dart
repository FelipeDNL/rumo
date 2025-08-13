import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userName = doc.data()?['name'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SlidingUpPanel(
        minHeight: 200,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        panel: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 24, right: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      top: 0
                    ),
                    child: Center(
                      child: Container(
                        width: 87,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  );
                }
              ),
              Row(
                children: ([
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    userName ?? 'Usuário',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ]),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: 8,
                        left: 25,
                        right: 25,
                        top: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(179, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Diários',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(179, 33, 33, 33),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: 8,
                        left: 12,
                        right: 12,
                        top: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(179, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Seguidores',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(179, 33, 33, 33),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xFFF5F5F5),
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.only(
                        bottom: 8,
                        left: 25,
                        right: 25,
                        top: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color.fromARGB(179, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Seguido',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(179, 33, 33, 33),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ÚLTIMOS REGISTROS',
                    style: 
                    TextStyle(
                      fontSize: 12, 
                      color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 24,),
                  Image.asset(AssetImages.catedral),
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 280, right: 7, left: 7),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromARGB(243, 85, 103, 241),
                      Colors.transparent,
                    ],
                    center: Alignment.center,
                    radius: 0.5,
                    stops: [1.0, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 180, left: 24, right: 24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Preencha seu mundo com aventuras e lembranças.',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 31),
                    Image.asset(AssetImages.mapIcon),
                    SizedBox(height: 31),
                    SizedBox(
                      width: double.maxFinite,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Adicione a ação do botão aqui
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        label: Text(
                          'Adicionar registro',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 78),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
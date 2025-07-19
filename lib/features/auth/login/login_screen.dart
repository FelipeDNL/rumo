import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/core/navigation_menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _senhaController.text,
        );
        if (!mounted) return; // Garante que o widget ainda está ativo
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login realizado com sucesso!')));
        // Verifica se o usuário está autenticado antes de navegar
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu(),),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Usuário não autenticado.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao fazer login: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 20.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AssetImages.logo,
                        width: 134,
                        height: 52,
                      ),
                      Text(
                        'Memórias na',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.68,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'palma da mão.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.68,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(AssetImages.loginCharacter),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: IconButton.filled(
                    padding: const EdgeInsets.all(10),
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    color: Color(0xFF383838),
                    icon: Icon(Icons.chevron_left, size: 29),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 32,
                    bottom: 32,
                    left: 24,
                    right: 24,
                  ),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem vindo (a) de volta!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Preencha com seus dados.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                                labelStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFF383838),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite seu e-mail';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Digite um e-mail válido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _senhaController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                labelStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color(0xFF383838),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 205, 205, 205),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Digite sua senha';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 62),
                      SizedBox(
                        width: double.maxFinite,
                        child: FilledButton(
                          onPressed: _login,
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
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
    );
  }
}

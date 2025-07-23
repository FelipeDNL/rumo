import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/auth/widgets/forgot_password_dialog.dart';
import 'package:rumo/features/home/routes/home_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool hidePassword = true;
  bool isLoading = false;

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: IconButton.filled(
                      padding: const EdgeInsets.all(10),
                      onPressed: () {
                        Navigator.of(context).pop();
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
                                controller: _passwordController,
                                obscureText: hidePassword,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                   suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: Icon(
                                      hidePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Por favor, insira uma senha';
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
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final isValid =
                                        _formKey.currentState?.validate() ??
                                        false;
                                    if (isValid) {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        final authRepository = AuthRepository();
                                        await authRepository.signInUser(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );

                                        setState(() {
                                          isLoading = false;
                                        });

                                        if (!context.mounted) return;
                                        Navigator.of(
                                          context,
                                        ).popUntil((route) => route.isFirst);
                                        Navigator.pushReplacementNamed(
                                          context,
                                        HomeRoutes.homeScreen,
                                        );
                                      } on AuthException catch (error) {
                                        if (!context.mounted) return;

                                        setState(() {
                                          isLoading = false;
                                        });

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Erro'),
                                              content: Text(error.getMessage()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                            child: Builder(
                              builder: (context) {
                                if (isLoading) {
                                  return SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                return Text('Entrar');
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return ForgotPasswordDialog();
                                },
                              );
                            },
                            child: const Text('Esqueci minha senha'),
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

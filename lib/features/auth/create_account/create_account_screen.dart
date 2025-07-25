import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 23, left: 25),
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
                      const Text(
                        'Memórias na',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.68,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
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
                Image.asset(AssetImages.createAccountCharacter),
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
                        Navigator.pushNamed(context, '/');
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      color: const Color(0xFF383838),
                      icon: const Icon(Icons.chevron_left, size: 29),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Preencha os dados abaixo para criar sua conta.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nome',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Digite seu nome';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility_off),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite uma senha';
                                  }
                                  if (value.length < 6) {
                                    return 'A senha deve ter pelo menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmarSenhaController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Confirmar senha',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hideConfirmPassword =
                                            !hideConfirmPassword;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_off),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirme sua senha';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'As senhas não coincidem';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 62),
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
                                        await authRepository.createAccount(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          name: _nameController.text,
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
                                          '/main-page'
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
                                return Text('Criar conta');
                              },
                            ),
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

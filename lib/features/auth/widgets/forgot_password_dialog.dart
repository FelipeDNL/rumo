import 'package:flutter/material.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Resetar senha'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(hintText: 'E-mail'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Digite seu e-mail';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Digite um e-mail válido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Visibility(visible: isLoading, child: CircularProgressIndicator()),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          try {
            final authRepository = AuthRepository();
            await authRepository.sendPasswordResetEmail(
              email: _emailController.text,
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('E-mail de redefinição enviado com sucesso!'),
              ),
            );
            Navigator.of(context).pop();
          } on AuthException catch (error) {
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
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Text('Enviar e-mail'),
      ),
    ],
  );
}

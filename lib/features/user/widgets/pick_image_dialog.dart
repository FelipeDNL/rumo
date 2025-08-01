import 'package:flutter/material.dart';

class PickImageDialog extends StatelessWidget {
  const PickImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.dangerous, color: Colors.red),
          Text(
            ' Erro',
          ),
        ],
      ),
      content: const Text('A foto de capa é obrigatória.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

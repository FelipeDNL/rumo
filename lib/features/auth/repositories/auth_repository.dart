import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Future createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw AuthException(code: 'invalid-user');
      }

      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
        "id": currentUser.uid,
        "email": email,
        "name": name,
      });

    } on FirebaseAuthException catch (error) {
      log(error.message ?? 'Erro desconhecido');

      throw AuthException(code: error.code);
    }
  }
}

class AuthException implements Exception {
  final String code;
  AuthException({required this.code});

  String getMessage() {
    switch (code) {
      case "email-already-in-use":
        return "Email já cadastrado";
      case "invalid-email":
        return "Email inválido";
      case "weak-password":
        return "Senha deve ter 6 ou mais caracteres";
      case "invalid-user":
        return "usuário inválido";
      default:
        return "Erro desconhecido";
    }
  }
}

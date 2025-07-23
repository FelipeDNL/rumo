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
        throw AuthException(code: "invalid-user");
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .set({"id": currentUser.uid, "email": email, "name": name});
    } on FirebaseAuthException catch (error) {
      log(error.message ?? 'Error desconhecido');

      throw AuthException(code: error.code);
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      log(
        "Firebase Error (Code: ${error.code}) ${error.message ?? "Erro desconhecido"}",
        error: error,
      );

      throw AuthException(code: error.code, originalMessage: error.message);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      log(
        "Firebase Error (Code: ${error.code}) ${error.message ?? "Erro desconhecido"}",
        error: error,
      );

      throw AuthException(code: error.code, originalMessage: error.message);
    }
  }
}

class AuthException implements Exception {
  final String code;
  final String? originalMessage;
  AuthException({required this.code, this.originalMessage});

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

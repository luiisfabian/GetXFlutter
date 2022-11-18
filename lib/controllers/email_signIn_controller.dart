import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';
import 'package:getx_flutter/repository/auth_repository.dart';

class EmailSignInController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  String? EmplyValidator(String? value) {
    return (value == null || value.isEmpty) ? "Requiered this field" : null;
  }

  Future<void> signInUserWithEmailAndPassword() async {
    try {
      isLoading.value = true;
      error.value = null;
      await _authRepository.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  Future resetPassword({required String email}) async {
    try {
      isLoading.value = true;
      error.value = null;
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        isLoading.value = true;
        error.value = null;
      });
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }
}

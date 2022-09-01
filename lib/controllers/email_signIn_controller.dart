import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';
import 'package:getx_flutter/repository/auth_repository.dart';

class SignInController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

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
}

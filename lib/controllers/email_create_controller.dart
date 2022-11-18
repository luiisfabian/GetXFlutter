import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';
import 'package:getx_flutter/repository/auth_repository.dart';

class EmailCreateController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  String? EmailValidator(String? value) {
   return (value == null || value.isEmpty) ? "Requiered this field" : null;
  }

  String? PasswordValidator(String? value) {
        bool hasUppercase = value!.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (value == null || value.isEmpty) return "Requiered this field";
    if (hasUppercase) return "Required Special Chrecters";
    if (value.length <= 6) return "El password is may to 6 ccaracteres";
    if (passwordController.text != repeatPasswordController.text) {
      return "Los password no son similares";
    }
    return null;
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      isLoading.value = true;
      error.value = null;
      await _authRepository.createUserWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }
}

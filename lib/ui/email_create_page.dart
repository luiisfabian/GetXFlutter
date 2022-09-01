import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/email_create_controller.dart';

class EmailCreatePage extends StatelessWidget {
  EmailCreatePage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = Get.put(EmailCreateController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Obx(
                  () => Visibility(
                    visible: emailController.isLoading.value,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: emailController.error.value?.isNotEmpty == true,
                    child: Text(
                      emailController.error.value ?? '',
                      style: TextStyle(color: Colors.red, fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: emailController.emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: emailController.EmailValidator,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: emailController.passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: emailController.PasswordValidator,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: emailController.repeatPasswordController,
                  decoration: InputDecoration(labelText: "Repeat Password"),
                  validator: emailController.PasswordValidator,
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        emailController.createUserWithEmailAndPassword();
                      }
                    },
                    child: Text("Create"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

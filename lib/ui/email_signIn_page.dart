import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/email_create_controller.dart';
import 'package:getx_flutter/controllers/email_signIn_controller.dart';

class EmailSignInPage extends StatelessWidget {
  EmailSignInPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = Get.put(EmailSignInController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
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
                  validator: emailController.EmplyValidator,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: emailController.passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: emailController.EmplyValidator,
                ),
          
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        emailController.signInUserWithEmailAndPassword();
                      }
                    },
                    child: Text("Login"),
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

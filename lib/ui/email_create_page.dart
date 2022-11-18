import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/email_create_controller.dart';

import '../controllers/email_signIn_controller.dart';

class EmailCreatePage extends StatefulWidget {
  EmailCreatePage({super.key});

  @override
  State<EmailCreatePage> createState() => _EmailCreatePageState();
}

class _EmailCreatePageState extends State<EmailCreatePage> {
  final _formKey = GlobalKey<FormState>();
      final emailController = Get.put(EmailSignInController());

    String? password;

  bool _passwordVisible = false;

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }
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
                // TextFormField(
                //   controller: emailController.passwordController,
                //   decoration: InputDecoration(labelText: "Password"),
                //   validator: emailController.PasswordValidator,
                // ),
                TextFormField(
                          controller: emailController.passwordController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: _obscureText
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            labelText: "Contraseña",
                          ),
                          validator: emailController.PasswordValidator
                        ),
                const SizedBox(
                  height: 8,
                ),
                // TextFormField(
                //   controller: emailController.repeatPasswordController,
                //   decoration: InputDecoration(labelText: "Repeat Password"),
                //   validator: emailController.PasswordValidator,
                // ),
                 TextFormField(
                          controller: emailController.repeatPasswordController,
                          obscureText: _obscureText,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: _obscureText
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            labelText: "Repetir Password",
                          ),
                          validator: emailController.PasswordValidator
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

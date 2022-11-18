import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/email_create_controller.dart';
import 'package:getx_flutter/controllers/email_signIn_controller.dart';

class EmailSignInPage extends StatefulWidget {
  EmailSignInPage({super.key});

  @override
  State<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final _formKey = GlobalKey<FormState>();

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
                    validator: emailController.EmplyValidator),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            emailController.signInUserWithEmailAndPassword();
                          }
                        },
                        child: Text("Login"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          emailController.resetPassword(email: emailController.emailController.text);
                        },
                        child: Text("ForgorPassword?"),
                      ),
                    ],
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

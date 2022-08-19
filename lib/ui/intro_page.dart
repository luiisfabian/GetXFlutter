import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';

import '../controllers/home_signin_controller.dart';
import '../navigation/routes.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WELCOME"),
      ),
      body: _IntroPager(),
    );
  }
}

class _IntroPager extends HookWidget {
  final String exampleText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";

  @override
  Widget build(BuildContext context) {
    final homeSignInController = Get.put(HomeSignInController());
    return AbsorbPointer(
      absorbing: homeSignInController.isLoading.value,
      child: PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        indicatorSpace: 12,
        indicatorColor: Colors.grey,
        indicatorSelectorColor: Colors.black,
        length: 4,
        child: PageView(
          children: [
             const _descriptionPage(
                text: "exampleText", imagenPath: 'assets/intro_1.png'),
             const _descriptionPage(
                text: "exampleText", imagenPath: 'assets/intro_2.png'),
             const _descriptionPage(
                text: "exampleText", imagenPath: 'assets/intro_3.png'),
          ],
          controller: usePageController(),
        ),
      ),
    );
  }
}

class _descriptionPage extends StatelessWidget {
  final String text;
  final String imagenPath;
  const _descriptionPage(
      {super.key, required this.text, required this.imagenPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Image.asset(
            imagenPath,
            height: 200,
            width: 200,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
    );
  }
}

class _loginPage extends StatelessWidget {
  const _loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeSignInController = Get.find<HomeSignInController>();
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/intro_1.png',
            width: 200,
            height: 200,
          ),
          Expanded(
            child: Container(
              child: const Text(
                "Sign In Or Create Account",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: homeSignInController.isLoading.value,
              child: const CircularProgressIndicator(),
            ),
          ),
          Obx(
            (() => Visibility(
                  visible: homeSignInController.error.value?.isNotEmpty == true,
                  child: Text(
                    homeSignInController.error.value ?? '',
                    style: const TextStyle(fontSize: 24, color: Colors.red),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                _loginButton(
                  text: "Sign In With Google",
                  imagePath: 'assets/icon_google.png',
                  color: Colors.white,
                  textColor: Colors.grey,
                  onTap: () => homeSignInController.signInWithGoogle(),
                ),
                const SizedBox(
                  height: 8,
                ),
                _loginButton(
                  text: "Sign In With Facebook",
                  imagePath: 'assets/icon_facebook.png',
                  color: Colors.blueAccent,
                  onTap: () => homeSignInController.signInWithFacebook(),
                ),
                const SizedBox(
                  height: 8,
                ),
                _loginButton(
                    text: "Sign In Email",
                    imagePath: 'assets/icon_email.png',
                    color: Colors.red,
                    textColor: Colors.white,
                    onTap: () => Get.toNamed(Routes.signInEmail)),
                const SizedBox(
                  height: 8,
                ),
                _loginButton(
                    text: "Sign In Anonymously",
                    imagePath: 'assets/icon_question.png',
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    onTap: () => homeSignInController.signInAnonymously()),
                const SizedBox(
                  height: 48,
                ),
                OutlinedButton(
                  onPressed: () => Get.toNamed(Routes.createAccount),
                  child: const Text("Create Account"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _loginButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;

  const _loginButton({
    Key? key,
    required this.text,
    required this.imagePath,
    this.onTap,
    this.color = Colors.blue,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

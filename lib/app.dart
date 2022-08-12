import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';
import 'package:getx_flutter/repository/auth_repository.dart';

import 'navigation/routes.dart';

class MyApp extends StatelessWidget {
  final authController = Get.put(AuthController());
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: authController,
      builder: (AuthController authController) {
        return const MaterialApp(
          title: "Authentication Flow",
          onGenerateRoute: Routes.routes,
        );
      },
    );
  }
}

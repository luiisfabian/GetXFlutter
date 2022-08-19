import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/navigation/routes.dart';

import 'controllers/auth_controller.dart';


class MyApp extends StatelessWidget {
  final authController = Get.put(AuthController());
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: authController,
      builder: (_) {
        return const MaterialApp(
          title: "Authentication Flow",
          onGenerateRoute: Routes.routes,
        );
      },
    );
  }
}

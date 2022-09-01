import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () => Get.find<AuthController>().signedOut(),
            tooltip: "LogOut",
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Text(Get.find<AuthController>().authUser.value?.uid ?? ''),
    );
  }
}

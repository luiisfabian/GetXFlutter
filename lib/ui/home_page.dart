import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';
import 'package:getx_flutter/controllers/my_user_controller.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(MyUserController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Home PAge"),
        actions: [
          IconButton(
            onPressed: () => Get.find<AuthController>().signedOut(),
            icon: Icon(Icons.logout),
            tooltip: 'LogOut',
          )
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _MyUserSection();
      }),
    );
  }
}

class _MyUserSection extends StatelessWidget {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<MyUserController>();

    final imageObx = Obx(() {
      Widget image = Image.asset(
        'assets/intro_3.png',
        fit: BoxFit.fill,
      );

      if (userController.pickedImage.value != null) {
        image = Image.file(
          userController.pickedImage.value!,
          fit: BoxFit.fill,
        );
      } else if (userController.user.value?.image?.isNotEmpty == true) {
        image = CachedNetworkImage(
          imageUrl: userController.user.value!.image!,
          progressIndicatorBuilder: (_, __, progress) =>
              CircularProgressIndicator(
            value: progress.progress,
          ),
          errorWidget: (_, __, ___) => const Icon(Icons.error),
          fit: BoxFit.fill,
        );
      }
      return image;
    });

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  Get.find<MyUserController>().setImage(File(pickedImage.path));
                }
              },
              child: Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: imageObx,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Obx(() {
              if (Get.find<AuthController>().authState.value ==
                  AuthState.signedIn) {
                return Center(
                  child: Text(
                      'UID: ${Get.find<AuthController>().authUser.value!.uid}'),
                );
              }
              return SizedBox.shrink();
            }),
            TextField(
              controller: userController.nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: userController.lastNameController,
              decoration: InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: userController.ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Age"),
            ),
            SizedBox(
              height: 8,
            ),
            Obx(() {
              final isSaving = userController.isSaving.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  ElevatedButton(
                    onPressed:
                        isSaving ? null : () => userController.saveMyUser(),
                    child: Text("Guardar"),
                  ),
                  if (isSaving) CircularProgressIndicator(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

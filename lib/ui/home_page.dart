import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/controllers/auth_controller.dart';
import 'package:getx_flutter/controllers/my_user_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../navigation/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(MyUserController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.food_menu);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("Profile Page"),
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
        // return _MyUserSection();
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
            TextField(
              controller: userController.phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              children: [
                Text("Al Precionar la palabra Guardar estara aceptando la"),
                TextButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: Text("Politica de Datos"),
                ),
              ],
            ),
            Obx(() {
              final isSaving = userController.isSaving.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () {
                            userController.saveMyUser();
                            Get.offAllNamed(Routes.food_menu);
                          },
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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Aceptar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Politica de Datos"),
      content: Text(
          " te informa sobre su Política de Privacidad respecto del tratamiento y protección de los datos de carácter personal de los usuarios y clientes que puedan ser recabados por la navegación o contratación de servicios a través del sitio Fabian Company. En este sentido, el Titular garantiza el cumplimiento de la normativa vigente en materia de protección de datos personales, reflejada en la Ley Orgánica 3/2018, de 5 de diciembre, de Protección de Datos Personales y de Garantía de Derechos Digitales (LOPD GDD). Cumple también con el Reglamento (UE) 2016/679 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas (RGPD). El uso de sitio Web implica la aceptación de esta Política de Privacidad así como las condiciones incluidas en el Aviso Legal."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

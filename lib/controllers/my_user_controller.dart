import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:getx_flutter/model/user.dart';
import 'package:getx_flutter/repository/my_user_repository.dart';

import 'auth_controller.dart';

class MyUserController extends GetxController {


  final _userRepository = Get.find<MyUserRepository>();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  Rx<File?> pickedImage = Rx(null);
  Rx<bool> isLoading = Rx(false);
  Rx<bool> isSaving = Rx(false);
  Rx<MyUser?> user = Rx(null);

  @override
  void onInit() {
    // TODO: implement onInit
    getMyUser();
    super.onInit();
  }


  void SetImage(File? imageFile) async{
    pickedImage.value = imageFile;
  }
  
  Future<void> getMyUser() async {
    isLoading.value = true;
    user.value = await _userRepository.getMyUser();
    nameController.text = user.value?.name ?? '';
    lastNameController.text = user.value?.lastName ?? ''; 
    ageController.text = user.value?.age.toString() ?? ''; 
    isLoading.value = false;
  }

  Future<void> saveMyUser() async{
    isSaving.value= true;
    final uid = Get.find<AuthController>().authUser.value!.uid;
    final name = nameController.text;
    final lastName = lastNameController.text;
    final age = int.tryParse(ageController.text) ?? 0;
    final newUser = MyUser(uid, name, lastName, age, image: user.value?.image);

    user.value = newUser;

    await Future.delayed(Duration(seconds: 3));
    await _userRepository.saveMyUser(newUser, pickedImage.value); 
    isSaving.value = false;
  }




}

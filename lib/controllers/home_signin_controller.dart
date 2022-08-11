import 'package:get/state_manager.dart';
import 'package:getx_flutter/repository/auth_repository.dart';

import 'package:get/get.dart';


class SignInController extends GetxController{
  final _authRepository = Get.find<AuthRepository>();

  final error = Rx<String?>(null);

  final isLoading = RxBool(false);


 Future<void> _signIn(Future<AuthUser?> auxUser) async{
  try {
    isLoading.value = true;
    error.value = null;
    await auxUser;
  } catch (e) {
    error.value = e.toString();
  }

  isLoading.value = false;
 }

 Future<void> signInAnonymously() => _signIn(_authRepository.signInAnonymously());

 Future<void> signInWithGoogle() => _signIn(_authRepository.signInWithGoogle());

 Future<void> signInWithFacebook() => _signIn(_authRepository.signInWithFacebook());

}
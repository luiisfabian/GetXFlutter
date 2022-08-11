import 'dart:async';

import 'package:get/get.dart';

import '../repository/auth_repository.dart';

enum AuthState { signedOut, signedIn }

class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  late StreamSubscription _authSubscription;

  final Rx<AuthState> authState = Rx(AuthState.signedOut);
  final Rx<AuthUser?> authUser = Rx(null);

  void _authStateChange(AuthUser? user) {
    if (user == null) {
      authState.value = AuthState.signedOut;
      //TODO entrar al inicio de la app
    } else {
      authState.value = AuthState.signedIn;
    }
    authUser.value = user;
  }

  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 4));
    _authSubscription =
        _authRepository.onAuthStateChange.listen(_authStateChange);
    super.onInit();
  }

  Future<void> signedOut() async {
    await _authRepository.signOut();
  }

  @override
  void onClose(){
    _authRepository.cancel();
    super.onClose();
  }
}

import 'dart:io';

import 'package:getx_flutter/model/user.dart';
import 'package:getx_flutter/providers/firebase_provider.dart';
import 'package:getx_flutter/repository/my_user_repository.dart';

class MyUserRepositoryImp extends MyUserRepository {
  final provider = FirebaseProvider();

  @override
  Future<MyUser?> getMyUser() => provider.getMyUser();

  @override
  Future<void> saveMyUser(MyUser user, File? image) =>
      provider.saveMyUser(user, image);
}

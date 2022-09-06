
import 'dart:io';

import '../model/user.dart';

abstract class MyUserRepository{
  Future<MyUser?> getMyUser();

  Future<void> saveMyUser(MyUser user, File? image);

}
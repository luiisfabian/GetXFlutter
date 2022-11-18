
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/menu/model/menuModel.dart';
import 'package:flutter/material.dart';

import '../../navigation/routes.dart';
class MenuService {
  final menuCollection =
      FirebaseFirestore.instance.collection("MenuColection");

  getMenus(List<MenuModel> MenuList) async {
    MenuList = [];
    await this.menuCollection.where("isDeleted", isEqualTo: false).get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        MenuList
            .add(new MenuModel.fromSnapshot(data: doc.data(), id: doc.id));
      });
      
    });
    return MenuList;
  }

  getMenusForType(List<MenuModel> MenuList, type) async {
    MenuList = [];
    await this.menuCollection.where("isDeleted", isEqualTo: false).where("type", isEqualTo: type).get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        MenuList
            .add(new MenuModel.fromSnapshot(data: doc.data(), id: doc.id));
      });
      
    });
    return MenuList;
  }

  addMenu(context, MenuModel menuModel) {

    this
        .menuCollection
        .add(menuModel.toJson())
        .then((value) => Get.offAllNamed(Routes.menu_types_list));
  }

  updateMenu(context,  MenuModel menuModel) {
    menuCollection
        .doc(menuModel.key)
        .update(menuModel.toJson())
        .then((value) => Navigator.pop(context));
  }

  deleteMenu(context, MenuModel menuModel) {
    menuCollection
        .doc(menuModel.key)
        .update(menuModel.toJson())
        .then((value) => print("elimin"));
  }
}
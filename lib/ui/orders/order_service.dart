
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../navigation/routes.dart';
import 'model/orderModel.dart';
class OrderService {
  final menuCollection =
      FirebaseFirestore.instance.collection("MenuColection");

  getOrder(List<OrderModel> OrderList) async {
    OrderList = [];
    await this.menuCollection.where("isDeleted", isEqualTo: false).get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        OrderList
            .add(new OrderModel.fromSnapshot(data: doc.data(), id: doc.id));
      });
      
    });
    return OrderList;
  }
  addMenu(context, OrderModel OrderModel) {
    this
        .menuCollection
        .add(OrderModel.toJson())
        .then((value) => Get.offAllNamed(Routes.orders_list));
  }

  updateMenu(context,  OrderModel OrderModel) {
    menuCollection
        .doc(OrderModel.key)
        .update(OrderModel.toJson())
        .then((value) => Get.offAllNamed(Routes.orders_list));
  }

  deleteMenu(context, OrderModel OrderModel) {
    menuCollection
        .doc(OrderModel.key)
        .update(OrderModel.toJson())
        .then((value) => print("elimin"));
  }
}
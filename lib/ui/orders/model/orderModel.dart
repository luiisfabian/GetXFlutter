// To parse this JSON data, do
//
//     final OrderModel = OrderModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getx_flutter/ui/menu/model/menuModel.dart';

class OrderModel {
  String? key;
  String clientName;
  Timestamp orderDate;
  List? products;
  bool? isDeleted;

  OrderModel({
    this.key,
    required this.clientName,
    required this.orderDate,
    this.isDeleted,
    this.products,
  });

  factory OrderModel.fromSnapshot({data, id}) {
    return OrderModel(
      key: id,
      clientName: data["clientName"],
      orderDate: data['orderDate'],
      products: data["products"],
      isDeleted: data["isDeleted"],
    );
  }
  toJson() {
    return {
      "key": key,
      "clientName": clientName,
      "products": products,
      "orderDate": orderDate,
      "isDeleted": isDeleted,
    };
  }
}

class ProductOrderModel {
  String? key;
  String? productName;
  int? amount;
  int? price;
  bool? isDeleted;

  ProductOrderModel({
    this.key,
    this.productName,
    this.amount,
    this.price,
    this.isDeleted,
  });

  factory ProductOrderModel.fromSnapshot({data, id}) {
    return ProductOrderModel(
      key: id,
      productName: data["productName"],
      amount: data['amount'],
      price: data['price'],
      isDeleted: data["isDeleted"],
    );
  }
  toJson() {
    return {
      "key": key,
      "productName": productName,
      "amount": amount,
      "price": price,
      "isDeleted": isDeleted,
    };
  }
}

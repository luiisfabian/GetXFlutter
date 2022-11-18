// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';



class MenuModel {
  MenuModel({
    this.key,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    this.isDeleted,
    this.photoUrl,

  });
  String? key;
  String name;
  String type;
  String description;
  int price;
  bool? isDeleted;
  String? photoUrl;



  factory MenuModel.fromSnapshot({data, id}) {
    return MenuModel(
      key: id,
      name: data["name"],
      type: data["type"],
      description: data["description"],
      price: data["price"],
      isDeleted: data["isDeleted"],
      photoUrl: data["photoUrl"]
    );
  }
  toJson() {
    return {
      "key": key,
      "type": type,
      "name": name,
      "description": description,
      "price": price,
      "isDeleted": isDeleted,
      "photoUrl": photoUrl
    };
  }
}

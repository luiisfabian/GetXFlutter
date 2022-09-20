
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:getx_flutter/model/user.dart';
 import 'package:path/path.dart' as path;

class FirebaseProvider{

  User get currentUser{
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) throw Exception('No authenticated Exception');
    return user;

  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;


  /// FUNCION PARA LEER LA BASE DE DATOS
  
  Future<MyUser?> getMyUser() async{

    final snapshot = await firestore.doc('user/${currentUser.uid}').get();

    if(snapshot.exists) return MyUser.fromFirebaseMap(snapshot.data()!);
    return null; 

  }
  /// FUNCION PARA ESCRIBIR EN LA BASE DE DATOS
  
  Future<void> saveMyUser(MyUser user, File? image) async{
    final ref = firestore.doc('user/${currentUser.uid}');

    if (image != null) {
      final imagePath = '${currentUser.uid}/profile/${path.basename(image.path)}';
      final storageRef = storage.ref(imagePath);
      await storageRef.putFile(image);
      final url = await storageRef.getDownloadURL();
      await ref.set(user.toFirebaseApp(newImage: url), SetOptions(merge: true));
    }else{
     await ref.set(user.toFirebaseApp(newImage: null), SetOptions(merge: true));
    }
  }
}
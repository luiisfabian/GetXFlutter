import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final int age;
  final int? phone;
  //final bool dataPolicy;

  final String? image;

  const MyUser(this.id, this.name, this.lastName, this.age,  this.phone, {this.image});

  Map<String, Object?> toFirebaseApp({String? newImage}) {
    return <String, Object?>{
      'id': id,
      'name': name,
      'lastName': lastName,
      'age': age,
      'phone': phone,
     // 'dataPolicy': dataPolicy,
      'image': newImage ?? image,
    };
  }

  MyUser.fromFirebaseMap(Map<String, Object?> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        lastName = data['lastName'] as String,
        age = data['age'] as int,
        phone = data['phone'] as int,
      //  dataPolicy = data['dataPolicy'] as bool,
        image = data['image'] as String?;

  @override
  // TODO: implement props
  List<Object?> get props =>
      [id, name, lastName, age, phone, image];
}

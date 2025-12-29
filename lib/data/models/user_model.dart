import 'package:leave_management/domain/entities/user_entity.dart';

class User extends UserEntity {
  User({
    String? id,
    required String username,
    required String email,
    required String password,
    required String department,
    required String designation,
    required String joinedDate,
  }) : super(
         id: id!,
         username: username,
         email: email,
         password: password,
         department: department,
         designation: designation,
         joinedDate: joinedDate,
       );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      username: json['username'],
      email: json['email'],
      password: json['password'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      joinedDate: json['joinedDate'] ?? '',
    );
  }
  toJson() {
    return {
      if (id != '') '_id': id,
      'username': username,
      'email': email,
      if (password != '') 'password': password,
      if (password != '') 'confirmPassword': password,
      'department': department,
      'designation': designation,
      'joinedDate': joinedDate,
    };
  }
}

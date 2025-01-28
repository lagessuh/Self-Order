// ignore_for_file: public_member_api_docs, sort_constructors_first
//classe de dados (DTO)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_order/models/users/users_access.dart';
//import 'package:self_order/models/users/users_access.dart';

class UserModel {
  String? id;
  String? userName;
  String? email;
  String? password;
  UsersAccess? usersAccess;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.password,
    this.usersAccess,
  });

  UserModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? password,
    UsersAccess? usersAccess,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      usersAccess: usersAccess ?? this.usersAccess,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'usersAccess': usersAccess,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      usersAccess: map['usersAccess'] != null
          ? UsersAccess.fromMap(map['usersAccess'] as Map<String, dynamic>)
          : null,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) =>
  //     UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, userName: $userName, email: $email, password: $password, usersAccess: $usersAccess)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.email == email &&
        other.password == password &&
        other.usersAccess == usersAccess;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'usersAccess': usersAccess,
    };
  }

  UserModel.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    userName = doc.get('userName');
    email = doc.get('email');
    usersAccess = doc.get('usersAccess') != null
        ? UsersAccess.fromMap(doc.get('usersAccess'))
        : null; // Inicialize o acesso se estiver presente
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        password.hashCode ^
        usersAccess.hashCode;
  }
}

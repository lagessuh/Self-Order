// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_order/models/users/users_access.dart';

class FuncionarioModel {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? matricula;
  String? funcao;
  UsersAccess? usersAccess;

  FuncionarioModel({
    this.id,
    this.userName,
    this.email,
    this.password,
    this.matricula,
    this.funcao,
    this.usersAccess,
  });

  FuncionarioModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? password,
    String? matricula,
    String? funcao,
    UsersAccess? usersAccess,
  }) {
    return FuncionarioModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      matricula: matricula ?? this.matricula,
      funcao: funcao ?? this.funcao,
      usersAccess: usersAccess ?? this.usersAccess,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'userName': userName,
  //     'email': email,
  //     'password': password,
  //     'matricula': matricula,
  //     'funcao': funcao,
  //     'usersAccess': usersAccess,
  //   };
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'matricula': matricula,
      'funcao': funcao,
      'usersAccess': usersAccess?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'matricula': matricula,
      'funcao': funcao,
      'usersAccess': usersAccess,
    };
  }

  factory FuncionarioModel.fromMap(Map<String, dynamic> map) {
    return FuncionarioModel(
      id: map['id'] != null ? map['id'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      matricula: map['matricula'] != null ? map['matricula'] as String : null,
      funcao: map['funcao'] != null ? map['funcao'] as String : null,
      usersAccess: map['usersAccess'] != null
          ? UsersAccess.fromMap(map['usersAccess'] as Map<String, dynamic>)
          : null,
    );
  }

  FuncionarioModel.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    userName = doc.get('userName');
    email = doc.get('email');
    matricula = doc.get('matricula');
    funcao = doc.get('funcao');
    usersAccess = doc.get('usersAccess');
  }

  //String toJson() => json.encode(toMap());

  //factory Funcionario.fromJson(String source) => Funcionario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FuncionarioModel(id: $id, userName: $userName, email: $email, password: $password, matricula: $matricula, funcao: $funcao, usersAccess: $usersAccess)';
  }

  @override
  bool operator ==(covariant FuncionarioModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.email == email &&
        other.password == password &&
        other.matricula == matricula &&
        other.funcao == funcao &&
        other.usersAccess == usersAccess;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        password.hashCode ^
        matricula.hashCode ^
        funcao.hashCode ^
        usersAccess.hashCode;
  }
}

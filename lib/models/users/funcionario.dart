// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class FuncionarioModel {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? matricula;
  String? funcao;
  FuncionarioModel({
    this.id,
    this.userName,
    this.email,
    this.password,
    this.matricula,
    this.funcao,
  });
  //UsersAccess? usersAccess;

  FuncionarioModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? password,
    String? matricula,
    String? funcao,
  }) {
    return FuncionarioModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      matricula: matricula ?? this.matricula,
      funcao: funcao ?? this.funcao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'matricula': matricula,
      'funcao': funcao,
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
    );
  }

  FuncionarioModel.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    userName = doc.get('userName');
    email = doc.get('email');
    matricula = doc.get('matricula');
    funcao = doc.get('funcao');
  }

  //String toJson() => json.encode(toMap());

  //factory Funcionario.fromJson(String source) => Funcionario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FuncionarioModel(id: $id, userName: $userName, email: $email, password: $password, matricula: $matricula, funcao: $funcao)';
  }

  @override
  bool operator ==(covariant FuncionarioModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userName == userName &&
        other.email == email &&
        other.password == password &&
        other.matricula == matricula &&
        other.funcao == funcao;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        email.hashCode ^
        password.hashCode ^
        matricula.hashCode ^
        funcao.hashCode;
  }
}

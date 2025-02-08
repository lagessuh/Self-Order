// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class UsersAccess {
//   String? id;
//   String? tipoUsuario;
//   UsersAccess({
//     this.tipoUsuario,
//   });

//   UsersAccess copyWith({
//     String? tipoUsuario,
//   }) {
//     return UsersAccess(
//       tipoUsuario: tipoUsuario ?? this.tipoUsuario,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'tipoUsuario': tipoUsuario,
//     };
//   }

//   factory UsersAccess.fromMap(Map<String, dynamic> map) {
//     return UsersAccess(
//       tipoUsuario:
//           map['tipoUsuario'] != null ? map['tipoUsuario'] as String : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory UsersAccess.fromJson(String source) =>
//       UsersAccess.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() => 'UserAccess(tipoUsuario: $tipoUsuario)';

//   @override
//   bool operator ==(covariant UsersAccess other) {
//     if (identical(this, other)) return true;

//     return other.tipoUsuario == tipoUsuario;
//   }

//   @override
//   int get hashCode => tipoUsuario.hashCode;
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';

class UsersAccess {
  String? id;
  String? tipoUsuario;
  List<String>? permissions; // Added field for granular permissions
  DateTime? lastAccessTime; // Added field to track last access
  bool isActive; // Added field to track if access is active

  UsersAccess({
    this.id,
    this.tipoUsuario,
    this.permissions,
    this.lastAccessTime,
    this.isActive = true,
  });

  UsersAccess copyWith({
    String? id,
    String? tipoUsuario,
    List<String>? permissions,
    DateTime? lastAccessTime,
    bool? isActive,
  }) {
    return UsersAccess(
      id: id ?? this.id,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      permissions: permissions ?? this.permissions,
      lastAccessTime: lastAccessTime ?? this.lastAccessTime,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipoUsuario': tipoUsuario,
      'permissions': permissions,
      'lastAccessTime': lastAccessTime?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory UsersAccess.fromMap(Map<String, dynamic> map) {
    return UsersAccess(
      id: map['id'],
      tipoUsuario: map['tipoUsuario'],
      permissions: map['permissions'] != null
          ? List<String>.from(map['permissions'])
          : null,
      lastAccessTime: map['lastAccessTime'] != null
          ? DateTime.parse(map['lastAccessTime'])
          : null,
      isActive: map['isActive'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersAccess.fromJson(String source) =>
      UsersAccess.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UsersAccess(id: $id, tipoUsuario: $tipoUsuario, permissions: $permissions, lastAccessTime: $lastAccessTime, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UsersAccess &&
        other.id == id &&
        other.tipoUsuario == tipoUsuario &&
        listEquals(other.permissions, permissions) &&
        other.lastAccessTime == lastAccessTime &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tipoUsuario.hashCode ^
        permissions.hashCode ^
        lastAccessTime.hashCode ^
        isActive.hashCode;
  }
}

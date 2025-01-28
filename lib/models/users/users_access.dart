// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsersAccess {
  String? id;
  String? tipoUsuario;
  UsersAccess({
    this.tipoUsuario,
  });

  UsersAccess copyWith({
    String? tipoUsuario,
  }) {
    return UsersAccess(
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tipoUsuario': tipoUsuario,
    };
  }

  factory UsersAccess.fromMap(Map<String, dynamic> map) {
    return UsersAccess(
      tipoUsuario:
          map['tipoUsuario'] != null ? map['tipoUsuario'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersAccess.fromJson(String source) =>
      UsersAccess.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserAccess(tipoUsuario: $tipoUsuario)';

  @override
  bool operator ==(covariant UsersAccess other) {
    if (identical(this, other)) return true;

    return other.tipoUsuario == tipoUsuario;
  }

  @override
  int get hashCode => tipoUsuario.hashCode;
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  String? id;
  String? titulo;
  String? descricao;

  Categoria({
    this.id,
    this.titulo,
    this.descricao,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titulo": titulo,
      "descricao": descricao,
    };
  }

  Categoria.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    titulo = doc.get('titulo');
    descricao = doc.get('descricao');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
    };
  }

  static fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}

  static fromDocument(DocumentSnapshot<Object?> e) {}
}

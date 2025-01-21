import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String? title;
  String? description;

  Category({
    this.id,
    this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
    };
  }

  Category.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    title = doc.get('title');
    description = doc.get('description');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'title': title,
    };
  }
}

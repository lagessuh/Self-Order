import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String? imageUrl;
  String? title;
  String? description;

  Category({
    this.id,
    this.imageUrl,
    this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "title": title,
      "description": description,
    };
  }

  Category.fromJson(DocumentSnapshot doc) {
    id = doc.id;
    imageUrl = doc.get('imageUrl');
    title = doc.get('title');
    description = doc.get('description');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'imageUrl': imageUrl,
      'title': title,
    };
  }
}

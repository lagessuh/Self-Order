import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String? id;
  String? name;
  String? description;
  bool? deleted;
  String? categoryId;
  String? image;
  String? url;
  double? price;
  String? unity;
  int? quantity;
  bool _loading = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
  }

  Produto(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.categoryId,
      this.price,
      this.unity,
      this.quantity = 0,
      this.deleted = false}) {
    name = name ?? '';
    image = image;
  }

  //método construtor para salvar os dados do documento firebase
  Produto.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.get('name');
    description = doc.get('description');
    quantity = doc.get('quantity') as int;
    unity = doc.get('unity') as String;
    price = doc.get('price') as double;
    categoryId = doc.get('categoryId') as String;
    deleted = (doc.get('deleted') ?? false) as bool;
    image = doc.get('image');
  }

  Produto.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        name = doc.get('name'),
        description = doc.get('description'),
        quantity = doc.get('quantity') as int,
        unity = doc.get('unity') as String,
        price = doc.get('price') as double,
        categoryId = doc.get('categoryId') as String,
        deleted = (doc.get('deleted') ?? false) as bool,
        image = doc.get('image');

//convert to map (Json) -> preparação do formato compatível com o JSON (FIREBASE)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unity': unity,
      'price': price,
      'image': image,
      'categoryId': categoryId,
      'deleted': deleted,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, quantity: $quantity,unity:$unity, price:$price, categoryId: $categoryId, image: $image)';
  }
}

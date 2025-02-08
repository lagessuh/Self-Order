import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String? id;
  String? nome;
  String? descricao;
  String? marca;
  //bool? deleted;
  String? idCategoria;
  String? image;
  //String? url;
  double? preco;
  String? unidade;
  int? quantidade;
  bool _loading = false;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
  }

  Produto(
      {this.id,
      this.nome,
      this.descricao,
      this.marca,
      this.image,
      this.idCategoria,
      this.preco,
      this.unidade,
      this.quantidade = 0
      //this.deleted = false
      }) {
    nome = nome ?? '';
    image = image;
  }

  // método construtor para salvar os dados do documento firebase
  Produto.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    nome = doc.get('nome');
    descricao = doc.get('descricao');
    marca = doc.get('marca');
    quantidade = doc.get('quantidade') as int;
    unidade = doc.get('unidade') as String;
    preco = doc.get('preco') as double;
    idCategoria = doc.get('idCategoria') as String;
    //deleted = (doc.get('deleted') ?? false) as bool;
    image = doc.get('image');
  }

  // Adicione este método à sua classe Produto
  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id']?.toString(),
      nome: map['nome']?.toString(),
      descricao: map['descricao']?.toString(),
      marca: map['marca']?.toString(),
      quantidade: map['quantidade']?.toInt(),
      unidade: map['unidade']?.toString(),
      preco: map['preco']?.toDouble(),
      idCategoria: map['idCategoria']?.toString(),
      image: map['image']?.toString(),
    );
  }

  Produto.fromSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        nome = doc.get('nome'),
        descricao = doc.get('descricao'),
        marca = doc.get('marca'),
        quantidade = doc.get('quantidade') as int,
        unidade = doc.get('unidade') as String,
        preco = doc.get('preco') as double,
        idCategoria = doc.get('idCategoria') as String,
        //deleted = (doc.get('deleted') ?? false) as bool,
        image = doc.get('image');

//convert to map (Json) -> preparação do formato compatível com o JSON (FIREBASE)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'marca': marca,
      'quantidade': quantidade,
      'unidade': unidade,
      'preco': preco,
      'image': image,
      'idCategoria': idCategoria,
      //'deleted': deleted,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, nome: $nome, descricao: $descricao, marca: $marca, quantidade: $quantidade, unidade:$unidade, price:$preco, idCategoria: $idCategoria, image: $image)';
  }
}

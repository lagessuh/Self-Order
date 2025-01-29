import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:uuid/uuid.dart';

class ProdutoServices extends ChangeNotifier {
  //instância para persistência dos dados no Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //instância para upload de mídias (imagens, vídeos, pdf) para o Firebase
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Produto? produto;

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('produtos');

  //CollectionReference get _collectionRef => _firestore.collection('users');

  DocumentReference get _firestoreRef =>
      _firestore.doc('produtos/${produto!.id}');

  //Reference get _storageRef =>
  //_storage.ref().child('produtos').child('${produto!.id}');

  Future<bool> save({Produto? produto, dynamic imageFile, bool? plat}) async {
    try {
      debugPrint("Salvando produto");

      // Adiciona o documento e obtém a referência
      final doc = await _collectionRef.add(produto!.toMap());

      // Atualiza o campo "id" no documento com o ID gerado pelo Firestore
      await doc.update({'id': doc.id});

      // Atualiza o objeto local
      this.produto = produto;
      this.produto!.id = doc.id;

      _uploadImage(imageFile, plat!);
      return Future.value(true);
    } on FirebaseException catch (e) {
      debugPrint(e.code.toString());
      return Future.value(false);
    }
  }

  _uploadImage(dynamic imageFile, bool plat) async {
    final uuid = const Uuid().v1();

    try {
      Reference storageRef =
          _storage.ref().child('produtos').child(produto!.id!);

      debugPrint('Iniciando upload no storage ${storageRef.name}');

      // Determinar o tipo MIME do arquivo
      String? mimeType;
      if (!plat) {
        // Se for um arquivo
        mimeType = lookupMimeType(imageFile.path);
        debugPrint('Tipo MIME detectado para arquivo: $mimeType');
      } else {
        // Se for dados (bytes)
        mimeType = lookupMimeType('', headerBytes: imageFile);
        debugPrint('Tipo MIME detectado para dados: $mimeType');
      }

      // Adiciona o metadata com o tipo MIME detectado
      SettableMetadata metadata = SettableMetadata(
        contentType: mimeType ?? 'application/octet-stream', // Valor padrão
      );

      UploadTask task;
      if (!plat) {
        task = storageRef.child(uuid).putFile(
              imageFile,
              metadata,
            );
      } else {
        task = storageRef.child(uuid).putData(
              imageFile,
              metadata,
            );
      }

      // Procedimento para obter a URL de download após o upload
      String url = await (await task.whenComplete(() {})).ref.getDownloadURL();

      // Atualiza a URL da imagem no Firestore
      DocumentReference docRef = _collectionRef.doc(produto!.id);
      await docRef.update({
        'id': produto!.id,
        'image': url,
      });

      debugPrint('Upload concluído. URL da imagem: $url');
    } on FirebaseException catch (e) {
      debugPrint('Erro no upload: ${e.code}');
      return Future.value(false);
    }
  }

  // Future<void> updateProduto(Produto produto) async {
  //   await _collectionRef.doc(produto.id).update(
  //         // {"name": product.name, "price": product.price},
  //         produto.toMap(),
  //       );
  // }

  Future<bool> updateProduto(Produto produto) async {
    try {
      if (produto.id == null || produto.id!.isEmpty) {
        throw Exception("ID do produto inválido");
      }

      // Validação básica dos dados do produto
      if (produto.nome!.isEmpty || produto.preco! <= 0) {
        throw Exception("Dados do produto inválidos");
      }

      final docRef = _collectionRef.doc(produto.id);

      // Atualiza o documento no Firestore
      await docRef.update(produto.toMap());
      debugPrint("Produto atualizado com sucesso: ${produto.id}");

      return true; // Sucesso
    } on FirebaseException catch (e) {
      debugPrint("Erro ao atualizar produto: ${e.code} - ${e.message}");
      throw Exception("Erro ao atualizar produto: ${e.message}");
    } catch (e) {
      debugPrint("Erro inesperado ao atualizar produto: $e");
      throw Exception("Erro inesperado: $e");
    }
  }

  Future<Produto?> getProdutoPorId(String? id) async {
    final docProduto = _firestore.collection('produtos').doc(id);
    final snapShot = await docProduto.get();
    if (snapShot.exists) {
      return Produto.fromDocument(snapShot);
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> getAllProdutos() {
    return _collectionRef.snapshots();
  }

  Future<List<Produto>> getProdutos() async {
    List<Produto> listProdutos = [];
    final result = await _collectionRef.get();
    listProdutos = result.docs.map((e) => Produto.fromSnapshot(e)).toList();
    return listProdutos;
  }

  // Future<bool> deleteProduto() {
  //   try {
  //     _firestoreRef.update({'deleted': true});
  //     return Future.value(true);
  //   } on FirebaseException {
  //     return Future.value(false);
  //   }
  // }

  Future<bool> deleteProduto({String? id}) async {
    try {
      if (id == null || id.isEmpty) {
        throw Exception("ID do produto inválido");
      }

      final docRef = _collectionRef.doc(id);

      // Hard delete: remove o documento completamente
      await docRef.delete();
      debugPrint("Produto removido completamente: $id");

      return true; // Sucesso
    } on FirebaseException catch (e) {
      debugPrint("Erro ao excluir produto: ${e.code} - ${e.message}");
      throw Exception("Erro ao excluir produto: ${e.message}");
    } catch (e) {
      debugPrint("Erro inesperado ao excluir produto: $e");
      throw Exception("Erro inesperado: $e");
    }
  }

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    debugPrint(allData.toString());
  }

  Future<List<DocumentSnapshot>> getProdutoPorNome(String nome) =>
      _collectionRef
          .orderBy('nome')
          .startAt([nome.toLowerCase()])
          .endAt([
            '${nome.toLowerCase()}\uf8ff'
          ]) //.endAt([name.toLowerCase() + '\uf8ff'])
          .get()
          .then((snapshot) {
            return snapshot.docs;
          });

  Future<List<DocumentSnapshot>> getProdutoPorNome2(String nome) async {
    try {
      var result = _collectionRef
          .where('nome', isGreaterThanOrEqualTo: nome)
          .where('nome', isLessThan: '${nome}z')
          .get()
          .then((value) {
        return value.docs;
      }); //.where('name', isLessThan: name +'z').snapshots(); //
      return Future.value(result);
    } on FirebaseException {
      return Future.value(null);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
//import 'package:flutter/material.dart';
import 'package:self_order/models/cardapio/categoria.dart';
import 'package:self_order/utils/exceptions/my_firebase_exceptions.dart';
import 'package:self_order/utils/exceptions/my_platform_exceptions.dart';
//import 'package:uuid/uuid.dart';

class CategoriaServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('categoria');
  List<DocumentSnapshot>? result;
  Categoria? categoria;

//Categoria? categoria, dynamic imageFile, bool? plat
  // Future<bool> add({Categoria? categoria}) async {
  //   try {
  //     debugPrint("Salvando categoria");
  //     final doc = await _collectionRef.add(categoria!.toMap());

  //     this.categoria = categoria;
  //     this.categoria!.id = doc.id;

  //     return Future.value(true);
  //   } on FirebaseException catch (e) {
  //     debugPrint(e.code.toString());
  //     return Future.value(false);
  //   }
  // }

  Future<bool> add({Categoria? categoria}) async {
    try {
      debugPrint("Salvando categoria");

      // Adiciona o documento e obtém a referência
      final doc = await _collectionRef.add(categoria!.toMap());

      // Atualiza o campo "id" no documento com o ID gerado pelo Firestore
      await doc.update({'id': doc.id});

      // Atualiza o objeto local
      this.categoria = categoria;
      this.categoria!.id = doc.id;

      return Future.value(true);
    } on FirebaseException catch (e) {
      debugPrint(e.code.toString());
      return Future.value(false);
    }
  }

  void update(Categoria categoria) async {
    await _collectionRef.doc(categoria.id).update(categoria.toJson());
  }

  void delete(String id) async {
    await _collectionRef.doc(id).delete();
  }

  Stream<QuerySnapshot> getCategorias() {
    return _collectionRef.snapshots();
  }

  Future<String> getCategoriasByID(String id) async {
    DocumentReference documentReference = _collectionRef.doc(id);
    var snapshot = await documentReference.get();
    return snapshot["titulo"];
  }

  //-- Get all categories --
  Future<List> getAllCategorias() async {
    try {
      final snapshot = await firestore.collection('categoria').get();
      final list =
          snapshot.docs.map((doc) => Categoria.fromSnapShot(doc)).toList();
      // debugPrint(
      //     'dados da categoria lidos ${snapshot.docs.map((doc) => CategoryModel.fromDocument(doc)).toList()}');
      // int index = 0;
      // while (index < list.length) {
      //   final name = list[index].name;
      //   ['name'];
      //   final id = list[index].id;
      //   print("Nome---> $name");
      //   print("id ---> $id");
      //   index++;
      // }

      return list;
    } on FirebaseException catch (e) {
      throw MyFirebaseExceptions(e.code).message;
    } on MyPlatformExceptions catch (e) {
      throw MyPlatformExceptions(e.code).message;
    } catch (e) {
      throw 'Alguma coisa de errado aconteceu. Por favor, tente novamente';
    }
  }

  Future<List<Categoria>> getCategoriesList() async {
    QuerySnapshot response;
    response = await firestore.collection('categoria').get();
    result = response.docs;
    debugPrint(
        'dados da categoria lidos ${result!.map((doc) => Categoria.fromDocument(doc)).toList()}');
    int index = 0;
    while (index < result!.length) {
      final name = result![index]['titulo'];
      final id = result![index].id;
      if (kDebugMode) {
        print("Nome categoria ---> $name");
      }
      if (kDebugMode) {
        print("Id categoria ---> $id");
      }
      index++;
    }

    return List<Categoria>.from(result!.map(
      (e) => Categoria.fromDocument(e),
    )).toList();
  }

  // _uploadImage(dynamic imageFile, bool plat) async {
  //   debugPrint("Salvando imagem da categoria");
  //   //chave para persistir a imagem no firebasestorage
  //   final uuid = const Uuid().v1();
  //   try {
  //     Reference storageRef =
  //         _storage.ref().child('categoria').child(categoria!.id!);
  //     debugPrint('storage ${storageRef.name}');
  //     //objeto para realizar o upload da imagem
  //     UploadTask task;

  //     if (!plat) {
  //       debugPrint('Imagem da câmera => ${imageFile.toString()}');
  //       task = storageRef.child(uuid).putFile(
  //             imageFile,
  //           );
  //     } else {
  //       debugPrint('Imagem da galeria => ${imageFile.toString()}');

  //       task = storageRef.child(uuid).putData(
  //             imageFile,
  //           );
  //     }
  //     //procedimento para persistir a imagem no banco de dados firebase
  //     String url = await (await task.whenComplete(() {})).ref.getDownloadURL();
  //     DocumentReference docRef = _collectionRef.doc(categoria!.id);
  //     await docRef.update({
  //       'id': categoria!.id,
  //       'imageUrl': url,
  //     });
  //   } on FirebaseException catch (e) {
  //     if (e.code != 'OK') {
  //       debugPrint('Problemas ao gravar dados');
  //     } else if (e.code == 'ABORTED') {
  //       debugPrint('Inclusão de dados abortada');
  //     }
  //     return Future.value(false);
  //   }
  // }
}

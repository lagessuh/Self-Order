import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:self_order/models/users/users.dart';
//import 'package:uuid/uuid.dart';

class UsersServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  UserModel? userModel;

  DocumentReference get _firestoreRef =>
      _firestore.doc('users/${userModel!.id}');
  CollectionReference get _collectionRef => _firestore.collection('users');

  UsersServices() {
    _loadingCurrentUser();
  }

  //Método para registrar o usuário no firebase console
  Future<bool> signUp(UserModel users, bool plat) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
              email: users.email!, password: users.password!))
          .user;
      //igualando os ids
      users.id = user!.uid;
      //atualizando variável de instância
      userModel = users;
      saveUserDetails();
      // _uploadImage(imageFile, plat);
      return Future.value(true);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        debugPrint('Email informado é inválido');
      } else if (error.code == 'weak-password') {
        debugPrint('A senha precisa ter no mínimo 6 caracteres');
      } else if (error.code == 'email-already-in-use') {
        debugPrint('Já existe cadastro com este email!!');
      } else {
        debugPrint("Algum erro aconteceu na Plataforma do Firebase");
      }
      return Future.value(false);
    }
  }

  //Método para autenticação de usuário
  Future<void> signIn(
      {String? email,
      String? password,
      Function? onSucess,
      Function? onFail}) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      ))
          .user;
      await _loadingCurrentUser(user: user);
      onSucess!();
      // return Future.value(true);
    } on FirebaseAuthException catch (e) {
      String code;
      if (e.code == 'invalid-email') {
        code = 'Email informado é inválido';
      } else if (e.code == 'wrong-password') {
        code = 'A senha informada está errada';
      } else if (e.code == 'user-disabled') {
        code = 'Já existe cadastro com este email!!';
      } else {
        code = "Algum erro aconteceu na Plataforma do Firebase";
      }
      onFail!(code);
      // return Future.value(false);
    }
  }

  saveUserDetails() async {
    await _firestoreRef.set(userModel!.toJson());
  }

  updateUser(UserModel users, dynamic imageFile, bool plat) {
    _firestoreRef.update(users.toJson());
    // _uploadImage(imageFile, plat);
  }

  //método para obter as credenciais do usuário autenticado
  _loadingCurrentUser({User? user}) async {
    User? currentUser = user ?? _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot docUser =
          await _firestore.collection('users').doc(currentUser.uid).get();
      userModel = UserModel.fromJson(docUser);
      notifyListeners();
    } else {
      userModel = UserModel(
          email: 'anonimo@anonimo.com',
          id: currentUser?.uid,
          userName: 'anônimo');
    }
  }

  // _uploadImage(dynamic imageFile, bool plat) async {
  //   //chave para persistir a imagem no firebasestorage
  //   final uuid = const Uuid().v1();
  //   try {
  //     Reference storageRef =
  //         _storage.ref().child('users').child(userModel!.id!);
  //     //objeto para realizar o upload da imagem
  //     UploadTask task;
  //     if (!plat) {
  //       task = storageRef.child(uuid).putFile(
  //             imageFile,
  //           );
  //     } else {
  //       task = storageRef.child(uuid).putData(
  //             imageFile,
  //           );
  //     }
  //     //procedimento para persistir a imagem no banco de dados firebase
  //     String url = await (await task.whenComplete(() {})).ref.getDownloadURL();
  //     DocumentReference docRef = _collectionRef.doc(userModel!.id);
  //     await docRef.update({'image': url});
  //   } on FirebaseException catch (e) {
  //     if (e.code != 'OK') {
  //       debugPrint('Problemas ao gravar dados');
  //     } else if (e.code == 'ABORTED') {
  //       debugPrint('Inclusão de dados abortada');
  //     }
  //     return Future.value(false);
  //   }
  // }

  Stream<QuerySnapshot> getUsers() {
    return _collectionRef.snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/users/users.dart';

class UsersServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;
  UserModel? userModel;

  DocumentReference get _firestoreRef =>
      _firestore.doc('users/${userModel!.id}');
  CollectionReference get _collectionRef => _firestore.collection('users');

  //para controlar o acesso do usuário
  bool _loading = false;
  bool get loading => _loading;
  // ignore: unnecessary_null_comparison
  bool get isLoggedIn => userModel! != null; //para ser utilizado na Gaveta

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

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

  Future<bool> signUp2({
    required UserModel userModel,
    required String password,
    required Function onFail,
    required Function onSuccess,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );

      User user = userCredential.user!;
      userModel.id = user.uid;

      // Salva os dados do usuário no Firestore usando o método toMap
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      // Carrega o usuário atual para atualizar o userModel
      await _loadingCurrentUser(user: user);

      onSuccess();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          if (kDebugMode) {
            print('Erro: Este email já está cadastrado');
          }
          onFail('Este email já está cadastrado');
          break;
        case 'invalid-email':
          if (kDebugMode) {
            print('Erro: O email informado está com formato inválido');
          }
          onFail('O email informado está com formato inválido');
          break;
        case 'weak-password':
          if (kDebugMode) {
            print('Erro: A senha precisa ter no mínimo 6 caracteres');
          }
          onFail('A senha precisa ter no mínimo 6 caracteres');
          break;
        case 'user-disabled':
          if (kDebugMode) {
            print('Erro: Este usuário foi desativado');
          }
          onFail('Este usuário foi desativado');
          break;
        case 'operation-not-allowed':
          if (kDebugMode) {
            print('Erro: A operação não é permitida');
          }
          onFail('A operação não é permitida');
          break;
        default:
          if (kDebugMode) {
            print('Erro ao criar conta: ${e.message}');
          }
          onFail('Erro ao criar conta: ${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Erro inesperado ao criar conta: $e');
      }
      onFail('Erro inesperado ao criar conta: $e');
      return false;
    }
  }

  // Future<bool> signUp2(
  //     {UserModel? userModel,
  //     String? userName,
  //     String? email,
  //     String? password,
  //     Function? onFail,
  //     Function? onSuccess}) async {
  //   try {
  //     User? user = (await _auth.createUserWithEmailAndPassword(
  //       email: userModel!.email!,
  //       password: password!,
  //     ))
  //         .user;

  //     userModel.id = user!.uid;
  //     userModel = userModel;

  //     saveData();

  //     _loadingCurrentUser(user: user);
  //     onSuccess!();
  //     return Future.value(true);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       onFail!('Este email já está cadastrado');
  //     } else if (e.code == 'invalid-email') {
  //       onFail!('O email informado está com formato inválido');
  //     } else if (e.code == 'weak-password') {
  //       onFail!('A senha precisa ter no mínimo 6 caracteres');
  //     } else if (e.code == 'user-disabled') {
  //       onFail!('Este usuário foi desativado');
  //     } else if (e.code == 'operation-not-allowed') {
  //       onFail!('A operação não é permitida');
  //     } else {
  //       onFail!('Erro ao criar conta: ${e.message}');
  //     }
  //     return Future.value(false);
  //   }
  // }

  Future<bool> saveData() async {
    try {
      final _docRef = FirebaseFirestore.instance.collection('users').doc(
          userModel!
              .id); // Usando o id do userLocal para referenciar o documento

      await _docRef.set(userModel!.toJson()); // Salva os dados

      return true; // Retorna true se os dados forem salvos com sucesso
    } catch (e) {
      debugPrint('Erro ao salvar dados: $e');
      return false; // Retorna false se houver erro
    }
  }

  // Método para autenticação de usuário
  Future<void> signIn({
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      await _loadingCurrentUser(user: user);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      String code;
      if (e.code == 'invalid-email') {
        code = 'Email informado é inválido';
      } else if (e.code == 'wrong-password') {
        code = 'A senha informada está errada';
      } else if (e.code == 'user-disabled') {
        code = 'Usuário desativado. Por favor, contate o suporte.';
      } else {
        code = 'Algum erro aconteceu na Plataforma do Firebase';
      }
      onFail(code);
    }
  }

  Future<void> _loadingCurrentUser({User? user}) async {
    User? currentUser = user ?? _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> docUser =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (docUser.exists) {
        // Carrega os dados do usuário do Firestore
        userModel = UserModel.fromMap(docUser.data()!);
      } else {
        // Lidar com o caso onde os dados do usuário não estão presentes
        userModel = UserModel(
          email: currentUser.email ?? 'anonimo@anonimo.com',
          id: currentUser.uid,
          userName: 'anônimo',
        );
      }
    } else {
      userModel = UserModel(
        email: 'anonimo@anonimo.com',
        id: null,
        userName: 'anônimo',
      );
    }
    notifyListeners();
  }

  // Future<void> _loadingCurrentUser({User? user}) async {
  //   User? currentUser = user ?? _auth.currentUser;
  //   if (currentUser != null) {
  //     DocumentSnapshot<Map<String, dynamic>> docUser =
  //         await _firestore.collection('users').doc(currentUser.uid).get();

  //     if (docUser.data() != null) {
  //       userModel = UserModel.fromMap(docUser.data()!);
  //     } else {
  //       // Lidar com o caso onde os dados do usuário não estão presentes
  //       userModel = UserModel(
  //         email: currentUser.email ?? 'anonimo@anonimo.com',
  //         id: currentUser.uid,
  //         userName: 'anônimo',
  //       );
  //     }
  //   } else {
  //     userModel = UserModel(
  //       email: 'anonimo@anonimo.com',
  //       id: null,
  //       userName: 'anônimo',
  //     );
  //   }
  //   notifyListeners();
  // }

  // Future<void> signIn(
  //     {String? email,
  //     String? password,
  //     Function? onSucess,
  //     Function? onFail,
  //     required Null Function() onSuccess}) async {
  //   try {
  //     User? user = (await _auth.signInWithEmailAndPassword(
  //       email: email!,
  //       password: password!,
  //     ))
  //         .user;
  //     await _loadingCurrentUser(user: user);
  //     onSucess!();
  //     // return Future.value(true);
  //   } on FirebaseAuthException catch (e) {
  //     String code;
  //     if (e.code == 'invalid-email') {
  //       code = 'Email informado é inválido';
  //     } else if (e.code == 'wrong-password') {
  //       code = 'A senha informada está errada';
  //     } else if (e.code == 'user-disabled') {
  //       code = 'Já existe cadastro com este email!!';
  //     } else {
  //       code = "Algum erro aconteceu na Plataforma do Firebase";
  //     }
  //     onFail!(code);
  //     // return Future.value(false);
  //   }
  // }

  saveUserDetails() async {
    await _firestoreRef.set(userModel!.toJson());
  }

  Future<void> updateUser(UserModel users) async {
    try {
      // Verifica se _firestoreRef não é nulo
      if (_firestoreRef != null) {
        await _firestoreRef.update(users.toJson());
      } else {
        throw Exception('Referência do Firestore não está disponível');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar usuário: $e');
      }
      rethrow; // Relança o erro para ser tratado no local de chamada
    }
  }

  // updateUser(UserModel users, dynamic imageFile, bool plat) {
  //   _firestoreRef.update(users.toJson());
  //   // _uploadImage(imageFile, plat);
  // }

  // //método para obter as credenciais do usuário autenticado
  // _loadingCurrentUser({User? user}) async {
  //   User? currentUser = user ?? _auth.currentUser;
  //   if (currentUser != null) {
  //     DocumentSnapshot docUser =
  //         await _firestore.collection('users').doc(currentUser.uid).get();
  //     userModel = UserModel.fromJson(docUser);
  //     notifyListeners();
  //   } else {
  //     userModel = UserModel(
  //         email: 'anonimo@anonimo.com',
  //         id: currentUser?.uid,
  //         userName: 'anônimo');
  //   }
  // }

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

  void logout() async {
    debugPrint("efetuando logout");
    _auth.signOut();
    userModel == null;
    notifyListeners();
    _loading = false;
    notifyListeners();
  }
}

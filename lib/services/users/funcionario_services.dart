import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
import 'package:self_order/models/users/funcionario.dart';
//import 'package:self_order/models/users/users.dart';
//import 'package:uuid/uuid.dart';
//import 'package:uuid/uuid.dart';

class FuncionarioServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final FirebaseStorage _storage = FirebaseStorage.instance;
  FuncionarioModel? funcionarioModel;

  DocumentReference get _firestoreRef =>
      _firestore.doc('funcionarios/${funcionarioModel!.id}');
  CollectionReference get _collectionRef =>
      _firestore.collection('funcionarios');

  //para controlar o acesso do usuário
  bool _loading = false;
  bool get loading => _loading;
  // ignore: unnecessary_null_comparison
  bool get isLoggedIn =>
      funcionarioModel! != null; //para ser utilizado na Gaveta

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  FuncionarioServices() {
    _loadingCurrentUser();
  }

  // //Método para registrar o usuário no firebase console
  // Future<bool> signUp(FuncionarioModel funcionario, bool plat) async {
  //   try {
  //     User? user = (await _auth.createUserWithEmailAndPassword(
  //             email: funcionario.email!, password: funcionario.password!))
  //         .user;
  //     //igualando os ids
  //     funcionario.id = user!.uid;
  //     //atualizando variável de instância
  //     funcionarioModel = funcionario;
  //     saveUserDetails();
  //     // _uploadImage(imageFile, plat);
  //     return Future.value(true);
  //   } on FirebaseAuthException catch (error) {
  //     if (error.code == 'invalid-email') {
  //       debugPrint('Email informado é inválido');
  //     } else if (error.code == 'weak-password') {
  //       debugPrint('A senha precisa ter no mínimo 6 caracteres');
  //     } else if (error.code == 'email-already-in-use') {
  //       debugPrint('Já existe cadastro com este email!!');
  //     } else {
  //       debugPrint("Algum erro aconteceu na Plataforma do Firebase");
  //     }
  //     return Future.value(false);
  //   }
  // }

  Future<bool> signUp2({
    required FuncionarioModel funcionarioModel,
    required String password,
    required Function onSuccess,
    required Function onFail,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: funcionarioModel.email!,
        password: password,
      );

      User user = userCredential.user!;
      funcionarioModel.id = user.uid;

      // Salva os dados do usuário no Firestore
      await _firestore
          .collection('funcionarios')
          .doc(user.uid)
          .set(funcionarioModel.toMap());

      // Remove estas duas linhas:
      // await _loadingCurrentUser(user: user);

      // Fazer logout logo após criar o usuário
      await _auth.signOut();

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

  // Future<bool> signUp2({
  //   required FuncionarioModel funcionarioModel,
  //   required String password,
  //   required Function onFail,
  //   required Function onSuccess,
  // }) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: funcionarioModel.email!,
  //       password: password,
  //     );

  //     User user = userCredential.user!;
  //     funcionarioModel.id = user.uid;

  //     // Salva os dados do usuário no Firestore usando o método toMap
  //     await _firestore
  //         .collection('funcionarios')
  //         .doc(user.uid)
  //         .set(funcionarioModel.toMap());

  //     // Carrega o usuário atual para atualizar o userModel
  //     await _loadingCurrentUser(user: user);

  //     onSuccess();
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case 'email-already-in-use':
  //         if (kDebugMode) {
  //           print('Erro: Este email já está cadastrado');
  //         }
  //         onFail('Este email já está cadastrado');
  //         break;
  //       case 'invalid-email':
  //         if (kDebugMode) {
  //           print('Erro: O email informado está com formato inválido');
  //         }
  //         onFail('O email informado está com formato inválido');
  //         break;
  //       case 'weak-password':
  //         if (kDebugMode) {
  //           print('Erro: A senha precisa ter no mínimo 6 caracteres');
  //         }
  //         onFail('A senha precisa ter no mínimo 6 caracteres');
  //         break;
  //       case 'user-disabled':
  //         if (kDebugMode) {
  //           print('Erro: Este usuário foi desativado');
  //         }
  //         onFail('Este usuário foi desativado');
  //         break;
  //       case 'operation-not-allowed':
  //         if (kDebugMode) {
  //           print('Erro: A operação não é permitida');
  //         }
  //         onFail('A operação não é permitida');
  //         break;
  //       default:
  //         if (kDebugMode) {
  //           print('Erro ao criar conta: ${e.message}');
  //         }
  //         onFail('Erro ao criar conta: ${e.message}');
  //     }
  //     return false;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Erro inesperado ao criar conta: $e');
  //     }
  //     onFail('Erro inesperado ao criar conta: $e');
  //     return false;
  //   }
  // }

  Future<bool> saveData() async {
    try {
      final _docRef = FirebaseFirestore.instance.collection('funcionarios').doc(
          funcionarioModel!
              .id); // Usando o id do userLocal para referenciar o documento

      await _docRef.set(funcionarioModel!.toJson()); // Salva os dados

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
        funcionarioModel = FuncionarioModel.fromMap(docUser.data()!);
      } else {
        // Lidar com o caso onde os dados do usuário não estão presentes
        funcionarioModel = FuncionarioModel(
          email: currentUser.email ?? 'anonimo@anonimo.com',
          id: currentUser.uid,
          userName: 'anônimo',
        );
      }
    } else {
      funcionarioModel = FuncionarioModel(
        email: 'anonimo@anonimo.com',
        id: null,
        userName: 'anônimo',
      );
    }
    notifyListeners();
  }

  saveUserDetails() async {
    await _firestoreRef.set(funcionarioModel!.toJson());
  }

  // Future<bool> deleteFuncionario({
  //   required String funcionarioId, // ID do funcionário a ser deletado
  //   required String adminEmail, // Email do admin
  //   required String adminPassword, // Senha do admin
  // }) async {
  //   try {
  //     if (funcionarioId.isEmpty) {
  //       throw Exception("ID do Funcionário inválido");
  //     }

  //     // 1. Reautenticar o administrador
  //     await _auth.signInWithEmailAndPassword(
  //       email: adminEmail,
  //       password: adminPassword,
  //     );

  //     // 2. Pegar referência do usuário a ser deletado
  //     DocumentSnapshot funcionarioDoc =
  //         await _collectionRef.doc(funcionarioId).get();
  //     String emailFuncionario = funcionarioDoc.get('email');

  //     // 3. Buscar o usuário no Authentication
  //     List<UserInfo> usuarios = await _auth
  //         .fetchSignInMethodsForEmail(emailFuncionario) as List<UserInfo>;
  //     if (usuarios.isNotEmpty) {
  //       // 4. Deletar do Authentication
  //       await _auth.currentUser?.delete();
  //     }

  //     // 5. Deletar do Firestore
  //     await _collectionRef.doc(funcionarioId).delete();

  //     debugPrint("Funcionário removido completamente");
  //     return true;
  //   } catch (e) {
  //     debugPrint("Erro ao excluir funcionário: $e");
  //     throw Exception("Erro ao excluir funcionário: $e");
  //   }
  // }

  Future<bool> deleteFuncionario({String? id}) async {
    try {
      if (id == null || id.isEmpty) {
        throw Exception("ID do Funcionário inválido");
      }

      final docRef = _collectionRef.doc(id);

      // Hard delete: remove o documento completamente
      await docRef.delete();
      debugPrint("Funcionário removido completamente: $id");

      return true; // Sucesso
    } on FirebaseException catch (e) {
      debugPrint("Erro ao excluir Funcionário: ${e.code} - ${e.message}");
      throw Exception("Erro ao excluir Funcionário: ${e.message}");
    } catch (e) {
      debugPrint("Erro inesperado ao excluir Funcionário: $e");
      throw Exception("Erro inesperado: $e");
    }
  }

  updateUser(FuncionarioModel funcionario) {
    _firestoreRef.update(funcionario.toJson());
    // _uploadImage(imageFile, plat);
  }

  // updateUser(FuncionarioModel funcionario, dynamic imageFile, bool plat) {
  //   _firestoreRef.update(funcionario.toJson());
  //   // _uploadImage(imageFile, plat);
  // }

  Stream<QuerySnapshot> getUsers() {
    return _collectionRef.snapshots();
  }

  Stream<QuerySnapshot> getAllFuncionarios() {
    return _collectionRef.snapshots();
  }

  void logout() async {
    debugPrint("efetuando logout");
    _auth.signOut();
    funcionarioModel == null;
    notifyListeners();
    _loading = false;
    notifyListeners();
  }
}

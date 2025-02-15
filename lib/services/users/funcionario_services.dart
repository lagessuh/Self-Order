// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:self_order/models/users/funcionario.dart';

// class FuncionarioServices extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   FuncionarioModel? funcionarioModel;

//   DocumentReference get _firestoreRef =>
//       _firestore.doc('funcionarios/${funcionarioModel!.id}');
//   CollectionReference get _collectionRef =>
//       _firestore.collection('funcionarios');

//   //para controlar o acesso do usuário
//   bool _loading = false;
//   bool get loading => _loading;
//   // ignore: unnecessary_null_comparison
//   bool get isLoggedIn =>
//       // ignore: unnecessary_null_comparison
//       funcionarioModel! != null; //para ser utilizado na Gaveta

//   set loading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }

//   FuncionarioServices() {
//     _loadingCurrentUser();
//   }

//   Future<bool> signUp2({
//     required FuncionarioModel funcionarioModel,
//     required String password,
//     required Function onSuccess,
//     required Function onFail,
//   }) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: funcionarioModel.email!,
//         password: password,
//       );

//       User user = userCredential.user!;
//       funcionarioModel.id = user.uid;

//       // Salva os dados do usuário no Firestore
//       await _firestore
//           .collection('funcionarios')
//           .doc(user.uid)
//           .set(funcionarioModel.toMap());

//       // Fazer logout logo após criar o usuário
//       await _auth.signOut();

//       onSuccess();
//       return true;
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'email-already-in-use':
//           if (kDebugMode) {
//             print('Erro: Este email já está cadastrado');
//           }
//           onFail('Este email já está cadastrado');
//           break;
//         case 'invalid-email':
//           if (kDebugMode) {
//             print('Erro: O email informado está com formato inválido');
//           }
//           onFail('O email informado está com formato inválido');
//           break;
//         case 'weak-password':
//           if (kDebugMode) {
//             print('Erro: A senha precisa ter no mínimo 6 caracteres');
//           }
//           onFail('A senha precisa ter no mínimo 6 caracteres');
//           break;
//         case 'user-disabled':
//           if (kDebugMode) {
//             print('Erro: Este usuário foi desativado');
//           }
//           onFail('Este usuário foi desativado');
//           break;
//         case 'operation-not-allowed':
//           if (kDebugMode) {
//             print('Erro: A operação não é permitida');
//           }
//           onFail('A operação não é permitida');
//           break;
//         default:
//           if (kDebugMode) {
//             print('Erro ao criar conta: ${e.message}');
//           }
//           onFail('Erro ao criar conta: ${e.message}');
//       }
//       return false;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Erro inesperado ao criar conta: $e');
//       }
//       onFail('Erro inesperado ao criar conta: $e');
//       return false;
//     }
//   }

//   Future<bool> saveData() async {
//     try {
//       final _docRef = FirebaseFirestore.instance.collection('funcionarios').doc(
//           funcionarioModel!
//               .id); // Usando o id do userLocal para referenciar o documento

//       await _docRef.set(funcionarioModel!.toJson()); // Salva os dados

//       return true; // Retorna true se os dados forem salvos com sucesso
//     } catch (e) {
//       debugPrint('Erro ao salvar dados: $e');
//       return false; // Retorna false se houver erro
//     }
//   }

//   // Método para autenticação de usuário
//   Future<void> signIn({
//     required String email,
//     required String password,
//     required Function onSuccess,
//     required Function(String) onFail,
//   }) async {
//     try {
//       User? user = (await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       ))
//           .user;

//       await _loadingCurrentUser(user: user);
//       onSuccess();
//     } on FirebaseAuthException catch (e) {
//       String code;
//       if (e.code == 'invalid-email') {
//         code = 'Email informado é inválido';
//       } else if (e.code == 'wrong-password') {
//         code = 'A senha informada está errada';
//       } else if (e.code == 'user-disabled') {
//         code = 'Usuário desativado. Por favor, contate o suporte.';
//       } else {
//         code = 'Algum erro aconteceu na Plataforma do Firebase';
//       }
//       onFail(code);
//     }
//   }

//   Future<void> _loadingCurrentUser({User? user}) async {
//     User? currentUser = user ?? _auth.currentUser;
//     if (currentUser != null) {
//       DocumentSnapshot<Map<String, dynamic>> docUser =
//           await _firestore.collection('users').doc(currentUser.uid).get();

//       if (docUser.exists) {
//         // Carrega os dados do usuário do Firestore
//         funcionarioModel = FuncionarioModel.fromMap(docUser.data()!);
//       } else {
//         // Lidar com o caso onde os dados do usuário não estão presentes
//         funcionarioModel = FuncionarioModel(
//           email: currentUser.email ?? 'anonimo@anonimo.com',
//           id: currentUser.uid,
//           userName: 'anônimo',
//         );
//       }
//     } else {
//       funcionarioModel = FuncionarioModel(
//         email: 'anonimo@anonimo.com',
//         id: null,
//         userName: 'anônimo',
//       );
//     }
//     notifyListeners();
//   }

//   saveUserDetails() async {
//     await _firestoreRef.set(funcionarioModel!.toJson());
//   }

//   Future<bool> deleteFuncionario({String? id}) async {
//     try {
//       if (id == null || id.isEmpty) {
//         throw Exception("ID do Funcionário inválido");
//       }

//       final docRef = _collectionRef.doc(id);

//       // Hard delete: remove o documento completamente
//       await docRef.delete();
//       debugPrint("Funcionário removido completamente: $id");

//       return true; // Sucesso
//     } on FirebaseException catch (e) {
//       debugPrint("Erro ao excluir Funcionário: ${e.code} - ${e.message}");
//       throw Exception("Erro ao excluir Funcionário: ${e.message}");
//     } catch (e) {
//       debugPrint("Erro inesperado ao excluir Funcionário: $e");
//       throw Exception("Erro inesperado: $e");
//     }
//   }

//   updateUser(FuncionarioModel funcionario) {
//     _firestoreRef.update(funcionario.toJson());
//   }

//   // updateUser(FuncionarioModel funcionario, dynamic imageFile, bool plat) {
//   //   _firestoreRef.update(funcionario.toJson());
//   //   // _uploadImage(imageFile, plat);
//   // }

//   Stream<QuerySnapshot> getUsers() {
//     return _collectionRef.snapshots();
//   }

//   Stream<QuerySnapshot> getAllFuncionarios() {
//     return _collectionRef.snapshots();
//   }

//   void logout() async {
//     debugPrint("efetuando logout");
//     _auth.signOut();
//     funcionarioModel == null;
//     notifyListeners();
//     _loading = false;
//     notifyListeners();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/models/users/users_access.dart';
import 'package:self_order/services/users/users_access_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FuncionarioServices extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FuncionarioModel? funcionarioModel;
  final UsersAccessServices _accessServices = UsersAccessServices();
  UsersAccess? usersAccess;

  DocumentReference get _firestoreRef =>
      _firestore.doc('funcionarios/${funcionarioModel!.id}');
  CollectionReference get _collectionRef =>
      _firestore.collection('funcionarios');

  // bool isFuncionario;

  //para controlar o acesso do usuário
  bool _loading = false;
  bool get loading => _loading;
  // ignore: unnecessary_null_comparison
  bool get isLoggedIn =>
      // ignore: unnecessary_null_comparison
      funcionarioModel! != null; //para ser utilizado na Gaveta

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  FuncionarioServices() {
    _loadingCurrentUser();
  }

  Future<bool> checkPermission(String permission) async {
    if (funcionarioModel?.usersAccess == null) return false;
    return _accessServices.hasPermission(
        funcionarioModel!.usersAccess!, permission);
  }

  Future<bool> signUp2({
    required FuncionarioModel funcionarioModel,
    required String password,
    required Function onSuccess,
    required Function onFail,
  }) async {
    try {
      // 🔹 1. Sua chave da API do Firebase
      const String apiKey = "AIzaSyAvL70V85C4ripLXm7xCWpxH7xkXkq_eno";

      // 🔹 2. Endpoint para criar usuário via API REST
      const String url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey";

      // 🔹 3. Requisição para criar usuário sem fazer login
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": funcionarioModel.email,
          "password": password,
          "returnSecureToken": false, // 🔥 Isso impede o login automático
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // 🔹 4. Usuário criado com sucesso, pega o UID
        String userId = responseData["localId"];
        funcionarioModel.id = userId;

        // 🔹 5. Salva os dados do funcionário no Firestore
        await _firestore
            .collection('funcionarios')
            .doc(userId)
            .set(funcionarioModel.toMap());

        onSuccess();
        return true;
      } else {
        onFail(responseData["error"]["message"]);
        return false;
      }
    } catch (e) {
      onFail("Erro inesperado ao criar conta: $e");
      return false;
    }
  }

  // Future<bool> signUp2({
  //   required FuncionarioModel funcionarioModel,
  //   required String password,
  //   required Function onSuccess,
  //   required Function onFail,
  // }) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: funcionarioModel.email!,
  //       password: password,
  //     );

  //     User user = userCredential.user!;
  //     funcionarioModel.id = user.uid;

  //     // ✅ Certifique-se de converter UsersAccess corretamente
  //     Map<String, dynamic> funcionarioMap = funcionarioModel.toMap();

  //     if (funcionarioModel.usersAccess != null) {
  //       funcionarioMap['usersAccess'] = funcionarioModel.usersAccess!.toMap();
  //     }

  //     // Salva os dados do usuário no Firestore
  //     await _firestore
  //         .collection('funcionarios')
  //         .doc(user.uid)
  //         .set(funcionarioMap);

  //     // Fazer logout logo após criar o usuário
  //     //await _auth.signOut();

  //     onSuccess();
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case 'email-already-in-use':
  //         if (kDebugMode) print('Erro: Este email já está cadastrado');
  //         onFail('Este email já está cadastrado');
  //         break;
  //       case 'invalid-email':
  //         if (kDebugMode)
  //           print('Erro: O email informado está com formato inválido');
  //         onFail('O email informado está com formato inválido');
  //         break;
  //       case 'weak-password':
  //         if (kDebugMode)
  //           print('Erro: A senha precisa ter no mínimo 6 caracteres');
  //         onFail('A senha precisa ter no mínimo 6 caracteres');
  //         break;
  //       case 'user-disabled':
  //         if (kDebugMode) print('Erro: Este usuário foi desativado');
  //         onFail('Este usuário foi desativado');
  //         break;
  //       case 'operation-not-allowed':
  //         if (kDebugMode) print('Erro: A operação não é permitida');
  //         onFail('A operação não é permitida');
  //         break;
  //       default:
  //         if (kDebugMode) print('Erro ao criar conta: ${e.message}');
  //         onFail('Erro ao criar conta: ${e.message}');
  //     }
  //     return false;
  //   } catch (e) {
  //     if (kDebugMode) print('Erro inesperado ao criar conta: $e');
  //     onFail('Erro inesperado ao criar conta: $e');
  //     return false;
  //   }
  // }

  // Future<bool> signUp2({
  //   required FuncionarioModel funcionarioModel,
  //   required String password,
  //   required Function onSuccess,
  //   required Function onFail,
  // }) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: funcionarioModel.email!,
  //       password: password,
  //     );

  //     User user = userCredential.user!;
  //     funcionarioModel.id = user.uid;

  //     // Salva os dados do usuário no Firestore
  //     await _firestore
  //         .collection('funcionarios')
  //         .doc(user.uid)
  //         .set(funcionarioModel.toMap());

  //     // Fazer logout logo após criar o usuário
  //     await _auth.signOut();

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

  // // Método para autenticação de usuário
  // Future<void> signIn({
  //   required String email,
  //   required String password,
  //   required Function onSuccess,
  //   required Function(String) onFail,
  // }) async {
  //   try {
  //     User? user = (await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     ))
  //         .user;

  //     await _loadingCurrentUser(user: user);
  //     onSuccess();
  //   } on FirebaseAuthException catch (e) {
  //     String code;
  //     if (e.code == 'invalid-email') {
  //       code = 'Email informado é inválido';
  //     } else if (e.code == 'wrong-password') {
  //       code = 'A senha informada está errada';
  //     } else if (e.code == 'user-disabled') {
  //       code = 'Usuário desativado. Por favor, contate o suporte.';
  //     } else {
  //       code = 'Algum erro aconteceu na Plataforma do Firebase';
  //     }
  //     onFail(code);
  //   }
  // }

  // Modificação no signIn para incluir verificação de acesso
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

      // Verifica se o acesso do funcionário é válido
      if (funcionarioModel?.usersAccess != null &&
          !_accessServices.isValidAccess(funcionarioModel!.usersAccess!)) {
        await _auth.signOut();
        onFail('Acesso inválido ou desativado');
        return;
      }

      // Atualiza o último acesso
      if (funcionarioModel?.usersAccess != null) {
        _accessServices.updateLastAccess(funcionarioModel!.usersAccess!);
        await saveUserDetails();
      }

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

  // Future<bool> deleteFuncionario({String? id}) async {
  //   try {
  //     if (id == null || id.isEmpty) {
  //       throw Exception("ID do Funcionário inválido");
  //     }

  //     final docRef = _collectionRef.doc(id);

  //     // Hard delete: remove o documento completamente
  //     await docRef.delete();
  //     debugPrint("Funcionário removido completamente: $id");

  //     return true; // Sucesso
  //   } on FirebaseException catch (e) {
  //     debugPrint("Erro ao excluir Funcionário: ${e.code} - ${e.message}");
  //     throw Exception("Erro ao excluir Funcionário: ${e.message}");
  //   } catch (e) {
  //     debugPrint("Erro inesperado ao excluir Funcionário: $e");
  //     throw Exception("Erro inesperado: $e");
  //   }
  // }

  // Modificação no deleteFuncionario para verificar permissões
  Future<bool> deleteFuncionario({String? id}) async {
    try {
      // Verifica se tem permissão para deletar funcionário
      if (!(await checkPermission('manage_funcionarios'))) {
        throw Exception('Sem permissão para deletar funcionários');
      }

      if (id == null || id.isEmpty) {
        throw Exception("ID do Funcionário inválido");
      }

      final docRef = _collectionRef.doc(id);
      await docRef.delete();

      return true;
    } catch (e) {
      debugPrint("Erro ao excluir Funcionário: $e");
      rethrow;
    }
  }

  // Novo método para verificar acesso a páginas
  bool hasPageAccess(String page) {
    if (funcionarioModel?.usersAccess == null) return false;
    return _accessServices.hasPageAccess(funcionarioModel!.usersAccess!, page);
  }

  // Modificação no updateUser para verificar permissões
  Future<void> updateUser(FuncionarioModel funcionario) async {
    try {
      // Verifica se tem permissão para atualizar funcionário
      if (!(await checkPermission('manage_funcionarios'))) {
        throw Exception('Sem permissão para atualizar funcionários');
      }

      await _firestoreRef.update(funcionario.toJson());
    } catch (e) {
      debugPrint("Erro ao atualizar funcionário: $e");
      rethrow;
    }
  }

  Future<bool> updateFuncionario(FuncionarioModel funcionarioModel) async {
    try {
      if (funcionarioModel.id == null || funcionarioModel.id!.isEmpty) {
        throw Exception("ID do produto inválido");
      }

      // Validação básica dos dados da categoria
      if (funcionarioModel.userName!.isEmpty) {
        throw Exception("Dados da categoria inválidos");
      }

      final docRef = _collectionRef.doc(funcionarioModel.id);

      // Atualiza o documento no Firestore
      await docRef.update(funcionarioModel.toMap());
      debugPrint("Produto atualizado com sucesso: ${funcionarioModel.id}");

      return true; // Sucesso
    } on FirebaseException catch (e) {
      debugPrint("Erro ao atualizar funcionario: ${e.code} - ${e.message}");
      throw Exception("Erro ao atualizar funcionario: ${e.message}");
    } catch (e) {
      debugPrint("Erro inesperado ao atualizar funcionario: $e");
      throw Exception("Erro inesperado: $e");
    }
  }

  // updateUser(FuncionarioModel funcionario) {
  //   _firestoreRef.update(funcionario.toJson());
  // }

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

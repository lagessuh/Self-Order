// class UsersAccessServices {
//   // Simula um banco de dados ou fonte de permissões
//   final Map<String, List<String>> _accessControl = {
//     'adminPage': ['admin'],
//     'userPage': ['admin', 'user'],
//     'guestPage': ['guest', 'user', 'admin'],
//   };

//   // Método para verificar se um usuário tem acesso a uma página específica
//   bool hasAccess(String tipoUsuario, String page) {
//     if (_accessControl.containsKey(page)) {
//       return _accessControl[page]!.contains(tipoUsuario);
//     }
//     // Se a página não estiver no mapeamento, comportamento padrão: sem acesso
//     return false;
//   }

//   // Exemplo de método para verificar acesso a múltiplas páginas
//   Map<String, bool> checkAccessForPages(
//       String tipoUsuario, List<String> pages) {
//     Map<String, bool> accessResults = {};
//     for (var page in pages) {
//       accessResults[page] = hasAccess(tipoUsuario, page);
//     }
//     return accessResults;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:self_order/models/users/cliente.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/models/users/users_access.dart';

class UsersAccessServices extends ChangeNotifier {
  // final UsersAccessServices _accessServices = UsersAccessServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ClienteModel? clienteModel;
  FuncionarioModel? funcionarioModel;
  bool _isCliente = false;
  bool _isFuncionario = false;

  ClienteModel? get getClienteModel => clienteModel;
  FuncionarioModel? get getFuncionarioModel => funcionarioModel;
  bool get isCliente => _isCliente;
  bool get isFuncionario => _isFuncionario;

  bool _loading = false;
  bool get loading => _loading;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  DocumentReference get _firestoreRefCliente =>
      _firestore.doc('users/${clienteModel!.id}');
  CollectionReference get _collectionRefCliente =>
      _firestore.collection('users');

  DocumentReference get _firestoreRefFuncionario =>
      _firestore.doc('funcionarios/${funcionarioModel!.id}');
  CollectionReference get _collectionRefFuncionario =>
      _firestore.collection('funcionarios');

  // Refined access control mapping with more specific roles and permissions
  final Map<String, List<String>> _rolePermissions = {
    'admin': [
      //'manage_users',
      'manage_funcionarios',
      //'view_reports',
      'manage_orders',
      'manage_menu',
      'view_all_order_history'
      //'manage_settings'
    ],
    'gerente': [
      //'view_reports',
      'manage_orders',
      'manage_menu',
      //'view_funcionarios',
      'view_all_order_history'
    ],
    'funcionario': ['manage_orders', 'view_menu'],
    'user': ['place_order', 'view_menu', 'view_order_history'],
    'guest': ['view_menu']
  };

  // Page access mapping
  final Map<String, List<String>> _pageAccess = {
    'adminPage': ['admin'],
    'gerentePage': ['admin', 'gerente'],
    'funcionarioPage': ['admin', 'gerente', 'funcionario'],
    'userPage': ['admin', 'gerente', 'funcionario', 'user'],
    'guestPage': ['guest', 'user', 'funcionario', 'gerente', 'admin'],
  };

  Future<bool> isFuncionario2(String userId) async {
    final funcionarioDoc = await FirebaseFirestore.instance
        .collection('funcionarios')
        .doc(userId)
        .get();
    return funcionarioDoc.exists;
  }

  Future<void> signInUsers({
    required String email,
    required String password,
    required Function onSuccess,
    required Function(String) onFail,
  }) async {
    try {
      // Corrigido: UserCredential é o tipo correto retornado pelo signInWithEmailAndPassword
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () =>
                throw TimeoutException('Tempo de resposta excedido'),
          );

      if (userCredential.user == null) {
        onFail('Erro ao autenticar usuário');
        return;
      }

      try {
        await loadingCurrentUser(user: userCredential.user);
      } catch (e) {
        await _auth.signOut();
        onFail('Erro ao carregar dados do usuário: ${e.toString()}');
        return;
      }

      // Resto do código permanece igual
      if (clienteModel == null && funcionarioModel == null) {
        await _auth.signOut();
        onFail('Usuário não cadastrado no sistema');
        return;
      }

      // bool accessInvalid = false;

      // if (clienteModel?.usersAccess != null) {
      //   accessInvalid = isValidAccess(clienteModel!.usersAccess!);
      // } else if (funcionarioModel?.usersAccess != null) {
      //   accessInvalid = isValidAccess(funcionarioModel!.usersAccess!);
      // }

      // if (accessInvalid) {
      //   await _auth.signOut();
      //   onFail('Acesso inválido ou desativado');
      //   return;
      // }
      // bool accessValid = false;

      // if (clienteModel?.usersAccess != null) {
      //   accessValid = isValidAccess(clienteModel!.usersAccess!);
      // } else if (funcionarioModel?.usersAccess != null) {
      //   accessValid = isValidAccess(funcionarioModel!.usersAccess!);
      // }

      bool accessValid = false;

      if (clienteModel != null) {
        // Clientes sempre têm acesso permitido
        accessValid = true;
      } else if (funcionarioModel != null &&
          funcionarioModel!.usersAccess != null) {
        // Funcionários passam pela validação de acesso
        accessValid = isValidAccess(funcionarioModel!.usersAccess!);
      }

      if (!accessValid) {
        await _auth.signOut();
        onFail('Acesso inválido ou desativado');
        return;
      }
      debugPrint("Status do acesso: ${accessValid ? 'válido' : 'inválido'}");
      debugPrint(
          "Tipo de usuário: ${clienteModel?.usersAccess?.tipoUsuario ?? funcionarioModel?.usersAccess?.tipoUsuario}");
      debugPrint(
          "Está ativo? ${clienteModel?.usersAccess?.isActive ?? funcionarioModel?.usersAccess?.isActive}");

      try {
        if (clienteModel?.usersAccess != null) {
          updateLastAccess(clienteModel!.usersAccess!);
          await saveClienteDetails();
        }

        if (funcionarioModel?.usersAccess != null) {
          updateLastAccess(funcionarioModel!.usersAccess!);
          await saveFuncionarioDetails();
        }
      } catch (e) {
        debugPrint('Erro ao atualizar último acesso: ${e.toString()}');
      }

      notifyListeners();
      onSuccess();
    } on TimeoutException {
      onFail('Tempo de resposta excedido. Tente novamente.');
    } on FirebaseAuthException catch (e) {
      String code = _getAuthErrorMessage(e.code);
      onFail(code);
    } catch (e) {
      onFail('Erro inesperado: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email informado é inválido';
      case 'wrong-password':
        return 'A senha informada está errada';
      case 'user-disabled':
        return 'Usuário desativado. Por favor, contate o suporte.';
      default:
        return 'Erro na Plataforma do Firebase';
    }
  }

  // Salvar os detalhes do cliente
  saveClienteDetails() async {
    await _firestoreRefCliente.set(clienteModel!.toJson());
  }

  // Salvar os detalhes do funcionário
  saveFuncionarioDetails() async {
    await _firestoreRefFuncionario.set(funcionarioModel!.toJson());
  }

  // Atualizar o último acesso
  void updateLastAccess(UsersAccess userAccess) {
    userAccess.lastAccessTime = DateTime.now();
  }

  // Validação de acesso
  bool isValidAccess(UsersAccess userAccess) {
    if (!userAccess.isActive) return false;

    if (userAccess.tipoUsuario == null) return false;
    return true;
  }

  Future<void> loadingCurrentUser({User? user}) async {
    try {
      User? currentUser = user ?? _auth.currentUser;
      debugPrint("Usuário autenticado: ${currentUser?.uid}");

      if (currentUser != null) {
        // Adicionar timeout para as operações do Firestore
        final timeout = Duration(seconds: 5);

        // Tenta carregar como Cliente
        DocumentSnapshot<Map<String, dynamic>> docUser = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .timeout(timeout);

        if (docUser.exists) {
          clienteModel = ClienteModel.fromMap(docUser.data()!);
          debugPrint(
              "Dados carregados como Cliente: ${clienteModel!.toJson()}");
          _isCliente = true;
          return;
        }

        // Se não for cliente, tenta carregar como Funcionário
        DocumentSnapshot<Map<String, dynamic>> docFuncionario = await _firestore
            .collection('funcionarios')
            .doc(currentUser.uid)
            .get()
            .timeout(timeout);

        if (docFuncionario.exists) {
          funcionarioModel = FuncionarioModel.fromMap(docFuncionario.data()!);
          debugPrint(
              "Dados carregados como Funcionário: ${funcionarioModel!.toJson()}");
          _isFuncionario = true;
          return;
        }

        debugPrint("Usuário não encontrado como Cliente ou Funcionário.");
      }

      // Criar modelo anônimo apenas se necessário
      _createAnonymousModel(currentUser);
    } catch (e) {
      debugPrint("Erro ao carregar usuário: ${e.toString()}");
      rethrow; // Propagar o erro para ser tratado no signInUsers
    } finally {
      notifyListeners();
    }
  }

  void _createAnonymousModel(User? currentUser) {
    clienteModel = ClienteModel(
      email: currentUser?.email ?? 'anonimo@anonimo.com',
      id: currentUser?.uid,
      userName: 'anônimo',
    );
  }

  void logout(BuildContext context) async {
    debugPrint("Efetuando logout");

    // Desconecta o usuário do Firebase
    await _auth.signOut();

    // Limpa as variáveis do cliente e do funcionário
    clienteModel = null;
    funcionarioModel = null;

    // Define o estado de carregamento para false
    _loading = false;

    // Notifica os listeners sobre a mudança
    notifyListeners();

    // Navega para a tela de login
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/loginpage2');
  }

  Stream<QuerySnapshot> getUsers() {
    if (_isCliente) {
      return _collectionRefCliente.snapshots();
    } else if (_isFuncionario) {
      return _collectionRefFuncionario.snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Future<void> updateUser(dynamic user) async {
    try {
      // // Verifica se o usuário tem permissão para atualizar os dados
      // if (!(await checkPermission('manage_users'))) {
      //   throw Exception('Sem permissão para atualizar usuários');
      // }

      DocumentReference? firestoreRef;

      if (user is ClienteModel) {
        firestoreRef = _firestoreRefCliente;
      } else if (user is FuncionarioModel) {
        firestoreRef = _firestoreRefFuncionario;
      } else {
        throw Exception('Tipo de usuário desconhecido');
      }

      if (firestoreRef != null) {
        await firestoreRef.update(user.toJson());
      } else {
        throw Exception('Referência do Firestore não está disponível');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar usuário: $e');
      }
      rethrow;
    }
  }

  // Verifica se é um cliente ou funcionário
  void checkUserType() {
    if (clienteModel != null) {
      _isCliente = true;
      _isFuncionario = false;
    } else if (funcionarioModel != null) {
      _isFuncionario = true;
      _isCliente = false;
    }
    notifyListeners(); // Notificar os listeners sobre a mudança no tipo de usuário
  }

  // Check if user has access to a specific page
  bool hasPageAccess(UsersAccess userAccess, String page) {
    if (!userAccess.isActive) return false;

    if (_pageAccess.containsKey(page)) {
      return _pageAccess[page]!.contains(userAccess.tipoUsuario);
    }
    return false;
  }

  // Check if user has a specific permission
  bool hasPermission(UsersAccess userAccess, String permission) {
    if (!userAccess.isActive) return false;

    final userRole = userAccess.tipoUsuario;
    if (userRole != null && _rolePermissions.containsKey(userRole)) {
      return _rolePermissions[userRole]!.contains(permission);
    }
    return false;
  }

  // Check multiple permissions at once
  Map<String, bool> checkMultiplePermissions(
      UsersAccess userAccess, List<String> permissions) {
    return {
      for (var permission in permissions)
        permission: hasPermission(userAccess, permission)
    };
  }

  // Check access for multiple pages at once
  Map<String, bool> checkMultiplePageAccess(
      UsersAccess userAccess, List<String> pages) {
    return {for (var page in pages) page: hasPageAccess(userAccess, page)};
  }

  // Validate user access
  // bool isValidAccess(UsersAccess userAccess) {
  //   if (!userAccess.isActive) return false;

  //   // Check if user type is valid
  //   if (userAccess.tipoUsuario == null) return false;
  //   if (!_rolePermissions.containsKey(userAccess.tipoUsuario)) return false;

  //   return true;
  // }
}



 // // Função que faz o login e notifica os providers
  // Future<void> signInUsers({
  //   required String email,
  //   required String password,
  //   required Null Function() onSuccess,
  //   required Null Function(dynamic error) onFail,
  // }) async {
  //   try {
  //     // Chama o serviço de login
  //     await signInUsers(
  //       email: email,
  //       password: password,
  //       onSuccess: () {
  //         // Notifica o sucesso
  //         notifyUserLoggedIn();
  //       },
  //       onFail: (error) {
  //         // Notifica falha no login
  //         if (kDebugMode) {
  //           print('Falha no login: $error');
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Erro ao fazer login: $e');
  //     }
  //   }
  // }

  // void notifyUserLoggedIn() {
  //   // Notifica os providers que o usuário foi logado
  //   if (clienteModel != null) {
  //     _isCliente = true;
  //     _isFuncionario = false;
  //   } else if (funcionarioModel != null) {
  //     _isFuncionario = true;
  //     _isCliente = false;
  //   }
  //   notifyListeners(); // Notifica os listeners (Providers)
  // }

  // // Atualiza os dados do cliente
  // void setClienteModel(ClienteModel cliente) {
  //   clienteModel = cliente;
  //   notifyListeners();
  // }

  // // Atualiza os dados do funcionário
  // void setFuncionarioModel(FuncionarioModel funcionario) {
  //   funcionarioModel = funcionario;
  //   notifyListeners();
  // }

//2 tentativa

//   Future<void> signInUsers({
//     required String email,
//     required String password,
//     required Function onSuccess,
//     required Function(String) onFail,
//   }) async {
//     try {
//       // Autentica o usuário no Firebase Auth
//       User? user;
//       try {
//         user = (await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         ))
//             .user;
//       } catch (e) {
//         if (kDebugMode) {
//           print('Erro ao autenticar usuário: $e');
//         }
//         onFail('Erro ao autenticar usuário');
//         return;
//       }

//       if (user == null) {
//         onFail('Erro ao autenticar usuário');
//         return;
//       }

//       if (kDebugMode) {
//         print('Usuário autenticado: ${user.uid}');
//       }

//       ClienteModel? clienteModel;
//       FuncionarioModel? funcionarioModel;

//       // 1️⃣ Verifica se o usuário está na coleção "clientes"
//       try {
//         var clienteSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .get()
//             .timeout(Duration(seconds: 10), onTimeout: () {
//           throw Exception('Timeout ao buscar cliente');
//         });

//         if (clienteSnapshot.exists) {
//           clienteModel = ClienteModel.fromMap(clienteSnapshot.data()!);
//           if (kDebugMode) {
//             print('Cliente encontrado: ${clienteModel.usersAccess}');
//           }
//         }
//       } catch (e) {
//         if (kDebugMode) {
//           print('Erro ao buscar cliente: $e');
//         }
//       }

//       // 2️⃣ Se não for cliente, verifica na coleção "funcionarios"
//       if (clienteModel == null) {
//         try {
//           var funcionarioSnapshot = await FirebaseFirestore.instance
//               .collection('funcionarios')
//               .doc(user.uid)
//               .get()
//               .timeout(Duration(seconds: 10), onTimeout: () {
//             throw Exception('Timeout ao buscar funcionário');
//           });

//           if (funcionarioSnapshot.exists) {
//             funcionarioModel =
//                 FuncionarioModel.fromMap(funcionarioSnapshot.data()!);
//             if (kDebugMode) {
//               print('Funcionário encontrado: ${funcionarioModel.usersAccess}');
//             }
//           }
//         } catch (e) {
//           if (kDebugMode) {
//             print('Erro ao buscar funcionário: $e');
//           }
//         }
//       }

//       // 3️⃣ Se não encontrou em nenhuma coleção, impede login
//       if (clienteModel == null && funcionarioModel == null) {
//         await _auth.signOut();
//         onFail('Usuário não cadastrado no sistema');
//         return;
//       }

//       // 4️⃣ Verifica se o acesso do usuário é válido (cliente ou funcionário)
//       if (clienteModel != null &&
//           clienteModel.usersAccess != null &&
//           isValidAccess(clienteModel.usersAccess!)) {
//         await _auth.signOut();
//         onFail('Acesso inválido ou desativado');
//         return;
//       }

//       if (funcionarioModel != null &&
//           funcionarioModel.usersAccess != null &&
//           isValidAccess(funcionarioModel.usersAccess!)) {
//         await _auth.signOut();
//         onFail('Acesso inválido ou desativado');
//         return;
//       }

//       // 5️⃣ Atualiza o último acesso no Firestore
//       if (clienteModel != null) {
//         updateLastAccess(clienteModel.usersAccess!);
//         await saveClienteDetails();
//       }

//       if (funcionarioModel != null) {
//         updateLastAccess(funcionarioModel.usersAccess!);
//         await saveFuncionarioDetails();
//       }

//       // 6️⃣ Se tudo estiver ok, finaliza com sucesso
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
//         code = 'Erro na Plataforma do Firebase';
//       }
//       onFail(code);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Erro inesperado: $e');
//       }
//       onFail('Erro inesperado ao processar o login');
//     }
//   }

//   saveClienteDetails() async {
//     await _firestoreRefCliente.set(clienteModel!.toJson());
//   }

//   saveFuncionarioDetails() async {
//     await _firestoreRefFuncionario.set(funcionarioModel!.toJson());
//   }

// // Atualiza o último acesso do usuário
//   void updateLastAccess(UsersAccess userAccess) {
//     userAccess.lastAccessTime = DateTime.now();
//   }

//1 tentativa

  // Future<void> signInUsers({
  //   required String email,
  //   required String password,
  //   required Function onSuccess,
  //   required Function(String) onFail,
  // }) async {
  //   try {
  //     // Autentica o usuário no Firebase Auth
  //     User? user = (await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     ))
  //         .user;

  //     if (user == null) {
  //       onFail('Erro ao autenticar usuário');
  //       return;
  //     }

  //     // 1️⃣ Verifica se o usuário está na coleção "clientes"
  //     var clienteSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     if (clienteSnapshot.exists) {
  //       clienteModel = ClienteModel.fromMap(clienteSnapshot.data()!);
  //     }

  //     // 2️⃣ Se não for cliente, verifica na coleção "funcionarios"
  //     var funcionarioSnapshot = await FirebaseFirestore.instance
  //         .collection('funcionarios')
  //         .doc(user.uid)
  //         .get();

  //     if (funcionarioSnapshot.exists) {
  //       funcionarioModel =
  //           FuncionarioModel.fromMap(funcionarioSnapshot.data()!);
  //     }

  //     // 3️⃣ Se não encontrou em nenhuma coleção, impede login
  //     if (clienteModel == null && funcionarioModel == null) {
  //       await _auth.signOut();
  //       onFail('Usuário não cadastrado no sistema');
  //       return;
  //     }

  //     // 4️⃣ Verifica se o acesso do usuário é válido (cliente ou funcionário)
  //     if (clienteModel != null &&
  //         clienteModel!.usersAccess != null &&
  //         isValidAccess(clienteModel!.usersAccess!)) {
  //       await _auth.signOut();
  //       onFail('Acesso inválido ou desativado');
  //       return;
  //     }

  //     if (funcionarioModel != null &&
  //         funcionarioModel!.usersAccess != null &&
  //         isValidAccess(funcionarioModel!.usersAccess!)) {
  //       await _auth.signOut();
  //       onFail('Acesso inválido ou desativado');
  //       return;
  //     }

  //     // 5️⃣ Atualiza o último acesso no Firestore
  //     if (clienteModel != null) {
  //       updateLastAccess(clienteModel!.usersAccess!);
  //       await saveClienteDetails();
  //     }

  //     if (funcionarioModel != null) {
  //       updateLastAccess(funcionarioModel!.usersAccess!);
  //       await saveFuncionarioDetails();
  //     }

  //     // 6️⃣ Se tudo estiver ok, finaliza com sucesso
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
  //       code = 'Erro na Plataforma do Firebase';
  //     }
  //     onFail(code);
  //   }
  // }

  // saveClienteDetails() async {
  //   await _firestoreRefCliente.set(clienteModel!.toJson());
  // }

  // saveFuncionarioDetails() async {
  //   await _firestoreRefFuncionario.set(funcionarioModel!.toJson());
  // }

  // // Update last access time
  // void updateLastAccess(UsersAccess userAccess) {
  //   userAccess.lastAccessTime = DateTime.now();
  // }

  // Método de login
  // Future<void> signInUsers({
  //   required String email,
  //   required String password,
  //   required Function onSuccess,
  //   required Function(String) onFail,
  // }) async {
  //   try {
  //     // Autentica o usuário no Firebase Auth
  //     User? user = (await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     ))
  //         .user;

  //     await loadingCurrentUser(user: user);

  //     if (user == null) {
  //       onFail('Erro ao autenticar usuário');
  //       return;
  //     }

  //     // Verifica se o usuário está na coleção "clientes"
  //     var clienteSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     if (clienteSnapshot.exists) {
  //       clienteModel = ClienteModel.fromMap(clienteSnapshot.data()!);
  //       _isCliente = true;
  //     }

  //     // Se não for cliente, verifica na coleção "funcionarios"
  //     var funcionarioSnapshot = await FirebaseFirestore.instance
  //         .collection('funcionarios')
  //         .doc(user.uid)
  //         .get();

  //     if (funcionarioSnapshot.exists) {
  //       funcionarioModel =
  //           FuncionarioModel.fromMap(funcionarioSnapshot.data()!);
  //       _isFuncionario = true;
  //     }

  //     // Se não encontrou em nenhuma coleção, impede login
  //     if (clienteModel == null && funcionarioModel == null) {
  //       await _auth.signOut();
  //       onFail('Usuário não cadastrado no sistema');
  //       return;
  //     }

  //     // Verifica se o acesso do usuário é válido (cliente ou funcionário)
  //     if (clienteModel != null &&
  //         clienteModel!.usersAccess != null &&
  //         isValidAccess(clienteModel!.usersAccess!)) {
  //       await _auth.signOut();
  //       onFail('Acesso inválido ou desativado');
  //       return;
  //     }

  //     if (funcionarioModel != null &&
  //         funcionarioModel!.usersAccess != null &&
  //         isValidAccess(funcionarioModel!.usersAccess!)) {
  //       await _auth.signOut();
  //       onFail('Acesso inválido ou desativado');
  //       return;
  //     }

  //     // Atualiza o último acesso no Firestore
  //     if (clienteModel != null) {
  //       updateLastAccess(clienteModel!.usersAccess!);
  //       await saveClienteDetails();
  //     }

  //     if (funcionarioModel != null) {
  //       updateLastAccess(funcionarioModel!.usersAccess!);
  //       await saveFuncionarioDetails();
  //     }

  //     // Notificar os listeners sobre o login bem-sucedido
  //     notifyListeners();
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
  //       code = 'Erro na Plataforma do Firebase';
  //     }
  //     onFail(code);
  //   }
  // }

//09-02-18:44
  // Future<void> signInUsers({
  //   required String email,
  //   required String password,
  //   required Function onSuccess,
  //   required Function(String) onFail,
  // }) async {
  //   try {
  //     // Autentica o usuário no Firebase Auth
  //     User? user = (await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     ))
  //         .user;

  //     await loadingCurrentUser(user: user);

  //     if (user == null) {
  //       onFail('Erro ao autenticar usuário');
  //       return;
  //     }

  //     // Se não encontrou nem como cliente nem como funcionário
  //     if (clienteModel == null && funcionarioModel == null) {
  //       await _auth.signOut();
  //       onFail('Usuário não cadastrado no sistema');
  //       return;
  //     }

  //     // Verifica se o acesso do usuário é válido
  //     if ((clienteModel != null &&
  //             clienteModel!.usersAccess != null &&
  //             isValidAccess(clienteModel!.usersAccess!)) ||
  //         (funcionarioModel != null &&
  //             funcionarioModel!.usersAccess != null &&
  //             isValidAccess(funcionarioModel!.usersAccess!))) {
  //       await _auth.signOut();
  //       onFail('Acesso inválido ou desativado');
  //       return;
  //     }

  //     // Atualiza o último acesso no Firestore
  //     if (clienteModel != null) {
  //       updateLastAccess(clienteModel!.usersAccess!);
  //       await saveClienteDetails();
  //     }

  //     if (funcionarioModel != null) {
  //       updateLastAccess(funcionarioModel!.usersAccess!);
  //       await saveFuncionarioDetails();
  //     }

  //     // Notificar os listeners sobre o login bem-sucedido
  //     notifyListeners();
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
  //       code = 'Erro na Plataforma do Firebase';
  //     }
  //     onFail(code);
  //   }
  // }

  // // Salvar os detalhes do cliente
  // saveClienteDetails() async {
  //   await _firestoreRefCliente.set(clienteModel!.toJson());
  // }

  // // Salvar os detalhes do funcionário
  // saveFuncionarioDetails() async {
  //   await _firestoreRefFuncionario.set(funcionarioModel!.toJson());
  // }

  // // Atualizar o último acesso
  // void updateLastAccess(UsersAccess userAccess) {
  //   userAccess.lastAccessTime = DateTime.now();
  // }

  // // Validação de acesso
  // bool isValidAccess(UsersAccess userAccess) {
  //   if (!userAccess.isActive) return false;

  //   if (userAccess.tipoUsuario == null) return false;
  //   return true;
  // }

  // Future<void> loadingCurrentUser({User? user}) async {
  //   User? currentUser = user ?? _auth.currentUser;
  //   debugPrint("Usuário autenticado: ${currentUser?.uid}");

  //   if (currentUser != null) {
  //     // Tenta carregar como Cliente
  //     DocumentSnapshot<Map<String, dynamic>> docUser =
  //         await _firestore.collection('users').doc(currentUser.uid).get();

  //     if (docUser.exists) {
  //       clienteModel = ClienteModel.fromMap(docUser.data()!);
  //       debugPrint("Dados carregados como Cliente: ${clienteModel!.toJson()}");
  //       _isCliente = true;
  //     } else {
  //       // Se não for cliente, tenta carregar como Funcionário
  //       DocumentSnapshot<Map<String, dynamic>> docFuncionario = await _firestore
  //           .collection('funcionarios')
  //           .doc(currentUser.uid)
  //           .get();

  //       if (docFuncionario.exists) {
  //         funcionarioModel = FuncionarioModel.fromMap(docFuncionario.data()!);
  //         debugPrint(
  //             "Dados carregados como Funcionário: ${funcionarioModel!.toJson()}");
  //         _isFuncionario = true;
  //       } else {
  //         debugPrint("Usuário não encontrado como Cliente ou Funcionário.");
  //         clienteModel = ClienteModel(
  //           email: currentUser.email ?? 'anonimo@anonimo.com',
  //           id: currentUser.uid,
  //           userName: 'anônimo',
  //         );
  //       }
  //     }
  //   } else {
  //     debugPrint("Nenhum usuário autenticado.");
  //     clienteModel = ClienteModel(
  //       email: 'anonimo@anonimo.com',
  //       id: null,
  //       userName: 'anônimo',
  //     );
  //   }

  //   notifyListeners();
  // }

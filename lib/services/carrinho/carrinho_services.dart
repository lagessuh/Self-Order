import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/models/carrinho/carrinho.dart';
import 'package:self_order/models/carrinho/item_carrinho.dart';
import 'package:self_order/models/users/cliente.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/services/users/cliente_services.dart';
import 'package:self_order/services/users/funcionario_services.dart';
import 'package:self_order/services/users/users_access_services.dart';
import 'package:self_order/utils/utilities.dart';

class CarrinhoServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ClienteModel? clienteModel;
  FuncionarioModel? funcionarioModel;
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => _itens;

  double get totalPrice => _itens.fold(
      0, (total, item) => total + item.produto!.preco! * item.quantidade!);
  void addItemToCart(Produto produto, int quantidade) {
    debugPrint("Adicionando item ao carrinho de compras");
    // verifica se o produto já existe no carrinho, incrementa a quantidade se houver
    // Caso contrário, adiciona um novo item no carrinho
    _itens.add(ItemCarrinho(produto: produto, quantidade: quantidade));
    notifyListeners();
  }

  void removeItem(ItemCarrinho itemCarrinho) {
    // Remove item do carrinho
    debugPrint('conteúdo do carrinho ${_itens.toString()}');
    _itens.removeWhere((item) => item == itemCarrinho);
    notifyListeners();
  }

  void updateQuantity(Produto produto, int novaQuantidade) {
    int index = _itens.indexWhere((item) => item.produto == produto);
    if (index != -1) {
      _itens[index] =
          ItemCarrinho(produto: produto, quantidade: novaQuantidade);
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> loadAllCart() {
    // obtêm dados do carrinho da base de dados para o usuário atual
    // Atualiza o objeto _items de acordo com os requisitos
    return _firestore.collection('carts').snapshots();
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Stream<QuerySnapshot> loadClientePedidos() {
    final currentUser = getCurrentUser();
    return _firestore
        .collection('carrinhos')
        .where('clienteModel.id', isEqualTo: currentUser?.uid)
        // .orderBy('data', descending: true)
        .snapshots();
  }

  // Método específico para funcionários gerenciarem pedidos
  Stream<QuerySnapshot> loadAllPedidosGerenciamento() {
    if (funcionarioModel?.id == null) {
      throw Exception('Funcionário não está logado');
    }

    // Todos os funcionários podem ver todos os pedidos para gerenciamento
    return _firestore
        .collection('carrinhos')
        .orderBy('data', descending: true)
        .snapshots();
  }

  // Método para atualizar status do pedido (usado por funcionários)
  Future<void> atualizarStatusPedido(String pedidoId, String novoStatus) async {
    try {
      if (funcionarioModel?.id == null) {
        throw Exception(
            'Apenas funcionários podem atualizar o status do pedido');
      }

      await _firestore.collection('carrinhos').doc(pedidoId).update({
        'status': novoStatus,
        'ultimaAtualizacao': DateTime.now().toIso8601String(),
        'atualizadoPor': {
          'funcionarioId': funcionarioModel!.id,
          'funcionarioNome': funcionarioModel!.userName,
        }
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao atualizar status do pedido: $e');
      rethrow;
    }
  }

  Future<bool> cartCheckout(ClienteModel user) async {
    try {
      clienteModel = user;
      Carrinho carrinho = Carrinho(
        itens: itens,
        clienteModel: user,
        data: Utilities.getDateTime(),
        status: 'Pendente',
      );

      // Cria um Map a partir do carrinho
      Map<String, dynamic> carrinhoMap = carrinho.toMap();

      // Adiciona clienteId separadamente para evitar o problema do Firestore
      carrinhoMap['clienteId'] = user.id;

      DocumentReference docRef =
          await _firestore.collection('carrinhos').add(carrinhoMap);

      if (docRef.id.isNotEmpty) {
        // Verifica se o documento foi criado com sucesso
        _itens.clear();
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao confirmar pedido: $e');
      }
      return false;
    }
  }

  void atualizarCliente(ClienteModel cliente) {
    clienteModel = cliente;
    notifyListeners();
  }

  void setUser(dynamic userServices) {
    debugPrint('setUser chamado com tipo: ${userServices.runtimeType}');

    if (userServices is UsersAccessServices) {
      // Se for UsersAccessServices, verifica qual modelo está preenchido
      if (userServices.clienteModel != null) {
        clienteModel = userServices.clienteModel;
        funcionarioModel = null;
        debugPrint(
            'CarrinhoServices - clienteModel atualizado via UsersAccessServices: ${clienteModel?.id}');
      } else if (userServices.funcionarioModel != null) {
        funcionarioModel = userServices.funcionarioModel;
        clienteModel = null;
        debugPrint(
            'CarrinhoServices - funcionarioModel atualizado via UsersAccessServices: ${funcionarioModel?.id}');
      }
    } else if (userServices is ClienteServices) {
      clienteModel = userServices.clienteModel;
      funcionarioModel = null;
      debugPrint(
          'CarrinhoServices - clienteModel atualizado via ClienteServices: ${clienteModel?.id}');
    } else if (userServices is FuncionarioServices) {
      funcionarioModel = userServices.funcionarioModel;
      clienteModel = null;
      debugPrint(
          'CarrinhoServices - funcionarioModel atualizado via FuncionarioServices: ${funcionarioModel?.id}');
    } else {
      debugPrint(
          'CarrinhoServices - Tipo de serviço inválido: ${userServices.runtimeType}');
      return;
    }

    // Verificação adicional após a atualização
    if (clienteModel == null && funcionarioModel == null) {
      debugPrint(
          'CarrinhoServices - Aviso: Nenhum modelo de usuário foi definido após setUser');
    }

    notifyListeners();
  }

  // Método helper para debug
  void printUserStatus() {
    debugPrint('Status atual do CarrinhoServices:');
    debugPrint('clienteModel: ${clienteModel?.id ?? "null"}');
    debugPrint('funcionarioModel: ${funcionarioModel?.id ?? "null"}');
  }

  @override
  notifyListeners();

  void setUserCliente(ClienteServices clienteServices) {
    clienteModel = clienteServices.clienteModel;
    debugPrint(
        'CarrinhoServices - clienteModel atualizado: ${clienteModel?.id}'); // Para debug
    notifyListeners();
  }

  // void setUserFuncionario(FuncionarioServices funcionarioServices) {
  //   funcionarioModel = funcionarioServices.funcionarioModel;
  //   debugPrint(
  //       'CarrinhoServices - funcionarioModel atualizado: ${funcionarioModel?.id}'); // Para debug
  //   notifyListeners();
  // }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:self_order/models/cardapio/produto.dart';
// import 'package:self_order/models/carrinho/carrinho.dart';
// import 'package:self_order/models/carrinho/item_carrinho.dart';
// //import 'package:self_order/models/enum/status_pedido.dart';
// import 'package:self_order/models/users/cliente.dart';
// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/services/users/cliente_services.dart';
// //import 'package:self_order/services/users/cliente_services2.dart';
// import 'package:self_order/services/users/funcionario_services.dart';
// import 'package:self_order/utils/utilities.dart';

// class CarrinhoServices extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   ClienteModel? clienteModel;
//   FuncionarioModel? funcionarioModel;
//   final List<ItemCarrinho> _itens = [];

//   List<ItemCarrinho> get itens => _itens;

//   double get totalPrice => _itens.fold(
//       0, (total, item) => total + item.produto!.preco! * item.quantidade!);
//   //-- FOLD é o mesmo que:
//   //comando uma lista de items
//   //for (var i = 0; i < _items.lenght; i++) {
//   //  total = total + (items[i].product!.price * item[i].product!.quantity);
//   //}
//   //========================================================================
//   //-- ou na iteração sobre uma coleção
//   //for (var item in _items) {
//   //  total = total + (item.product!.price! * item.quantity!)
//   //}

//   void addItemToCart(Produto produto, int quantidade) {
//     debugPrint("Adicionando item ao carrinho de compras");
//     // verifica se o produto já existe no carrinho, incrementa a quantidade se houver
//     // Caso contrário, adiciona um novo item no carrinho
//     _itens.add(ItemCarrinho(produto: produto, quantidade: quantidade));
//     notifyListeners();
//   }

//   void removeItem(ItemCarrinho itemCarrinho) {
//     // Remove item do carrinho
//     debugPrint('conteúdo do carrinho ${_itens.toString()}');
//     _itens.removeWhere((item) => item == itemCarrinho);
//     notifyListeners();
//   }

//   void updateQuantity(Produto produto, int novaQuantidade) {
//     int index = _itens.indexWhere((item) => item.produto == produto);
//     if (index != -1) {
//       _itens[index] =
//           ItemCarrinho(produto: produto, quantidade: novaQuantidade);
//       notifyListeners();
//     }
//   }

//   // void updateQuantity(Produto produto, int novaQuantidade) {
//   //   // atualiza a quantidade do produto no carrinho
//   //   // _items[_items.indexWhere((element)=> element.product == product.id)]=CartItem(product: product, quantity: newQuantity);
//   //   for (var item in _itens) {
//   //     if (item.produto == produto) {
//   //       item.quantidade = novaQuantidade;
//   //     }
//   //   }

//   //   notifyListeners();
//   // }

// //antigo
//   // Future<void> atualizarStatusPedido(String pedidoId, String novoStatus) async {
//   //   try {
//   //     await _firestore.collection('carrinhos').doc(pedidoId).update({
//   //       'status': novoStatus,
//   //     });
//   //   } catch (e) {
//   //     debugPrint('Erro ao atualizar status do pedido: $e');
//   //     rethrow;
//   //   }
//   // }

//   // Stream<QuerySnapshot> loadAllCarrinho() {
//   //   if (userModel?.isAdmin ?? false) {
//   //     // Admins see all orders
//   //     return _firestore
//   //         .collection('carrinhos')
//   //         .orderBy('data', descending: true)
//   //         .snapshots();
//   //   } else {
//   //     // Regular users only see their own orders
//   //     return _firestore
//   //         .collection('carrinhos')
//   //         .where('userModel.id', isEqualTo: userModel?.id)
//   //         .orderBy('data', descending: true)
//   //         .snapshots();
//   //   }
//   // }

//   // Stream<QuerySnapshot> loadClientePedidos() {
//   //   if (clienteModel?.id == null) {
//   //     throw Exception('Cliente não está logado');
//   //   }

//   //   return _firestore
//   //       .collection('carrinhos')
//   //       .where('clienteModel.id', isEqualTo: clienteModel!.id)
//   //       .orderBy('data', descending: true)
//   //       .snapshots();
//   // }

//   // Stream<QuerySnapshot> loadClientePedidos() {
//   //   if (clienteModel?.id == null) {
//   //     throw Exception('Cliente não está logado');
//   //   }

//   //   return _firestore
//   //       .collection('carrinhos')
//   //       .where('clienteModel.id', isEqualTo: clienteModel!.id)
//   //       .orderBy('data', descending: true)
//   //       .snapshots();
//   // }

//   Stream<QuerySnapshot> loadAllCart() {
//     // obtêm dados do carrinho da base de dados para o usuário atual
//     // Atualiza o objeto _items de acordo com os requisitos
//     return _firestore.collection('carts').snapshots();
//   }

// //  void verifyUser() {
//   // final currentUser = getCurrentUser();
// //     if (currentUser == null) {
// //       debugPrint('Nenhum usuário autenticado');
// //     } else {
// //       debugPrint('Usuário autenticado: ${currentUser.uid}');
// //     }
// //   }

//   User? getCurrentUser() {
//     return FirebaseAuth.instance.currentUser;
//   }

//   Stream<QuerySnapshot> loadClientePedidos() {
//     final currentUser = getCurrentUser();
//     return _firestore
//         .collection('carrinhos')
//         .where('clienteModel.id', isEqualTo: currentUser?.uid)
//         // .orderBy('data', descending: true)
//         .snapshots();
//   }

//   // Stream<QuerySnapshot> loadClientePedidos() {
//   // if (clienteModel?.id == null) {
//   //   throw Exception('Cliente não está logado');
//   // }

//   // return _firestore
//   //     .collection('carrinhos')
//   //     .where('clienteId',
//   //         isEqualTo: clienteModel!.id) // Filtrando pelo campo separado
//   //     .orderBy('data', descending: true)
//   //     .snapshots();
//   // }

//   // Stream<List<Carrinho>> loadClientePedidos(String clienteId) {
//   //   return FirebaseFirestore.instance
//   //       .collection('pedidos')
//   //       .where('clienteId', isEqualTo: clienteId)
//   //       .snapshots() // 🔥 Usa snapshots() para retornar um Stream
//   //       .map((snapshot) => snapshot.docs.map((doc) {
//   //             return Carrinho.fromMap(
//   //                 doc.data()); // ✅ Converte os docs para Carrinho
//   //           }).toList());
//   // }

//   // Método específico para funcionários gerenciarem pedidos
//   Stream<QuerySnapshot> loadAllPedidosGerenciamento() {
//     if (funcionarioModel?.id == null) {
//       throw Exception('Funcionário não está logado');
//     }

//     // Todos os funcionários podem ver todos os pedidos para gerenciamento
//     return _firestore
//         .collection('carrinhos')
//         .orderBy('data', descending: true)
//         .snapshots();
//   }

//   // Método para atualizar status do pedido (usado por funcionários)
//   Future<void> atualizarStatusPedido(String pedidoId, String novoStatus) async {
//     try {
//       if (funcionarioModel?.id == null) {
//         throw Exception(
//             'Apenas funcionários podem atualizar o status do pedido');
//       }

//       await _firestore.collection('carrinhos').doc(pedidoId).update({
//         'status': novoStatus,
//         'ultimaAtualizacao': DateTime.now().toIso8601String(),
//         'atualizadoPor': {
//           'funcionarioId': funcionarioModel!.id,
//           'funcionarioNome': funcionarioModel!.userName,
//         }
//       });

//       notifyListeners();
//     } catch (e) {
//       debugPrint('Erro ao atualizar status do pedido: $e');
//       rethrow;
//     }
//   }

//   // Future<void> cartCheckout(ClienteModel user) async {
//   //   clienteModel = user;
//   //   Carrinho? carrinho = Carrinho(
//   //     itens: itens,
//   //     clienteModel: user,
//   //     data: Utilities.getDateTime(),
//   //     status: StatusPedido.pendente.name, // Set initial status
//   //   );
//   //   await _firestore.collection('carrinhos').add(carrinho.toMap());
//   //   _itens.clear(); // Clear cart after checkout
//   //   notifyListeners();
//   // }

//   // Future<void> cartCheckout(ClienteModel user) async {
//   //   clienteModel = user;
//   //   Carrinho carrinho = Carrinho(
//   //     itens: itens,
//   //     clienteModel: user,
//   //     data: Utilities.getDateTime(),
//   //     status: 'Pendente', // Agora passando diretamente a string "Pendente"
//   //   );
//   //   await _firestore.collection('carrinhos').add(carrinho.toMap());
//   //   _itens.clear(); // Limpa o carrinho após o checkout
//   //   notifyListeners();
//   // }

//   // Future<bool> cartCheckout(ClienteModel user) async {
//   //   try {
//   //     clienteModel = user;
//   //     Carrinho carrinho = Carrinho(
//   //       itens: itens,
//   //       clienteModel: user,
//   //       data: Utilities.getDateTime(),
//   //       status: 'Pendente',
//   //     );
//   //     await _firestore.collection('carrinhos').add(carrinho.toMap());
//   //     _itens.clear();
//   //     notifyListeners();
//   //     return true; // Retorna true indicando sucesso
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print('Erro ao confirmar pedido: $e');
//   //     }
//   //     return false; // Retorna false em caso de erro
//   //   }
//   // }

//   // Future<bool> cartCheckout(ClienteModel user) async {
//   //   try {
//   //     clienteModel = user;
//   //     Carrinho carrinho = Carrinho(
//   //       itens: itens,
//   //       clienteModel: user, // Garante que clienteId está salvo separadamente
//   //       data: Utilities.getDateTime(),
//   //       status: 'Pendente',
//   //     );

//   //     DocumentReference docRef =
//   //         await _firestore.collection('carrinhos').add(carrinho.toMap());

//   //     if (docRef.id.isNotEmpty) {
//   //       // Verifica se o documento foi criado
//   //       _itens.clear();
//   //       notifyListeners();
//   //       return true;
//   //     }

//   //     return false; // Retorna false caso o ID do documento seja inválido
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print('Erro ao confirmar pedido: $e');
//   //     }
//   //     return false;
//   //   }
//   // }

//   Future<bool> cartCheckout(ClienteModel user) async {
//     try {
//       clienteModel = user;
//       Carrinho carrinho = Carrinho(
//         itens: itens,
//         clienteModel: user,
//         data: Utilities.getDateTime(),
//         status: 'Pendente',
//       );

//       // Cria um Map a partir do carrinho
//       Map<String, dynamic> carrinhoMap = carrinho.toMap();

//       // Adiciona clienteId separadamente para evitar o problema do Firestore
//       carrinhoMap['clienteId'] = user.id;

//       DocumentReference docRef =
//           await _firestore.collection('carrinhos').add(carrinhoMap);

//       if (docRef.id.isNotEmpty) {
//         // Verifica se o documento foi criado com sucesso
//         _itens.clear();
//         notifyListeners();
//         return true;
//       }

//       return false;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Erro ao confirmar pedido: $e');
//       }
//       return false;
//     }
//   }

//   void atualizarCliente(ClienteModel cliente) {
//     clienteModel = cliente;
//     notifyListeners();
//   }

//   void setUser(dynamic usersAccessServices) {
//     if (usersAccessServices is ClienteServices) {
//       clienteModel = usersAccessServices.clienteModel;
//       funcionarioModel = null; // Garante que não há conflito
//       debugPrint(
//           'CarrinhoServices - clienteModel atualizado: ${clienteModel?.id}');
//     } else if (usersAccessServices is FuncionarioServices) {
//       funcionarioModel = usersAccessServices.funcionarioModel;
//       clienteModel = null; // Garante que não há conflito
//       debugPrint(
//           'CarrinhoServices - funcionarioModel atualizado: ${funcionarioModel?.id}');
//     } else {
//       debugPrint('CarrinhoServices - Tipo de usuário inválido');
//       return;
//     }

//     notifyListeners();
//   }

//   // void setUser2(dynamic users) {
//   //   if (users is ClienteModel) {
//   //     clienteModel = clienteModel;
//   //     funcionarioModel = null; // Garante que não há conflito
//   //     debugPrint(
//   //         'CarrinhoServices - clienteModel atualizado: ${clienteModel?.id}');
//   //   } else if (users is FuncionarioServices) {
//   //     funcionarioModel = users.funcionarioModel;
//   //     clienteModel = null; // Garante que não há conflito
//   //     debugPrint(
//   //         'CarrinhoServices - funcionarioModel atualizado: ${funcionarioModel?.id}');
//   //   } else {
//   //     debugPrint('CarrinhoServices - Tipo de usuário inválido');
//   //     return;
//   //   }

//   //   notifyListeners();
//   // }

//   void setUserCliente(ClienteServices clienteServices) {
//     clienteModel = clienteServices.clienteModel;
//     debugPrint(
//         'CarrinhoServices - clienteModel atualizado: ${clienteModel?.id}'); // Para debug
//     notifyListeners();
//   }

//   // void setUserFuncionario(FuncionarioServices funcionarioServices) {
//   //   funcionarioModel = funcionarioServices.funcionarioModel;
//   //   debugPrint(
//   //       'CarrinhoServices - funcionarioModel atualizado: ${funcionarioModel?.id}'); // Para debug
//   //   notifyListeners();
//   // }

//   // setUser(ClienteServices userServices) {
//   //   clienteModel = userServices.clienteModel;
//   //   notifyListeners();
//   // }
// }

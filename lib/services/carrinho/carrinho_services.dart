import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/models/carrinho/carrinho.dart';
import 'package:self_order/models/carrinho/item_carrinho.dart';
import 'package:self_order/models/enum/status_pedido.dart';
import 'package:self_order/models/users/users.dart';
import 'package:self_order/services/users/users_services.dart';
import 'package:self_order/utils/utilities.dart';

class CarrinhoServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? userModel;
  final List<ItemCarrinho> _itens = [];

  List<ItemCarrinho> get itens => _itens;

  double get totalPrice => _itens.fold(
      0, (total, item) => total + item.produto!.preco! * item.quantidade!);
  //-- FOLD é o mesmo que:
  //comando uma lista de items
  //for (var i = 0; i < _items.lenght; i++) {
  //  total = total + (items[i].product!.price * item[i].product!.quantity);
  //}
  //========================================================================
  //-- ou na iteração sobre uma coleção
  //for (var item in _items) {
  //  total = total + (item.product!.price! * item.quantity!)
  //}

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
    // atualiza a quantidade do produto no carrinho
    // _items[_items.indexWhere((element)=> element.product == product.id)]=CartItem(product: product, quantity: newQuantity);
    for (var item in _itens) {
      if (item.produto == produto) {
        item.quantidade = novaQuantidade;
      }
    }

    notifyListeners();
  }

  // //carregar carrinho da base de dados

  // Stream<QuerySnapshot> loadAllCarrinho() {
  //   // obtêm dados do carrinho da base de dados para o usuário atual
  //   // Atualiza o objeto _items de acordo com os requisitos
  //   return _firestore.collection('carrinhos').snapshots();
  // }

  // //salvar o carrinho na base de dados
  // Future<void> salvarCarrinho(UserModel user) async {
  //   // Salva os dados do carrinho na base de dados para o usuário atual
  //   Carrinho? carrinho = Carrinho(
  //     itens: itens,
  //     userModel: user,
  //     data: Utilities.getDateTime(),
  //   );
  //   _firestore.collection('carrinhos').add(carrinho.toMap());
  // }

  Future<void> atualizarStatusPedido(String pedidoId, String novoStatus) async {
    try {
      await _firestore.collection('carrinhos').doc(pedidoId).update({
        'status': novoStatus,
      });
    } catch (e) {
      debugPrint('Erro ao atualizar status do pedido: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> loadAllCarrinho() {
    if (userModel?.isAdmin ?? false) {
      // Admins see all orders
      return _firestore
          .collection('carrinhos')
          .orderBy('data', descending: true)
          .snapshots();
    } else {
      // Regular users only see their own orders
      return _firestore
          .collection('carrinhos')
          .where('userModel.id', isEqualTo: userModel?.id)
          .orderBy('data', descending: true)
          .snapshots();
    }
  }

  Future<void> cartCheckout(UserModel user) async {
    userModel = user;
    Carrinho? carrinho = Carrinho(
      itens: itens,
      userModel: user,
      data: Utilities.getDateTime(),
      status: StatusPedido.pendente.name, // Set initial status
    );
    await _firestore.collection('carrinhos').add(carrinho.toMap());
    _itens.clear(); // Clear cart after checkout
    notifyListeners();
  }

  // //salvar o carrinho na base de dados
  // Future<void> cartCheckout(UserModel user) async {
  //   userModel = user;
  //   // Salva os dados do carrinho na base de dados para o usuário atual
  //   Carrinho? carrinho = Carrinho(
  //     itens: itens,
  //     userModel: user,
  //     data: Utilities.getDateTime(),
  //   );
  //   _firestore.collection('carrinhos').add(carrinho.toMap());
  // }

  setUser(UsersServices userServices) {
    userModel = userServices.userModel;
    notifyListeners();
  }
}

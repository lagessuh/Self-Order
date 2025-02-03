// import 'package:flutter/material.dart';
// //import 'package:flutter_ecom/pages/authentication/login_card.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/models/users/users.dart';
// import 'package:self_order/pages/autenticacao/login_page2.dart';
// import 'package:self_order/pages/carrinho/carrinho_vazio_card.dart';
// import 'package:self_order/services/carrinho/carrinho_services.dart';
// import 'package:self_order/services/users/users_services.dart';

// class CheckoutPage extends StatelessWidget {
//   const CheckoutPage({super.key, this.user});
//   final UserModel? user;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<UsersServices, CarrinhoServices>(
//         builder: (context, usersServices, carrinhoServices, child) {
//       // if (cartServices.userModel == null) {
//       if (user == null) {
//         return const LoginPage2();
//       }
//       if (carrinhoServices.itens == []) {
//         return const CarrinhoVazioCard(
//           iconData: Icons.remove_shopping_cart,
//           title: 'Nenhum produto no carrinho!!!',
//         );
//       }
//       return Material(
//         child: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: Container(
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 border: Border.all(width: 1),
//                 borderRadius: BorderRadius.circular(10)),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(children: [
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Center(
//                   child: OutlinedButton(
//                     onPressed: () {},
//                     child: const Text('Confirmar Pedido'),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 const Divider(),
//                 Text(
//                   'Itens: ${carrinhoServices.totalPrice}',
//                   style: const TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//                 const Text(
//                   'Frete e manuseio: R\$ 21,45',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 ),
//                 const Text(
//                   'Total do Pedido: R\$ 100,45',
//                   style: TextStyle(fontSize: 18, color: Colors.black),
//                 )
//               ]),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/models/users/users.dart';
import 'package:self_order/pages/autenticacao/login_page2.dart';
import 'package:self_order/pages/carrinho/carrinho_vazio_card.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';
import 'package:self_order/services/users/users_services.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, this.user});
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UsersServices, CarrinhoServices>(
        builder: (context, usersServices, carrinhoServices, child) {
      if (user == null) {
        return const LoginPage2();
      }
      if (carrinhoServices.itens.isEmpty) {
        return const CarrinhoVazioCard(
          iconData: Icons.remove_shopping_cart,
          title: 'Nenhum produto no carrinho!!!',
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
          backgroundColor: Colors.blue, // Cor de fundo do AppBar
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Confirmar Pedido'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  Text(
                    'Itens: ${carrinhoServices.totalPrice}',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const Text(
                    'Frete e manuseio: R\$ 21,45',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const Text(
                    'Total do Pedido: R\$ 100,45',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

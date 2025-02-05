// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// //import 'package:flutter_ecom/pages/cart/services/cart_services2.dart';
// import 'package:self_order/services/carrinho/carrinho_services.dart';

// class ListaPedidosPage extends StatelessWidget {
//   const ListaPedidosPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     CarrinhoServices carrinhoServices = CarrinhoServices();
//     return Scaffold(
//       body: StreamBuilder(
//           stream:
//               carrinhoServices.loadAllCarrinho(), //use .snapshot() to get data
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               // final current = snapshot.data as Map<String, dynamic>;
//               // final items = current["items"] as List;
//               // List quantities = items.map((e) => e["quantity"]).toList();
//               // List product = items.map((e) => e["product"]).toList();

//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot ds = snapshot.data!.docs[index];
//                   // debugPrint('tamanho : ${snapshot.data!.docs.length}');
//                   // debugPrint('doc: ${ds['items'][index]['product']['description']}');
//                   final items = ds['items'] as List;
//                   // debugPrint('tamanho dos items ${items.length}');
//                   // final notes = ds['notesArray'] as List;
//                   return Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10, right: 10, top: 10, bottom: 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text('Id do Carrinho: ${ds.id}'),
//                         Text('Data do Pedido: ${ds['data']}'),
//                         ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: items.length,
//                             physics: const ScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 10.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Image.network(
//                                       width: 55,
//                                       height: 55,
//                                       items[index]['produto']['image'],
//                                     ),
//                                     const SizedBox(
//                                       width: 25,
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(items[index]['produto']['marca']),
//                                         Text(items[index]['produto']['nome']),
//                                         // Text(items[index]['product']['unity']),
//                                         SizedBox(
//                                           width: 400,
//                                           child: Text(
//                                             items[index]['produto']
//                                                 ['descricao'],
//                                             maxLines: 1,
//                                             softWrap: false,
//                                             overflow: TextOverflow.ellipsis,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                         const Divider(
//                           color: Color.fromARGB(255, 1, 26, 2),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const CircularProgressIndicator();
//             }
//           }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/models/carrinho/carrinho.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';

class ListaPedidosPage extends StatelessWidget {
  const ListaPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: Consumer<CarrinhoServices>(
        builder: (_, carrinhoServices, __) {
          return StreamBuilder(
            stream: carrinhoServices.loadAllCarrinho(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar pedidos'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final pedidos = snapshot.data?.docs ?? [];

              return ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index].data() as Map<String, dynamic>;
                  final carrinho = Carrinho.fromMap(pedido);

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text('Pedido ${index + 1}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Data: ${carrinho.data}'),
                          Text('Status: ${carrinho.status ?? "Pendente"}'),
                          Text(
                              'Total de itens: ${carrinho.itens?.length ?? 0}'),
                        ],
                      ),
                      trailing: Icon(
                        _getStatusIcon(carrinho.status),
                        color: _getStatusColor(carrinho.status),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'preparo':
        return Icons.restaurant;
      case 'pronto':
        return Icons.check_circle;
      case 'entregue':
        return Icons.delivery_dining;
      case 'cancelado':
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'preparo':
        return Colors.orange;
      case 'pronto':
        return Colors.green;
      case 'entregue':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

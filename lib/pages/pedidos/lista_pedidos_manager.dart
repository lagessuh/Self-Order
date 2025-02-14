// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/services/carrinho/carrinho_services.dart';

// class ListaPedidosManagerPage extends StatelessWidget {
//   const ListaPedidosManagerPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gerenciar Pedidos'),
//       ),
//       body: Consumer<CarrinhoServices>(
//         builder: (_, carrinhoServices, __) {
//           return StreamBuilder(
//             stream: carrinhoServices.loadAllPedidosGerenciamento(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return const Center(
//                   child: Text('Erro ao carregar pedidos'),
//                 );
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               final carrinhos = snapshot.data?.docs ?? [];

//               return ListView.builder(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   DocumentSnapshot ds = snapshot.data!.docs[index];
//                   final carrinhoDoc = carrinhos[index];
//                   final items = ds['itens'] as List;

//                   return Card(
//                     margin: const EdgeInsets.all(8),
//                     child: ExpansionTile(
//                       title: Text('Pedido ${index + 1}'),
//                       subtitle: Text('Status: ${ds['status']}'),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Cliente: ${ds['clienteModel.userName']}'),
//                               Text('Data: ${ds['data']}'),
//                               ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: items.length,
//                                   physics: const ScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding:
//                                           const EdgeInsets.only(bottom: 10.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Image.network(
//                                             width: 55,
//                                             height: 55,
//                                             items[index]['produto']['image'],
//                                           ),
//                                           const SizedBox(
//                                             width: 25,
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(items[index]['produto']
//                                                   ['marca']),
//                                               Text(items[index]['produto']
//                                                   ['nome']),
//                                               SizedBox(
//                                                 width: 300,
//                                                 child: Text(
//                                                   items[index]['produto']
//                                                       ['descricao'],
//                                                   maxLines: 1,
//                                                   softWrap: false,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                               // const Divider(),
//                               // const Text('Alterar Status:'),
//                               // Wrap(
//                               //   spacing: 8,
//                               //   children: [
//                               //     'Pendente',
//                               //     'Em Preparo',
//                               //     'Pronto',
//                               //     'Entregue',
//                               //     'Cancelado'
//                               //   ].map((novoStatus) {
//                               //     return ElevatedButton(
//                               //       onPressed: () {
//                               //         carrinhoServices.atualizarStatusPedido(
//                               //           carrinhoDoc.id,
//                               //           novoStatus,
//                               //         );
//                               //       },
//                               //       style: ElevatedButton.styleFrom(
//                               //         backgroundColor:
//                               //             _getStatusColor(novoStatus),
//                               //       ),
//                               //       child: Text(novoStatus),
//                               //     );
//                               //   }).toList(),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // Color _getStatusColor(String status) {
//   //   switch (status.toLowerCase()) {
//   //     case 'preparo':
//   //       return Colors.orange;
//   //     case 'pronto':
//   //       return Colors.green;
//   //     case 'entregue':
//   //       return Colors.blue;
//   //     case 'cancelado':
//   //       return Colors.red;
//   //     default:
//   //       return Colors.grey;
//   //   }
//   // }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';

class ListaPedidosManagerPage extends StatefulWidget {
  const ListaPedidosManagerPage({super.key});

  @override
  State<ListaPedidosManagerPage> createState() =>
      _ListaPedidosManagerPageState();
}

class _ListaPedidosManagerPageState extends State<ListaPedidosManagerPage> {
  String? _statusSelecionado; // Status selecionado pelo usuário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listagem de Pedidos'),
      ),
      body: Column(
        children: [
          // Dropdown para selecionar o status do pedido
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _statusSelecionado,
              hint: const Text('Filtrar por status'),
              isExpanded: true,
              items: [
                'Todos',
                'Pendente',
                'Em Preparo',
                'Pronto',
                'Entregue',
                'Cancelado'
              ].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (novoStatus) {
                setState(() {
                  _statusSelecionado = novoStatus;
                });
              },
            ),
          ),

          Expanded(
            child: Consumer<CarrinhoServices>(
              builder: (_, carrinhoServices, __) {
                return StreamBuilder(
                  stream: carrinhoServices.loadAllPedidosEditGerenciamento(
                      status: _statusSelecionado),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erro: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final carrinhos = snapshot.data?.docs ?? [];

                    if (carrinhos.isEmpty) {
                      return const Center(
                        child: Text('Nenhum pedido encontrado.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: carrinhos.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = carrinhos[index];
                        final items = ds['itens'] as List;

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ExpansionTile(
                            title: Text('Pedido ${index + 1}'),
                            subtitle: Text('Status: ${ds['status']}'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Cliente: ${ds['clienteModel.userName']}'),
                                    Text('Data: ${ds['data']}'),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: items.length,
                                        physics: const ScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  width: 55,
                                                  height: 55,
                                                  items[index]['produto']
                                                      ['image'],
                                                ),
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(items[index]['produto']
                                                        ['marca']),
                                                    Text(items[index]['produto']
                                                        ['nome']),
                                                    SizedBox(
                                                      width: 300,
                                                      child: Text(
                                                        items[index]['produto']
                                                            ['descricao'],
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    // const Divider(),
                                    // const Text('Alterar Status:'),
                                    // Wrap(
                                    //   spacing: 8,
                                    //   children: [
                                    //     'Pendente',
                                    //     'Em Preparo',
                                    //     'Pronto',
                                    //     'Entregue',
                                    //     'Cancelado'
                                    //   ].map((novoStatus) {
                                    //     return ElevatedButton(
                                    //       onPressed: () {
                                    //         carrinhoServices
                                    //             .atualizarStatusPedido(
                                    //           ds.id,
                                    //           novoStatus,
                                    //         );
                                    //       },
                                    //       style: ElevatedButton.styleFrom(
                                    //         backgroundColor:
                                    //             _getStatusColor(novoStatus),
                                    //       ),
                                    //       child: Text(novoStatus),
                                    //     );
                                    //   }).toList(),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Color _getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case 'em preparo':
  //       return Colors.orange;
  //     case 'pronto':
  //       return Colors.green;
  //     case 'entregue':
  //       return Colors.blue;
  //     case 'cancelado':
  //       return Colors.red;
  //     default:
  //       return Colors.grey;
  //   }
  // }
}

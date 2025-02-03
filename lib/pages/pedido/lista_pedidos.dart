import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_ecom/pages/cart/services/cart_services2.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';

class ListaPedidosPage extends StatelessWidget {
  const ListaPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    CarrinhoServices carrinhoServices = CarrinhoServices();
    return Scaffold(
      body: StreamBuilder(
          stream:
              carrinhoServices.loadAllCarrinho(), //use .snapshot() to get data
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // final current = snapshot.data as Map<String, dynamic>;
              // final items = current["items"] as List;
              // List quantities = items.map((e) => e["quantity"]).toList();
              // List product = items.map((e) => e["product"]).toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  // debugPrint('tamanho : ${snapshot.data!.docs.length}');
                  // debugPrint('doc: ${ds['items'][index]['product']['description']}');
                  final items = ds['items'] as List;
                  // debugPrint('tamanho dos items ${items.length}');
                  // final notes = ds['notesArray'] as List;
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Id do Carrinho: ${ds.id}'),
                        Text('Data do Pedido: ${ds['data']}'),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      width: 55,
                                      height: 55,
                                      items[index]['produto']['image'],
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(items[index]['produto']['marca']),
                                        Text(items[index]['produto']['nome']),
                                        // Text(items[index]['product']['unity']),
                                        SizedBox(
                                          width: 400,
                                          child: Text(
                                            items[index]['produto']
                                                ['descricao'],
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                        const Divider(
                          color: Color.fromARGB(255, 1, 26, 2),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/pages/cardapio/produto/produto_add_page.dart';
import 'package:self_order/pages/cardapio/produto/produto_edit_page.dart';
import 'package:self_order/services/cardapio/produto_services.dart';

class ProdutoListPage extends StatelessWidget {
  const ProdutoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProdutoServices produtoServices = ProdutoServices();
    //final Produto produto = Produto();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listagem de Produtos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Buscar",
                  hintText: "Filtra por nome do produto",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  )),
              onChanged: (name) {},
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: produtoServices.getAllProdutos(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docSnapshot =
                              snapshot.data!.docs[index];
                          return Card(
                            child: Row(children: [
                              Image.network(
                                height: 50,
                                docSnapshot['image'],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    docSnapshot['nome'],
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'R\$ ${docSnapshot['preco'].toString()}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          produtoServices.deleteProduto();
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     produto.id = docSnapshot.id;
                                      //     produto.nome = docSnapshot['nome'];
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ProdutoEditPage(
                                      //                 // produto: categoria,
                                      //                 ),
                                      //       ),
                                      //     );
                                      //   },
                                      //   child: const Icon(
                                      //     Icons.edit,
                                      //     color: Colors.orange,
                                      //     size: 20,
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Produto produto = Produto(
                                            id: docSnapshot.id,
                                            nome: docSnapshot['nome'],
                                            descricao: docSnapshot['descricao'],
                                            marca: docSnapshot['marca'],
                                            preco: (docSnapshot['preco']
                                                    as num?)
                                                ?.toDouble(), // Garante que `preco` seja double
                                            quantidade:
                                                docSnapshot['quantidade']
                                                    as int?,
                                            unidade: docSnapshot['unidade'],
                                            // deleted:
                                            //     docSnapshot['deleted'] as bool?,
                                            image: docSnapshot['image'],
                                            //url: docSnapshot['url'],
                                            idCategoria:
                                                docSnapshot['idCategoria'],
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProdutoEditPage(
                                                      produto: produto),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.orange,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                              )
                            ]),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 101, 85, 143),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProdutoAddPage(),
            ),
          );
        },
        child: const Text(
          '+',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:self_order/commons/responsive.dart';
// import 'package:self_order/models/cardapio/produto.dart';
// import 'package:self_order/pages/cardapio/produto/produto_add_page.dart';
// import 'package:self_order/pages/cardapio/produto/produto_edit_page.dart';
// import 'package:self_order/services/cardapio/produto_services.dart';

// class ProdutoListPage extends StatefulWidget {
//   const ProdutoListPage({super.key});

//   @override
//   State<ProdutoListPage> createState() => _ProdutoListPageState();
// }

// class _ProdutoListPageState extends State<ProdutoListPage> {
//   final Produto produto = Produto();

//   @override
//   Widget build(BuildContext context) {
//     ProdutoServices produtoServices = ProdutoServices();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Gerencimento de Produtos',
//           style: TextStyle(
//               fontSize: 20, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         // decoration: BoxDecoration(
//         //     borderRadius: BorderRadius.circular(20),
//         //     color: const Color.fromARGB(172, 214, 198, 255),
//         //     border: const Border()),

//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 decoration: const InputDecoration(
//                     labelText: "Buscar",
//                     hintText: "Filtra por nome do produto",
//                     prefixIcon: Icon(Icons.search),
//                     prefixIconColor: Colors.blue,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(8.0),
//                       ),
//                     )),
//                 onChanged: (name) {},
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               StreamBuilder(
//                   stream: produtoServices.getAllProdutos(),
//                   builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (snapshot.hasData) {
//                       return Expanded(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: ((context, index) {
//                             DocumentSnapshot docSnapshot =
//                                 snapshot.data!.docs[index];
//                             return Card(
//                               child: Row(
//                                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Image.network(
//                                     height: 50,
//                                     docSnapshot['image'],
//                                   ),
//                                   const SizedBox(
//                                     width: 20,
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         docSnapshot['nome'],
//                                         style: const TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         'R\$ ${docSnapshot['preco'].toString()}',
//                                         style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       //],

//                                       //SizedBox(
//                                       //   height: 85,
//                                       //   child: Row(
//                                       //     children: [
//                                       //       Column(
//                                       //         mainAxisAlignment:
//                                       //             MainAxisAlignment.center,
//                                       //         crossAxisAlignment:
//                                       //             CrossAxisAlignment.start,
//                                       //         children: [
//                                       //           const Text('Local de Aquisição:'),
//                                       //           Text(
//                                       //             '${ds['nome']}',
//                                       //             style: TextStyle(
//                                       //               color: const Color.fromARGB(
//                                       //                   255, 7, 48, 8),
//                                       //               fontSize: Responsive
//                                       //                       .isExtraLarge(context)
//                                       //                   ? 21.0
//                                       //                   : Responsive.isDesktop(
//                                       //                           context)
//                                       //                       ? 19
//                                       //                       : Responsive.isLaptop(
//                                       //                               context)
//                                       //                           ? 17
//                                       //                           : Responsive
//                                       //                                   .isTablet(
//                                       //                                       context)
//                                       //                               ? 15
//                                       //                               : 12,
//                                       //               fontWeight: FontWeight.bold,
//                                       //             ),
//                                       //           ),
//                                       //         ],
//                                       //       ),
//                                       //     ],
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       Column(
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               produtoServices.delete();
//                                             },
//                                             child: const Icon(
//                                               Icons.delete,
//                                               color: Colors.red,
//                                               size: 30,
//                                             ),
//                                           ),
//                                           InkWell(
//                                             onTap: () {
//                                               produto.id = docSnapshot.id;
//                                               produto.nome =
//                                                   docSnapshot['nome'];
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       ProdutoEditPage(
//                                                           // produto: categoria,
//                                                           ),
//                                                 ),
//                                               );
//                                             },
//                                             child: const Icon(
//                                               Icons.edit,
//                                               color: Colors.orange,
//                                               size: 30,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       );
//                     } else {
//                       return const CircularProgressIndicator();
//                     }
//                   })),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color.fromARGB(255, 101, 85, 143),
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const ProdutoAddPage(),
//             ),
//           );
//         },
//         child: const Text(
//           '+',
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

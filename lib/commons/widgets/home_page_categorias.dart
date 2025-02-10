// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
// import 'package:self_order/services/cardapio/produto_services.dart';

// class HomePageCategorias extends StatefulWidget {
//   const HomePageCategorias({
//     super.key,
//   });

//   @override
//   State<HomePageCategorias> createState() => _HomePageCategoriasState();
// }

// class _HomePageCategoriasState extends State<HomePageCategorias> {
//   CategoriaServices categoriaServices = CategoriaServices();
//   ProdutoServices produtoServices = ProdutoServices();
//   List<QueryDocumentSnapshot>? produtos;

//   int? tam;
//   String? categoriaSelecionada; // Definição da variável

//   Future<int> getCategoriasLength() async {
//     return await categoriaServices.getAllCategorias2().then((value) {
//       return value.length;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //inside initState method
//     getCategoriasLength().then((value) {
//       setState(() {
//         tam = value;
//       });
//     });
//   }

//   // Future<void> carregarProdutosPorCategoria(String categoria) async {
//   //   try {
//   //     QuerySnapshot querySnapshot =
//   //         await produtoServices.getProdutosPorCategoria(categoria);
//   //     setState(() {
//   //       produtos =
//   //           querySnapshot.docs; // Atualiza a lista de produtos com os filtrados
//   //     });
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print("Erro ao carregar produtos: $e");
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (tam == null) {
//       return Center(
//         child: Text('Dados das Categorias não encontrados',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyMedium!
//                 .apply(color: Colors.white)),
//       );
//     }
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20),
//       child: Container(
//           height: 90,
//           width: MediaQuery.of(context).size.width,
//           margin: const EdgeInsets.only(top: 10, bottom: 10),
//           alignment: Alignment.center,
//           child: StreamBuilder(
//             stream: categoriaServices.getAllCategorias(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasData) {
//                 return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot docSnapshot = snapshot.data!.docs[index];
//                       return InkWell(
//                         onTap: () {
//                           // setState(() {
//                           //   categoriaSelecionada = docSnapshot['titulo'];
//                           // });
//                           // carregarProdutosPorCategoria(categoriaSelecionada!);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 child: Text(
//                                   docSnapshot['titulo'],
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   softWrap: false,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 12.0),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     });
//               } else {
//                 return Container();
//               }
//             },
//           )

//           //  child: FutureBuilder(
//           // //     future: categoryServices.getCategoriesList(),
//           // //     builder: (context, AsyncSnapshot<List<CategoryModel>> snapshot) {
//           // //       switch (snapshot.connectionState) {
//           // //         case ConnectionState.none:
//           // //           return Container();
//           // //         case ConnectionState.waiting:
//           // //           return const CircularProgressIndicator();
//           // //         case ConnectionState.active:
//           // //           return Container();
//           // //         case ConnectionState.done:
//           // //           if (snapshot.hasData) {
//           // //             final List<CategoryModel> category = snapshot.data ?? [];
//           // //             if (category.isNotEmpty) {
//           // //               return ListView.builder(
//           // //                   itemCount: snapshot.data!.length, //categoryServices.getCategoriesList().,
//           // //                   shrinkWrap: true,
//           // //                   scrollDirection: Axis.horizontal,
//           // //                   itemBuilder: (_, index) {
//           // //                     return MyVerticalImageText(
//           // //                       image: category[index].imageUrl!,
//           // //                       title: category[index].title!,
//           // //                       onTap: () {
//           // //                         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//           // //                           return const SubCategoriesPage();
//           // //                         }));
//           // //                       },
//           // //                     );
//           // //                   });
//           // //             } else {
//           // //               return Container();
//           // //             }
//           // //           } else {
//           // //             return Container();
//           // //           }
//           // //         default:
//           // //           return Container();
//           // //       }
//           // //     }),
//           ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';

class HomePageCategorias extends StatefulWidget {
  final Function(String?) onCategorySelected;
  final String? selectedCategoryId;

  const HomePageCategorias({
    super.key,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  State<HomePageCategorias> createState() => _HomePageCategoriasState();
}

class _HomePageCategoriasState extends State<HomePageCategorias> {
  CategoriaServices categoriaServices = CategoriaServices();
  int? tam;

  Future<int> getCategoriasLength() async {
    return await categoriaServices.getAllCategorias2().then((value) {
      return value.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategoriasLength().then((value) {
      setState(() {
        tam = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tam == null) {
      return Center(
        child: Text('Dados das Categorias não encontrados',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .apply(color: Colors.white)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: categoriaServices.getAllCategorias(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    snapshot.data!.docs.length + 1, // +1 for "Todos" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "Todos" option
                    return InkWell(
                      onTap: () {
                        widget.onCategorySelected(null);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: widget.selectedCategoryId == null
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Todos",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  DocumentSnapshot docSnapshot = snapshot.data!.docs[index - 1];
                  String categoryId =
                      docSnapshot.id; // Pegando o ID do documento

                  return InkWell(
                    onTap: () {
                      widget.onCategorySelected(categoryId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: widget.selectedCategoryId == categoryId
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            child: Text(
                              docSnapshot['titulo'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mercadinho/lib/commons/responsive.dart';
// import 'package:mercadinho/lib/models/category/category_service.dart';
// import 'package:mercadinho/lib/models/marketing/marketing_services.dart';
// import 'package:mercadinho/lib/models/product/product.dart';
// import 'package:mercadinho/lib/models/product/product_services.dart';
// import 'package:mercadinho/lib/pages/product/product_detail_page2.dart';
// import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
// import 'package:self_order/services/cardapio/produto_services.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   CategoriaServices categoryService = CategoriaServices();
//   String? selectedCategory;

//   List<String> imageUrls = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchImagesFromFirebase();
//   }

//   Future<void> fetchImagesFromFirebase() async {
//     try {
//       // Referência à pasta 'carrossel'
//       final storageRef = FirebaseStorage.instance.ref().child('carousel');

//       // Obtem a lista de todos os arquivos dentro da pasta
//       final ListResult result = await storageRef.listAll();

//       // Converte cada arquivo em uma URL de download
//       final urls = await Future.wait(
//         result.items.map((ref) => ref.getDownloadURL()),
//       );

//       setState(() {
//         imageUrls = urls;
//         isLoading = false;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print("Erro ao carregar imagens do Firebase Storage: $e");
//       }
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ProdutoServices produtoServices = ProdutoServices();
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 30.0, bottom: 30),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         '------- ',
//                         style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: const Color.fromARGB(255, 2, 33, 3)),
//                       ),
//                       Image.asset(
//                         'assets/images/google.png',
//                         height: 35,
//                       ),
//                       Text(
//                         ' -------',
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: const Color.fromARGB(255, 2, 33, 3),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     'FullStack Burguer',
//                     style: GoogleFonts.roboto(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w600,
//                       color: const Color.fromARGB(255, 2, 33, 3),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 40.0,
//                 right: 40,
//                 bottom: 25,
//               ),
//               child: TextFormField(
//                 decoration: const InputDecoration(
//                     suffixIcon: Icon(Icons.search),
//                     label: Text("Procure por um produto"),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(width: 1.3),
//                     ),
//                     focusedBorder:
//                         OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
//               ),
//             ),
//             // ConstrainedBox(
//             //   constraints: BoxConstraints(
//             //     maxWidth: MediaQuery.sizeOf(context).width - 60,
//             //     maxHeight: 200,
//             //   ),
//             //   child: CarouselView(
//             //     itemExtent: 400,
//             //     itemSnapping: true,
//             //     // shrinkExtent: 150,
//             //     padding: const EdgeInsets.all(5),
//             //     children: imageUrls.map((url) {
//             //       return Image.network(
//             //         url,
//             //         fit: BoxFit.cover,
//             //       );
//             //     }).toList(),
//             //   ),
//             // ),
//             CarouselSlider(
//               items: imageUrls.map((url) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Image.network(
//                       url,
//                       fit: BoxFit.cover,
//                       width: MediaQuery.of(context).size.width,
//                     );
//                   },
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 height: 400.0, // Altura do carrossel
//                 autoPlay: true, // Ativa o autoplay
//                 autoPlayInterval: const Duration(seconds: 3), // Intervalo
//                 enlargeCenterPage: true, // Destaca o item central
//                 aspectRatio: 16 / 9, // Ajusta o aspecto das imagens
//                 viewportFraction: 0.8, // Largura dos itens no carrossel
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(top: 20.0),
//               child: Center(
//                   child: Column(
//                 children: [
//                   Text(
//                     'PRODUTOS POPULARES',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 2, 33, 3),
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Roboto',
//                     ),
//                   ),
//                   SizedBox(
//                     width: 100,
//                     child: Divider(
//                       color: Color.fromARGB(255, 1, 24, 2),
//                     ),
//                   )
//                 ],
//               )),
//             ),
//             StreamBuilder(
//               stream: categoryService.getCategorias(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   // Converte os dados do snapshot em uma lista de DropdownMenuItem
//                   List<DropdownMenuItem<String>> categoryItems =
//                       snapshot.data!.docs.map<DropdownMenuItem<String>>((doc) {
//                     return DropdownMenuItem<String>(
//                       value: doc.id,
//                       child: Text(doc['title']),
//                     );
//                   }).toList();
//                   return DropdownButton<String>(
//                     value: selectedCategory,
//                     hint: const Text('Selecione uma categoria'),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedCategory = newValue;
//                       });
//                     },
//                     items: categoryItems,
//                   );
//                 }
//               },
//             ),

//             StreamBuilder(
//               stream: selectedCategory == null
//                   ? productServices
//                       .getAllProducts() // Quando nenhuma categoria é selecionada, retorna todos os produtos.
//                   : productServices.getAllProductsByCategory(
//                       selectedCategory!), // Quando uma categoria é selecionada, retorna os produtos dessa categoria.
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return const Center(
//                       child: Text('Erro ao carregar os produtos.'));
//                 }

//                 if (snapshot.hasData) {
//                   List<DocumentSnapshot> docSnap = snapshot.data!.docs;

//                   if (docSnap.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'Nenhum produto encontrado.',
//                         style: TextStyle(fontSize: 16.0, color: Colors.grey),
//                       ),
//                     );
//                   }

//                   return Padding(
//                     padding: const EdgeInsets.only(
//                       bottom: 30.0,
//                       top: 30,
//                       left: 20,
//                       right: 20,
//                     ),
//                     child: GridView.builder(
//                       shrinkWrap: true,
//                       itemCount: docSnap.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisSpacing: 10,
//                         crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
//                         childAspectRatio: .5,
//                         mainAxisExtent: Responsive.isDesktop(context)
//                             ? MediaQuery.of(context).size.height * .5
//                             : MediaQuery.of(context).size.height * .3,
//                       ),
//                       itemBuilder: (context, index) {
//                         return InkWell(
//                           onTap: () {
//                             Product product = Product();
//                             product.id = docSnap[index].id;
//                             product.name = docSnap[index].get('name');
//                             product.brand = docSnap[index].get('brand');
//                             product.description =
//                                 docSnap[index].get('description');
//                             product.price = double.parse(
//                                 docSnap[index].get('price').toString());
//                             product.image = docSnap[index].get('image');

//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) =>
//                                     ProductDetailPage2(product: product)));
//                           },
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 10.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Image.network(
//                                   docSnap[index].get('image'),
//                                   height: Responsive.isDesktop(context)
//                                       ? MediaQuery.of(context).size.height * .3
//                                       : MediaQuery.of(context).size.height * .2,
//                                   width: Responsive.isDesktop(context)
//                                       ? MediaQuery.of(context).size.height * .3
//                                       : MediaQuery.of(context).size.height * .2,
//                                   scale: 1,
//                                 ),
//                                 SizedBox(
//                                   width: 120.0,
//                                   child: Text(
//                                     docSnap[index].get('name'),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     softWrap: false,
//                                     style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12.0),
//                                   ),
//                                 ),
//                                 Text(
//                                   'R\$ ${docSnap[index].get('price').toString()}',
//                                   style: const TextStyle(
//                                       color: Color.fromARGB(255, 2, 33, 3),
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 } else {
//                   return const Center(
//                     child: Text(
//                       'Nenhum dado disponível.',
//                       style: TextStyle(fontSize: 16.0, color: Colors.grey),
//                     ),
//                   );
//                 }
//               },
//             ),

//             // StreamBuilder(
//             //   stream: productServices.getAllProducts(),
//             //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             //     if (snapshot.hasData) {
//             //       List<DocumentSnapshot> docSnap = snapshot.data!.docs;
//             //       return Padding(
//             //         padding: const EdgeInsets.only(
//             //           bottom: 30.0,
//             //           top: 30,
//             //           left: 20,
//             //           right: 20,
//             //         ),
//             //         child: GridView.builder(
//             //             shrinkWrap: true,
//             //             itemCount: snapshot.data!.docs.length,
//             //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //               crossAxisSpacing: 10,
//             //               crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
//             //               childAspectRatio: .5,
//             //               mainAxisExtent: Responsive.isDesktop(context)
//             //                   ? MediaQuery.of(context).size.height * .5
//             //                   : MediaQuery.of(context).size.height * .3,
//             //             ),
//             //             itemBuilder: (context, index) {
//             //               return InkWell(
//             //                 onTap: () {
//             //                   Product product = Product();
//             //                   product.id = snapshot.data!.docs[index].id;
//             //                   product.name =
//             //                       snapshot.data!.docs[index].get('name');
//             //                   product.brand =
//             //                       snapshot.data!.docs[index].get('brand');
//             //                   product.description =
//             //                       snapshot.data!.docs[index].get('description');
//             //                   product.price = double.parse(snapshot
//             //                       .data!.docs[index]
//             //                       .get('price')
//             //                       .toString());
//             //                   product.image =
//             //                       snapshot.data!.docs[index].get('image');

//             //                   Navigator.of(context).push(MaterialPageRoute(
//             //                       builder: (context) =>
//             //                           ProductDetailPage2(product: product)));
//             //                 },
//             //                 child: Padding(
//             //                   padding:
//             //                       const EdgeInsets.symmetric(horizontal: 10.0),
//             //                   child: Column(
//             //                     crossAxisAlignment: CrossAxisAlignment.start,
//             //                     children: [
//             //                       Image.network(
//             //                         docSnap[index].get('image'),
//             //                         height: Responsive.isDesktop(context)
//             //                             ? MediaQuery.of(context).size.height *
//             //                                 .3
//             //                             : MediaQuery.of(context).size.height *
//             //                                 .2,
//             //                         width: Responsive.isDesktop(context)
//             //                             ? MediaQuery.of(context).size.height *
//             //                                 .3
//             //                             : MediaQuery.of(context).size.height *
//             //                                 .2,
//             //                         scale: 1,
//             //                       ),
//             //                       SizedBox(
//             //                         width: 120.0,
//             //                         child: Text(
//             //                           docSnap[index].get('name'),
//             //                           maxLines: 2,
//             //                           overflow: TextOverflow.ellipsis,
//             //                           softWrap: false,
//             //                           style: const TextStyle(
//             //                               color: Colors.black,
//             //                               fontWeight: FontWeight.bold,
//             //                               fontSize: 12.0),
//             //                         ),
//             //                       ),
//             //                       Text(
//             //                         'R\$ ${docSnap[index].get('price').toString()}',
//             //                         style: const TextStyle(
//             //                             color: Color.fromARGB(255, 2, 33, 3),
//             //                             fontWeight: FontWeight.bold),
//             //                       ),
//             //                     ],
//             //                   ),
//             //                 ),
//             //               );
//             //             }),
//             //       );
//             //     } else {
//             //       return Container();
//             //     }
//             //   },
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/commons/widgets/home_page_categorias.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/pages/cardapio/produto/produto_detail_page.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
import 'package:self_order/services/cardapio/produto_services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'hamburgueria.jpg',
    ];

    ProdutoServices produtoServices = ProdutoServices();
    CategoriaServices categoriaServices = CategoriaServices();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text(
                      //   '------- ',
                      //   style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 2, 33, 3)),
                      // ),
                      // Image.asset(
                      //   'assets/images/candy-shop.jpg',
                      //   height: 35,
                      // ),
                      // Text(
                      //   ' -------',
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.bold,
                      //     color: const Color.fromARGB(255, 2, 33, 3),
                      //   ),
                      // ),
                    ],
                  ),
                  Text(
                    'FullStack Burger',
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 2, 33, 3),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40,
                bottom: 25,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    label: Text("Procure por um produto"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.3),
                    ),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width - 60,
                maxHeight: 200,
              ),
              child: CarouselView(
                itemExtent: 400,
                itemSnapping: true,
                // shrinkExtent: 150,
                padding: const EdgeInsets.all(5),
                children: List.generate(
                  images.length,
                  (index) => Image.asset(
                    "assets/banners/${images[index]}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //-- Categories --//
            HomePageCategorias(),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(
                  child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: Divider(
                      color: Color.fromARGB(255, 1, 24, 2),
                    ),
                  )
                ],
              )),
            ),
            StreamBuilder(
              stream: produtoServices.getAllProdutos(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> docSnap = snapshot.data!.docs;
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30.0,
                      top: 30,
                      left: 20,
                      right: 20,
                    ),
                    child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          crossAxisCount: Responsive.isDesktop(context) ? 4 : 3,
                          childAspectRatio: .5,
                          mainAxisExtent: Responsive.isDesktop(context)
                              ? MediaQuery.of(context).size.height * .5
                              : MediaQuery.of(context).size.height * .3,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Produto produto = Produto();
                              produto.id = snapshot.data!.docs[index].id;
                              produto.nome =
                                  snapshot.data!.docs[index].get('nome');
                              produto.marca =
                                  snapshot.data!.docs[index].get('marca');
                              produto.descricao =
                                  snapshot.data!.docs[index].get('descricao');
                              produto.preco = double.parse(snapshot
                                  .data!.docs[index]
                                  .get('preco')
                                  .toString());
                              produto.image =
                                  snapshot.data!.docs[index].get('image');

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProdutoDetailPage(produto: produto)));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    docSnap[index].get('image'),
                                    height: Responsive.isDesktop(context)
                                        ? MediaQuery.of(context).size.height *
                                            .3
                                        : MediaQuery.of(context).size.height *
                                            .2,
                                    width: Responsive.isDesktop(context)
                                        ? MediaQuery.of(context).size.height *
                                            .3
                                        : MediaQuery.of(context).size.height *
                                            .2,
                                    scale: 1,
                                  ),
                                  SizedBox(
                                    width: 120.0,
                                    child: Text(
                                      docSnap[index].get('nome'),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${docSnap[index].get('preco').toString()}',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 2, 33, 3),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

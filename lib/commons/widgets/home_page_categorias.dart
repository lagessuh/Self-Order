import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';

class HomePageCategorias extends StatefulWidget {
  const HomePageCategorias({
    super.key,
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
    // TODO: implement initState
    super.initState();
    //inside initState method
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
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot docSnapshot = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Text(
                                  docSnapshot['titulo'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Container();
              }
            },
          )

          // child: FutureBuilder(
          //     future: categoryServices.getCategoriesList(),
          //     builder: (context, AsyncSnapshot<List<CategoryModel>> snapshot) {
          //       switch (snapshot.connectionState) {
          //         case ConnectionState.none:
          //           return Container();
          //         case ConnectionState.waiting:
          //           return const CircularProgressIndicator();
          //         case ConnectionState.active:
          //           return Container();
          //         case ConnectionState.done:
          //           if (snapshot.hasData) {
          //             final List<CategoryModel> category = snapshot.data ?? [];
          //             if (category.isNotEmpty) {
          //               return ListView.builder(
          //                   itemCount: snapshot.data!.length, //categoryServices.getCategoriesList().,
          //                   shrinkWrap: true,
          //                   scrollDirection: Axis.horizontal,
          //                   itemBuilder: (_, index) {
          //                     return MyVerticalImageText(
          //                       image: category[index].imageUrl!,
          //                       title: category[index].title!,
          //                       onTap: () {
          //                         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          //                           return const SubCategoriesPage();
          //                         }));
          //                       },
          //                     );
          //                   });
          //             } else {
          //               return Container();
          //             }
          //           } else {
          //             return Container();
          //           }
          //         default:
          //           return Container();
          //       }
          //     }),
          ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:self_order/models/cardapio/categoria.dart';
import 'package:self_order/pages/cardapio/categoria/categoria_edit_page.dart';
import 'package:self_order/pages/cardapio/produto/produto_add_page.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';

class CategoriaListPage extends StatelessWidget {
  const CategoriaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    CategoriaServices categoriaServices = CategoriaServices();
    //final Categoria categoria = Categoria();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Listagem de Categorias"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Buscar",
                  hintText: "Filtra por nome da categoria",
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
                stream: categoriaServices.getAllCategorias(),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    docSnapshot['titulo'],
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    docSnapshot['descricao'],
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          categoriaServices.deleteCategoria();
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
                                          Categoria categoria = Categoria(
                                            id: docSnapshot.id,
                                            titulo: docSnapshot['nome'],
                                            descricao: docSnapshot['descricao'],
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoriaEditPage(
                                                      categoria: categoria),
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
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
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

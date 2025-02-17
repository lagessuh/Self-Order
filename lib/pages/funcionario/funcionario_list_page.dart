import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/pages/funcionario/funcionario_add_page.dart';
import 'package:self_order/pages/funcionario/funcionario_edit_page.dart';
import 'package:self_order/services/users/funcionario_services.dart';

class FuncionarioListPage extends StatelessWidget {
  const FuncionarioListPage({super.key});

  @override
  Widget build(BuildContext context) {
    FuncionarioServices funcionarioServices = FuncionarioServices();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Funcionários Cadastrados"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: funcionarioServices.getAllFuncionarios(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "Nenhum funcionário cadastrado.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot docSnapshot = snapshot.data!.docs[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: Text(
                        docSnapshot['userName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Matrícula: ${docSnapshot['matricula']}"),
                          Text("E-mail: ${docSnapshot['email']}"),
                          Text("Função: ${docSnapshot['funcao']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              FuncionarioModel funcionarioModel =
                                  FuncionarioModel(
                                id: docSnapshot.id,
                                userName: docSnapshot['userName'],
                                email: docSnapshot['email'],
                                matricula: docSnapshot['matricula'],
                                funcao: docSnapshot['funcao'],
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FuncionarioEditPage(
                                      funcionarioModel: funcionarioModel),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirmacao = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: Text(
                                      'Deseja realmente excluir o funcionário ${docSnapshot['userName']}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.red),
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmacao == true) {
                                try {
                                  await funcionarioServices.deleteFuncionario(
                                      id: docSnapshot.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Funcionário removido com sucesso'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Erro ao remover funcionário: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FuncionarioAddPage(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/pages/funcionario/funcionario_add_page.dart';
// import 'package:self_order/pages/funcionario/funcionario_edit_page.dart';
// import 'package:self_order/services/users/funcionario_services.dart';

// class FuncionarioListPage extends StatelessWidget {
//   const FuncionarioListPage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     FuncionarioServices funcionarioServices = FuncionarioServices();
//     //final Produto produto = Produto();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Funcionários Cadastrados"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             // TextField(
//             //   decoration: const InputDecoration(
//             //       labelText: "Buscar",
//             //       hintText: "Filtra pelo nome do funcionário",
//             //       prefixIcon: Icon(Icons.search),
//             //       prefixIconColor: Colors.blue,
//             //       border: OutlineInputBorder(
//             //         borderRadius: BorderRadius.all(
//             //           Radius.circular(8.0),
//             //         ),
//             //       )),
//             //   onChanged: (name) {},
//             // ),
//             // const SizedBox(
//             //   height: 15,
//             // ),
//             StreamBuilder(
//                 stream: funcionarioServices.getAllFuncionarios(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasData) {
//                     return Expanded(
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           DocumentSnapshot docSnapshot =
//                               snapshot.data!.docs[index];
//                           return Card(
//                             child: Row(children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     docSnapshot['userName'],
//                                     style: const TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     docSnapshot['matricula'],
//                                     style: const TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     docSnapshot['email'],
//                                     style: const TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Text(
//                                     docSnapshot['funcao'],
//                                     style: const TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                                 child: Row(children: [
//                                   Column(
//                                     children: [
//                                       InkWell(
//                                         onTap: () async {
//                                           final confirmacao =
//                                               await showDialog<bool>(
//                                             context: context,
//                                             builder: (context) => AlertDialog(
//                                               title: const Text(
//                                                   'Confirmar exclusão'),
//                                               content: Text(
//                                                   'Deseja realmente excluir o funcionário ${docSnapshot['userName']}?'),
//                                               actions: [
//                                                 TextButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(
//                                                           context, false),
//                                                   child: const Text('Cancelar'),
//                                                 ),
//                                                 TextButton(
//                                                   onPressed: () =>
//                                                       Navigator.pop(
//                                                           context, true),
//                                                   style: TextButton.styleFrom(
//                                                       foregroundColor:
//                                                           Colors.red),
//                                                   child: const Text('Excluir'),
//                                                 ),
//                                               ],
//                                             ),
//                                           );

//                                           if (confirmacao == true) {
//                                             try {
//                                               await funcionarioServices
//                                                   .deleteFuncionario(
//                                                       id: docSnapshot.id);
//                                               if (context.mounted) {
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   const SnackBar(
//                                                     content: Text(
//                                                         'Funcionário removido com sucesso'),
//                                                     backgroundColor:
//                                                         Colors.green,
//                                                   ),
//                                                 );
//                                               }
//                                             } catch (e) {
//                                               if (context.mounted) {
//                                                 ScaffoldMessenger.of(context)
//                                                     .showSnackBar(
//                                                   SnackBar(
//                                                     content: Text(
//                                                         'Erro ao remover funcionário: $e'),
//                                                     backgroundColor: Colors.red,
//                                                   ),
//                                                 );
//                                               }
//                                             }
//                                           }
//                                         },
//                                         child: const Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                           size: 20,
//                                         ),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           FuncionarioModel funcionarioModel =
//                                               FuncionarioModel(
//                                             id: docSnapshot.id,
//                                             userName: docSnapshot['userName'],
//                                             email: docSnapshot['email'],
//                                             matricula: docSnapshot['matricula'],
//                                             funcao: docSnapshot['funcao'],
//                                           );

//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   FuncionarioEditPage(
//                                                       funcionarioModel:
//                                                           funcionarioModel),
//                                             ),
//                                           );
//                                         },
//                                         child: const Icon(
//                                           Icons.edit,
//                                           color: Colors.orange,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 ]),
//                               )
//                             ]),
//                           );
//                         },
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 })
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color.fromARGB(255, 255, 17, 0),
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const FuncionarioAddPage(),
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

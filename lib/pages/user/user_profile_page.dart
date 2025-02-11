// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/services/users/users_services.dart';

// class UserProfilePage extends StatelessWidget {
//   const UserProfilePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Edição do Perfil de Usuário'),
//       // ),
//       body: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: Consumer<UsersServices>(
//           builder: (context, usersServices, child) {
//             return Column(
//               children: [
//                 const Text(
//                   "Perfil de Usuário",
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 2, 32, 3),
//                     fontSize: 28,
//                     fontFamily: 'Lustria',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 Card(
//                   elevation: 1.0,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20.0,
//                       vertical: 15,
//                     ),
//                     child: Row(children: [
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                               'Nome: ${usersServices.userModel!.userName!.toUpperCase()}'),
//                           Text('Email: ${usersServices.userModel!.email}'),
//                           //Text('Telefone: ${usersServices.userModel!.telefone}'),
//                         ],
//                       )
//                     ]),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.pushNamed(context, '/userprofileedit'),
//                   child: const Card(
//                     elevation: 1.0,
//                     child: Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.person_add_alt_1_outlined,
//                             size: 90.0,
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Cadastro',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Text('Edite dados pessoais, profissionais'),
//                                 Text(
//                                     'Emails, telefones, redes sociais e outros'),
//                               ]),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:self_order/services/users/cliente_services.dart';
import 'package:self_order/services/users/users_access_services.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  bool isFuncionario = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Verifica na coleção de funcionários primeiro
    DocumentSnapshot funcionarioDoc =
        await _firestore.collection('funcionarios').doc(currentUser.uid).get();

    if (funcionarioDoc.exists) {
      setState(() {
        userData = funcionarioDoc.data() as Map<String, dynamic>;
        isFuncionario = true;
      });
      return;
    }

    // Se não for funcionário, verifica na coleção de clientes
    DocumentSnapshot clienteDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (clienteDoc.exists) {
      setState(() {
        userData = clienteDoc.data() as Map<String, dynamic>;
        isFuncionario = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Consumer<UsersAccessServices>(
          builder: (context, usersAccessServices, child) {
            // Verificação se clienteModel existe
            // if (usersAccessServices.clienteModel == null) {
            //   return const Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.error_outline, size: 50, color: Colors.red),
            //         SizedBox(height: 16),
            //         Text(
            //           'Usuário não carregado',
            //           style: TextStyle(fontSize: 18),
            //         ),
            //       ],
            //     ),
            //   );
            // }

            // if (usersAccessServices.funcionarioModel == null) {
            //   return const Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.error_outline, size: 50, color: Colors.red),
            //         SizedBox(height: 16),
            //         Text(
            //           'Usuário não carregado',
            //           style: TextStyle(fontSize: 18),
            //         ),
            //       ],
            //     ),
            //   );
            // }

            if (userData == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 50, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Usuário não carregado',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                const Text(
                  "Perfil de Usuário",
                  style: TextStyle(
                    color: Color.fromARGB(255, 2, 32, 3),
                    fontSize: 28,
                    fontFamily: 'Lustria',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Card(
                  elevation: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15,
                    ),
                    child: Row(children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nome: ${userData?['userName']?.toUpperCase() ?? 'Não definido'}',
                          ),
                          Text(
                            'Email: ${userData?['email'] ?? 'Não definido'}',
                          ),
                          Text(
                              'Tipo: ${isFuncionario ? 'Funcionário' : 'Cliente'}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                        context, '/userprofileeditpage');
                    if (result == true) {
                      _fetchUserData(); // Atualiza os dados ao retornar
                    }
                  },
                  child: const Card(
                    elevation: 1.0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Icon(Icons.person_add_alt_1_outlined, size: 90.0),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cadastro',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text('Edite dados pessoais'),
                              // onTap: () =>
                              //     Navigator.pushNamed(context, '/userprofileeditpage'),
                              // child: const Card(
                              //   elevation: 1.0,
                              //   child: Padding(
                              //     padding:
                              //         EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              //     child: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.person_add_alt_1_outlined,
                              //           size: 90.0,
                              //         ),
                              //         SizedBox(
                              //           width: 15,
                              //         ),
                              //         Column(
                              //           crossAxisAlignment: CrossAxisAlignment.start,
                              //           children: [
                              //             Text(
                              //               'Cadastro',
                              //               style: TextStyle(
                              //                 fontSize: 20,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //             Text('Edite dados pessoais'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/services/users/users_services.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Consumer<UsersServices>(
          builder: (context, usersServices, child) {
            // Verificação se userModel existe
            if (usersServices.userModel == null) {
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
                            'Nome: ${usersServices.userModel?.userName?.toUpperCase() ?? 'Não definido'}',
                          ),
                          Text(
                            'Email: ${usersServices.userModel?.email ?? 'Não definido'}',
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/userprofileeditpage'),
                  child: const Card(
                    elevation: 1.0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add_alt_1_outlined,
                            size: 90.0,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cadastro',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Edite dados pessoais'),
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

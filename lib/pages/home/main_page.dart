import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:self_order/commons/responsive.dart';
import 'package:self_order/pages/home/home_page.dart';
import 'package:self_order/pages/user/user_profile_page.dart';
import 'package:self_order/services/users/users_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const HomePage(),
        const UserProfilePage(),
        const UserProfilePage(),
        const UserProfilePage(),
        const UserProfilePage(),
      ][_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (int position) {
          setState(() {
            _index = position;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Carrinho',
          ),
          NavigationDestination(
            icon: Icon(Icons.line_style_outlined),
            label: 'Pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_box_outlined),
            label: 'Perfil de Usuário',
          )
        ],
      ),
      drawer: Consumer<UsersServices>(
        builder: (context, usersServices, child) {
          return Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      // Flexible(
                      //   flex: 1,
                      //   // child: ClipOval(
                      //   //   child: Image.asset(
                      //   //     'assets/images/hamburgueria.jpg',
                      //   //     height: Responsive.isDesktop(context)
                      //   //         ? 400
                      //   //         : Responsive.isTablet(context)
                      //   //             ? 350
                      //   //             : 200,
                      //   //     width: Responsive.isDesktop(context)
                      //   //         ? const Size.fromHeight(50).height
                      //   //         : Responsive.isTablet(context)
                      //   //             ? 475
                      //   //             : 400,
                      //   //     fit: BoxFit.cover,
                      //   //   ),
                      //   // ),
                      // ),
                      Text(usersServices.userModel!.userName!.toUpperCase()),
                      Text(usersServices.userModel!.email!.toLowerCase()),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const ListTile(
                      title: Text('Pedidos'),
                    ),
                    const ListTile(
                      title: Text('Carrinho de Compras'),
                    ),
                    const Divider(
                      height: 2,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfilePage(),
                          ),
                        );
                      },
                      title: const Text('Perfil de usuário'),
                    ),
                    ExpansionTile(
                        title: const Text("Gerenciamento de Produtos"),
                        leading: const Icon(Icons.person),
                        childrenPadding: const EdgeInsets.only(left: 60),
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserProfilePage(),
                                ),
                              );
                            },
                            title: const Text('Cadastro de Produtos'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserProfilePage(),
                                ),
                              );
                            },
                            title: const Text('Listagem de Produtos'),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserProfilePage(),
                                ),
                              );
                            },
                            title: const Text('Categorias de Produtos'),
                          )
                        ]),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/commons/responsive.dart';
// import 'package:self_order/pages/home/home.dart';
// import 'package:self_order/pages/user/user_profile_page.dart';
// import 'package:self_order/services/users/users_services.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: [
//         const HomePage(),
//         const UserProfilePage(), // Substitua com a página do Carrinho
//         const UserProfilePage(), // Substitua com a página de Pedidos
//         const UserProfilePage(), // Substitua com a página de Perfil de Usuário
//       ][_index],
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _index,
//         onDestinationSelected: (int position) {
//           setState(() {
//             _index = position;
//           });
//         },
//         destinations: const <NavigationDestination>[
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             label: 'Início',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.shopping_cart_outlined),
//             label: 'Carrinho',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.line_style_outlined),
//             label: 'Pedidos',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.account_box_outlined),
//             label: 'Perfil de Usuário',
//           ),
//         ],
//       ),
//       // drawer: Consumer<UsersServices>(
//       //   builder: (context, usersServices, child) {
//       //     final user = usersServices.userModel;
//       //     return Drawer(
//       //       child: Column(
//       //         children: [
//       //           DrawerHeader(
//       //             child: Column(
//       //               children: [
//       //                 if (user != null) ...[
//       //                   Text(user.userName?.toUpperCase() ?? 'Usuário'),
//       //                   Text(user.email?.toLowerCase() ??
//       //                       'Email não disponível'),
//       //                 ],
//       //               ],
//       //             ),
//       //           ),
//       //           Column(
//       //             children: [
//       //               const ListTile(
//       //                 title: Text('Pedidos'),
//       //               ),
//       //               const ListTile(
//       //                 title: Text('Carrinho de Compras'),
//       //               ),
//       //               const Divider(height: 2),
//       //               ListTile(
//       //                 onTap: () {
//       //                   Navigator.push(
//       //                     context,
//       //                     MaterialPageRoute(
//       //                       builder: (context) => const UserProfilePage(),
//       //                     ),
//       //                   );
//       //                 },
//       //                 title: const Text('Perfil de usuário'),
//       //               ),
//       //               ExpansionTile(
//       //                 title: const Text("Gerenciamento de Produtos"),
//       //                 leading: const Icon(Icons.person),
//       //                 childrenPadding: const EdgeInsets.only(left: 60),
//       //                 children: [
//       //                   ListTile(
//       //                     onTap: () {
//       //                       Navigator.push(
//       //                         context,
//       //                         MaterialPageRoute(
//       //                           builder: (context) => const UserProfilePage(),
//       //                         ),
//       //                       );
//       //                     },
//       //                     title: const Text('Cadastro de Produtos'),
//       //                   ),
//       //                   ListTile(
//       //                     onTap: () {
//       //                       Navigator.push(
//       //                         context,
//       //                         MaterialPageRoute(
//       //                           builder: (context) => const UserProfilePage(),
//       //                         ),
//       //                       );
//       //                     },
//       //                     title: const Text('Listagem de Produtos'),
//       //                   ),
//       //                   ListTile(
//       //                     onTap: () {
//       //                       Navigator.push(
//       //                         context,
//       //                         MaterialPageRoute(
//       //                           builder: (context) => const UserProfilePage(),
//       //                         ),
//       //                       );
//       //                     },
//       //                     title: const Text('Categorias de Produtos'),
//       //                   ),
//       //                 ],
//       //               ),
//       //             ],
//       //           ),
//       //         ],
//       //       ),
//       //     );
//       //   },
//       // ),
//     );
//   }
// }

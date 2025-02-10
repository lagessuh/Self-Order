import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/pages/cardapio/categoria/categoria_list_page.dart';
import 'package:self_order/pages/cardapio/produto/produto_list_page.dart';
import 'package:self_order/pages/carrinho/carrinho_page.dart';
import 'package:self_order/pages/funcionario/funcionario_list_page.dart';
import 'package:self_order/pages/home/home_page.dart';
import 'package:self_order/pages/pedidos/lista_pedidos_page.dart';
import 'package:self_order/pages/pedidos/pedidos_manager_page.dart';
import 'package:self_order/pages/user/user_profile_page.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';
import 'package:self_order/services/users/cliente_services.dart';
import 'package:self_order/services/users/funcionario_services.dart';
import 'package:self_order/services/users/users_access_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;
  bool isFuncionario = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Verifica se o usuário está na coleção "funcionarios"
      DocumentSnapshot docFuncionario = await FirebaseFirestore.instance
          .collection('funcionarios')
          .doc(user.uid)
          .get();
      if (docFuncionario.exists) {
        setState(() {
          isFuncionario = true;
        });
      } else {
        // Caso não encontre, verifica na coleção "clientes"
        DocumentSnapshot docCliente = await FirebaseFirestore.instance
            .collection('clientes')
            .doc(user.uid)
            .get();
        if (docCliente.exists) {
          setState(() {
            isFuncionario = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Cardápio: Faça seu pedido',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2.0,
        actions: [
          Consumer<CarrinhoServices>(
              builder: (context, carrinhoServices, child) {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 24, 0),
              child: GestureDetector(
                onTap: () {
                  if (carrinhoServices.itens.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CarrinhoPage(),
                    ));
                  }
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      size: 32,
                    ),
                    if (carrinhoServices.itens.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                        child: CircleAvatar(
                          radius: 8.0,
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          child: Text(
                            carrinhoServices.itens.length.toString(),
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
          Consumer3<ClienteServices, FuncionarioServices, UsersAccessServices>(
            builder: (context, userServices, funcionarioServices,
                usersAccessServices, child) {
              return InkWell(
                onTap: () {
                  usersAccessServices.logout(context);
                },
                child: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 32,
                ),
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: [
        const HomePage(),
        const CarrinhoPage(),
        const ListaPedidosPage(), // Substitua com a página de Pedidos
        const UserProfilePage(), // Substitua com a página de Perfil de Usuário
      ][_bottomNavIndex],
      drawer: isFuncionario
          ? Drawer(
              backgroundColor: Colors.black, // Cor de fundo do Drawer
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black, // Cor de fundo do DrawerHeader
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white, // Texto em branco
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ExpansionTile(
                      title: const Text("Gerenciamento de Perfis",
                          style: TextStyle(color: Colors.white)),
                      leading: const Icon(Icons.person,
                          color: Colors.red), //add icon
                      childrenPadding:
                          const EdgeInsets.only(left: 60), //children padding
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FuncionarioListPage(),
                              ),
                            );
                          },
                          title: Text('Funcionários',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                  ExpansionTile(
                      title: const Text("Gerenciamento do Cardápio",
                          style: TextStyle(color: Colors.white)),
                      leading: const Icon(Icons.settings,
                          color: Colors.red), //add icon
                      childrenPadding:
                          const EdgeInsets.only(left: 60), //children padding
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProdutoListPage(),
                              ),
                            );
                          },
                          title: const Text('Produtos',
                              style: TextStyle(color: Colors.white)),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriaListPage(),
                              ),
                            );
                          },
                          title: const Text('Categorias',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                  ExpansionTile(
                      title: const Text("Gerenciamento de Pedidos",
                          style: TextStyle(color: Colors.white)),
                      leading: const Icon(Icons.settings,
                          color: Colors.red), //add icon
                      childrenPadding:
                          const EdgeInsets.only(left: 60), //children padding
                      children: [
                        ListTile(
                          title: Text('Administração de Pedidos',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriaListPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PedidoManagerPage(),
                              ),
                            );
                          },
                          title: const Text('Listagem de Pedidos',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                ],
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.red,
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: (int position) {
          setState(() {
            _bottomNavIndex = position;
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
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/pages/cardapio/categoria/categoria_list_page.dart';
// import 'package:self_order/pages/cardapio/produto/produto_list_page.dart';
// import 'package:self_order/pages/carrinho/carrinho_page.dart';
// import 'package:self_order/pages/funcionario/funcionario_list_page.dart';
// import 'package:self_order/pages/home/home_page.dart';
// import 'package:self_order/pages/pedidos/lista_pedidos_page.dart';
// import 'package:self_order/pages/pedidos/pedidos_manager_page.dart';
// import 'package:self_order/pages/user/user_profile_page.dart';
// import 'package:self_order/services/carrinho/carrinho_services.dart';
// import 'package:self_order/services/users/cliente_services.dart';
// import 'package:self_order/services/users/funcionario_services.dart';
// import 'package:self_order/services/users/users_access_services.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _bottomNavIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(
//           'Cardápio: Faça seu pedido',
//           style: TextStyle(color: Colors.white),
//         ),
//         elevation: 2.0,
//         actions: [
//           Consumer<CarrinhoServices>(
//             builder: (context, carrinhoServices, child) {
//               return Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 24, 0),
//                 child: GestureDetector(
//                   onTap: () {
//                     if (carrinhoServices.itens.isNotEmpty) {
//                       Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => const CarrinhoPage(),
//                       ));
//                     }
//                   },
//                   child: Stack(
//                     alignment: Alignment.topCenter,
//                     children: [
//                       const Icon(
//                         Icons.shopping_cart,
//                         size: 32,
//                       ),
//                       if (carrinhoServices.itens.isNotEmpty)
//                         Padding(
//                           padding:
//                               const EdgeInsets.only(left: 4.0, bottom: 8.0),
//                           child: CircleAvatar(
//                             radius: 8.0,
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.white,
//                             child: Text(
//                               carrinhoServices.itens.length.toString(),
//                               style: const TextStyle(fontSize: 12.0),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           Consumer3<ClienteServices, FuncionarioServices, UsersAccessServices>(
//             builder: (context, userServices, funcionarioServices,
//                 usersAccessServices, child) {
//               return InkWell(
//                 onTap: () {
//                   usersAccessServices.logout(context);
//                 },
//                 child: const Icon(
//                   Icons.exit_to_app,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               );
//             },
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//         ],
//       ),
//       body: [
//         const HomePage(),
//         const CarrinhoPage(),
//         const ListaPedidosPage(), // Substitua com a página de Pedidos
//         const UserProfilePage(), // Substitua com a página de Perfil de Usuário
//       ][_bottomNavIndex],
//       drawer: Drawer(
//         backgroundColor: Colors.black, // Cor de fundo do Drawer
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.black, // Cor de fundo do DrawerHeader
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white, // Texto em branco
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ExpansionTile(
//                 title: const Text("Gerenciamento de Perfis",
//                     style: TextStyle(color: Colors.white)),
//                 leading: const Icon(Icons.person, color: Colors.red), //add icon
//                 childrenPadding:
//                     const EdgeInsets.only(left: 60), //children padding
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const FuncionarioListPage(),
//                         ),
//                       );
//                     },
//                     title: Text('Funcionários',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ]),
//             ExpansionTile(
//                 title: const Text("Gerenciamento do Cardápio",
//                     style: TextStyle(color: Colors.white)),
//                 leading:
//                     const Icon(Icons.settings, color: Colors.red), //add icon
//                 childrenPadding:
//                     const EdgeInsets.only(left: 60), //children padding
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ProdutoListPage(),
//                         ),
//                       );
//                     },
//                     title: const Text('Produtos',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CategoriaListPage(),
//                         ),
//                       );
//                     },
//                     title: const Text('Categorias',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ]),
//             ExpansionTile(
//                 title: const Text("Gerenciamento de Pedidos",
//                     style: TextStyle(color: Colors.white)),
//                 leading:
//                     const Icon(Icons.settings, color: Colors.red), //add icon
//                 childrenPadding:
//                     const EdgeInsets.only(left: 60), //children padding
//                 children: [
//                   ListTile(
//                     title: Text('Administração de Pedidos',
//                         style: TextStyle(color: Colors.white)),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CategoriaListPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PedidoManagerPage(),
//                         ),
//                       );
//                     },
//                     title: const Text('Listagem de Pedidos',
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ]),
//           ],
//         ),
//       ),
//       bottomNavigationBar: NavigationBar(
//         backgroundColor: Colors.red,
//         selectedIndex: _bottomNavIndex,
//         onDestinationSelected: (int position) {
//           setState(() {
//             _bottomNavIndex = position;
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
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// //import 'package:self_order/commons/responsive.dart';
// import 'package:self_order/pages/home/home_page.dart';
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
//         const UserProfilePage(),
//         const UserProfilePage(),
//         const UserProfilePage(),
//         const UserProfilePage(),
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
//           )
//         ],
//       ),
//       drawer: Consumer<UsersServices>(
//         builder: (context, usersServices, child) {
//           return Drawer(
//             child: Column(
//               children: [
//                 DrawerHeader(
//                   child: Column(
//                     children: [
//                       // Flexible(
//                       //   flex: 1,
//                       //   // child: ClipOval(
//                       //   //   child: Image.asset(
//                       //   //     'assets/images/hamburgueria.jpg',
//                       //   //     height: Responsive.isDesktop(context)
//                       //   //         ? 400
//                       //   //         : Responsive.isTablet(context)
//                       //   //             ? 350
//                       //   //             : 200,
//                       //   //     width: Responsive.isDesktop(context)
//                       //   //         ? const Size.fromHeight(50).height
//                       //   //         : Responsive.isTablet(context)
//                       //   //             ? 475
//                       //   //             : 400,
//                       //   //     fit: BoxFit.cover,
//                       //   //   ),
//                       //   // ),
//                       // ),
//                       Text(usersServices.userModel!.userName!.toUpperCase()),
//                       Text(usersServices.userModel!.email!.toLowerCase()),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     const ListTile(
//                       title: Text('Pedidos'),
//                     ),
//                     const ListTile(
//                       title: Text('Carrinho de Compras'),
//                     ),
//                     const Divider(
//                       height: 2,
//                     ),
//                     ListTile(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const UserProfilePage(),
//                           ),
//                         );
//                       },
//                       title: const Text('Perfil de usuário'),
//                     ),
//                     ExpansionTile(
//                         title: const Text("Gerenciamento de Produtos"),
//                         leading: const Icon(Icons.person),
//                         childrenPadding: const EdgeInsets.only(left: 60),
//                         children: [
//                           ListTile(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const UserProfilePage(),
//                                 ),
//                               );
//                             },
//                             title: const Text('Cadastro de Produtos'),
//                           ),
//                           ListTile(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const UserProfilePage(),
//                                 ),
//                               );
//                             },
//                             title: const Text('Listagem de Produtos'),
//                           ),
//                           ListTile(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const UserProfilePage(),
//                                 ),
//                               );
//                             },
//                             title: const Text('Categorias de Produtos'),
//                           )
//                         ]),
//                   ],
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

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

// import 'package:flutter/material.dart';
// import 'package:self_order/pages/home/home_page.dart';
// import 'package:self_order/pages/user/user_profile_page.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _bottomNavIndex = 0;

//   // Índice para Drawer (navegação)
//   int _drawerIndex = 0;

//   // Atualizar o índice do Drawer
//   void _onDrawerItemTapped(int index) {
//     setState(() {
//       _drawerIndex = index;
//     });
//     // Fechar o Drawer após seleção
//     Navigator.pop(context);
//   }

//   void _logout() {
//     Navigator.pushReplacementNamed(context, '/loginpage2');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black, // Cor do AppBar
//         title: Text(
//           'Main Page',
//           style: TextStyle(color: Colors.white), // Texto em branco
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.logout,
//               color: Colors.red), // Ícone de logout em vermelho
//           onPressed: _logout,
//         ),
//       ),
//       body: [
//         const HomePage(),
//         const UserProfilePage(), // Substitua com a página do Carrinho
//         const UserProfilePage(), // Substitua com a página de Pedidos
//         const UserProfilePage(), // Substitua com a página de Perfil de Usuário
//       ][_bottomNavIndex],
//       drawer: Drawer(
//         backgroundColor: Colors.black, // Cor de fundo do Drawer
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.black, // Cor de fundo do DrawerHeader
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white, // Texto em branco
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home, color: Colors.red), // Ícone vermelho
//               title: Text('Home',
//                   style: TextStyle(color: Colors.white)), // Texto em branco
//               onTap: () {
//                 Navigator.pop(context);
//                 _onDrawerItemTapped(0);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person, color: Colors.red), // Ícone vermelho
//               title: Text('Profile',
//                   style: TextStyle(color: Colors.white)), // Texto em branco
//               onTap: () {
//                 Navigator.pop(context);
//                 _onDrawerItemTapped(1);
//               },
//             ),
//             ListTile(
//               leading:
//                   Icon(Icons.settings, color: Colors.red), // Ícone vermelho
//               title: Text('Settings',
//                   style: TextStyle(color: Colors.white)), // Texto em branco
//               onTap: () {
//                 Navigator.pop(context);
//                 _onDrawerItemTapped(2);
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _bottomNavIndex,
//         onDestinationSelected: (int position) {
//           setState(() {
//             _bottomNavIndex = position;
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
//     );
//   }
// }


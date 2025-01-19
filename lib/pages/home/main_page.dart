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

import 'package:flutter/material.dart';
import 'package:self_order/pages/home/home_page.dart';
import 'package:self_order/pages/user/user_profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  // Índice para Drawer (navegação)
  int _drawerIndex = 0;

  // Atualizar o índice do Drawer
  void _onDrawerItemTapped(int index) {
    setState(() {
      _drawerIndex = index;
    });
    // Fechar o Drawer após seleção
    Navigator.pop(context);
  }

  // Método de logout que navega para a página de login
  void _logout() {
    Navigator.pushReplacementNamed(context, '/loginpage2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Cor do AppBar
        title: Text(
          'Main Page',
          style: TextStyle(color: Colors.white), // Texto em branco
        ),
        actions: [
          // Ícone de logout à direita
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red), // Ícone de logout
            onPressed: _logout,
          ),
        ],
      ),
      body: [
        const HomePage(),
        const UserProfilePage(),
        const UserProfilePage(), // Substitua com a página de Pedidos
        const UserProfilePage(), // Substitua com a página de Perfil de Usuário
      ][_bottomNavIndex],
      drawer: Drawer(
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
            ListTile(
              leading: Icon(Icons.home, color: Colors.red), // Ícone vermelho
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _onDrawerItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.red), // Ícone vermelho
              title: Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _onDrawerItemTapped(1);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.settings, color: Colors.red), // Ícone vermelho
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _onDrawerItemTapped(2);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
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

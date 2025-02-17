// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/models/users/users.dart';
// import 'package:self_order/services/users/users_services.dart';

// class UserProfileEditPage extends StatefulWidget {
//   const UserProfileEditPage({this.users, super.key});
//   final UserModel? users;

//   @override
//   State<UserProfileEditPage> createState() => _UserProfileEditPageState();
// }

// class _UserProfileEditPageState extends State<UserProfileEditPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Consumer<UsersServices>(
//           builder: (context, usersServices, child) {
//             return Column(
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 const Text(
//                   "Editando Perfil de Usuário",
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 2, 32, 3),
//                     fontSize: 28,
//                     fontFamily: 'Lustria',
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 TextFormField(
//                   initialValue: usersServices.userModel!.userName,
//                   decoration: InputDecoration(
//                     label: const Text('Nome do Usuário'),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(width: 1.5),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 1.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   //initialValue: usersServices.userModel!.telefone,
//                   decoration: InputDecoration(
//                     label: const Text('Telefone'),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(width: 1.5),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 1.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   // initialValue: usersServices.userModel!.aniversario,
//                   decoration: InputDecoration(
//                     label: const Text('Data de Nascimento'),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(width: 1.5),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(width: 1.5),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/models/users/cliente.dart';
// import 'package:self_order/services/users/cliente_services.dart';

// class UserProfileEditPage extends StatefulWidget {
//   const UserProfileEditPage({super.key});

//   @override
//   State<UserProfileEditPage> createState() => _UserProfileEditPageState();
// }

// class _UserProfileEditPageState extends State<UserProfileEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   ClienteModel? clienteModel = ClienteModel();

//   @override
//   void initState() {
//     super.initState();
//     final clienteServices =
//         Provider.of<ClienteServices>(context, listen: false);

//     _nameController = TextEditingController(
//         text: clienteServices.clienteModel?.userName ?? '');
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       final clienteServices =
//           Provider.of<ClienteServices>(context, listen: false);

//       // Atualiza o nome do usuário no modelo existente
//       clienteServices.clienteModel?.userName = _nameController.text;

//       // Verifica se o clienteModel não é nulo antes de passar
//       if (clienteServices.clienteModel != null) {
//         clienteServices.updateUser(clienteServices.clienteModel!).then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Perfil atualizado com sucesso!')),
//           );
//           Navigator.pop(context);
//         }).catchError((error) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erro ao atualizar: $error')),
//           );
//         });
//       } else {
//         // Trata o caso de clienteModel ser nulo
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Erro: Usuário não encontrado')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Editar Perfil'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 30),
//               const Text(
//                 "Editando Perfil de Usuário",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 2, 32, 3),
//                   fontSize: 28,
//                   fontFamily: 'Lustria',
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Consumer<ClienteServices>(
//                 builder: (context, clienteServices, child) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Email: ${clienteServices.clienteModel?.email ?? "Não definido"}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const SizedBox(height: 15),
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: _buildInputDecoration('Nome do Usuário'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Por favor, insira um nome';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: const Text('Salvar Alterações'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(width: 1.5),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(width: 1.5),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.red, width: 1.5),
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/models/users/cliente.dart';
// import 'package:self_order/services/users/cliente_services.dart';

// class UserProfileEditPage extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   final bool isFuncionario;

//   const UserProfileEditPage({
//     super.key,
//     required this.userData,
//     required this.isFuncionario,
//   });
//   @override
//   State<UserProfileEditPage> createState() => _UserProfileEditPageState();
// }

// class _UserProfileEditPageState extends State<UserProfileEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController =
//         TextEditingController(text: widget.userData['userName'] ?? '');
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       String updatedName = _nameController.text;
//       String collection = widget.isFuncionario ? 'funcionarios' : 'users';

//       try {
//         await FirebaseFirestore.instance
//             .collection(collection)
//             .doc(widget.userData['uid'])
//             .update({'userName': updatedName});

//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Perfil atualizado com sucesso!')),
//         );
//         // ignore: use_build_context_synchronously
//         Navigator.pop(context);
//       } catch (error) {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erro ao atualizar: $error')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Editar Perfil'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               const SizedBox(height: 30),
//               const Text(
//                 "Editando Perfil de Usuário",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 2, 32, 3),
//                   fontSize: 28,
//                   fontFamily: 'Lustria',
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 'Email: ${widget.userData['email'] ?? "Não definido"}',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 15),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: _buildInputDecoration('Nome do Usuário'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, insira um nome';
//                   }
//                   return null;
//                 },
//               ),
//               // Consumer<ClienteServices>(
//               //   builder: (context, clienteServices, child) {
//               //     return Column(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //         Text(
//               //           'Email: ${clienteServices.clienteModel?.email ?? "Não definido"}',
//               //           style: const TextStyle(fontSize: 16),
//               //         ),
//               //         const SizedBox(height: 15),
//               //         TextFormField(
//               //           controller: _nameController,
//               //           decoration: _buildInputDecoration('Nome do Usuário'),
//               //           validator: (value) {
//               //             if (value == null || value.isEmpty) {
//               //               return 'Por favor, insira um nome';
//               //             }
//               //             return null;
//               //           },
//               //         ),
//               //       ],
//               //     );
//               //   },
//               // ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 child: const Text('Salvar Alterações'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _buildInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(width: 1.5),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(width: 1.5),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.red, width: 1.5),
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_order/commons/responsive.dart';
//import 'package:provider/provider.dart';
//import 'package:self_order/models/users/cliente.dart';
//import 'package:self_order/models/users/funcionario.dart';
//import 'package:self_order/services/users/cliente_services.dart';
//import 'package:self_order/services/users/funcionario_services.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({super.key});

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  Map<String, dynamic>? userData;
  bool isFuncionario = false;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        _nameController.text = userData?['userName'] ?? '';
        userEmail = userData?['email'];
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
        _nameController.text = userData?['userName'] ?? '';
        userEmail = userData?['email'];
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null || currentUser.uid.isEmpty) {
        throw Exception('❌ Usuário não autenticado ou UID inválido!');
      }

      if (kDebugMode) {
        print("📌 UID do usuário logado: ${currentUser.uid}");
      }

      final updatedData = {
        'userName': _nameController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      DocumentReference userDocRef = _firestore
          .collection(isFuncionario ? 'funcionarios' : 'users')
          .doc(currentUser.uid);

      // Verifica se o documento existe ANTES de atualizar
      DocumentSnapshot userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        if (kDebugMode) {
          print("❌ ERRO: Documento do usuário não encontrado no Firestore!");
        }
        throw Exception('Documento do usuário não encontrado!');
      }

      // Atualiza o nome do usuário
      await userDocRef.update(updatedData);
      if (kDebugMode) {
        print("✅ Usuário atualizado com sucesso!");
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Perfil atualizado com sucesso!')),
        );
        Navigator.pop(context, true); // Retorna "true" para indicar atualização
      }

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('✅ Perfil atualizado com sucesso!')),
      //   );
      //   Navigator.pop(context);
      // }
    } catch (error) {
      if (kDebugMode) {
        print("❌ Erro ao atualizar usuário: $error");
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erro ao atualizar: $error')),
        );
      }
    }
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return const EdgeInsets.all(80);
    } else if (Responsive.isTablet(context)) {
      return const EdgeInsets.all(70);
    }
    return const EdgeInsets.all(40);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            //padding: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Editando Perfil de Usuário",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 2, 32, 3),
                      fontSize: 28,
                      fontFamily: 'Lustria',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (userData != null) ...[
                    Text(
                      'Email: ${userEmail ?? "Não definido"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Tipo: ${isFuncionario ? "Funcionário" : "Cliente"}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration('Nome do Usuário'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Salvar Alterações'),
                    ),
                  ] else
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}


// Future<void> _saveProfile() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   try {
  //     User? currentUser = _auth.currentUser;
  //     if (currentUser == null) {
  //       throw Exception('Usuário não autenticado');
  //     }

  //     final updatedData = {
  //       'userName': _nameController.text,
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     };

  //     if (isFuncionario) {
  //       await _firestore
  //           .collection('funcionarios')
  //           .doc(currentUser.uid)
  //           .update(updatedData);
  //     } else {
  //       await _firestore
  //           .collection('users')
  //           .doc(currentUser.uid)
  //           .update(updatedData);
  //     }

  //     // Atualiza o provider apropriado
  //     if (isFuncionario) {
  //       final funcionarioServices =
  //           // ignore: use_build_context_synchronously
  //           Provider.of<FuncionarioServices>(context, listen: false);
  //       if (funcionarioServices.funcionarioModel != null) {
  //         funcionarioServices.funcionarioModel!.userName = _nameController.text;
  //         await funcionarioServices
  //             .updateUser(funcionarioServices.funcionarioModel!);
  //       }
  //     } else {
  //       final clienteServices =
  //           // ignore: use_build_context_synchronously
  //           Provider.of<ClienteServices>(context, listen: false);
  //       if (clienteServices.clienteModel != null) {
  //         clienteServices.clienteModel!.userName = _nameController.text;
  //         await clienteServices.updateUser(clienteServices.clienteModel!);
  //       }
  //     }

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Perfil atualizado com sucesso!')),
  //       );
  //       Navigator.pop(context);
  //     }
  //   } catch (error) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Erro ao atualizar: $error')),
  //       );
  //     }
  //   }
  // }
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/models/users/users.dart';
import 'package:self_order/services/users/users_services.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({super.key});

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  UserModel? users = UserModel();

  @override
  void initState() {
    super.initState();
    final userServices = Provider.of<UsersServices>(context, listen: false);

    _nameController =
        TextEditingController(text: userServices.userModel?.userName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final userServices = Provider.of<UsersServices>(context, listen: false);

      // Atualiza o nome do usuário no modelo existente
      userServices.userModel?.userName = _nameController.text;

      // Verifica se o userModel não é nulo antes de passar
      if (userServices.userModel != null) {
        userServices.updateUser(userServices.userModel!).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso!')),
          );
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar: $error')),
          );
        });
      } else {
        // Trata o caso de userModel ser nulo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Usuário não encontrado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
              Consumer<UsersServices>(
                builder: (context, usersServices, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ${usersServices.userModel?.email ?? "Não definido"}',
                        style: const TextStyle(fontSize: 16),
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
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Salvar Alterações'),
              ),
            ],
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/services/users/funcionario_services.dart';

// class FuncionarioEditPage extends StatefulWidget {
//   const FuncionarioEditPage({super.key, this.funcionarioModel});
//   final FuncionarioModel? funcionarioModel;

//   @override
//   State<FuncionarioEditPage> createState() => _FuncionarioEditPageState();
// }

// class _FuncionarioEditPageState extends State<FuncionarioEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   FuncionarioModel? funcionarioModel = FuncionarioModel();

//   @override
//   void initState() {
//     super.initState();
//     final funcionarioServices =
//         Provider.of<FuncionarioServices>(context, listen: false);

//     _nameController = TextEditingController(
//         text: funcionarioServices.funcionarioModel?.userName ?? '');
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       final funcionarioServices =
//           Provider.of<FuncionarioServices>(context, listen: false);

//       // Atualiza o nome do usuário no modelo existente
//       funcionarioServices.funcionarioModel?.userName = _nameController.text;

//       // Verifica se o userModel não é nulo antes de passar
//       if (funcionarioServices.funcionarioModel != null) {
//         funcionarioServices
//             .updateUser(funcionarioServices.funcionarioModel!)
//             .then((_) {
//           // ignore: use_build_context_synchronously
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Perfil atualizado com sucesso!')),
//           );
//           // ignore: use_build_context_synchronously
//           Navigator.pop(context);
//         }).catchError((error) {
//           // ignore: use_build_context_synchronously
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Erro ao atualizar: $error')),
//           );
//         });
//       } else {
//         // Trata o caso de userModel ser nulo
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
//               Consumer<FuncionarioServices>(
//                 builder: (context, funcionarioServices, child) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Email: ${funcionarioServices.funcionarioModel?.email ?? "Não definido"}',
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/commons/responsive.dart';
// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
// import 'package:self_order/services/users/funcionario_services.dart';

// class FuncionarioEditPage extends StatefulWidget {
//   const FuncionarioEditPage({this.funcionarioModel, super.key});
//   final FuncionarioModel? funcionarioModel;

//   @override
//   State<FuncionarioEditPage> createState() => _FuncionarioEditPageState();
// }

// class _FuncionarioEditPageState extends State<FuncionarioEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _userNameController;
//   late TextEditingController _matriculaController;
//   late TextEditingController _funcaoController;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _userNameController =
//         TextEditingController(text: widget.funcionarioModel?.userName ?? '');
//     _matriculaController =
//         TextEditingController(text: widget.funcionarioModel?.matricula ?? '');
//     _funcaoController =
//         TextEditingController(text: widget.funcionarioModel?.funcao ?? '');
//   }

//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _matriculaController.dispose();
//     _funcaoController.dispose();
//     super.dispose();
//   }

//   Future<void> _salvarFuncionario(BuildContext context) async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final funcionarioAtualizado = FuncionarioModel(
//         id: widget.funcionarioModel?.id,
//         userName: _userNameController.text,
//         matricula: _matriculaController.text,
//         funcao: _funcaoController.text,
//       );

//       final funcionarioServices =
//           Provider.of<FuncionarioServices>(context, listen: false);

//       await funcionarioServices.updateFuncionario(funcionarioAtualizado);

//       if (mounted) {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Funcionário atualizado com sucesso!')),
//         );
//         // ignore: use_build_context_synchronously
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erro ao atualizar funcionário: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   EdgeInsets _getResponsivePadding(BuildContext context) {
//     if (Responsive.isDesktop(context)) {
//       return const EdgeInsets.all(80);
//     } else if (Responsive.isTablet(context)) {
//       return const EdgeInsets.all(70);
//     }
//     return const EdgeInsets.all(40);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 255, 0, 0),
//         title: const Text("Editar Funcionário",
//             style: TextStyle(
//               color: Colors.white,
//             )),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: _getResponsivePadding(context),
//           child: Card(
//             margin: const EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Consumer<CategoriaServices>(
//                 builder: (context, categoriaServices, child) {
//                   return Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 50),
//                         const Text(
//                           "Editando Funcionário",
//                           style: TextStyle(
//                             color: Color.fromARGB(255, 2, 32, 3),
//                             fontSize: 28,
//                             fontFamily: 'Lustria',
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         _buildTextField(
//                           controller: _userNameController,
//                           label: 'Nome',
//                           validator: (value) => value?.isEmpty ?? true
//                               ? 'Campo obrigatório'
//                               : null,
//                         ),
//                         const SizedBox(height: 10),
//                         _buildTextField(
//                           controller: _matriculaController,
//                           label: 'Matrícula',
//                           validator: (value) => value?.isEmpty ?? true
//                               ? 'Campo obrigatório'
//                               : null,
//                         ),
//                         const SizedBox(height: 10),
//                         _buildTextField(
//                           controller: _funcaoController,
//                           label: 'Função',
//                           validator: (value) => value?.isEmpty ?? true
//                               ? 'Campo obrigatório'
//                               : null,
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _isLoading
//                                   ? null
//                                   : () => Navigator.pop(context),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red),
//                               child: const Text("Cancelar"),
//                             ),
//                             ElevatedButton(
//                               onPressed: _isLoading
//                                   ? null
//                                   : () => _salvarFuncionario(context),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green),
//                               child: _isLoading
//                                   ? const SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                           color: Colors.white),
//                                     )
//                                   : const Text("Salvar"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       enabled: !_isLoading,
//       decoration: InputDecoration(
//         label: Text(label),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/models/users/users_access.dart';
import 'package:self_order/services/users/funcionario_services.dart';

class FuncionarioEditPage extends StatefulWidget {
  const FuncionarioEditPage({this.funcionarioModel, super.key});
  final FuncionarioModel? funcionarioModel;

  @override
  State<FuncionarioEditPage> createState() => _FuncionarioEditPageState();
}

class _FuncionarioEditPageState extends State<FuncionarioEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _matriculaController;
  late TextEditingController _funcaoController;
  bool _isLoading = false;
  bool isActive = true;
  String selectedUserType = 'funcionario';
  Set<String> selectedPermissions = {};

  final Map<String, List<String>> rolePermissions = {
    'admin': [
      'manage_funcionarios',
      'manage_orders',
      'manage_menu',
      'view_all_order_history'
    ],
    'funcionario': ['manage_orders', 'view_menu'],
    'gerente': ['manage_orders', 'manage_menu', 'view_all_order_history'],
  };

  final Map<String, String> permissionLabels = {
    'manage_funcionarios': 'Gerenciar Funcionários',
    'manage_orders': 'Gerenciar Pedidos',
    'manage_menu': 'Gerenciar Cardápio',
    'view_menu': 'Visualizar Cardápio',
    'view_all_order_history': 'Visualizar Histórico de Pedidos',
  };

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.funcionarioModel?.userName ?? '');
    _matriculaController =
        TextEditingController(text: widget.funcionarioModel?.matricula ?? '');
    _funcaoController =
        TextEditingController(text: widget.funcionarioModel?.funcao ?? '');

    // Initialize user access settings
    if (widget.funcionarioModel?.usersAccess != null) {
      isActive = widget.funcionarioModel!.usersAccess!.isActive;
      selectedUserType = widget.funcionarioModel!.usersAccess!.tipoUsuario!;
      // Fix the type mismatch by ensuring non-null list and explicit casting
      selectedPermissions =
          Set.from(widget.funcionarioModel!.usersAccess!.permissions ?? []);
    } else {
      updatePermissionsForRole(selectedUserType);
    }
  }

  void updatePermissionsForRole(String role) {
    setState(() {
      selectedPermissions = Set.from(rolePermissions[role] ?? []);
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _matriculaController.dispose();
    _funcaoController.dispose();
    super.dispose();
  }

  Widget _buildPermissionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Permissões',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...permissionLabels.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.value),
              value: selectedPermissions.contains(entry.key),
              onChanged: _isLoading
                  ? null
                  : (bool? value) {
                      setState(() {
                        if (value!) {
                          selectedPermissions.add(entry.key);
                        } else {
                          selectedPermissions.remove(entry.key);
                        }
                      });
                    },
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _salvarFuncionario(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final usersAccess = UsersAccess(
        isActive: isActive,
        tipoUsuario: selectedUserType,
        lastAccessTime: widget.funcionarioModel?.usersAccess?.lastAccessTime ??
            DateTime.now(),
        permissions: selectedPermissions.toList(),
      );

      final funcionarioAtualizado = FuncionarioModel(
        id: widget.funcionarioModel?.id,
        userName: _userNameController.text,
        matricula: _matriculaController.text,
        funcao: _funcaoController.text,
        email: widget.funcionarioModel?.email, // Maintain the original email
        usersAccess: usersAccess,
      );

      final funcionarioServices =
          Provider.of<FuncionarioServices>(context, listen: false);
      await funcionarioServices.updateFuncionario(funcionarioAtualizado);

      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionário atualizado com sucesso!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar funcionário: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ??
          (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
      enabled: !_isLoading,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        title: const Text(
          "Editar Funcionário",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: _getResponsivePadding(context),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _userNameController,
                      label: 'Nome Completo',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _matriculaController,
                      label: 'Matrícula',
                      icon: Icons.badge,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _funcaoController,
                      label: 'Função',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Configurações de Acesso',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedUserType,
                            decoration: InputDecoration(
                              labelText: "Tipo de Usuário",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: rolePermissions.keys.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: _isLoading
                                ? null
                                : (String? newValue) {
                                    setState(() {
                                      selectedUserType = newValue!;
                                      updatePermissionsForRole(newValue);
                                    });
                                  },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: isActive,
                                onChanged: _isLoading
                                    ? null
                                    : (bool? value) {
                                        setState(() {
                                          isActive = value!;
                                        });
                                      },
                              ),
                              const Text('Usuário Ativo'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionsSection(),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () => _salvarFuncionario(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
                              : const Text("Salvar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

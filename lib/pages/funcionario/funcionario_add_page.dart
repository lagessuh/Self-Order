// import 'package:self_order/commons/responsive.dart';
// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/services/users/funcionario_services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class FuncionarioAddPage extends StatefulWidget {
//   const FuncionarioAddPage({super.key});

//   @override
//   State<FuncionarioAddPage> createState() => _FuncionarioAddPageState();
// }

// class _FuncionarioAddPageState extends State<FuncionarioAddPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool isChecked = false;

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _matriculaController = TextEditingController();
//   final TextEditingController _funcaoController = TextEditingController();

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
//       backgroundColor: Color.fromARGB(255, 0, 0, 0),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 255, 0, 0), // Cor do AppBar
//         title: const Text(
//           'Criar Perfil de Funcionário',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: _getResponsivePadding(context),
//           child: Form(
//             key: _formKey,
//             child: Consumer<FuncionarioServices>(
//               builder: (context, funcionarioServices, child) {
//                 return Card(
//                   margin: const EdgeInsets.all(16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (email) {
//                             if (email == null || email.isEmpty) {
//                               return 'Por favor, insira um email';
//                             }
//                             // Validação de email mais robusta
//                             final emailRegex =
//                                 RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                             if (!emailRegex.hasMatch(email)) {
//                               return 'Por favor, insira um email válido';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: "Senha",
//                             prefixIcon: const Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (senha) {
//                             if (senha == null || senha.isEmpty) {
//                               return 'Por favor, insira uma senha';
//                             }
//                             if (senha.length < 6) {
//                               return 'A senha deve ter no mínimo 6 caracteres';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _userNameController,
//                           decoration: InputDecoration(
//                             labelText: "Nome Completo",
//                             prefixIcon: const Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (nome) {
//                             if (nome == null || nome.isEmpty) {
//                               return 'Por favor, insira seu nome completo';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _matriculaController,
//                           decoration: InputDecoration(
//                             labelText: "Matrícula",
//                             prefixIcon: const Icon(Icons.badge),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (matricula) {
//                             if (matricula == null || matricula.isEmpty) {
//                               return 'Por favor, insira sua matrícula';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _funcaoController,
//                           decoration: InputDecoration(
//                             labelText: "Função",
//                             prefixIcon: const Icon(Icons.work),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (funcao) {
//                             if (funcao == null || funcao.isEmpty) {
//                               return 'Por favor, insira sua função';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               // Criar modelo de funcionário
//                               final funcionario = FuncionarioModel(
//                                 email: _emailController.text,
//                                 userName: _userNameController.text,
//                                 matricula: _matriculaController.text,
//                                 funcao: _funcaoController.text,
//                               );

//                               // Chamar método de cadastro
//                               funcionarioServices.signUp2(
//                                 funcionarioModel: funcionario,
//                                 password: _passwordController.text,
//                                 onSuccess: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           'Funcionário cadastrado com sucesso!'),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                   );
//                                   // Ao invés de ir para MainPage, apenas volta para a tela anterior
//                                   Navigator.pop(context);
//                                 },
//                                 onFail: (error) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Erro no cadastro: $error'),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 },
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           child: const Text('Cadastrar Funcionário'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:self_order/commons/responsive.dart';
// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/models/users/users_access.dart';
// import 'package:self_order/services/users/funcionario_services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class FuncionarioAddPage extends StatefulWidget {
//   const FuncionarioAddPage({super.key});

//   @override
//   State<FuncionarioAddPage> createState() => _FuncionarioAddPageState();
// }

// class _FuncionarioAddPageState extends State<FuncionarioAddPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool isActive = true;
//   String selectedUserType = 'funcionario'; // Default value

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _matriculaController = TextEditingController();
//   final TextEditingController _funcaoController = TextEditingController();

//   final List<String> userTypes = [
//     'admin',
//     'gerente',
//     'funcionario',
//     'user',
//     'guest'
//   ];

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
//       backgroundColor: Color.fromARGB(255, 0, 0, 0),
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 255, 0, 0),
//         title: const Text(
//           'Criar Perfil de Funcionário',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: _getResponsivePadding(context),
//           child: Form(
//             key: _formKey,
//             child: Consumer<FuncionarioServices>(
//               builder: (context, funcionarioServices, child) {
//                 return Card(
//                   margin: const EdgeInsets.all(16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: "Email",
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (email) {
//                             if (email == null || email.isEmpty) {
//                               return 'Por favor, insira um email';
//                             }
//                             final emailRegex =
//                                 RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//                             if (!emailRegex.hasMatch(email)) {
//                               return 'Por favor, insira um email válido';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             labelText: "Senha",
//                             prefixIcon: const Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (senha) {
//                             if (senha == null || senha.isEmpty) {
//                               return 'Por favor, insira uma senha';
//                             }
//                             if (senha.length < 6) {
//                               return 'A senha deve ter no mínimo 6 caracteres';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _userNameController,
//                           decoration: InputDecoration(
//                             labelText: "Nome Completo",
//                             prefixIcon: const Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (nome) {
//                             if (nome == null || nome.isEmpty) {
//                               return 'Por favor, insira seu nome completo';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _matriculaController,
//                           decoration: InputDecoration(
//                             labelText: "Matrícula",
//                             prefixIcon: const Icon(Icons.badge),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (matricula) {
//                             if (matricula == null || matricula.isEmpty) {
//                               return 'Por favor, insira sua matrícula';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         TextFormField(
//                           controller: _funcaoController,
//                           decoration: InputDecoration(
//                             labelText: "Função",
//                             prefixIcon: const Icon(Icons.work),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           validator: (funcao) {
//                             if (funcao == null || funcao.isEmpty) {
//                               return 'Por favor, insira sua função';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         // User Access Fields
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Configurações de Acesso',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               DropdownButtonFormField<String>(
//                                 value: selectedUserType,
//                                 decoration: InputDecoration(
//                                   labelText: "Tipo de Usuário",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 items: userTypes.map((String type) {
//                                   return DropdownMenuItem<String>(
//                                     value: type,
//                                     child: Text(type),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {
//                                   setState(() {
//                                     selectedUserType = newValue!;
//                                   });
//                                 },
//                               ),
//                               const SizedBox(height: 16),
//                               Row(
//                                 children: [
//                                   Checkbox(
//                                     value: isActive,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         isActive = value!;
//                                       });
//                                     },
//                                   ),
//                                   const Text('Usuário Ativo'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               // Create UsersAccess instance
//                               final usersAccess = UsersAccess(
//                                 isActive: isActive,
//                                 tipoUsuario: selectedUserType,
//                                 lastAccessTime: DateTime.now(),
//                               );

//                               // Create funcionario model with UsersAccess
//                               final funcionario = FuncionarioModel(
//                                 email: _emailController.text,
//                                 userName: _userNameController.text,
//                                 matricula: _matriculaController.text,
//                                 funcao: _funcaoController.text,
//                                 usersAccess: usersAccess,
//                               );

//                               funcionarioServices.signUp2(
//                                 funcionarioModel: funcionario,
//                                 password: _passwordController.text,
//                                 onSuccess: () {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           'Funcionário cadastrado com sucesso!'),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                   );
//                                   Navigator.pop(context);
//                                 },
//                                 onFail: (error) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Erro no cadastro: $error'),
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   );
//                                 },
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             minimumSize: const Size(double.infinity, 50),
//                           ),
//                           child: const Text('Cadastrar Funcionário'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:self_order/commons/responsive.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/models/users/users_access.dart';
import 'package:self_order/services/users/funcionario_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FuncionarioAddPage extends StatefulWidget {
  const FuncionarioAddPage({super.key});

  @override
  State<FuncionarioAddPage> createState() => _FuncionarioAddPageState();
}

class _FuncionarioAddPageState extends State<FuncionarioAddPage> {
  final _formKey = GlobalKey<FormState>();
  bool isActive = true;
  String selectedUserType = 'funcionario';
  Set<String> selectedPermissions = {};

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _funcaoController = TextEditingController();

  final Map<String, List<String>> rolePermissions = {
    'admin': [
      //'manage_users',
      'manage_funcionarios',
      //'view_reports',
      'manage_orders',
      'manage_menu',
      'view_all_order_history'
      //'manage_settings'
    ],
    'funcionario': ['manage_orders', 'view_menu'],
    'gerente': [
      //'view_reports',
      'manage_orders',
      'manage_menu',
      'view_all_order_history'
      //'view_funcionarios'
    ],

    //'user': ['place_order', 'view_menu', 'view_order_history'],
    //'guest': ['view_menu']
  };

  final Map<String, String> permissionLabels = {
    //'manage_users': 'Gerenciar Usuários',
    'manage_funcionarios': 'Gerenciar Funcionários',
    //'view_reports': 'Visualizar Relatórios',
    'manage_orders': 'Gerenciar Pedidos',
    'manage_menu': 'Gerenciar Cardápio',
    //'manage_settings': 'Gerenciar Configurações',
    //'view_funcionarios': 'Visualizar Funcionários',
    'view_menu': 'Visualizar Cardápio',
    //'place_order': 'Fazer Pedidos',
    'view_all_order_history': 'Visualizar Histórico de Pedidos',
  };

  @override
  void initState() {
    super.initState();
    // Set initial permissions based on default user type
    updatePermissionsForRole(selectedUserType);
  }

  void updatePermissionsForRole(String role) {
    setState(() {
      selectedPermissions = Set.from(rolePermissions[role] ?? []);
    });
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return const EdgeInsets.all(80);
    } else if (Responsive.isTablet(context)) {
      return const EdgeInsets.all(70);
    }
    return const EdgeInsets.all(40);
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
              onChanged: (bool? value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        title: const Text(
          'Criar Perfil de Funcionário',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: _getResponsivePadding(context),
          child: Form(
            key: _formKey,
            child: Consumer<FuncionarioServices>(
              builder: (context, funcionarioServices, child) {
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Por favor, insira um email';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(email)) {
                              return 'Por favor, insira um email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Senha",
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (senha) {
                            if (senha == null || senha.isEmpty) {
                              return 'Por favor, insira uma senha';
                            }
                            if (senha.length < 6) {
                              return 'A senha deve ter no mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            labelText: "Nome Completo",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (nome) {
                            if (nome == null || nome.isEmpty) {
                              return 'Por favor, insira seu nome completo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _matriculaController,
                          decoration: InputDecoration(
                            labelText: "Matrícula",
                            prefixIcon: const Icon(Icons.badge),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (matricula) {
                            if (matricula == null || matricula.isEmpty) {
                              return 'Por favor, insira sua matrícula';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _funcaoController,
                          decoration: InputDecoration(
                            labelText: "Função",
                            prefixIcon: const Icon(Icons.work),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (funcao) {
                            if (funcao == null || funcao.isEmpty) {
                              return 'Por favor, insira sua função';
                            }
                            return null;
                          },
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
                                onChanged: (String? newValue) {
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
                                    onChanged: (bool? value) {
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
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final usersAccess = UsersAccess(
                                isActive: isActive,
                                tipoUsuario: selectedUserType,
                                lastAccessTime: DateTime.now(),
                                permissions: selectedPermissions.toList(),
                              );

                              final funcionario = FuncionarioModel(
                                email: _emailController.text,
                                userName: _userNameController.text,
                                matricula: _matriculaController.text,
                                funcao: _funcaoController.text,
                                usersAccess: usersAccess,
                              );

                              funcionarioServices.signUp2(
                                funcionarioModel: funcionario,
                                password: _passwordController.text,
                                onSuccess: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Funcionário cadastrado com sucesso!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onFail: (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro no cadastro: $error'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Cadastrar Funcionário'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

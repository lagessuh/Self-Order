// import 'package:self_order/models/users/funcionario.dart';
// import 'package:self_order/services/users/funcionario_services.dart';
// import 'package:self_order/utils/helpers/responsive.dart';
// import 'package:self_order/pages/autenticacao/singup2.dart';
// import 'package:self_order/pages/home/main_page.dart';
// //import 'package:self_order/services/users/users_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// //import 'package:self_order/models/users/users.dart';
// import 'package:self_order/utils/helpers/validators.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';

// class FuncionarioAddPage extends StatefulWidget {
//   const FuncionarioAddPage({super.key});

//   @override
//   State<FuncionarioAddPage> createState() => _FuncionarioAddPageState();
// }

// class _FuncionarioAddPageState extends State<FuncionarioAddPage> {
//   bool isChecked = false;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _matriculaController = TextEditingController();
//   final TextEditingController _funcaoController = TextEditingController();
//   final FuncionarioModel _funcionarioModel = FuncionarioModel();

//   late Box box;

//   @override
//   void initState() {
//     super.initState();
//     createBox();
//   }

//   void createBox() async {
//     box = await Hive.openBox('userName');
//     getDataBox();
//   }

//   void getDataBox() async {
//     if (box.get('remember').toString() == 'true') {
//       if (box.get('email') != null && mounted) {
//         setState(() {
//           _emailController.text = box.get('email');
//           isChecked = true;
//         });
//       }
//       if (box.get('password') != null && mounted) {
//         setState(() {
//           _passwordController.text = box.get('password');
//           isChecked = true;
//         });
//       }
//     }
//   }

// // Delete info from people box
//   _deleteInfo(int index) {
//     box.deleteAt(index);
//     print('Item deleted from box at index: $index');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text(
//           'Adicionar Funcionário',
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               return const MainPage();
//             } else {
//               return Center(
//                 child: Padding(
//                   padding: Responsive.isDesktop(context)
//                       ? const EdgeInsets.only(
//                           left: 80.0, right: 80, top: 50, bottom: 50)
//                       : Responsive.isTablet(context)
//                           ? const EdgeInsets.only(
//                               left: 70.0, right: 70, top: 30, bottom: 30)
//                           : const EdgeInsets.only(
//                               left: 40.0, right: 40, top: 20, bottom: 20),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Responsive.isDesktop(context)
//                             ? const SizedBox(
//                                 height: 20,
//                               )
//                             : const SizedBox(
//                                 height: 20,
//                               ),
//                         const SizedBox(
//                           height: 20.0,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             left: 50,
//                             right: 50,
//                             top: 30,
//                           ),
//                           child: Center(
//                             child: Consumer<FuncionarioServices>(
//                               builder: (_, funcionarioServices, __) {
//                                 return Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: const Color(0xFFD9D9D9),
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextFormField(
//                                         controller: _emailController,
//                                         decoration: const InputDecoration(
//                                           label: Text("Email"),
//                                           prefixIcon: Icon(Icons.email,
//                                               color: Colors.black),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1.3),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                                   BorderSide(width: 1.5)),
//                                         ),
//                                         validator: (email) {
//                                           if (!emailValidator(email!)) {
//                                             return 'E-mail inválido!!!';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: const Color(0xFFD9D9D9),
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextFormField(
//                                         decoration: const InputDecoration(
//                                           label: Text("Senha"),
//                                           prefixIcon: Icon(Icons.fingerprint,
//                                               color: Colors.black),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1.3),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                                   BorderSide(width: 1.5)),
//                                         ),
//                                         obscureText: true,
//                                         controller: _passwordController,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Campo senha deve ser informado';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: const Color(0xFFD9D9D9),
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextFormField(
//                                         decoration: const InputDecoration(
//                                           label: Text("Matricula"),
//                                           prefixIcon: Icon(Icons.fingerprint,
//                                               color: Colors.black),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1.3),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                                   BorderSide(width: 1.5)),
//                                         ),
//                                         obscureText: true,
//                                         controller: _passwordController,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Campo senha deve ser informado';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: const Color(0xFFD9D9D9),
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextFormField(
//                                         decoration: const InputDecoration(
//                                           label: Text("Nome"),
//                                           prefixIcon: Icon(Icons.fingerprint,
//                                               color: Colors.black),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1.3),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                                   BorderSide(width: 1.5)),
//                                         ),
//                                         obscureText: true,
//                                         controller: _userNameController,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Campo nome deve ser informado';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: const Color(0xFFD9D9D9),
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextFormField(
//                                         decoration: const InputDecoration(
//                                           label: Text("Matricula"),
//                                           prefixIcon: Icon(Icons.fingerprint,
//                                               color: Colors.black),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1.3),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                                   BorderSide(width: 1.5)),
//                                         ),
//                                         obscureText: true,
//                                         controller: _matriculaController,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Campo senha deve ser informado';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: const Color(0xFFD9D9D9),
//                                           width: 1,
//                                         ),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: TextFormField(
//                                         decoration: const InputDecoration(
//                                           label: Text("Função"),
//                                           prefixIcon: Icon(Icons.fingerprint,
//                                               color: Colors.black),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1.3),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide:
//                                                   BorderSide(width: 1.5)),
//                                         ),
//                                         obscureText: true,
//                                         controller: _funcaoController,
//                                         validator: (value) {
//                                           if (value!.isEmpty) {
//                                             return 'Campo função deve ser informado';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 30,
//                                     ),
//                                     SizedBox(
//                                       width: Responsive.isMobile(context)
//                                           ? 350
//                                           : 450,
//                                       child: ElevatedButton(
//                                         onPressed: () {
//                                           funcionarioServices.signIn(
//                                             email: _emailController.text,
//                                             password: _passwordController.text,
//                                             onSuccess: () {
//                                               saveLoginHive();
//                                               Navigator.pushReplacement(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const MainPage(),
//                                                 ),
//                                               );
//                                             },
//                                             onFail: (String error) {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                   content: Text(
//                                                     'Falha ao entrar: $error',
//                                                     style: const TextStyle(
//                                                         fontSize: 14),
//                                                   ),
//                                                   backgroundColor: Colors.red,
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.white,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                           ),
//                                           minimumSize:
//                                               const Size.fromHeight(50),
//                                         ),
//                                         child: const Text(
//                                           'Entrar',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 16,
//                                             fontFamily: 'Roboto',
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: Responsive.isMobile(context)
//                                           ? 350
//                                           : 450,
//                                       padding: const EdgeInsets.only(top: 5),
//                                       alignment: Alignment.centerRight,
//                                       child: TextButton(
//                                         onPressed: () {},
//                                         child: Text(
//                                           'Esqueceu sua senha?',
//                                           style: TextStyle(
//                                             color: Colors.red,
//                                             fontFamily: 'Inter',
//                                             fontWeight: FontWeight.bold,
//                                             fontSize:
//                                                 Responsive.isMobile(context)
//                                                     ? 12
//                                                     : 15,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: Responsive.isMobile(context)
//                                           ? 10
//                                           : 15,
//                                     ),
//                                     SizedBox(
//                                       width: Responsive.isMobile(context)
//                                           ? 350
//                                           : 450,
//                                       child: Center(
//                                         child: Text(
//                                           'ou',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize:
//                                                 Responsive.isMobile(context)
//                                                     ? 14
//                                                     : 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: Responsive.isMobile(context)
//                                           ? 10
//                                           : 15,
//                                     ),
//                                     SizedBox(
//                                       width: Responsive.isMobile(context)
//                                           ? 350
//                                           : 450,
//                                       child: ElevatedButton(
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 255, 255, 255),
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                           ),
//                                           minimumSize:
//                                               const Size.fromHeight(50),
//                                         ),
//                                         onPressed: () {},
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Image.asset(
//                                               'assets/images/google.png',
//                                               height: 20,
//                                             ),
//                                             const Text(
//                                               '  Login com Google',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 16,
//                                                 fontFamily: 'Roboto',
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     Container(
//                                       width: Responsive.isMobile(context)
//                                           ? 350
//                                           : 450,
//                                       padding: const EdgeInsets.only(top: 5),
//                                       alignment: Alignment.centerRight,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             'Ainda não possui uma conta?',
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize:
//                                                   Responsive.isMobile(context)
//                                                       ? 10
//                                                       : 12,
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           InkWell(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const SignupPage2(),
//                                                 ),
//                                               );
//                                             },
//                                             child: Text(
//                                               'Registre-se aqui',
//                                               style: TextStyle(
//                                                 color: Colors.red,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize:
//                                                     Responsive.isMobile(context)
//                                                         ? 12
//                                                         : 15,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           }),
//     );
//   }

//   void saveLoginHive() async {
//     if (isChecked) {
//       await box.put('email', _emailController.text);
//       await box.put('password', _passwordController.text);
//       await box.put('remember', isChecked);
//     } else {
//       await box.delete('email');
//       await box.delete('password');
//       await box.put('remember', false);
//     }
//   }
// }

import 'package:self_order/models/users/funcionario.dart';
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
  bool isChecked = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _funcaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.red, // Cor do AppBar
        title: const Text(
          'Criar Perfil de Funcionário',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Consumer<FuncionarioServices>(
                  builder: (context, funcionarioServices, child) {
                    return Column(
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
                            // Validação de email mais robusta
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
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Criar modelo de funcionário
                              final funcionario = FuncionarioModel(
                                email: _emailController.text,
                                userName: _userNameController.text,
                                matricula: _matriculaController.text,
                                funcao: _funcaoController.text,
                              );

                              // Chamar método de cadastro
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
                                  // Ao invés de ir para MainPage, apenas volta para a tela anterior
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
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

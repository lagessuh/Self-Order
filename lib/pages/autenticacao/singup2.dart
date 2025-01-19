//import 'package:acervo/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/commons/widgets/my_textformfield.dart';
import 'package:self_order/helpers/validators.dart';
import 'package:self_order/models/users/users.dart';
import 'package:self_order/pages/autenticacao/login_page2.dart';
import 'package:self_order/services/users/users_services.dart';

class SignupPage2 extends StatefulWidget {
  const SignupPage2({super.key});

  @override
  State<SignupPage2> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage2> {
  UserModel userModel = UserModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Padding(
          padding: Responsive.isDesktop(context)
              ? const EdgeInsets.only(
                  left: 80.0, right: 80, top: 50, bottom: 50)
              : Responsive.isTablet(context)
                  ? const EdgeInsets.only(
                      left: 70.0, right: 70, top: 30, bottom: 30)
                  : const EdgeInsets.only(
                      left: 40.0, right: 40, top: 20, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Responsive.isDesktop(context)
                    ? const SizedBox(
                        height: 20,
                      )
                    : const SizedBox(
                        height: 20,
                      ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/hamburgueria.jpg',
                          height: Responsive.isDesktop(context)
                              ? 400
                              : Responsive.isTablet(context)
                                  ? 350
                                  : 200,
                          width: Responsive.isDesktop(context)
                              ? const Size.fromHeight(500).height
                              : Responsive.isTablet(context)
                                  ? 475
                                  : 400,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "FullStackBurger   |   Hamburgueria Gourmet ",
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context)
                            ? 26
                            : Responsive.isTablet(context)
                                ? 23
                                : 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                    top: 30,
                    bottom: 30,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MyTextFormField(
                            prefixIcon: Icon(Icons.person, color: Colors.black),
                            onSaved: (value) => userModel.userName = value,
                            onChanged: (value) {},
                            labelText: 'Nome',
                            textType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo nome deve ser preenchido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MyTextFormField(
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            onChanged: (value) {},
                            onSaved: (value) => userModel.email = value,
                            labelText: 'E-mail',
                            textType: TextInputType.emailAddress,
                            validator: (email) {
                              //um validador deve ser chamando no Form
                              if (!emailValidator(email!)) {
                                return 'E-mail inválido!!!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFD9D9D9),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MyTextFormField(
                            prefixIcon:
                                Icon(Icons.fingerprint, color: Colors.black),
                            onChanged: (value) {},
                            onSaved: (value) => _password = value.toString(),
                            labelText: 'Senha',
                            textType: TextInputType.text,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo senha deve ser informado';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //-- populando objeto (classe de dados)
                              _formKey.currentState!.save();
                              //criando instância da classe UserServices
                              UsersServices usersServices = UsersServices();

                              //utilizando a instância da classe UsersServices
                              usersServices.signUp2(
                                userModel: userModel,
                                password: _password,
                                onFail: (erro) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Falha ao entrar: $erro',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                onSuccess: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Registro realizado com sucesso',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            minimumSize:
                                //const Size(300, 50),
                                const Size.fromHeight(50),
                          ),
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'ou',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage2(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            minimumSize:
                                //const Size(300, 50),
                                const Size.fromHeight(50),
                          ),
                          child: const Text(
                            'Já Possuo uma Conta',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// //import 'package:acervo/services/user_services.dart';
// import 'package:flutter/material.dart';
// import 'package:self_order/commons/widgets/my_textformfield.dart';
// import 'package:self_order/helpers/validators.dart';
// import 'package:self_order/models/users/users.dart';
// import 'package:self_order/pages/autenticacao/login_page2.dart';
// import 'package:self_order/services/users/users_services.dart';

// class SignupPage2 extends StatefulWidget {
//   const SignupPage2({super.key});

//   @override
//   State<SignupPage2> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage2> {
//   UserModel userModel = UserModel();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   // final TextEditingController userNameController = TextEditingController();
//   // final TextEditingController emailController = TextEditingController();
//   // final TextEditingController passwordController = TextEditingController();
//   String _password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(214, 198, 255, 84),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(40.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: 140,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF65558F),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 108,
//                         height: 108,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage('assets/images/acervo.png'),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                           width: 20), // Espaço entre a imagem e o texto
//                       const Text(
//                         'GERENCIAMENTO DE\nACERVO PESSOAL',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontFamily: 'Roboto',
//                           fontWeight: FontWeight.w500,
//                           height: 1.2,
//                           letterSpacing: 0.1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 //MyTextFormField(userNameController: userNameController),
//                 MyTextFormField(
//                   onSaved: (value) => userModel.userName = value,
//                   onChanged: (value) {},
//                   labelText: 'Nome do Usuário',
//                   textType: TextInputType.text,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Campo usuário deve ser preenchido';
//                     }

//                     return null;
//                   },
//                 ),
//                 // padding:
//                 //     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 // decoration: BoxDecoration(
//                 //   color: Colors.white,
//                 //   border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
//                 //   borderRadius: BorderRadius.circular(8),
//                 // ),
//                 // child: TextFormField(
//                 //   controller: userNameController,
//                 //   decoration: const InputDecoration.collapsed(hintText: 'Nome'),
//                 // ),
//                 //),
//                 const SizedBox(height: 16),
//                 MyTextFormField(
//                   onChanged: (value) {},
//                   onSaved: (value) => userModel.email = value,
//                   labelText: 'E-mail',
//                   textType: TextInputType.emailAddress,
//                   validator: (email) {
//                     //um validador deve ser chamando no Form
//                     if (!emailValidator(email!)) {
//                       return 'E-mail inválido!!!';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 MyTextFormField(
//                   onChanged: (value) {},
//                   onSaved: (value) => _password = value.toString(),
//                   labelText: 'Senha',
//                   textType: TextInputType.text,
//                   obscureText: true,
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Campo senha deve ser informado';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       //-- populando objeto (classe de dados)
//                       _formKey.currentState!.save();
//                       //criando instância da classe UserServices
//                       UsersServices usersServices = UsersServices();

//                       //utilizando a instância da classe UsersServices
//                       usersServices.signUp2(
//                         userModel: userModel,
//                         password: _password,
//                         onFail: (erro) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 'Falha ao entrar: $erro',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                         },
//                         onSuccess: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'Registro realizado com sucesso',
//                                 style: TextStyle(fontSize: 14),
//                               ),
//                               backgroundColor: Colors.green,
//                             ),
//                           );
//                           Navigator.pop(context);
//                         },
//                       );
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF65558F),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     minimumSize: const Size(300, 50),
//                   ),
//                   child: const Text(
//                     'Criar conta',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Roboto',
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'OU',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontFamily: 'Roboto',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const LoginPage2(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF65558F),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     minimumSize: const Size(300, 50),
//                   ),
//                   child: const Text(
//                     'Já Possuo uma Conta',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Roboto',
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';
import 'package:self_order/services/users/cliente_services.dart';
import 'package:self_order/services/users/funcionario_services.dart';
import 'package:self_order/services/users/users_access_services.dart';
//import 'package:self_order/services/carrinho/carrinho_services.dart';
import 'package:self_order/utils/helpers/responsive.dart';
import 'package:self_order/pages/autenticacao/singup2.dart';
import 'package:self_order/pages/home/main_page.dart';
//import 'package:self_order/services/users/cliente_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:self_order/models/users/cliente.dart';
import 'package:self_order/utils/helpers/validators.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  bool isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final ClienteModel _clienteModel = ClienteModel();
  late Box box;

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box = await Hive.openBox('user');
    getDataBox();
  }

  void getDataBox() async {
    if (box.get('remember').toString() == 'true') {
      if (box.get('email') != null && mounted) {
        setState(() {
          _emailController.text = box.get('email');
          isChecked = true;
        });
      }
      if (box.get('password') != null && mounted) {
        setState(() {
          _passwordController.text = box.get('password');
          isChecked = true;
        });
      }
    }
  }

// Delete info from people box
  _deleteInfo(int index) {
    box.deleteAt(index);
    if (kDebugMode) {
      print('Item deleted from box at index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MainPage();
            } else {
              return Center(
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
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Faça seu pedido sem a necessidade de um garçom!',
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context)
                                    ? 21
                                    : Responsive.isTablet(context)
                                        ? 20
                                        : 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 50,
                            right: 50,
                            top: 30,
                          ),
                          child: Center(
                            child: Consumer3<UsersAccessServices,
                                ClienteServices, FuncionarioServices>(
                              builder: (_, userAccessServices, clienteServices,
                                  funcionarioServices, __) {
                                return Column(
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
                                      child: TextFormField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          label: Text("Email"),
                                          prefixIcon: Icon(Icons.email,
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.3),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 1.5)),
                                        ),
                                        validator: (email) {
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
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          label: Text("Senha"),
                                          prefixIcon: Icon(Icons.fingerprint,
                                              color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.3),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 1.5)),
                                        ),
                                        obscureText: true,
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Campo senha deve ser informado';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    SizedBox(
                                      width: Responsive.isMobile(context)
                                          ? 350
                                          : 450,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          userAccessServices.signInUsers(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            onSuccess: () {
                                              final carrinhoServices =
                                                  Provider.of<CarrinhoServices>(
                                                      context,
                                                      listen: false);
                                              final clienteServices =
                                                  Provider.of<ClienteServices>(
                                                      context,
                                                      listen: false);
                                              final usersAccessServices =
                                                  Provider.of<
                                                          UsersAccessServices>(
                                                      context,
                                                      listen: false);
                                              final funcionarioServices =
                                                  Provider.of<
                                                          FuncionarioServices>(
                                                      context,
                                                      listen: false);
                                              carrinhoServices
                                                  .setUser(usersAccessServices);
                                              saveLoginHive();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MainPage(),
                                                ),
                                              );
                                            },
                                            onFail: (String error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Falha ao entrar: $error',
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          minimumSize:
                                              const Size.fromHeight(50),
                                        ),
                                        child: const Text(
                                          'Entrar',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Responsive.isMobile(context)
                                          ? 350
                                          : 450,
                                      padding: const EdgeInsets.only(top: 5),
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Esqueceu sua senha?',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Responsive.isMobile(context)
                                                    ? 12
                                                    : 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Responsive.isMobile(context)
                                          ? 10
                                          : 15,
                                    ),
                                    SizedBox(
                                      width: Responsive.isMobile(context)
                                          ? 350
                                          : 450,
                                      child: Center(
                                        child: Text(
                                          'ou',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                Responsive.isMobile(context)
                                                    ? 14
                                                    : 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Responsive.isMobile(context)
                                          ? 10
                                          : 15,
                                    ),
                                    SizedBox(
                                      width: Responsive.isMobile(context)
                                          ? 350
                                          : 450,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          minimumSize:
                                              const Size.fromHeight(50),
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/google.png',
                                              height: 20,
                                            ),
                                            const Text(
                                              '  Login com Google',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: Responsive.isMobile(context)
                                          ? 350
                                          : 450,
                                      padding: const EdgeInsets.only(top: 5),
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Ainda não possui uma conta?',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  Responsive.isMobile(context)
                                                      ? 10
                                                      : 12,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignupPage2(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'Registre-se aqui',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Responsive.isMobile(context)
                                                        ? 12
                                                        : 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  void saveLoginHive() async {
    if (isChecked) {
      await box.put('email', _emailController.text);
      await box.put('password', _passwordController.text);
      await box.put('remember', isChecked);
    } else {
      await box.delete('email');
      await box.delete('password');
      await box.put('remember', false);
    }
  }
}

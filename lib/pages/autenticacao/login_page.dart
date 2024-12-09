import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/pages/autenticacao/signup.dart';
import 'package:self_order/services/users/users_services.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Responsive.isDesktop(context)
            ? const EdgeInsets.only(left: 80.0, right: 80, top: 50)
            : Responsive.isTablet(context)
                ? const EdgeInsets.only(left: 70.0, right: 70, top: 30)
                : const EdgeInsets.only(left: 40.0, right: 40, top: 20),
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
              Padding(
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
                          ? const Size.fromHeight(50).height
                          : Responsive.isTablet(context)
                              ? 475
                              : 400,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Text(
                "FullStackBurger   |   Hamburgueria Gourmet ",
                style: TextStyle(
                  fontSize: Responsive.isDesktop(context)
                      ? 30
                      : Responsive.isTablet(context)
                          ? 27
                          : 22,
                  color: const Color.fromARGB(248, 21, 118, 6),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'Faça seu pedido sem a necessidade de um garçom!',
                style: TextStyle(
                  fontSize: Responsive.isDesktop(context)
                      ? 24
                      : Responsive.isTablet(context)
                          ? 21
                          : 18,
                  color: const Color.fromARGB(248, 21, 118, 6),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    label: Text("E-mail"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.3),
                    ),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                obscureText: true,
                controller: _password,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.fingerprint),
                    label: Text("Senha"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.3),
                    ),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1.5))),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 8.0),
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Consumer<UsersServices>(
                builder: (context, usersServices, child) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          usersServices.signIn(
                              email: _email.text.trim(),
                              password: _password.text.trim(),
                              onSucess: () {
                                Navigator.pushReplacementNamed(
                                    context, '/mainpage');
                              },
                              onFail: (e) {
                                var snack = SnackBar(
                                  content: Text(e),
                                  backgroundColor: Colors.red,
                                  elevation: 20,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(20),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snack);
                              });
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 1.5,
                            minimumSize: const Size.fromHeight(50),
                            shape: LinearBorder.bottom()),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Ainda não tem conta?'),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Registre-se',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

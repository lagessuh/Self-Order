import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:self_order/commons/custom_textformfield.dart';
import 'package:self_order/models/users/users.dart';
import 'package:self_order/pages/autenticacao/login_page.dart';
import 'package:self_order/services/users/users_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  final TextEditingController _aniversario = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserModel users = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Image.asset(
                    'assets/images/hamburgueria.jpg',
                    height: 100,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Registre-se",
                          style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 213, 107, 8),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        Text(
                          'FullStackBurger   |   Hamburgueria Gourmet ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 213, 93, 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  onSaved: (value) => users.userName = value,
                  controller: _userName,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      label: Text("Nome do usuário"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.3),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5))),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      label: Text("E-mail"),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.3),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5))),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  enabled: true,
                  labelText: const Text('Telefone'),
                  controller: _telefone,
                  prefixIcon: Icons.phone_enabled,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  enabled: true,
                  labelText: const Text('Data de Nascimento'),
                  controller: _aniversario,
                  prefixIcon: Icons.calendar_month,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  obscureText: true,
                  controller: _password,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.fingerprint),
                      label: Text("Senha"),
                      suffixIcon: Icon(Icons.remove_red_eye),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1.3),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5))),
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
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        UsersServices usersServices = UsersServices();

                        users.email = _email.text;
                        users.userName = _userName.text;
                        users.password = _password.text;
                        users.aniversario = _aniversario.text;
                        users.telefone = _telefone.text;

                        if (await usersServices.signUp(users, kIsWeb)) {
                          if (context.mounted) Navigator.of(context).pop();
                        } else {
                          if (context.mounted) {
                            var snackBar = const SnackBar(
                              content: Text('Algum erro aconteceu no registro'),
                              backgroundColor: Color.fromARGB(255, 161, 71, 66),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(50),
                              elevation: 20,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 1.5,
                          minimumSize: const Size.fromHeight(50),
                          shape: LinearBorder.bottom()),
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Ou',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 50,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            "Login com Google",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Já tem uma conta?'),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

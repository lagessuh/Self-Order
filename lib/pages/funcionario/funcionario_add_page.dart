import 'package:self_order/commons/responsive.dart';
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
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0), // Cor do AppBar
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

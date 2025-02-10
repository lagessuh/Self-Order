import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/services/users/funcionario_services.dart';

class FuncionarioEditPage extends StatefulWidget {
  const FuncionarioEditPage({super.key, this.funcionarioModel});
  final FuncionarioModel? funcionarioModel;

  @override
  State<FuncionarioEditPage> createState() => _FuncionarioEditPageState();
}

class _FuncionarioEditPageState extends State<FuncionarioEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  FuncionarioModel? funcionarioModel = FuncionarioModel();

  @override
  void initState() {
    super.initState();
    final funcionarioServices =
        Provider.of<FuncionarioServices>(context, listen: false);

    _nameController = TextEditingController(
        text: funcionarioServices.funcionarioModel?.userName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final funcionarioServices =
          Provider.of<FuncionarioServices>(context, listen: false);

      // Atualiza o nome do usuário no modelo existente
      funcionarioServices.funcionarioModel?.userName = _nameController.text;

      // Verifica se o userModel não é nulo antes de passar
      if (funcionarioServices.funcionarioModel != null) {
        funcionarioServices
            .updateUser(funcionarioServices.funcionarioModel!)
            .then((_) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso!')),
          );
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }).catchError((error) {
          // ignore: use_build_context_synchronously
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
              Consumer<FuncionarioServices>(
                builder: (context, funcionarioServices, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ${funcionarioServices.funcionarioModel?.email ?? "Não definido"}',
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

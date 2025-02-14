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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/models/users/funcionario.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
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

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.funcionarioModel?.userName ?? '');
    _matriculaController =
        TextEditingController(text: widget.funcionarioModel?.matricula ?? '');
    _funcaoController =
        TextEditingController(text: widget.funcionarioModel?.funcao ?? '');
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _matriculaController.dispose();
    _funcaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarFuncionario(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final funcionarioAtualizado = FuncionarioModel(
        id: widget.funcionarioModel?.id,
        userName: _userNameController.text,
        matricula: _matriculaController.text,
        funcao: _funcaoController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        title: const Text("Editar Funcionário",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: _getResponsivePadding(context),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<CategoriaServices>(
                builder: (context, categoriaServices, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        const Text(
                          "Editando Funcionário",
                          style: TextStyle(
                            color: Color.fromARGB(255, 2, 32, 3),
                            fontSize: 28,
                            fontFamily: 'Lustria',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildTextField(
                          controller: _userNameController,
                          label: 'Nome',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Campo obrigatório'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _matriculaController,
                          label: 'Matrícula',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Campo obrigatório'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _funcaoController,
                          label: 'Função',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Campo obrigatório'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text("Cancelar"),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _salvarFuncionario(context),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      enabled: !_isLoading,
      decoration: InputDecoration(
        label: Text(label),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

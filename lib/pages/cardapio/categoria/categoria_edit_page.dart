import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_order/models/cardapio/categoria.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';

class CategoriaEditPage extends StatefulWidget {
  const CategoriaEditPage({this.categoria, super.key});
  final Categoria? categoria;

  @override
  State<CategoriaEditPage> createState() => _CategoriaEditPageState();
}

class _CategoriaEditPageState extends State<CategoriaEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController =
        TextEditingController(text: widget.categoria?.titulo ?? '');
    _descricaoController =
        TextEditingController(text: widget.categoria?.descricao ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarCategoria(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final categoriaAtualizada = Categoria(
        id: widget.categoria?.id,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
      );

      final categoriaServices =
          Provider.of<CategoriaServices>(context, listen: false);

      await categoriaServices.updateCategoria(categoriaAtualizada);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria atualizada com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar categoria: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Categoria"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Consumer<CategoriaServices>(
          builder: (context, categoriaServices, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Editando Categoria",
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 32, 3),
                        fontSize: 28,
                        fontFamily: 'Lustria',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      controller: _tituloController,
                      label: 'Titulo',
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _descricaoController,
                      label: 'Descrição',
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () => _salvarCategoria(context),
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
              ),
            );
          },
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

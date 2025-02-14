import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_order/commons/custom_textformfield.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
import 'package:self_order/services/cardapio/produto_services.dart';

class ProdutoAddPage extends StatefulWidget {
  const ProdutoAddPage({super.key});

  @override
  State<ProdutoAddPage> createState() => _ProdutoAddPageState();
}

class _ProdutoAddPageState extends State<ProdutoAddPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProdutoServices produtoServices = ProdutoServices();
  final CategoriaServices categoriaServices = CategoriaServices();
  final ImagePicker picker = ImagePicker();

  // Form controllers
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController unidadeController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  // State variables
  Produto produto = Produto();
  String selectedCategoria = '';
  File? photoFile;
  Uint8List webImage = Uint8List(0);

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    precoController.dispose();
    marcaController.dispose();
    unidadeController.dispose();
    quantidadeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 100,
        maxHeight: 100,
      );

      if (image == null) return;

      if (kIsWeb) {
        final imageBytes = await image.readAsBytes();
        setState(() {
          webImage = imageBytes;
          photoFile = File('placeholder');
        });
      } else {
        setState(() {
          photoFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao selecionar imagem')),
      );
    }
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeria'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Câmera'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelector() {
    return InkWell(
      onTap: _showImageSourceSelector,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: _buildImagePreview(),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (photoFile == null || (kIsWeb && webImage.isEmpty)) {
      return DottedBorder(
        dashPattern: const [6],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        color: Colors.red,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_outlined, color: Colors.red, size: 60),
              Text("Foto", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: kIsWeb
          ? Image.memory(webImage, fit: BoxFit.cover)
          : Image.file(photoFile!, fit: BoxFit.cover),
    );
  }

  Future<void> _saveProduto() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    try {
      final ok = await produtoServices.save(
        produto: produto,
        imageFile: kIsWeb ? webImage : photoFile,
        plat: kIsWeb,
      );

      if (!mounted) return;

      if (ok) {
        _showSaveSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar produto')),
      );
    }
  }

  void _resetForm() {
    // Limpa todos os controllers
    nomeController.clear();
    descricaoController.clear();
    precoController.clear();
    marcaController.clear();
    unidadeController.clear();
    quantidadeController.clear();

    // Reseta o state
    setState(() {
      photoFile = null;
      webImage = Uint8List(0);
      selectedCategoria = '';
      produto = Produto(); // Cria uma nova instância limpa do produto
    });

    // Reseta o formulário
    formKey.currentState?.reset();
  }

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sucesso!'),
        content: const Text('Deseja cadastrar outro produto?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              _resetForm(); // Limpa todos os campos
            },
            child: const Text('Sim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              Navigator.pop(context); // Fecha a página de cadastro
            },
            child: const Text('Não'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        title: const Text(
          'Adicionar Produto',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: _getResponsivePadding(context),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildImageSelector(),
                        const SizedBox(height: 16),
                        _buildFormFields(),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
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

  EdgeInsets _getResponsivePadding(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return const EdgeInsets.all(80);
    } else if (Responsive.isTablet(context)) {
      return const EdgeInsets.all(70);
    }
    return const EdgeInsets.all(40);
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomTextFormField(
          enabled: true,
          controller: nomeController,
          labelText: const Text("Nome do produto"),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Campo obrigatório';
            return null;
          },
          onSaved: (value) => produto.nome = value,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          enabled: true,
          controller: marcaController,
          labelText: const Text("Marca"),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Campo obrigatório';
            return null;
          },
          onSaved: (value) => produto.marca = value,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          enabled: true,
          controller: descricaoController,
          labelText: const Text("Descrição"),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Campo obrigatório';
            return null;
          },
          onSaved: (value) => produto.descricao = value,
        ),
        const SizedBox(height: 16),
        _buildCategoriaDropdown(),
        const SizedBox(height: 16),
        CustomTextFormField(
          enabled: true,
          controller: unidadeController,
          labelText: const Text("Unidade"),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Campo obrigatório';
            return null;
          },
          onSaved: (value) => produto.unidade = value!,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          enabled: true,

          controller: quantidadeController,
          labelText: const Text("Quantidade"),
          //keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Campo obrigatório';
            if (int.tryParse(value!) == null) return 'Digite um número válido';
            return null;
          },
          onSaved: (value) => produto.quantidade = int.parse(value!),
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          enabled: true,

          controller: precoController,
          labelText: const Text("Preço do produto"),
          // keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Campo obrigatório';
            if (double.tryParse(value!) == null) {
              return 'Digite um valor válido';
            }
            return null;
          },
          onSaved: (value) => produto.preco = double.parse(value!),
        ),
      ],
    );
  }

  Widget _buildCategoriaDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoriaServices.getCategorias(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final categorias = snapshot.data!.docs.map((doc) {
          return DropdownMenuItem<String>(
            value: doc.id,
            child: Text(
              doc.get('titulo'),
              style: const TextStyle(color: Color(0xff1c313a)),
            ),
          );
        }).toList();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonFormField<String>(
            items: categorias,
            value: selectedCategoria.isEmpty ? null : selectedCategoria,
            hint: const Text("Escolha a categoria do produto"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione uma categoria';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                selectedCategoria = value!;
                produto.idCategoria = value;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveProduto,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

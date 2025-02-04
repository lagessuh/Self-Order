// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:self_order/models/cardapio/produto.dart';
// import 'package:self_order/services/cardapio/produto_services.dart';

// class ProdutoEditPage extends StatefulWidget {
//   final Produto produto;

//   const ProdutoEditPage({super.key, required this.produto});

//   @override
//   _ProdutoEditPageState createState() => _ProdutoEditPageState();
// }

// class _ProdutoEditPageState extends State<ProdutoEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();
//   File? _imagemSelecionada;
//   late TextEditingController _nomeController;
//   late TextEditingController _descricaoController;
//   late TextEditingController _marcaController;
//   late TextEditingController _precoController;
//   late TextEditingController _quantidadeController;
//   late TextEditingController _unidadeController;

//   @override
//   void initState() {
//     super.initState();
//     _nomeController = TextEditingController(text: widget.produto.nome);
//     _descricaoController =
//         TextEditingController(text: widget.produto.descricao);
//     _marcaController = TextEditingController(text: widget.produto.marca);
//     _precoController =
//         TextEditingController(text: widget.produto.preco?.toString());
//     _quantidadeController =
//         TextEditingController(text: widget.produto.quantidade?.toString());
//     _unidadeController = TextEditingController(text: widget.produto.unidade);
//   }

//   @override
//   void dispose() {
//     _nomeController.dispose();
//     _descricaoController.dispose();
//     _marcaController.dispose();
//     _precoController.dispose();
//     _quantidadeController.dispose();
//     _unidadeController.dispose();
//     super.dispose();
//   }

//   Future<void> _selecionarImagem() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _imagemSelecionada = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String?> _uploadImagem(File imagem) async {
//     try {
//       String caminho = 'produtos/${widget.produto.id}.jpg';
//       final ref = FirebaseStorage.instance.ref().child(caminho);
//       await ref.putFile(imagem);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       if (kDebugMode) {
//         print("Erro ao fazer upload da imagem: $e");
//       }
//       return null;
//     }
//   }

//   Future<void> _salvarProduto() async {
//     if (_formKey.currentState!.validate()) {
//       String? urlImagem = widget.produto.url;

//       if (_imagemSelecionada != null) {
//         urlImagem = await _uploadImagem(_imagemSelecionada!);
//       }

//       final produtoAtualizado = {
//         "nome": _nomeController.text,
//         "descricao": _descricaoController.text,
//         "marca": _marcaController.text,
//         "preco": double.tryParse(_precoController.text),
//         "quantidade": int.tryParse(_quantidadeController.text),
//         "unidade": _unidadeController.text,
//         "url": urlImagem,
//       };

//       await FirebaseFirestore.instance
//           .collection('produtos')
//           .doc(widget.produto.id)
//           .update(produtoAtualizado);

//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Editar Produto")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               GestureDetector(
//                 onTap: _selecionarImagem,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _imagemSelecionada != null
//                       ? FileImage(_imagemSelecionada!)
//                       : (widget.produto.url != null
//                           ? NetworkImage(widget.produto.url!) as ImageProvider
//                           : const AssetImage('assets/no-image.png')),
//                   child:
//                       _imagemSelecionada == null && widget.produto.url == null
//                           ? const Icon(Icons.camera_alt,
//                               size: 40, color: Colors.grey)
//                           : null,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 initialValue: ProdutoServices.produto!.socialMedia,
//                 controller: _nomeController,
//                 decoration: const InputDecoration(labelText: "Nome"),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Campo obrigatório" : null,
//               ),
//               TextFormField(
//                 controller: _descricaoController,
//                 decoration: const InputDecoration(labelText: "Descrição"),
//               ),
//               TextFormField(
//                 controller: _marcaController,
//                 decoration: const InputDecoration(labelText: "Marca"),
//               ),
//               TextFormField(
//                 controller: _precoController,
//                 decoration: const InputDecoration(labelText: "Preço"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextFormField(
//                 controller: _quantidadeController,
//                 decoration: const InputDecoration(labelText: "Quantidade"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextFormField(
//                 controller: _unidadeController,
//                 decoration: const InputDecoration(labelText: "Unidade"),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _salvarProduto,
//                 child: const Text("Salvar"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/commons/mypicked_image.dart';
// import 'package:self_order/models/cardapio/produto.dart';
// import 'package:self_order/services/cardapio/produto_services.dart';

// class ProdutoEditPage extends StatefulWidget {
//   const ProdutoEditPage({this.produto, super.key});
//   final Produto? produto;

//   @override
//   State<ProdutoEditPage> createState() => _ProdutoEditPageState();
// }

// class _ProdutoEditPageState extends State<ProdutoEditPage> {
//   @override
//   Widget build(BuildContext context) {
//     bool imageUpdate = false;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Editar Produto"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Consumer2<ProdutoServices, MyPickedImage>(
//           builder: (context, produtoServices, myPickedImage, child) {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   const Text(
//                     "Editando Produto",
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 2, 32, 3),
//                       fontSize: 28,
//                       fontFamily: 'Lustria',
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       bool picked = await Provider.of<MyPickedImage>(context,
//                               listen: false)
//                           .myPickedImage();
//                       setState(() {
//                         imageUpdate = picked;
//                       });
//                     },
//                     child: imageUpdate & kIsWeb
//                         ? Consumer<MyPickedImage>(
//                             builder: (context, myPickedImage, child) {
//                               if (kIsWeb) {
//                                 return ClipOval(
//                                   child: Image.memory(
//                                     myPickedImage.webImage!,
//                                     height: 150,
//                                     width: 150,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 );
//                               } else {
//                                 return ClipOval(
//                                   child: Image.file(
//                                     myPickedImage.pickImage!,
//                                     height: 150,
//                                     width: 150,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 );
//                               }
//                             },
//                           )
//                         : ClipOval(
//                             child: Image.network(
//                               widget.produto?.image ?? 'URL_DA_IMAGEM_PADRÃO',
//                               height: 150,
//                               width: 150,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   TextFormField(
//                     initialValue: widget.produto?.nome,
//                     decoration: InputDecoration(
//                       label: const Text('Nome'),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.5),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     initialValue: widget.produto?.descricao,
//                     decoration: InputDecoration(
//                       label: const Text('Descrição'),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.5),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     initialValue: widget.produto?.marca,
//                     decoration: InputDecoration(
//                       label: const Text('Marca'),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.5),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     initialValue: widget.produto?.preco.toString() ?? 'R\$',
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       label: const Text('Preço'),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.5),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     initialValue: widget.produto?.unidade,
//                     decoration: InputDecoration(
//                       label: const Text('Unidade'),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.5),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     initialValue: widget.produto?.quantidade.toString() ?? '',
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       label: const Text('Quantidade'),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(width: 1.5),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(width: 1.5),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(
//                               context); // Cancela e volta à tela anterior
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red),
//                         child: const Text("Cancelar"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Aqui você pode salvar as alterações
//                           produtoServices.updateProduto(widget.produto);
//                           Navigator.pop(
//                               context); // Salva e volta à tela anterior
//                         },
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green),
//                         child: const Text("Salvar"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:self_order/commons/mypicked_image.dart';
// import 'package:self_order/models/cardapio/produto.dart';
// import 'package:self_order/services/cardapio/produto_services.dart';

// class ProdutoEditPage extends StatefulWidget {
//   const ProdutoEditPage({this.produto, super.key});
//   final Produto? produto;

//   @override
//   State<ProdutoEditPage> createState() => _ProdutoEditPageState();
// }

// class _ProdutoEditPageState extends State<ProdutoEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nomeController;
//   late TextEditingController _descricaoController;
//   late TextEditingController _marcaController;
//   late TextEditingController _precoController;
//   late TextEditingController _unidadeController;
//   late TextEditingController _quantidadeController;
//   bool _isLoading = false;
//   bool _imageUpdate = false;

//   @override
//   void initState() {
//     super.initState();
//     _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
//     _descricaoController =
//         TextEditingController(text: widget.produto?.descricao ?? '');
//     _marcaController = TextEditingController(text: widget.produto?.marca ?? '');
//     _precoController =
//         TextEditingController(text: widget.produto?.preco?.toString() ?? '');
//     _unidadeController =
//         TextEditingController(text: widget.produto?.unidade ?? '');
//     _quantidadeController = TextEditingController(
//         text: widget.produto?.quantidade?.toString() ?? '');
//   }

//   @override
//   void dispose() {
//     _nomeController.dispose();
//     _descricaoController.dispose();
//     _marcaController.dispose();
//     _precoController.dispose();
//     _unidadeController.dispose();
//     _quantidadeController.dispose();
//     super.dispose();
//   }

//   Future<void> _salvarProduto(
//       BuildContext context, MyPickedImage myPickedImage) async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final produtoAtualizado = Produto(
//         id: widget.produto?.id,
//         nome: _nomeController.text,
//         descricao: _descricaoController.text,
//         marca: _marcaController.text,
//         preco: double.tryParse(_precoController.text) ?? 0.0,
//         unidade: _unidadeController.text,
//         quantidade: int.tryParse(_quantidadeController.text) ?? 0,
//         image: widget.produto?.image,
//       );

//       final produtoServices =
//           Provider.of<ProdutoServices>(context, listen: false);

//       if (_imageUpdate && myPickedImage.webImage != null) {
//         // Se houver uma nova imagem, primeiro faz o upload
//         await produtoServices.save(
//           produto: produtoAtualizado,
//           imageFile: kIsWeb ? myPickedImage.webImage : myPickedImage.pickImage,
//           plat: kIsWeb,
//         );
//       } else {
//         // Se não houver nova imagem, apenas atualiza os dados
//         await produtoServices.updateProduto(produtoAtualizado);
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Produto atualizado com sucesso!')),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erro ao atualizar produto: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Editar Produto"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Consumer2<ProdutoServices, MyPickedImage>(
//           builder: (context, produtoServices, myPickedImage, child) {
//             return Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 50),
//                     const Text(
//                       "Editando Produto",
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 2, 32, 3),
//                         fontSize: 28,
//                         fontFamily: 'Lustria',
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     GestureDetector(
//                       onTap: _isLoading
//                           ? null
//                           : () async {
//                               bool picked = await myPickedImage.myPickedImage();
//                               setState(() => _imageUpdate = picked);
//                             },
//                       child: _imageUpdate && kIsWeb
//                           ? ClipOval(
//                               child: Image.memory(
//                                 myPickedImage.webImage!,
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                           : ClipOval(
//                               child: Image.network(
//                                 widget.produto?.image ?? 'URL_DA_IMAGEM_PADRÃO',
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Icon(Icons.image, size: 150),
//                               ),
//                             ),
//                     ),
//                     const SizedBox(height: 30),
//                     _buildTextField(
//                       controller: _nomeController,
//                       label: 'Nome',
//                       validator: (value) =>
//                           value?.isEmpty ?? true ? 'Campo obrigatório' : null,
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                       controller: _descricaoController,
//                       label: 'Descrição',
//                       validator: (value) =>
//                           value?.isEmpty ?? true ? 'Campo obrigatório' : null,
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                       controller: _marcaController,
//                       label: 'Marca',
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                       controller: _precoController,
//                       label: 'Preço',
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value?.isEmpty ?? true) return 'Campo obrigatório';
//                         if (double.tryParse(value!) == null)
//                           return 'Digite um número válido';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                       controller: _unidadeController,
//                       label: 'Unidade',
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                       controller: _quantidadeController,
//                       label: 'Quantidade',
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value?.isEmpty ?? true) return 'Campo obrigatório';
//                         if (int.tryParse(value!) == null)
//                           return 'Digite um número inteiro';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed:
//                               _isLoading ? null : () => Navigator.pop(context),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red),
//                           child: const Text("Cancelar"),
//                         ),
//                         ElevatedButton(
//                           onPressed: _isLoading
//                               ? null
//                               : () => _salvarProduto(context, myPickedImage),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green),
//                           child: _isLoading
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                       color: Colors.white),
//                                 )
//                               : const Text("Salvar"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       validator: validator,
//       enabled: !_isLoading,
//       decoration: InputDecoration(
//         label: Text(label),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:self_order/commons/mypicked_image.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';
import 'package:self_order/services/cardapio/produto_services.dart';

class ProdutoEditPage extends StatefulWidget {
  const ProdutoEditPage({this.produto, super.key});
  final Produto? produto;

  @override
  State<ProdutoEditPage> createState() => _ProdutoEditPageState();
}

class _ProdutoEditPageState extends State<ProdutoEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _marcaController;
  late TextEditingController _precoController;
  late TextEditingController _unidadeController;
  late TextEditingController _quantidadeController;
  bool _isLoading = false;
  bool _imageUpdate = false;
  late String selectedCategoria;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.produto?.nome ?? '');
    _descricaoController =
        TextEditingController(text: widget.produto?.descricao ?? '');
    _marcaController = TextEditingController(text: widget.produto?.marca ?? '');
    _precoController =
        TextEditingController(text: widget.produto?.preco?.toString() ?? '');
    _unidadeController =
        TextEditingController(text: widget.produto?.unidade ?? '');
    _quantidadeController = TextEditingController(
        text: widget.produto?.quantidade?.toString() ?? '');
    selectedCategoria = widget.produto?.idCategoria ?? '';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _marcaController.dispose();
    _precoController.dispose();
    _unidadeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  Widget _buildCategoriaDropdown(CategoriaServices categoriaServices) {
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
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      selectedCategoria = value!;
                    });
                  },
          ),
        );
      },
    );
  }

  Future<void> _salvarProduto(
      BuildContext context, MyPickedImage myPickedImage) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final produtoAtualizado = Produto(
        id: widget.produto?.id,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        marca: _marcaController.text,
        preco: double.tryParse(_precoController.text) ?? 0.0,
        unidade: _unidadeController.text,
        quantidade: int.tryParse(_quantidadeController.text) ?? 0,
        image: widget.produto?.image,
        idCategoria: selectedCategoria, // Mantendo a categoria
      );

      final produtoServices =
          Provider.of<ProdutoServices>(context, listen: false);

      if (_imageUpdate && myPickedImage.webImage != null) {
        // Se houver uma nova imagem, primeiro faz o upload
        await produtoServices.save(
          produto: produtoAtualizado,
          imageFile: kIsWeb ? myPickedImage.webImage : myPickedImage.pickImage,
          plat: kIsWeb,
        );
      } else {
        // Se não houver nova imagem, apenas atualiza os dados
        await produtoServices.updateProduto(produtoAtualizado);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar produto: $e')),
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
        title: const Text("Editar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Consumer3<ProdutoServices, MyPickedImage, CategoriaServices>(
          builder: (context, produtoServices, myPickedImage, categoriaServices,
              child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "Editando Produto",
                      style: TextStyle(
                        color: Color.fromARGB(255, 2, 32, 3),
                        fontSize: 28,
                        fontFamily: 'Lustria',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () async {
                              bool picked = await myPickedImage.myPickedImage();
                              setState(() => _imageUpdate = picked);
                            },
                      child: _imageUpdate && kIsWeb
                          ? ClipOval(
                              child: Image.memory(
                                myPickedImage.webImage!,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                widget.produto?.image ?? 'URL_DA_IMAGEM_PADRÃO',
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image, size: 150),
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                    _buildCategoriaDropdown(
                        categoriaServices), // Adicionado aqui
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _nomeController,
                      label: 'Nome',
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
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _marcaController,
                      label: 'Marca',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _precoController,
                      label: 'Preço',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Campo obrigatório';
                        if (double.tryParse(value!) == null) {
                          return 'Digite um número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _unidadeController,
                      label: 'Unidade',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _quantidadeController,
                      label: 'Quantidade',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Campo obrigatório';
                        if (int.tryParse(value!) == null) {
                          return 'Digite um número inteiro';
                        }
                        return null;
                      },
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
                              : () => _salvarProduto(context, myPickedImage),
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

//import 'dart:io';

//import 'package:dotted_border/dotted_border.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_order/models/cardapio/categoria.dart';
import 'package:self_order/services/cardapio/categoria/categoria_services.dart';

class CategoriaAddPage extends StatefulWidget {
  const CategoriaAddPage({super.key});

  @override
  State<CategoriaAddPage> createState() => _CategoriaAddPageState();
}

class _CategoriaAddPageState extends State<CategoriaAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Categoria categoria = Categoria();
  //para armazenar imagens da câmera
  //File? _photo;
  //para armazenar imagens da galeria para ser utilizar no browser
  //Uint8List webImage = Uint8List(8);
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).highlightColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            const Text(
              "Cadastro de Categorias",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black54,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width > 650
                  ? 650
                  : MediaQuery.of(context).size.width,
              color: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Título da categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (titulo) {
                        if (titulo!.isEmpty) {
                          return 'Campo deve ser preenchido!!!';
                        }
                        return null;
                      },
                      onSaved: (titulo) => categoria.titulo = titulo,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Descrição do Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (descricao) {
                        if (descricao!.isEmpty) {
                          return 'Campo deve ser preenchido!!!';
                        }
                        return null;
                      },
                      onSaved: (descricao) => categoria.descricao = descricao,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //código para obtenção da imagem e envio para o Firebase
                    // Container(
                    //   width: MediaQuery.of(context).size.width > 650
                    //       ? 500
                    //       : MediaQuery.of(context).size.width * 0.90,
                    //   height: MediaQuery.of(context).size.width > 650
                    //       ? 350
                    //       : MediaQuery.of(context).size.width * 0.45,
                    //   decoration: BoxDecoration(
                    //     color: Theme.of(context).scaffoldBackgroundColor,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: _photo == null || webImage.isEmpty
                    //       ? dottedBorder(color: Colors.blue)
                    //       : Card(
                    //           elevation: 1.5,
                    //           color: Theme.of(context).scaffoldBackgroundColor,
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(12),
                    //             child: kIsWeb
                    //                 ? Image.memory(webImage)
                    //                 : Image.file(_photo!),
                    //           ),
                    //         ),
                    // ),
                    //Fim do código de upload de imagem
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                CategoriaServices categoriaServices =
                                    CategoriaServices();
                                categoriaServices.add(categoria: categoria);
                                //imageFile: kIsWeb ? webImage : _photo,
                                //plat: kIsWeb);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                              "Dados gravados com sucesso!!!")));
                                  _formKey.currentState!.reset();
                                  // Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content:
                                          Text("Problemas ao gravar dados!!!"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Salvar"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// //rotina para desenhar o pontilhado na tela
//   Widget dottedBorder({required Color color}) {
//     return DottedBorder(
//       dashPattern: const [6],
//       borderType: BorderType.RRect,
//       radius: const Radius.circular(10),
//       color: color,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.image_outlined,
//               color: color,
//               size: 80,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             TextButton(
//                 onPressed: () {
//                   _pickImage();
//                 },
//                 child: Text(
//                   "Escolha uma Imagem para o produto",
//                   style: TextStyle(color: color),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Wrap(
//           children: [
//             ListTile(
//               onTap: () {
//                 imageFromGallery();
//                 Navigator.of(context).pop();
//               },
//               leading: const Icon(Icons.photo_library),
//               title: const Text(
//                 'Galeria',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 1, 17, 1),
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             const Divider(),
//             ListTile(
//               onTap: () {
//                 imageFromCamera();
//                 Navigator.of(context).pop();
//               },
//               leading: const Icon(Icons.photo_camera),
//               title: const Text(
//                 'Câmera',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 1, 17, 1),
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   //obtendo imagem da galeria
//   Future imageFromGallery() async {
//     //condição para obter imagem do dispositivo móvel
//     if (!kIsWeb) {
//       XFile? image = await picker.pickImage(
//           source: ImageSource.gallery, maxWidth: 100, maxHeight: 100);
//       if (image != null) {
//         var imageSelected = File(image.path);
//         setState(() {
//           _photo = imageSelected;
//         });
//       }
//     } else if (kIsWeb) {
//       XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         var imageSelected =
//             await image.readAsBytes(); //converte a imagem para bytes
//         setState(() {
//           webImage = imageSelected;
//           _photo = File('a');
//         });
//       } else {
//         debugPrint('nenhuma imagem foi selecionada');
//       }
//     } else {
//       debugPrint('Algo errado aconteceu');
//     }
//   }

//   //obtendo imagem da camera
//   Future imageFromCamera() async {
//     //condição para obter imagem do dispositivo móvel
//     if (!kIsWeb) {
//       XFile? image = await picker.pickImage(
//           source: ImageSource.camera, maxWidth: 100, maxHeight: 100);
//       if (image != null) {
//         var imageSelected = File(image.path);
//         setState(() {
//           _photo = imageSelected;
//         });
//       }
//     } else if (kIsWeb) {
//       XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         var imageSelected =
//             await image.readAsBytes(); //converte a imagem para bytes
//         setState(() {
//           webImage = imageSelected;
//           _photo = File('a');
//         });
//       } else {
//         debugPrint('nenhuma imagem foi selecionada');
//       }
//     } else {
//       debugPrint('Algo errado aconteceu');
//     }
//   }
}

import 'package:flutter/material.dart';
import 'package:self_order/commons/responsive.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.red, // Cor do AppBar
        title: const Text(
          'Cadastro de Categorias',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
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
                // const SizedBox(
                //   height: 35,
                // ),
                // const Text(
                //   "Cadastro de Categorias",
                //   style: TextStyle(
                //     fontSize: 30,
                //     color: Colors.white,
                //   ),
                // ),
                // const SizedBox(
                //   height: 25,
                // ),
                Container(
                  // width: MediaQuery.of(context).size.width > 650
                  //     ? 650
                  //     : MediaQuery.of(context).size.width,
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
                            hintText: 'Descrição da Categoria',
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
                          onSaved: (descricao) =>
                              categoria.descricao = descricao,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Dados gravados com sucesso!!!")));
                                      _formKey.currentState!.reset();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              "Problemas ao gravar dados!!!"),
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
        ),
      ),
    );
  }
}

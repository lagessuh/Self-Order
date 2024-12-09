import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CategoryModel? categorySelected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox(
            width: 1000,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CategoryDropdownButton(callback: (CategoryModel category) {
                    setState(() {
                      categorySelected = category;
                    });
                  }),
                  (categorySelected == null)
                      ? Container()
                      : Text(
                          "Categoria selecionada: ${categorySelected!.id} - ${categorySelected!.name}")
                ])),
      ),
    );
  }
}

class CategoryDropdownButton extends StatefulWidget {
  const CategoryDropdownButton({super.key, this.callback});

  final Function(CategoryModel)? callback;

  @override
  _CategoryDropdownButtonState createState() => _CategoryDropdownButtonState();
}

class _CategoryDropdownButtonState extends State<CategoryDropdownButton> {
  CategoryModel? category;

  List<CategoryModel> categories = [
    CategoryModel(id: 1, name: "Chás", description: "Chás de todos os tipos"),
    CategoryModel(id: 2, name: "Cafés", description: "Cafés de todos os tipos"),
    CategoryModel(id: 3, name: "Pães", description: "Levains e não levains"),
    CategoryModel(id: 4, name: "Doces", description: "Doces de todos os tipos"),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: category!.id,
      hint: const Text("Selecione a categori",
          style: TextStyle(color: Colors.deepPurple)),
      icon: const RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.chevron_right, color: Colors.deepPurple)),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurple,
      ),
      onChanged: (int? idSelected) {
        setState(() {
          category =
              categories.firstWhere((category) => category.id == idSelected);
        });
        widget.callback!(category!);
      },
      items: categories.map<DropdownMenuItem<int>>((CategoryModel category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name!),
        );
      }).toList(),
    );
  }
}

class CategoryModel {
  CategoryModel({this.id, this.name, this.description});

  int? id;
  String? name;
  String? description;
}

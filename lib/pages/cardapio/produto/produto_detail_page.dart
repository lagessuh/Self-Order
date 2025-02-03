import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:self_order/commons/customized_elevated_button.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/models/cardapio/produto.dart';
import 'package:self_order/pages/carrinho/carrinho_page.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';

class ProdutoDetailPage extends StatefulWidget {
  const ProdutoDetailPage({required this.produto, super.key});
  final Produto produto;

  @override
  State<ProdutoDetailPage> createState() => _ProdutoDetailPageState();
}

class _ProdutoDetailPageState extends State<ProdutoDetailPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int? countControllerValue = 1;
  // Initial Selected Value
  String quantity = '1';

  // List of items in our dropdown menu
  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  String selectedValue = "1";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Detalhes do Produto",
          style: TextStyle(
            color: const Color.fromARGB(255, 1, 17, 1),
            fontSize: Responsive.isDesktop(context)
                ? 22
                : Responsive.isTablet(context)
                    ? 20
                    : 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Consumer<CarrinhoServices>(
            builder: (context, carrinhoServices, child) {
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 24, 0),
                child: GestureDetector(
                  onTap: () {
                    if (carrinhoServices.itens.isNotEmpty) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const CarrinhoPage() //CartPage2(),
                          ));
                    }
                  },
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 36,
                      ),
                      if (carrinhoServices.itens.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 4.0, bottom: 8.0),
                          child: CircleAvatar(
                            radius: 8.0,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            child: Text(
                              carrinhoServices.itens.length.toString(),
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: constraints.maxWidth > 700
                    ? EdgeInsets.only(
                        top: 30.0,
                        left: MediaQuery.of(context).size.width * .1,
                        right: MediaQuery.of(context).size.width * .1)
                    : const EdgeInsets.only(top: 15.0, left: 40, right: 40),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 30, left: 15, right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.black12, //
                      )),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.produto.image!,
                          height: constraints.maxWidth > 1100
                              ? 700
                              : constraints.maxWidth > 800
                                  ? 600
                                  : 300,
                          width: constraints.maxWidth > 1100
                              ? 700
                              : constraints.maxWidth > 800
                                  ? 600
                                  : 300,
                          fit: BoxFit.contain,
                          isAntiAlias: true,
                          // filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.produto.nome!,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.lexendDeca(
                          color: const Color(0xFF151B1E),
                          fontSize: constraints.maxWidth > 700 ? 22 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'R\$ ${widget.produto.preco.toString()}',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.lexendDeca(
                          color: const Color(0xFF151B1E),
                          fontSize: constraints.maxWidth > 700 ? 22 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informações do Produto:',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lexendDeca(
                              color: const Color(0xFF151B1E),
                              fontSize: constraints.maxWidth > 700 ? 20 : 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            widget.produto.descricao!,
                            style: GoogleFonts.lexendDeca(
                              color: const Color(0xFF151B1E),
                              fontSize: constraints.maxWidth > 700 ? 20 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     CountController(
                          //       decrementIconBuilder: (enabled) => Icon(
                          //         Icons.remove_circle_outline,
                          //         size: constraints.maxWidth > 1100
                          //             ? 50
                          //             : constraints.maxWidth > 700
                          //                 ? 40
                          //                 : 30,
                          //         color: enabled ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                          //       ),
                          //       incrementIconBuilder: (enabled) => Icon(
                          //         Icons.add_circle_outline,
                          //         size: constraints.maxWidth > 1100
                          //             ? 50
                          //             : constraints.maxWidth > 700
                          //                 ? 40
                          //                 : 30,
                          //         color: enabled ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                          //       ),
                          //       countBuilder: (count) => Text(
                          //         count.toString(),
                          //         style: Theme.of(context).textTheme.displaySmall,
                          //       ),
                          //       count: countControllerValue ?? 1,
                          //       min: 1,
                          //       updateCount: (count) => setState(
                          //         () => countControllerValue = count,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Container(
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            child: DropdownButton(
                              // Initial Value
                              value: quantity,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    width: 250,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(items),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  quantity = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomizedElevatedButton(
                            icon: const Icon(Icons.shopping_cart),
                            text: 'Adicionar no Carrinho',
                            onPressed: () {
                              Produto produto = widget.produto;
                              produto.quantidade =
                                  int.parse(quantity); //countControllerValue;
                              context
                                  .read<CarrinhoServices>()
                                  .addItemToCart(produto, int.parse(quantity));
                            },
                            options: ButtonOptions(
                              width: constraints.maxWidth > 1100
                                  ? 450
                                  : constraints.maxWidth > 800
                                      ? 350
                                      : 300,
                              height: constraints.maxWidth > 1100
                                  ? 80
                                  : constraints.maxWidth > 800
                                      ? 70
                                      : 50,
                              color: Theme.of(context).primaryColor,
                              textStyle: GoogleFonts.poppins(
                                  fontSize: constraints.maxWidth > 1100
                                      ? 55
                                      : constraints.maxWidth > 800
                                          ? 45
                                          : 30,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

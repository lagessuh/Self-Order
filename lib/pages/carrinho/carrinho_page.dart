import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:self_order/commons/responsive.dart';
import 'package:self_order/pages/carrinho/carrinho_vazio_card.dart';
import 'package:self_order/pages/carrinho/checkout_page.dart';
import 'package:self_order/services/carrinho/carrinho_services.dart';
import 'package:self_order/services/users/users_services.dart';

import '../../commons/count_controller.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  int? countControllerValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Carrinho"),
            // ClipOval(
            //   child: Image.network(
            //     usersServices.userModel!.image!,
            //     height: 40,
            //     width: 40,
            //     fit: BoxFit.fill,
            //   ),
            // ),
          ],
        ),
      ),
      body: Consumer2<UsersServices, CarrinhoServices>(
          builder: (context, usersServices, carrinhoServices, child) {
        if (carrinhoServices.itens.isEmpty) {
          return const CarrinhoVazioCard(
            title: 'Carrinho vazio',
            iconData: Icons.shopping_cart_checkout_sharp,
          ); //Text("Não há produtos no carrinho");
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: carrinhoServices.itens.length,
                    itemBuilder: (context, int index) {
                      final item = carrinhoServices.itens[index];
                      return Padding(
                        padding: Responsive.isDesktop(context)
                            ? const EdgeInsetsDirectional.fromSTEB(
                                100.0, 48, 100, 20)
                            : Responsive.isTablet(context)
                                ? const EdgeInsetsDirectional.fromSTEB(
                                    80.0, 5, 80, 10)
                                : const EdgeInsetsDirectional.fromSTEB(
                                    50.0, 5, 50, 10),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: Responsive.isDesktop(context)
                                ? const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 20)
                                : Responsive.isTablet(context)
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 15)
                                    : const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                          width: Responsive.isDesktop(context)
                                              ? 200
                                              : Responsive.isTablet(context)
                                                  ? 170
                                                  : 80,
                                          height: Responsive.isDesktop(context)
                                              ? 200
                                              : Responsive.isTablet(context)
                                                  ? 150
                                                  : 80,
                                          carrinhoServices.itens[index].produto!
                                              .image! //item.product!.image!,

                                          ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              carrinhoServices
                                                  .itens[index]
                                                  .produto!
                                                  .nome!, //item.product!.name!,
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      Responsive.isDesktop(
                                                              context)
                                                          ? 20
                                                          : Responsive.isTablet(
                                                                  context)
                                                              ? 17
                                                              : 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black //Theme.of(context).primaryColor,
                                                  ),
                                            ),
                                            Text(
                                              'R\$ ${carrinhoServices.itens[index].produto!.preco!}', //'R\$ ${item.product!.price}',
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      Responsive.isDesktop(
                                                              context)
                                                          ? 20
                                                          : Responsive.isTablet(
                                                                  context)
                                                              ? 17
                                                              : 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .black //Theme.of(context).primaryColor,
                                                  ),
                                            ),
                                            Text(
                                              carrinhoServices
                                                  .itens[index]
                                                  .produto!
                                                  .descricao!, //'R\$ ${item.product!.price}',
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      Responsive.isDesktop(
                                                              context)
                                                          ? 18
                                                          : Responsive.isTablet(
                                                                  context)
                                                              ? 15
                                                              : 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors
                                                      .black //Theme.of(context).primaryColor,
                                                  ),
                                            ),
                                            // CountController(
                                            //   decrementIconBuilder: (enabled) => Icon(
                                            //     Icons.remove_circle_outline,
                                            //     size: MediaQuery.of(context).size.width > 1100
                                            //         ? 20
                                            //         : MediaQuery.of(context).size.width > 700
                                            //             ? 17
                                            //             : 15,
                                            //     color: enabled ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                                            //   ),
                                            //   incrementIconBuilder: (enabled) => Icon(
                                            //     Icons.add_circle_outline,
                                            //     size: MediaQuery.of(context).size.width > 1100
                                            //         ? 20
                                            //         : MediaQuery.of(context).size.width > 700
                                            //             ? 17
                                            //             : 15,
                                            //     color: enabled ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
                                            //   ),
                                            //   countBuilder: (count) => Text(
                                            //     count.toString(),
                                            //     style: Theme.of(context).textTheme.labelLarge,
                                            //   ),
                                            //   count: cart.items[index].quantity!, //item.quantity!,
                                            //   min: 1,
                                            //   updateCount: (count) => setState(
                                            //     () => cart.items[index].quantity = count, //item.quantity = count,
                                            //   ),
                                            // ),
                                            // Text(
                                            //   'Quantidade: ${item.quantity}',
                                            //   style: GoogleFonts.poppins(
                                            //     fontSize: Responsive.isDesktop(context)
                                            //         ? 27
                                            //         : Responsive.isTablet(context)
                                            //             ? 22
                                            //             : 18,
                                            //     fontWeight: FontWeight.bold,
                                            //     color: Theme.of(context).primaryColorDark,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          carrinhoServices.removeItem(item);
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: const Color.fromARGB(
                                              255, 104, 96, 96),
                                          size: Responsive.isDesktop(context)
                                              ? 35
                                              : Responsive.isTablet(context)
                                                  ? 30
                                                  : 25,
                                        ))
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CountController(
                                      decrementIconBuilder: (enabled) => Icon(
                                        Icons.remove_circle_outline,
                                        size:
                                            MediaQuery.of(context).size.width >
                                                    1100
                                                ? 20
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        700
                                                    ? 17
                                                    : 15,
                                        color: enabled
                                            ? Theme.of(context).primaryColorDark
                                            : Theme.of(context)
                                                .primaryColorLight,
                                      ),
                                      incrementIconBuilder: (enabled) => Icon(
                                        Icons.add_circle_outline,
                                        size:
                                            MediaQuery.of(context).size.width >
                                                    1100
                                                ? 20
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        700
                                                    ? 17
                                                    : 15,
                                        color: enabled
                                            ? Theme.of(context).primaryColorDark
                                            : Theme.of(context)
                                                .primaryColorLight,
                                      ),
                                      countBuilder: (count) => Text(
                                        count.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                      count: carrinhoServices.itens[index]
                                          .quantidade!, //item.quantity!,
                                      min: 1,
                                      updateCount: (count) => setState(() {
                                        carrinhoServices
                                            .itens[index].quantidade = count;
                                        carrinhoServices.itens[index].subTotal =
                                            carrinhoServices
                                                    .itens[index].quantidade! *
                                                carrinhoServices.itens[index]
                                                    .produto!.preco!;
                                      } //item.quantity = count,
                                          ),
                                    ),
                                    Text(
                                      'R\$ ${carrinhoServices.itens[index].subTotal!}',
                                      style: GoogleFonts.poppins(
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 20
                                                  : Responsive.isTablet(context)
                                                      ? 17
                                                      : 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .black //Theme.of(context).primaryColor,
                                          ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: Responsive.isDesktop(context)
                      ? const EdgeInsetsDirectional.fromSTEB(100.0, 48, 100, 48)
                      : Responsive.isTablet(context)
                          ? const EdgeInsetsDirectional.fromSTEB(
                              80.0, 20, 80, 20)
                          : const EdgeInsetsDirectional.fromSTEB(
                              50.0, 10, 50, 10),
                  child: const Divider(),
                ),
                Padding(
                  padding: Responsive.isDesktop(context)
                      ? const EdgeInsetsDirectional.fromSTEB(100.0, 48, 100, 48)
                      : Responsive.isTablet(context)
                          ? const EdgeInsetsDirectional.fromSTEB(
                              80.0, 20, 80, 20)
                          : const EdgeInsetsDirectional.fromSTEB(
                              50.0, 10, 50, 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total da compra: ${context.select((CarrinhoServices c) => c.totalPrice)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      // cart.saveCart(usersServices.userModel!);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const CartPage2(),
                      // ));
                      // Navigator.of(context).pushNamed('/checkout');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckoutPage(user: usersServices.userModel),
                        ),
                      );
                    },
                    child: Text(
                      "Fechar o pedido ( ${carrinhoServices.itens.length} )",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
        }
      }),
    );
  }
}

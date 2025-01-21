import 'dart:convert';
import 'package:self_order/models/cardapio/produto.dart';

class Item {
  Produto? produto;
  int? quantidade;
  double? subTotal;

  Item({
    this.produto,
    this.quantidade = 1,
    this.subTotal,
  }) {
    subTotal = produto!.price! * quantidade!;
  }

  Item copyWith({
    Produto? product,
    int? quantity,
    double? subTotal,
  }) {
    return Item(
      produto: product ?? produto,
      quantidade: quantity ?? quantidade,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (produto != null) {
      result.addAll({'product': produto!.toMap()});
    }
    if (quantidade != null) {
      result.addAll({'quantity': quantidade});
    }
    if (subTotal != null) {
      result.addAll({'subTotal': subTotal});
    }

    return result;
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      produto:
          map['product'] != null ? Produto.fromDocument(map['product']) : null,
      quantidade: map['quantity']?.toInt(),
      subTotal: map['subTotal']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartItem(product: $produto, quantity: $quantidade, subTotal: $subTotal)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.produto == produto &&
        other.quantidade == quantidade &&
        other.subTotal == subTotal;
  }

  @override
  int get hashCode =>
      produto.hashCode ^ quantidade.hashCode ^ subTotal.hashCode;
}

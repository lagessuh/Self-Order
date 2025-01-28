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
    subTotal = produto!.preco! * quantidade!;
  }

  Item copyWith({
    Produto? produto,
    int? quantidade,
    double? subTotal,
  }) {
    return Item(
      produto: produto ?? produto,
      quantidade: quantidade ?? quantidade,
      subTotal: subTotal ?? this.subTotal,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (produto != null) {
      result.addAll({'produto': produto!.toMap()});
    }
    if (quantidade != null) {
      result.addAll({'quantidade': quantidade});
    }
    if (subTotal != null) {
      result.addAll({'subTotal': subTotal});
    }

    return result;
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      produto:
          map['produto'] != null ? Produto.fromDocument(map['produto']) : null,
      quantidade: map['quantidade']?.toInt(),
      subTotal: map['subTotal']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() =>
      'CartItem(produto: $produto, quantidade: $quantidade, subTotal: $subTotal)';

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

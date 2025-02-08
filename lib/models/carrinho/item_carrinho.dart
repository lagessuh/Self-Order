import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/cardapio/produto.dart';

class ItemCarrinho {
  Produto? produto;
  int? quantidade;
  double? subTotal;

  ItemCarrinho({
    this.produto,
    this.quantidade = 1,
    this.subTotal,
  }) {
    subTotal = produto!.preco! * quantidade!;
  }

  ItemCarrinho copyWith({
    Produto? produto,
    int? quantidade,
    double? subTotal,
  }) {
    return ItemCarrinho(
      produto: produto ?? this.produto,
      quantidade: quantidade ?? this.quantidade,
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

  factory ItemCarrinho.fromMap(Map<String, dynamic> map) {
    try {
      return ItemCarrinho(
        produto: map['produto'] != null
            ? Produto.fromMap(Map<String, dynamic>.from(map['produto']))
            : null,
        quantidade: map['quantidade']?.toInt(),
        subTotal: map['subTotal']?.toDouble(),
      );
    } catch (e) {
      debugPrint('Error in ItemCarrinho.fromMap: $e');
      debugPrint('Map content: $map');
      rethrow;
    }
  }

  // factory ItemCarrinho.fromMap(Map<String, dynamic> map) {
  //   return ItemCarrinho(
  //     produto:
  //         map['produto'] != null ? Produto.fromDocument(map['produto']) : null,
  //     quantidade: map['quantidade']?.toInt(),
  //     subTotal: map['subTotal']?.toDouble(),
  //   );
  // }

  String toJson() => json.encode(toMap());

  factory ItemCarrinho.fromJson(String source) =>
      ItemCarrinho.fromMap(json.decode(source));

  @override
  String toString() =>
      'ItemCarrinho(produto: $produto, quantidade: $quantidade, subTotal: $subTotal)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemCarrinho &&
        other.produto == produto &&
        other.quantidade == quantidade &&
        other.subTotal == subTotal;
  }

  @override
  int get hashCode =>
      produto.hashCode ^ quantidade.hashCode ^ subTotal.hashCode;
}

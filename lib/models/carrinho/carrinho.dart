import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/carrinho/item_carrinho.dart';
import 'package:self_order/models/users/users.dart';

class Carrinho {
  UserModel? userModel;
  List<ItemCarrinho>? _itens;
  String? data; // dia do pedido
  String? status;

  Carrinho({
    this.userModel,
    List<ItemCarrinho>? itens,
    this.data,
    this.status,
  }) : _itens = itens;

  Carrinho copyWith(
      {UserModel? userModel,
      List<ItemCarrinho>? itens,
      String? data,
      String? status}) {
    return Carrinho(
      userModel: userModel ?? this.userModel,
      itens: itens ?? _itens,
      data: data,
      status: status,
    );
  }

  List<ItemCarrinho>? get itens => _itens;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userModel != null) {
      result.addAll({'userModel': userModel!.toJson()});
    }
    if (_itens != null) {
      result.addAll({'itens': _itens!.map((x) => x.toMap()).toList()});
    }
    if (data != null) {
      result.addAll({'data': data!});
    }
    if (status != null) {
      result.addAll({'status': status!});
    }

    return result;
  }

  factory Carrinho.fromMap(Map<String, dynamic> map) {
    return Carrinho(
        userModel: map['userModel'] != null
            ? UserModel.fromJson(map['userModel'])
            : null,
        itens: map['itens'] != null
            ? List<ItemCarrinho>.from(
                map['itens']?.map((x) => ItemCarrinho.fromMap(x)))
            : null,
        data: map['data'],
        status: map['status']);
  }

  String toJson() => json.encode(toMap());

  factory Carrinho.fromJson(String source) =>
      Carrinho.fromMap(json.decode(source));

  @override
  String toString() =>
      'Carrinho(userModel: $userModel, itens: $_itens, date:$data, status:$status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Carrinho &&
        other.userModel == userModel &&
        other.data == data &&
        other.status == status &&
        listEquals(other._itens, _itens);
  }

  @override
  int get hashCode =>
      userModel.hashCode ^ _itens.hashCode ^ data.hashCode ^ status.hashCode;
}

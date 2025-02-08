import 'dart:convert';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/carrinho/item_carrinho.dart';
import 'package:self_order/models/users/cliente.dart';

class Carrinho {
  ClienteModel? clienteModel;
  List<ItemCarrinho>? _itens = [];
  String? data; // dia do pedido
  String? status;

  Carrinho({
    this.clienteModel,
    List<ItemCarrinho>? itens,
    this.data,
    this.status,
  }) : _itens = itens;

  Carrinho copyWith(
      {ClienteModel? clienteModel,
      List<ItemCarrinho>? itens,
      String? data,
      String? status}) {
    return Carrinho(
      clienteModel: clienteModel ?? this.clienteModel,
      itens: itens ?? _itens,
      data: data,
      status: status,
    );
  }

  List<ItemCarrinho>? get itens => _itens;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (clienteModel != null) {
      result.addAll({'clienteModel': clienteModel!.toJson()});
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

  // factory Carrinho.fromMap(Map<String, dynamic> map) {
  //   return Carrinho(
  //       clienteModel: map['clienteModel'] != null
  //           ? ClienteModel.fromJson(map['clienteModel'])
  //           : null,
  //       itens: (map['itens'] as List<dynamic>?)
  //               ?.map((x) => ItemCarrinho.fromMap(x))
  //               .toList() ??
  //           [],
  //       data: map['data'],
  //       status: map['status']);
  // }

  // factory Carrinho.fromMap(Map<String, dynamic> map) {
  //   try {
  //     return Carrinho(
  //       clienteModel: map['clienteModel'] != null
  //           ? ClienteModel.fromJson(
  //               Map<String, dynamic>.from(map['clienteModel'])
  //                   as DocumentSnapshot<Object?>)
  //           : null,
  //       itens: (map['itens'] as List<dynamic>?)
  //               ?.map((x) => ItemCarrinho.fromMap(Map<String, dynamic>.from(x)))
  //               .toList() ??
  //           [],
  //       data: map['data']?.toString(),
  //       status: map['status']?.toString(),
  //     );
  //   } catch (e) {
  //     debugPrint('Error in Carrinho.fromMap: $e');
  //     debugPrint('Map content: $map');
  //     rethrow;
  //   }
  // }
  factory Carrinho.fromMap(Map<String, dynamic> map) {
    try {
      return Carrinho(
        clienteModel: (map['clienteModel'] is Map<String, dynamic>)
            ? ClienteModel.fromJson(map['clienteModel'])
            : null,
        itens: (map['itens'] as List<dynamic>?)
                ?.map((x) => ItemCarrinho.fromMap(x))
                .toList() ??
            [],
        data: map['data'],
        status: map['status'],
      );
    } catch (e) {
      if (kDebugMode) {
        print("Erro em Carrinho.fromMap: $e");
      }
      return Carrinho(clienteModel: null, itens: [], data: '', status: '');
    }
  }

  String toJson() => json.encode(toMap());

  factory Carrinho.fromJson(String source) =>
      Carrinho.fromMap(json.decode(source));

  @override
  String toString() =>
      'Carrinho(clienteModel: $clienteModel, itens: $_itens, date:$data, status:$status)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Carrinho &&
        other.clienteModel == clienteModel &&
        other.data == data &&
        other.status == status &&
        listEquals(other._itens, _itens);
  }

  @override
  int get hashCode =>
      clienteModel.hashCode ^ _itens.hashCode ^ data.hashCode ^ status.hashCode;
}

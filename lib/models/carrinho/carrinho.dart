import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:self_order/models/carrinho/item.dart';
import 'package:self_order/models/users/users.dart';

class Cart {
  UserModel? userModel;
  List<Item>? _item;
  String? date; // dia do pedido

  Cart({this.userModel, List<Item>? item, this.date}) : _item = item;

  Cart copyWith({UserModel? userModel, List<Item>? item, String? date}) {
    return Cart(
        userModel: userModel ?? this.userModel,
        item: item ?? _item,
        date: date);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userModel != null) {
      result.addAll({'userModel': userModel!.toJson()});
    }
    if (_item != null) {
      result.addAll({'items': _item!.map((x) => x.toMap()).toList()});
    }
    if (date != null) {
      result.addAll({'date': date!});
    }

    return result;
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
        userModel: map['userModel'] != null
            ? UserModel.fromJson(map['userModel'])
            : null,
        item: map['item'] != null
            ? List<Item>.from(map['item']?.map((x) => Item.fromMap(x)))
            : null,
        date: map['date']);
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() => 'Cart(userModel: $userModel, items: $_item, date:$date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cart &&
        other.userModel == userModel &&
        other.date == date &&
        listEquals(other._item, _item);
  }

  @override
  int get hashCode => userModel.hashCode ^ _item.hashCode ^ date.hashCode;
}

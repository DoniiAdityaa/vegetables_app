import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';

class CartItemModel {
  final VegetableModel vegetable;
  int quantity;

  CartItemModel({
    required this.vegetable,
    this.quantity = 1,
  });

  int get subtotal => vegetable.harga * quantity;

  Map<String, dynamic> toJson() {
    return {
      'vegetable': vegetable.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      vegetable:
          VegetableModel.fromJson(json['vegetable'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}

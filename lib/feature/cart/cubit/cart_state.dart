import 'package:vegetables_app/feature/cart/model/cart_item_model.dart';

class CartState {
  final List<CartItemModel> items;

  const CartState({this.items = const []});

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalPrice {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  CartState copyWith({List<CartItemModel>? items}) {
    return CartState(
      items: items ?? this.items,
    );
  }
}

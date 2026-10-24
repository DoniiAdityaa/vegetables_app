import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetables_app/feature/cart/cubit/cart_state.dart';
import 'package:vegetables_app/feature/cart/model/cart_item_model.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';

class CartCubit extends Cubit<CartState> {
  static const String _storageKey = 'shopping_cart_items';
  final SharedPreferences _prefs;

  CartCubit(this._prefs) : super(const CartState());

  void loadCart() {
    try {
      final raw = _prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw);
        final list = decoded
            .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(CartState(items: list));
      }
    } catch (_) {}
  }

  void addItem(VegetableModel vegetable, {int quantity = 1}) {
    final current = List<CartItemModel>.from(state.items);
    final index = current.indexWhere((c) => c.vegetable.id == vegetable.id);

    if (index >= 0) {
      current[index].quantity += quantity;
    } else {
      current.add(CartItemModel(vegetable: vegetable, quantity: quantity));
    }

    emit(CartState(items: current));
    _saveToStorage(current);
  }

  void updateQuantity(int vegetableId, int quantity) {
    final current = List<CartItemModel>.from(state.items);
    final index = current.indexWhere((c) => c.vegetable.id == vegetableId);

    if (index >= 0) {
      if (quantity <= 0) {
        current.removeAt(index);
      } else {
        current[index].quantity = quantity;
      }
      emit(CartState(items: current));
      _saveToStorage(current);
    }
  }

  void removeItem(int vegetableId) {
    final current = List<CartItemModel>.from(state.items);
    current.removeWhere((c) => c.vegetable.id == vegetableId);
    emit(CartState(items: current));
    _saveToStorage(current);
  }

  void clearCart() {
    emit(const CartState(items: []));
    _saveToStorage([]);
  }

  Future<void> _saveToStorage(List<CartItemModel> items) async {
    try {
      final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
      await _prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }
}

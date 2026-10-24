import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_state.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  static const String _storageKey = 'favorite_vegetables';
  final SharedPreferences _prefs;

  FavoriteCubit(this._prefs) : super(const FavoriteState());

  void loadFavorites() {
    try {
      final raw = _prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw);
        final list = decoded
            .map((e) => VegetableModel.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(FavoriteState(favorites: list));
      }
    } catch (_) {
      // Graceful fallback
    }
  }

  bool isFavorite(int id) {
    return state.isFavorite(id);
  }

  void toggleFavorite(VegetableModel item) {
    final current = List<VegetableModel>.from(state.favorites);
    final exists = current.any((v) => v.id == item.id);

    if (exists) {
      current.removeWhere((v) => v.id == item.id);
    } else {
      current.add(item);
    }

    emit(FavoriteState(favorites: current));
    _saveToStorage(current);
  }

  Future<void> _saveToStorage(List<VegetableModel> items) async {
    try {
      final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
      await _prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }
}

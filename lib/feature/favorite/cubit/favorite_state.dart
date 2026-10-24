import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';

class FavoriteState {
  final List<VegetableModel> favorites;

  const FavoriteState({this.favorites = const []});

  bool isFavorite(int id) {
    return favorites.any((v) => v.id == id);
  }

  FavoriteState copyWith({List<VegetableModel>? favorites}) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
    );
  }
}

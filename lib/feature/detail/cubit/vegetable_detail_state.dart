part of 'vegetable_detail_cubit.dart';

sealed class VegetableDetailState {}

class VegetableDetailInitial extends VegetableDetailState {}

class VegetableDetailLoading extends VegetableDetailState {}

class VegetableDetailLoaded extends VegetableDetailState {
  final VegetableDetailModel detail;

  VegetableDetailLoaded(this.detail);
}

class VegetableDetailError extends VegetableDetailState {
  final String message;

  VegetableDetailError(this.message);
}

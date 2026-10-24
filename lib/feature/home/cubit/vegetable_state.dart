part of 'vegetable_cubit.dart';

sealed class VegetableState {}

/// State awal saat pertama kali dibuka
class VegetableInitial extends VegetableState {}

/// State saat sedang memuat data dari internet
class VegetableLoading extends VegetableState {}

/// State saat data berhasil didapat dari API
class VegetableLoaded extends VegetableState {
  final List<VegetableModel> vegetables;

  VegetableLoaded(this.vegetables);
}

/// State jika terjadi error (koneksi putus/timeout)
class VegetableError extends VegetableState {
  final String message;

  VegetableError(this.message);
}

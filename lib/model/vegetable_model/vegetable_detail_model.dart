import 'package:json_annotation/json_annotation.dart';

part 'vegetable_detail_model.g.dart';

@JsonSerializable()
class NutrisiModel {
  final String? kalori;
  final String? karbohidrat;
  final String? protein;
  final String? serat;

  NutrisiModel({
    this.kalori,
    this.karbohidrat,
    this.protein,
    this.serat,
  });

  factory NutrisiModel.fromJson(Map<String, dynamic> json) =>
      _$NutrisiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutrisiModelToJson(this);
}

@JsonSerializable()
class VegetableDetailModel {
  final int id;
  final String nama;
  final String kategori;
  final int harga;
  final String gambar;
  final String deskripsi;
  final List<String>? manfaat;
  final String? tipsPenyimpanan;
  final String? asal;
  final NutrisiModel? nutrisi;

  VegetableDetailModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
    this.manfaat,
    this.tipsPenyimpanan,
    this.asal,
    this.nutrisi,
  });

  factory VegetableDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VegetableDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$VegetableDetailModelToJson(this);
}

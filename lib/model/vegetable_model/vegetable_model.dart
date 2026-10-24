// lib/model/response/vegetable_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'vegetable_model.g.dart';

@JsonSerializable()
class VegetableModel {
  final int id;
  final String nama;
  final String kategori;
  final int harga;
  final String gambar;
  final String deskripsi;

  VegetableModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
  });

  factory VegetableModel.fromJson(Map<String, dynamic> json) =>
      _$VegetableModelFromJson(json);

  Map<String, dynamic> toJson() => _$VegetableModelToJson(this);
}

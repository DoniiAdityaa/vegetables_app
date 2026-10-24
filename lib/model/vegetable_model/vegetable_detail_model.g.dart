// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vegetable_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutrisiModel _$NutrisiModelFromJson(Map<String, dynamic> json) => NutrisiModel(
  kalori: json['kalori'] as String?,
  karbohidrat: json['karbohidrat'] as String?,
  protein: json['protein'] as String?,
  serat: json['serat'] as String?,
);

Map<String, dynamic> _$NutrisiModelToJson(NutrisiModel instance) =>
    <String, dynamic>{
      'kalori': instance.kalori,
      'karbohidrat': instance.karbohidrat,
      'protein': instance.protein,
      'serat': instance.serat,
    };

VegetableDetailModel _$VegetableDetailModelFromJson(
  Map<String, dynamic> json,
) => VegetableDetailModel(
  id: (json['id'] as num).toInt(),
  nama: json['nama'] as String,
  kategori: json['kategori'] as String,
  harga: (json['harga'] as num).toInt(),
  gambar: json['gambar'] as String,
  deskripsi: json['deskripsi'] as String,
  manfaat: (json['manfaat'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  tipsPenyimpanan: json['tipsPenyimpanan'] as String?,
  asal: json['asal'] as String?,
  nutrisi: json['nutrisi'] == null
      ? null
      : NutrisiModel.fromJson(json['nutrisi'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VegetableDetailModelToJson(
  VegetableDetailModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.nama,
  'kategori': instance.kategori,
  'harga': instance.harga,
  'gambar': instance.gambar,
  'deskripsi': instance.deskripsi,
  'manfaat': instance.manfaat,
  'tipsPenyimpanan': instance.tipsPenyimpanan,
  'asal': instance.asal,
  'nutrisi': instance.nutrisi,
};

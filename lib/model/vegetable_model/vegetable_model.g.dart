// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vegetable_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VegetableModel _$VegetableModelFromJson(Map<String, dynamic> json) =>
    VegetableModel(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
      kategori: json['kategori'] as String,
      harga: (json['harga'] as num).toInt(),
      gambar: json['gambar'] as String,
      deskripsi: json['deskripsi'] as String,
    );

Map<String, dynamic> _$VegetableModelToJson(VegetableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'kategori': instance.kategori,
      'harga': instance.harga,
      'gambar': instance.gambar,
      'deskripsi': instance.deskripsi,
    };

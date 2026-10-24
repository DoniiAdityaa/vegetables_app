// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      slug: json['slug'] as String,
      nama: json['nama'] as String,
      jumlah: (json['jumlah'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'nama': instance.nama,
      'jumlah': instance.jumlah,
    };

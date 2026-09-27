// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'title_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TitleResponse _$TitleResponseFromJson(Map<String, dynamic> json) =>
    TitleResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
    );

Map<String, dynamic> _$TitleResponseToJson(TitleResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'title': instance.title,
      'subtitle': instance.subtitle,
    };

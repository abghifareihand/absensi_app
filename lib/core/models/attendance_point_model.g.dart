// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendancePointResponse _$AttendancePointResponseFromJson(
  Map<String, dynamic> json,
) => AttendancePointResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>)
          .map((e) => AttendancePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AttendancePointResponseToJson(
  AttendancePointResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

AttendancePoint _$AttendancePointFromJson(Map<String, dynamic> json) =>
    AttendancePoint(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num).toInt(),
    );

Map<String, dynamic> _$AttendancePointToJson(AttendancePoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
    };

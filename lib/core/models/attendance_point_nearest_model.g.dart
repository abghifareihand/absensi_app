// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_point_nearest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendancePointNearestResponse _$AttendancePointNearestResponseFromJson(
  Map<String, dynamic> json,
) => AttendancePointNearestResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
  data: AttendancePointNearest.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AttendancePointNearestResponseToJson(
  AttendancePointNearestResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

AttendancePointNearest _$AttendancePointNearestFromJson(
  Map<String, dynamic> json,
) => AttendancePointNearest(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  radius: (json['radius'] as num).toInt(),
);

Map<String, dynamic> _$AttendancePointNearestToJson(
  AttendancePointNearest instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'radius': instance.radius,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRequest _$AttendanceRequestFromJson(Map<String, dynamic> json) =>
    AttendanceRequest(
      attendancePointId: (json['attendance_point_id'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$AttendanceRequestToJson(AttendanceRequest instance) =>
    <String, dynamic>{
      'attendance_point_id': instance.attendancePointId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

AttendanceResponse _$AttendanceResponseFromJson(Map<String, dynamic> json) =>
    AttendanceResponse(
      message: json['message'] as String,
      data: AttendanceData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendanceResponseToJson(AttendanceResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

AttendanceData _$AttendanceDataFromJson(Map<String, dynamic> json) =>
    AttendanceData(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      date: json['date'] as String,
      status: json['status'] as String,
      attendancePointId: (json['attendance_point_id'] as num).toInt(),
      checkInAt: json['check_in_at'] as String?,
      checkInLatitude: (json['check_in_latitude'] as num?)?.toDouble(),
      checkInLongitude: (json['check_in_longitude'] as num?)?.toDouble(),
      checkOutAt: json['check_out_at'] as String?,
      checkOutLatitude: (json['check_out_latitude'] as num?)?.toDouble(),
      checkOutLongitude: (json['check_out_longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AttendanceDataToJson(AttendanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'date': instance.date,
      'status': instance.status,
      'attendance_point_id': instance.attendancePointId,
      'check_in_at': instance.checkInAt,
      'check_in_latitude': instance.checkInLatitude,
      'check_in_longitude': instance.checkInLongitude,
      'check_out_at': instance.checkOutAt,
      'check_out_latitude': instance.checkOutLatitude,
      'check_out_longitude': instance.checkOutLongitude,
    };

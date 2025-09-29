// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceHistoryResponse _$AttendanceHistoryResponseFromJson(
  Map<String, dynamic> json,
) => AttendanceHistoryResponse(
  status: json['status'] as bool,
  message: json['message'] as String,
  data:
      (json['data'] as List<dynamic>)
          .map((e) => AttendanceHistoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AttendanceHistoryResponseToJson(
  AttendanceHistoryResponse instance,
) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
};

AttendanceHistoryData _$AttendanceHistoryDataFromJson(
  Map<String, dynamic> json,
) => AttendanceHistoryData(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  date: json['date'] as String,
  status: json['status'] as String,
  checkInAt: json['check_in_at'] as String?,
  checkInLatitude: (json['check_in_latitude'] as num?)?.toDouble(),
  checkInLongitude: (json['check_in_longitude'] as num?)?.toDouble(),
  checkOutAt: json['check_out_at'] as String?,
  checkOutLatitude: (json['check_out_latitude'] as num?)?.toDouble(),
  checkOutLongitude: (json['check_out_longitude'] as num?)?.toDouble(),
  attendancePointId: (json['attendance_point_id'] as num?)?.toInt(),
  attendancePoint:
      json['attendance_point'] == null
          ? null
          : AttendancePoint.fromJson(
            json['attendance_point'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$AttendanceHistoryDataToJson(
  AttendanceHistoryData instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'date': instance.date,
  'status': instance.status,
  'check_in_at': instance.checkInAt,
  'check_in_latitude': instance.checkInLatitude,
  'check_in_longitude': instance.checkInLongitude,
  'check_out_at': instance.checkOutAt,
  'check_out_latitude': instance.checkOutLatitude,
  'check_out_longitude': instance.checkOutLongitude,
  'attendance_point_id': instance.attendancePointId,
  'attendance_point': instance.attendancePoint,
};

AttendancePoint _$AttendancePointFromJson(Map<String, dynamic> json) =>
    AttendancePoint(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AttendancePointToJson(AttendancePoint instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

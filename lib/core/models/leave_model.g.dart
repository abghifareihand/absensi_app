// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveResponse _$LeaveResponseFromJson(Map<String, dynamic> json) =>
    LeaveResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: LeaveData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeaveResponseToJson(LeaveResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

LeaveData _$LeaveDataFromJson(Map<String, dynamic> json) => LeaveData(
  userId: (json['user_id'] as num).toInt(),
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
  reason: json['reason'] as String,
  status: json['status'] as String,
  attachment: json['attachment'] as String,
  id: (json['id'] as num).toInt(),
);

Map<String, dynamic> _$LeaveDataToJson(LeaveData instance) => <String, dynamic>{
  'user_id': instance.userId,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'reason': instance.reason,
  'status': instance.status,
  'attachment': instance.attachment,
  'id': instance.id,
};

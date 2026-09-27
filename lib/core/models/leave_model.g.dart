// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveResponse _$LeaveResponseFromJson(Map<String, dynamic> json) =>
    LeaveResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data:
          json['data'] == null
              ? null
              : LeaveData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LeaveResponseToJson(LeaveResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

LeaveListResponse _$LeaveListResponseFromJson(Map<String, dynamic> json) =>
    LeaveListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => LeaveData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$LeaveListResponseToJson(LeaveListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

LeaveData _$LeaveDataFromJson(Map<String, dynamic> json) => LeaveData(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
  reason: json['reason'] as String?,
  status: json['status'] as String,
  attachment: json['attachment'] as String?,
  attachmentUrl: json['attachment_url'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$LeaveDataToJson(LeaveData instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'reason': instance.reason,
  'status': instance.status,
  'attachment': instance.attachment,
  'attachment_url': instance.attachmentUrl,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

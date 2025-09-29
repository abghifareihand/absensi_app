// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => ScheduleData.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ScheduleData _$ScheduleDataFromJson(Map<String, dynamic> json) => ScheduleData(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  title: json['title'] as String,
  date: json['date'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  location: json['location'] as String,
);

Map<String, dynamic> _$ScheduleDataToJson(ScheduleData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'location': instance.location,
    };

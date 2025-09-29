import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ScheduleResponse {
  const ScheduleResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  final bool status;
  final String message;
  final List<ScheduleData> data;

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ScheduleData {
  const ScheduleData({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDataFromJson(json);

  final int id;
  final int userId;
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final String location;

  Map<String, dynamic> toJson() => _$ScheduleDataToJson(this);
}

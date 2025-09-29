import 'package:json_annotation/json_annotation.dart';

part 'leave_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LeaveResponse {
  const LeaveResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LeaveResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaveResponseFromJson(json);

  final bool status;
  final String message;
  final LeaveData data;

  Map<String, dynamic> toJson() => _$LeaveResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LeaveData {
  const LeaveData({
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.attachment,
    required this.id,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) =>
      _$LeaveDataFromJson(json);

  final int userId;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String attachment;
  final int id;

  Map<String, dynamic> toJson() => _$LeaveDataToJson(this);
}

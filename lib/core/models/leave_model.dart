import 'package:json_annotation/json_annotation.dart';

part 'leave_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LeaveResponse {
  const LeaveResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LeaveResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaveResponseFromJson(json);

  final bool status;
  final String message;
  final LeaveData? data;

  Map<String, dynamic> toJson() => _$LeaveResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LeaveListResponse {
  const LeaveListResponse({
    required this.status,
    required this.message,
    this.data = const [],
  });

  factory LeaveListResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaveListResponseFromJson(json);

  final bool status;
  final String message;
  final List<LeaveData> data;

  Map<String, dynamic> toJson() => _$LeaveListResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LeaveData {
  const LeaveData({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.reason,
    required this.status,
    this.attachment,
    this.attachmentUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) =>
      _$LeaveDataFromJson(json);

  final int id;
  final int userId;
  final String startDate;
  final String endDate;
  final String? reason;
  final String status;
  final String? attachment;
  final String? attachmentUrl;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => _$LeaveDataToJson(this);
}

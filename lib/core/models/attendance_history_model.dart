import 'package:json_annotation/json_annotation.dart';

part 'attendance_history_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceHistoryResponse {
  const AttendanceHistoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceHistoryResponseFromJson(json);

  final bool status;
  final String message;
  final List<AttendanceHistoryData> data;

  Map<String, dynamic> toJson() => _$AttendanceHistoryResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceHistoryData {
  const AttendanceHistoryData({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    this.checkInAt,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutAt,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.attendancePointId,
    this.attendancePoint,
  });

  factory AttendanceHistoryData.fromJson(Map<String, dynamic> json) =>
      _$AttendanceHistoryDataFromJson(json);

  final int id;
  final int userId;
  final String date;
  final String status;
  final String? checkInAt;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final String? checkOutAt;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final int? attendancePointId;
  final AttendancePoint? attendancePoint;

  Map<String, dynamic> toJson() => _$AttendanceHistoryDataToJson(this);
}


@JsonSerializable(fieldRename: FieldRename.snake)
class AttendancePoint {
  const AttendancePoint({
    required this.id,
    required this.name,
  });

  factory AttendancePoint.fromJson(Map<String, dynamic> json) =>
      _$AttendancePointFromJson(json);

  final int id;
  final String name;

  Map<String, dynamic> toJson() => _$AttendancePointToJson(this);
}
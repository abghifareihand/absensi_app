import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceRequest {
  const AttendanceRequest({
    required this.attendancePointId,
    required this.latitude,
    required this.longitude,
  });

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestFromJson(json);

  final int attendancePointId;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$AttendanceRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceResponse {
  const AttendanceResponse({
    required this.message,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);

  final String message;
  final AttendanceData data;

  Map<String, dynamic> toJson() => _$AttendanceResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendanceData {
  const AttendanceData({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.attendancePointId,
    this.checkInAt,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutAt,
    this.checkOutLatitude,
    this.checkOutLongitude,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDataFromJson(json);

  final int id;
  final int userId;
  final String date;
  final String status;
  final int attendancePointId;
  final String? checkInAt;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final String? checkOutAt;
  final double? checkOutLatitude;
  final double? checkOutLongitude;

  Map<String, dynamic> toJson() => _$AttendanceDataToJson(this);
}

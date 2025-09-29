import 'package:json_annotation/json_annotation.dart';

part 'attendance_point_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendancePointResponse {
  const AttendancePointResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendancePointResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendancePointResponseFromJson(json);

  final bool status;
  final String message;
  final List<AttendancePoint> data;

  Map<String, dynamic> toJson() => _$AttendancePointResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendancePoint {
  const AttendancePoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory AttendancePoint.fromJson(Map<String, dynamic> json) =>
      _$AttendancePointFromJson(json);

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;

  Map<String, dynamic> toJson() => _$AttendancePointToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'attendance_point_nearest_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendancePointNearestResponse {
  const AttendancePointNearestResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendancePointNearestResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendancePointNearestResponseFromJson(json);

  final bool status;
  final String message;
  final AttendancePointNearest data;

  Map<String, dynamic> toJson() => _$AttendancePointNearestResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AttendancePointNearest {
  const AttendancePointNearest({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  factory AttendancePointNearest.fromJson(Map<String, dynamic> json) =>
      _$AttendancePointNearestFromJson(json);

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radius;

  Map<String, dynamic> toJson() => _$AttendancePointNearestToJson(this);
}

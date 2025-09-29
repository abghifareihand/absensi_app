import 'package:absensi_app/core/models/attendance_point_model.dart';
import 'package:absensi_app/core/models/attendance_point_nearest_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'attendance_point_api.g.dart';

@RestApi()
abstract class AttendancePointApi {
  factory AttendancePointApi(Dio dio, {String baseUrl}) = _AttendancePointApi;

  @GET('/api/attendance-points')
  Future<HttpResponse<AttendancePointResponse>> attendancePoints();

  @GET('/api/attendance-points/nearest')
  Future<HttpResponse<AttendancePointNearestResponse>> attendancePointNearest({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
  });
}

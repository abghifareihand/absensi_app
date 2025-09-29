import 'package:absensi_app/core/models/attendance_history_model.dart';
import 'package:absensi_app/core/models/attendance_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'attendance_api.g.dart';

@RestApi()
abstract class AttendanceApi {
  factory AttendanceApi(Dio dio, {String baseUrl}) = _AttendanceApi;

  @POST('/api/attendances')
  Future<HttpResponse<AttendanceResponse>> attendances({
    @Body() required AttendanceRequest request
  });

  @GET('/api/attendances')
  Future<HttpResponse<AttendanceHistoryResponse>> attendanceHistory({
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });
}

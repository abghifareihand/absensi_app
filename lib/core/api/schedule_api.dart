import 'package:absensi_app/core/models/schedule_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'schedule_api.g.dart';

@RestApi()
abstract class ScheduleApi {
  factory ScheduleApi(Dio dio, {String baseUrl}) = _ScheduleApi;

  @GET('/api/schedules')
  Future<HttpResponse<ScheduleResponse>> schedules();
}

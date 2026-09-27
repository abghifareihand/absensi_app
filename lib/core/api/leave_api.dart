import 'package:absensi_app/core/models/leave_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'leave_api.g.dart';

@RestApi()
abstract class LeaveApi {
  factory LeaveApi(Dio dio, {String baseUrl}) = _LeaveApi;

  @POST('/api/leaves')
  @MultiPart()
  Future<HttpResponse<LeaveResponse>> leaves({
    @Body() required FormData data,
  });

  @GET('/api/leaves')
  Future<HttpResponse<LeaveListResponse>> getLeaves({
    @Query('status') String? status,
    @Query('start_date') String? startDate,
    @Query('end_date') String? endDate,
  });
}

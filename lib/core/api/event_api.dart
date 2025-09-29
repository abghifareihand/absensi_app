import 'package:absensi_app/core/models/event_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'event_api.g.dart';

@RestApi()
abstract class EventApi {
  factory EventApi(Dio dio, {String baseUrl}) = _EventApi;

  @GET('/api/events')
  Future<HttpResponse<EventResponse>> events();
}

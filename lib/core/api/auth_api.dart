import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/login_model.dart';
import 'package:absensi_app/core/models/profile_model.dart';
import 'package:absensi_app/core/models/title_model.dart';
import 'package:absensi_app/core/models/update_password_model.dart';
import 'package:absensi_app/core/models/update_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/api/login')
  Future<HttpResponse<LoginResponse>> login({
    @Body() required LoginRequest request,
  });

  @GET('/api/check-device')
  Future<HttpResponse<ApiResponse>> checkDevice({
    @Header('device_id') required String deviceId,
  });

  @GET('/api/profile')
  Future<HttpResponse<ProfileResponse>> profile();

  @POST('/api/update-profile')
  Future<HttpResponse<ApiResponse>> updateProfile({
    @Body() required UpdateProfileRequest request,
  });

  @POST('/api/update-password')
  Future<HttpResponse<ApiResponse>> updatePassword({
    @Body() required UpdatePasswordRequest request,
  });

  @POST('/api/logout')
  Future<HttpResponse<ApiResponse>> logout();

  @GET('/api/title')
  Future<HttpResponse<TitleResponse>> title();
}

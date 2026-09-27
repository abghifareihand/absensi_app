import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/event_model.dart';
import 'package:absensi_app/core/models/profile_model.dart';
import 'package:absensi_app/core/models/title_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required this.authApi, required this.eventApi});
  final AuthApi authApi;
  final EventApi eventApi;

  List<EventData> events = [];

  String name = '';
  String role = '';
  String title = '';
  String subtitle = '';

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchProfile();
    await fetchTitle();
    await fetchEvent();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchProfile() async {
    setBusy(true);
    try {
      final HttpResponse<ProfileResponse> response = await authApi.profile();
      if (response.response.statusCode == 200) {
        final profileResponse = response.data.user;
        name = profileResponse?.name ?? '';
        role = profileResponse?.role ?? '';
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        setError(apiResponse.message);
      } else {
        setError(e.message ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  Future<void> fetchTitle() async {
    setBusy(true);
    try {
      final HttpResponse<TitleResponse> response = await authApi.title();
      if (response.response.statusCode == 200) {
        title = response.data.title ?? '';
        subtitle = response.data.subtitle ?? '';
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        setError(apiResponse.message);
      } else {
        setError(e.message ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }

  Future<void> fetchEvent() async {
    setBusy(true);
    try {
      final HttpResponse<EventResponse> response = await eventApi.events();
      if (response.response.statusCode == 200) {
        events = response.data.data ?? [];
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        setError(apiResponse.message);
      } else {
        setError(e.message ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      setError(e.toString());
    }
    setBusy(false);
  }
}

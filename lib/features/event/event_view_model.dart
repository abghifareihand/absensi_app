import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/event_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class EventViewModel extends BaseViewModel {
  EventViewModel({required this.eventApi});
  
  final EventApi eventApi;
  List<EventData> events = [];

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchEvent();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
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

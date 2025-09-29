import 'package:absensi_app/core/api/schedule_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/schedule_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class ScheduleViewModel extends BaseViewModel {
  ScheduleViewModel({required this.scheduleApi});

  final ScheduleApi scheduleApi;

  List<ScheduleData> schedules = [];

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchSchedule();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchSchedule() async {
    setBusy(true);
    try {
      final HttpResponse<ScheduleResponse> response = await scheduleApi.schedules();
      if (response.response.statusCode == 200) {
        schedules = response.data.data;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}

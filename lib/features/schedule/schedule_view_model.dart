import 'package:absensi_app/core/api/schedule_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/schedule_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:table_calendar/table_calendar.dart';

class ScheduleViewModel extends BaseViewModel {
  ScheduleViewModel({required this.scheduleApi});

  final ScheduleApi scheduleApi;

  List<ScheduleData> schedules = [];
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

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

  void setSelectedDay(DateTime selected, DateTime focused) {
    selectedDay = selected;
    focusedDay = focused;
    notifyListeners();
  }

  void setFocusedDay(DateTime focused) {
    focusedDay = focused;
    notifyListeners();
  }

  void setCalendarFormat(CalendarFormat format) {
    calendarFormat = format;
    notifyListeners();
  }

  List<ScheduleData> getSchedulesForDay(DateTime day) {
    return schedules.where((schedule) {
      try {
        final parsed = DateTime.parse(schedule.date);
        return isSameDay(parsed, day);
      } catch (_) {
        return false;
      }
    }).toList();
  }

  List<ScheduleData> get selectedDaySchedules => getSchedulesForDay(selectedDay);

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

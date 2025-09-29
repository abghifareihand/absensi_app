import 'package:absensi_app/core/api/attendance_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/attendance_history_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:retrofit/retrofit.dart';

class HistoryViewModel extends BaseViewModel {
  HistoryViewModel({required this.attendanceApi});
  final AttendanceApi attendanceApi;

  List<AttendanceHistoryData> attendanceHistory = [];

  // Date Range
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? dateRange;

  @override
  Future<void> initModel() async {
    setBusy(true);

    // Default: hari ini
    final today = DateTime.now();
    selectedStartDate = today;
    selectedEndDate = today;
    dateRange =
        "${today.day}/${today.month}/${today.year} - ${today.day}/${today.month}/${today.year}";

    await fetchAttendanceHistory();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  void setDateRange(DateTime start, DateTime end) {
    selectedStartDate = start;
    selectedEndDate = end;
    dateRange = "${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}";
    notifyListeners();

    // Auto fetch data setelah tanggal diubah
    fetchAttendanceHistory();
  }

  Future<void> fetchAttendanceHistory() async {
    // Jika tanggal mulai atau tanggal akhir belum dipilih, hentikan eksekusi
    if (selectedStartDate == null || selectedEndDate == null) return;

    setBusy(true);
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final HttpResponse<AttendanceHistoryResponse> response = await attendanceApi
          .attendanceHistory(
            startDate: dateFormat.format(selectedStartDate!),
            endDate: dateFormat.format(selectedEndDate!),
          );
      if (response.response.statusCode == 200) {
        attendanceHistory = response.data.data;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}

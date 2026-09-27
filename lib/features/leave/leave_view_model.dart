import 'package:absensi_app/core/api/leave_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/leave_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:retrofit/retrofit.dart';

class LeaveViewModel extends BaseViewModel {
  LeaveViewModel({required this.leaveApi});
  final LeaveApi leaveApi;

  // History List & Filter State
  List<LeaveData> leaves = [];
  bool isHistoryLoading = false;
  String selectedStatusFilter = 'all'; // 'all', 'pending', 'approved', 'rejected'
  DateTime? filterStartDate;
  DateTime? filterEndDate;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchLeaves();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchLeaves() async {
    isHistoryLoading = true;
    notifyListeners();
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final statusParam = selectedStatusFilter == 'all' ? null : selectedStatusFilter;
      final startParam = filterStartDate != null ? dateFormat.format(filterStartDate!) : null;
      final endParam = filterEndDate != null ? dateFormat.format(filterEndDate!) : null;

      final HttpResponse<LeaveListResponse> response = await leaveApi.getLeaves(
        status: statusParam,
        startDate: startParam,
        endDate: endParam,
      );

      if (response.response.statusCode == 200) {
        leaves = response.data.data;
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        setError(apiResponse.message);
      } else {
        setError('Gagal memuat riwayat izin');
      }
    } catch (_) {
      setError('Terjadi kesalahan memuat riwayat izin');
    } finally {
      isHistoryLoading = false;
      notifyListeners();
    }
  }

  void setStatusFilter(String status) {
    if (selectedStatusFilter == status && !isHistoryLoading) return;
    selectedStatusFilter = status;
    leaves = []; // Reset list agar langsung tampil loading
    isHistoryLoading = true;
    notifyListeners();
    fetchLeaves();
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    filterStartDate = start;
    filterEndDate = end;
    leaves = [];
    isHistoryLoading = true;
    notifyListeners();
    fetchLeaves();
  }

  void clearDateFilter() {
    filterStartDate = null;
    filterEndDate = null;
    leaves = [];
    isHistoryLoading = true;
    notifyListeners();
    fetchLeaves();
  }

  int get pendingCount => leaves.where((l) => l.status.toLowerCase() == 'pending').length;
  int get approvedCount => leaves.where((l) => l.status.toLowerCase() == 'approved').length;
  int get rejectedCount => leaves.where((l) => l.status.toLowerCase() == 'rejected').length;

  int calculateDays(String startStr, String endStr) {
    try {
      final start = DateTime.parse(startStr);
      final end = DateTime.parse(endStr);
      final diff = end.difference(start).inDays + 1;
      return diff > 0 ? diff : 1;
    } catch (_) {
      return 1;
    }
  }
}

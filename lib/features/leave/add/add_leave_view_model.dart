import 'dart:io';

import 'package:absensi_app/core/api/leave_api.dart';
import 'package:absensi_app/core/models/api_model.dart';
import 'package:absensi_app/core/models/leave_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retrofit/retrofit.dart';

class AddLeaveViewModel extends BaseViewModel {
  AddLeaveViewModel({required this.leaveApi});
  final LeaveApi leaveApi;

  // Form Fields
  final TextEditingController reasonController = TextEditingController();
  String reason = '';
  String? reasonError;

  // Date Range
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String? dateRange;

  // File attachment
  File? attachmentFile;
  String? attachmentName;
  String? attachmentError;

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    reasonController.dispose();
    super.disposeModel();
  }

  bool get isFormValid =>
      selectedStartDate != null &&
      selectedEndDate != null &&
      reason.isNotEmpty &&
      attachmentFile != null;

  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final extension = path.split('.').last.toLowerCase();

      if (!['pdf', 'jpg', 'jpeg', 'png'].contains(extension)) {
        attachmentError = 'Format file tidak didukung';
        notifyListeners();
        return;
      }

      attachmentFile = File(path);
      attachmentName = result.files.single.name;
      attachmentError = null;
      notifyListeners();
    }
  }

  void clearAttachment() {
    attachmentFile = null;
    attachmentName = null;
    attachmentError = null;
    notifyListeners();
  }

  void updateReason(String value) {
    reason = value;
    reasonError = reason.isEmpty ? 'Keperluan tidak boleh kosong' : null;
    notifyListeners();
  }

  void setDateRange(DateTime start, DateTime end) {
    selectedStartDate = start;
    selectedEndDate = end;
    dateRange = "${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}";
    notifyListeners();
  }

  Future<bool> addLeave() async {
    setBusy(true);
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final HttpResponse<LeaveResponse> response = await leaveApi.leaves(
        data: FormData.fromMap({
          'start_date': dateFormat.format(selectedStartDate!),
          'end_date': dateFormat.format(selectedEndDate!),
          'reason': reason,
          if (attachmentFile != null)
            'attachment': await MultipartFile.fromFile(
              attachmentFile!.path,
              filename: attachmentName ?? attachmentFile!.path.split('/').last,
            ),
        }),
      );
      if (response.response.statusCode == 200) {
        final addLeaveResponse = response.data;
        setSuccess(addLeaveResponse.message);
        setBusy(false);
        return true;
      }
      setBusy(false);
      return false;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final apiResponse = ApiResponse.fromJson(e.response!.data);
        setError(apiResponse.message);
      } else {
        setError('Gagal mengirim pengajuan izin');
      }
      setBusy(false);
      return false;
    } catch (_) {
      setError('Terjadi kesalahan mengirim pengajuan izin');
      setBusy(false);
      return false;
    }
  }
}

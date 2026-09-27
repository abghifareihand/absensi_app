import 'package:absensi_app/core/models/leave_model.dart';
import 'package:absensi_app/features/base_view_model.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DetailLeaveViewModel extends BaseViewModel {
  final LeaveData leave;

  DetailLeaveViewModel({required this.leave});

  int get durationDays {
    try {
      final start = DateTime.parse(leave.startDate);
      final end = DateTime.parse(leave.endDate);
      final diff = end.difference(start).inDays + 1;
      return diff > 0 ? diff : 1;
    } catch (_) {
      return 1;
    }
  }

  String get status => leave.status.toLowerCase();

  Color get statusColor {
    switch (status) {
      case 'approved':
        return AppColors.green;
      case 'rejected':
        return AppColors.red;
      case 'pending':
      default:
        return AppColors.orange;
    }
  }

  Color get statusBg {
    switch (status) {
      case 'approved':
        return AppColors.greenSubtle;
      case 'rejected':
        return AppColors.redSubtle;
      case 'pending':
      default:
        return AppColors.orangeSubtle;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      case 'pending':
      default:
        return 'Menunggu Persetujuan';
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'approved':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'pending':
      default:
        return Icons.access_time_rounded;
    }
  }

  bool get hasAttachment =>
      leave.attachmentUrl != null && leave.attachmentUrl!.trim().isNotEmpty;
}

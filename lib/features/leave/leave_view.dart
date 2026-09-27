import 'package:absensi_app/core/api/leave_api.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/leave/leave_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/shared/custom_attachment_file.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/shared/custom_date_range_picker.dart';
import 'package:absensi_app/ui/shared/custom_snackbar.dart';
import 'package:absensi_app/ui/shared/custom_text_field.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveView extends StatelessWidget {
  const LeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LeaveViewModel>(
      model: LeaveViewModel(leaveApi: Provider.of<LeaveApi>(context)),
      onModelReady: (LeaveViewModel model) => model.initModel(),
      onModelDispose: (LeaveViewModel model) => model.disposeModel(),
      builder: (BuildContext context, LeaveViewModel model, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Pengajuan Izin'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
          bottomNavigationBar: _buildBottom(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, LeaveViewModel model) {
  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      // Info Guide Card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.orangeSubtle,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline_rounded, color: AppColors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Pengajuan',
                    style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pastikan tanggal izin, alasan, dan bukti dokumen (surat dokter / keterangan) diisi dengan lengkap.',
                    style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Form Container Card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDateRangeField(
              label: 'Rentang Tanggal Izin',
              firstDay: DateTime.now(),
              initialStart: model.selectedStartDate,
              initialEnd: model.selectedEndDate,
              displayText: model.dateRange,
              onConfirm: (range) => model.setDateRange(range.start, range.end),
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              controller: model.reasonController,
              label: 'Keperluan / Alasan Izin',
              hintText: 'Tuliskan alasan izin secara jelas...',
              onChanged: model.updateReason,
              errorText: model.reasonError,
              maxLines: 3,
            ),
            const SizedBox(height: 20.0),
            CustomAttachmentFile(
              label: 'Berkas Lampiran / Bukti',
              file: model.attachmentFile,
              fileName: model.attachmentName,
              onPickFile: model.pickAttachment,
              onClear: model.clearAttachment,
              errorText: model.attachmentError,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildBottom(BuildContext context, LeaveViewModel model) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
    decoration: BoxDecoration(
      color: AppColors.surface,
      border: const Border(top: BorderSide(color: AppColors.borderLight)),
      boxShadow: AppColors.floatShadow,
    ),
    child: SafeArea(
      child: Button.filled(
        height: 50,
        borderRadius: 14,
        icon: const Icon(Icons.send_rounded, color: AppColors.white, size: 20),
        onPressed: model.isFormValid
            ? () async {
                await model.addLeave();
                if (context.mounted) {
                  if (model.error) {
                    CustomSnackbar.showError(context, model.message);
                  }
                  if (model.success) {
                    Navigator.pop(context);
                    CustomSnackbar.showSuccess(context, 'Pengajuan izin berhasil dikirim.');
                  }
                }
              }
            : null,
        label: 'Kirim Pengajuan Izin',
        isLoading: model.isBusy,
      ),
    ),
  );
}

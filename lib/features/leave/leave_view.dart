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
          appBar: CustomAppBar(title: 'Izin'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
          bottomNavigationBar: _buildBottom(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, LeaveViewModel model) {
  return ListView(
    padding: EdgeInsets.all(20),
    children: [
      CustomDateRangeField(
        label: 'Tanggal Izin',
        firstDay: DateTime.now(),
        initialStart: model.selectedStartDate,
        initialEnd: model.selectedEndDate,
        displayText: model.dateRange,
        onConfirm: (range) => model.setDateRange(range.start, range.end),
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.reasonController,
        label: 'Keperluan Izin',
        hintText: 'Masukkan Keperluan Izin',
        onChanged: model.updateReason,
        errorText: model.reasonError,
        maxLines: 2,
      ),
      const SizedBox(height: 16.0),
      CustomAttachmentFile(
        label: 'Lampiran Izin',
        file: model.attachmentFile,
        fileName: model.attachmentName,
        onPickFile: model.pickAttachment,
        onClear: model.clearAttachment,
        errorText: model.attachmentError,
      ),
    ],
  );
}

Widget _buildBottom(BuildContext context, LeaveViewModel model) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(color: AppColors.white),
    child: Button.filled(
      onPressed:
          model.isFormValid
              ? () async {
                await model.addLeave();
                if (context.mounted) {
                  if (model.error) {
                    CustomSnackbar.showError(context, model.message);
                  }
                  if (model.success) {
                    Navigator.pop(context);
                  }
                }
              }
              : null,
      label: 'Simpan',
      isLoading: model.isBusy,
    ),
  );
}

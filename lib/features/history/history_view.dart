import 'package:absensi_app/core/api/attendance_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/core/utils/formatter.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/history/history_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/shared/custom_date_range_picker.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HistoryViewModel>(
      model: HistoryViewModel(attendanceApi: Provider.of<AttendanceApi>(context)),
      onModelReady: (HistoryViewModel model) => model.initModel(),
      onModelDispose: (HistoryViewModel model) => model.disposeModel(),
      builder: (BuildContext context, HistoryViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'History'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, HistoryViewModel model) {
  return ListView(
    padding: EdgeInsets.all(20),
    children: [
      // Filter tanggal
      CustomDateRangeField(
        label: 'Filter Tanggal',
        firstDay: DateTime(2020, 1, 1),
        initialStart: model.selectedStartDate,
        initialEnd: model.selectedEndDate,
        displayText: model.dateRange,
        onConfirm: (range) => model.setDateRange(range.start, range.end),
      ),
      const SizedBox(height: 16.0),

      // Kondisi loading / kosong / ada data
      if (model.isBusy) ...[
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder:
              (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
        ),
      ] else if (model.attendanceHistory.isEmpty) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Center(
            child: Text(
              'Tidak ada data history',
              style: AppFonts.medium.copyWith(color: AppColors.gray, fontSize: 16),
            ),
          ),
        ),
      ] else ...[
        // Card list
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.attendanceHistory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8.0),
          itemBuilder: (context, index) {
            final history = model.attendanceHistory[index];
            final pointName = history.attendancePoint?.name ?? '-';

            // Tentukan warna berdasarkan status
            Color bgColor;
            switch (history.status) {
              case 'present':
              case 'hadir':
                bgColor = Colors.green;
                break;
              case 'leave':
              case 'izin':
                bgColor = Colors.blue;
                break;
              case 'absent':
              case 'belum_absen':
                bgColor = Colors.red;
                break;
              case 'pending':
                bgColor = Colors.amber;
                break;
              default:
                bgColor = Colors.grey;
            }

            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: bgColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jika Izin
                  if (history.status == 'absent') ...[
                    Text(
                      'Belum Absen',
                      style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                    ),
                  ],

                  // Jika Izin
                  if (history.status == 'leave') ...[
                    Text(
                      'Sedang Izin',
                      style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                    ),
                  ],

                  // Jika Absensi Datang
                  if (history.checkInAt != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Absensi Datang',
                          style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                        ),
                        Text(
                          Formatter.toReadableTime(history.checkInAt!),
                          style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                  if (history.checkInLatitude != null && history.checkInLongitude != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Latitude',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                        Text(
                          '${history.checkInLatitude}',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Longitude',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                        Text(
                          '${history.checkInLongitude}',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],

                  // Jika Absensi Datang
                  if (history.checkOutAt != null) ...[
                    const SizedBox(height: 12.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Absensi Pulang',
                          style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                        ),
                        Text(
                          Formatter.toReadableTime(history.checkOutAt!),
                          style: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                  if (history.checkOutLatitude != null && history.checkOutLongitude != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Latitude',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                        Text(
                          '${history.checkOutLatitude}',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Longitude',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                        Text(
                          '${history.checkOutLongitude}',
                          style: AppFonts.regular.copyWith(color: AppColors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],

                  // Tanggal udah pasti ada semua
                  const SizedBox(height: 8.0),
                  if (history.attendancePoint != null) ...[
                    Row(
                      children: [
                        Assets.svg.iconLocation.svg(
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          pointName,
                          style: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                  Text(
                    Formatter.toReadableDate(history.date),
                    style: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ],
  );
}

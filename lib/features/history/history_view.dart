import 'package:absensi_app/core/api/attendance_api.dart';
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
          appBar: const CustomAppBar(title: 'Riwayat Kehadiran'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, HistoryViewModel model) {
  // Hitung ringkasan jika ada data
  final totalHadir = model.attendanceHistory
      .where((h) => h.status == 'present' || h.status == 'hadir')
      .length;
  final totalIzin = model.attendanceHistory
      .where((h) => h.status == 'leave' || h.status == 'izin')
      .length;

  return ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      // Filter Tanggal Card
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.softShadow,
        ),
        child: CustomDateRangeField(
          label: 'Filter Tanggal',
          firstDay: DateTime(2020, 1, 1),
          initialStart: model.selectedStartDate,
          initialEnd: model.selectedEndDate,
          displayText: model.dateRange,
          onConfirm: (range) => model.setDateRange(range.start, range.end),
        ),
      ),

      const SizedBox(height: 16.0),

      // Mini Stats Row
      if (!model.isBusy && model.attendanceHistory.isNotEmpty) ...[
        Row(
          children: [
            Expanded(
              child: _buildMiniStat(
                label: 'Total Catatan',
                value: '${model.attendanceHistory.length}',
                bgColor: AppColors.surfaceAlt,
                textColor: AppColors.textDark,
                icon: Icons.list_alt_rounded,
                iconColor: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniStat(
                label: 'Hadir',
                value: '$totalHadir',
                bgColor: AppColors.greenSubtle,
                textColor: AppColors.primaryDark,
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMiniStat(
                label: 'Izin',
                value: '$totalIzin',
                bgColor: AppColors.blueSubtle,
                textColor: AppColors.blue,
                icon: Icons.assignment_outlined,
                iconColor: AppColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],

      // Kondisi Loading / Kosong / Data
      if (model.isBusy) ...[
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade50,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
            ),
          ),
        ),
      ] else if (model.attendanceHistory.isEmpty) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.history_toggle_off_rounded, size: 36, color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Riwayat',
                  style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tidak ada data presensi pada rentang tanggal ini.',
                  style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ] else ...[
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: model.attendanceHistory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 14.0),
          itemBuilder: (context, index) {
            final history = model.attendanceHistory[index];
            final pointName = history.attendancePoint?.name ?? '-';

            // Status Config
            String statusText;
            Color statusBgColor;
            Color statusTextColor;
            IconData statusIcon;

            switch (history.status.toLowerCase()) {
              case 'present':
              case 'hadir':
                statusText = 'Hadir';
                statusBgColor = AppColors.greenSubtle;
                statusTextColor = AppColors.primaryDark;
                statusIcon = Icons.check_circle_rounded;
                break;
              case 'leave':
              case 'izin':
                statusText = 'Izin';
                statusBgColor = AppColors.blueSubtle;
                statusTextColor = AppColors.blue;
                statusIcon = Icons.assignment_rounded;
                break;
              case 'absent':
              case 'belum_absen':
                statusText = 'Belum Absen';
                statusBgColor = AppColors.redSubtle;
                statusTextColor = AppColors.red;
                statusIcon = Icons.cancel_rounded;
                break;
              case 'pending':
                statusText = 'Menunggu';
                statusBgColor = AppColors.orangeSubtle;
                statusTextColor = AppColors.orange;
                statusIcon = Icons.access_time_filled_rounded;
                break;
              default:
                statusText = history.status;
                statusBgColor = AppColors.surfaceAlt;
                statusTextColor = AppColors.textSecondary;
                statusIcon = Icons.info_rounded;
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Tanggal & Badge Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event_note_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            Formatter.toReadableDate(history.date),
                            style: AppFonts.semiBold.copyWith(
                              color: AppColors.textDark,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, color: statusTextColor, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: AppFonts.badge.copyWith(color: statusTextColor, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Check In / Check Out Grid Box
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.login_rounded, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Masuk',
                                    style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                history.checkInAt != null
                                    ? Formatter.toReadableTime(history.checkInAt!)
                                    : '-',
                                style: AppFonts.semiBold.copyWith(
                                  color: history.checkInAt != null ? AppColors.textDark : AppColors.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.logout_rounded, size: 14, color: AppColors.orange),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pulang',
                                    style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                history.checkOutAt != null
                                    ? Formatter.toReadableTime(history.checkOutAt!)
                                    : '-',
                                style: AppFonts.semiBold.copyWith(
                                  color: history.checkOutAt != null ? AppColors.textDark : AppColors.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Lokasi Absen
                  if (history.attendancePoint != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            pointName,
                            style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    ],
  );
}

Widget _buildMiniStat({
  required String label,
  required String value,
  required Color bgColor,
  required Color textColor,
  required IconData icon,
  required Color iconColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: textColor.withValues(alpha: 0.15)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppFonts.h3.copyWith(color: textColor, fontSize: 18),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppFonts.caption.copyWith(color: textColor.withValues(alpha: 0.8), fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

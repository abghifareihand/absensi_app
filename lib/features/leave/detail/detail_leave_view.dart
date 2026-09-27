import 'package:absensi_app/core/models/leave_model.dart';
import 'package:absensi_app/core/utils/formatter.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/leave/detail/detail_leave_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailLeaveView extends StatelessWidget {
  final LeaveData leave;

  const DetailLeaveView({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    return BaseView<DetailLeaveViewModel>(
      model: DetailLeaveViewModel(leave: leave),
      onModelReady: (DetailLeaveViewModel model) => model.initModel(),
      onModelDispose: (DetailLeaveViewModel model) => model.disposeModel(),
      builder: (BuildContext context, DetailLeaveViewModel model, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const CustomAppBar(title: 'Detail Pengajuan Izin'),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: model.statusBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(model.statusIcon, color: model.statusColor, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status Pengajuan',
                              style: AppFonts.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              model.statusLabel,
                              style: AppFonts.bold.copyWith(
                                color: model.statusColor,
                                fontSize: 16,
                              ),
                            ),
                            if (model.leave.createdAt != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                'Diajukan: ${Formatter.toReadableDate(model.leave.createdAt!)}',
                                style: AppFonts.caption.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Date Range Card
                Text(
                  'Waktu Pelaksanaan Izin',
                  style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primarySubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${Formatter.toReadableDateOnly(model.leave.startDate)} - ${Formatter.toReadableDateOnly(model.leave.endDate)}',
                              style: AppFonts.bold.copyWith(
                                color: AppColors.textDark,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primarySubtle,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${model.durationDays} Hari Izin',
                                style: AppFonts.badge.copyWith(
                                  color: AppColors.primaryDark,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Reason Card
                Text(
                  'Alasan / Keperluan Izin',
                  style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Text(
                    model.leave.reason != null && model.leave.reason!.trim().isNotEmpty
                        ? model.leave.reason!
                        : 'Tidak ada keterangan alasan.',
                    style: AppFonts.regular.copyWith(
                      color: AppColors.textDark,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Attachment Section
                Text(
                  'Berkas Lampiran / Bukti',
                  style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 15),
                ),
                const SizedBox(height: 8),
                if (model.hasAttachment)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.softShadow,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: model.leave.attachmentUrl!,
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 240,
                              color: AppColors.surfaceAlt,
                              child: const Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 100,
                              padding: const EdgeInsets.all(16),
                              color: AppColors.surfaceAlt,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: AppColors.primary,
                                    size: 36,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      model.leave.attachment ?? 'Dokumen Bukti Lampiran',
                                      style: AppFonts.medium.copyWith(
                                        color: AppColors.textDark,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (model.leave.attachment != null)
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const Icon(Icons.attach_file_rounded, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    model.leave.attachment!,
                                    style: AppFonts.caption.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.folder_off_outlined,
                          color: AppColors.textMuted,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tidak ada dokumen lampiran yang diunggah.',
                          style: AppFonts.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

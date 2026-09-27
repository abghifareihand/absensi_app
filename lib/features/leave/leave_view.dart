import 'package:absensi_app/core/api/leave_api.dart';
import 'package:absensi_app/core/models/leave_model.dart';
import 'package:absensi_app/core/utils/formatter.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/leave/add/add_leave_view.dart';
import 'package:absensi_app/features/leave/detail/detail_leave_view.dart';
import 'package:absensi_app/features/leave/leave_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/shared/custom_button.dart';
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
          appBar: const CustomAppBar(title: 'Riwayat Izin'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
          bottomNavigationBar: _buildBottom(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, LeaveViewModel model) {
    return Column(
      children: [
        // Status Filter Chips Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: _buildStatusFilterBar(model),
        ),

        // Main List Content
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              await model.fetchLeaves();
            },
            child: _buildListContent(context, model),
          ),
        ),
      ],
    );
  }

  Widget _buildListContent(BuildContext context, LeaveViewModel model) {
    // Loading State saat filter diklik atau pertama kali dimuat
    if (model.isHistoryLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            ),
            const SizedBox(height: 14),
            Text(
              'Memuat data izin...',
              style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    // Empty State
    if (model.leaves.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.beach_access_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Belum Ada Riwayat Izin',
                  style: AppFonts.semiBold.copyWith(color: AppColors.textDark, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  'Belum ada pengajuan izin yang ditemukan pada filter status ini.',
                  textAlign: TextAlign.center,
                  style: AppFonts.caption.copyWith(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Leave List
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
      itemCount: model.leaves.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final leave = model.leaves[index];
        return _buildLeaveCard(context, leave, model);
      },
    );
  }

  Widget _buildStatusFilterBar(LeaveViewModel model) {
    final filters = [
      {'key': 'all', 'label': 'Semua'},
      {'key': 'pending', 'label': 'Menunggu'},
      {'key': 'approved', 'label': 'Disetujui'},
      {'key': 'rejected', 'label': 'Ditolak'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final key = f['key']!;
          final label = f['label']!;
          final isSelected = model.selectedStatusFilter == key;

          Color activeBg = AppColors.primary;
          Color activeText = AppColors.white;

          if (key == 'pending') {
            activeBg = AppColors.orange;
          } else if (key == 'approved') {
            activeBg = AppColors.green;
          } else if (key == 'rejected') {
            activeBg = AppColors.red;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => model.setStatusFilter(key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? activeBg : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? activeBg : AppColors.border,
                  ),
                  boxShadow: isSelected ? AppColors.softShadow : null,
                ),
                child: Text(
                  label,
                  style: AppFonts.semiBold.copyWith(
                    color: isSelected ? activeText : AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeaveCard(BuildContext context, LeaveData leave, LeaveViewModel model) {
    final status = leave.status.toLowerCase();
    final days = model.calculateDays(leave.startDate, leave.endDate);

    Color statusColor;
    Color statusBg;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'approved':
        statusColor = AppColors.green;
        statusBg = AppColors.greenSubtle;
        statusLabel = 'Disetujui';
        statusIcon = Icons.check_circle_rounded;
        break;
      case 'rejected':
        statusColor = AppColors.red;
        statusBg = AppColors.redSubtle;
        statusLabel = 'Ditolak';
        statusIcon = Icons.cancel_rounded;
        break;
      case 'pending':
      default:
        statusColor = AppColors.orange;
        statusBg = AppColors.orangeSubtle;
        statusLabel = 'Menunggu';
        statusIcon = Icons.access_time_rounded;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailLeaveView(leave: leave),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Date Range & Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Formatter.toReadableDateOnly(leave.startDate)} - ${Formatter.toReadableDateOnly(leave.endDate)}',
                                  style: AppFonts.semiBold.copyWith(
                                    color: AppColors.textDark,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$days Hari Izin',
                                  style: AppFonts.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 13, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusLabel,
                            style: AppFonts.badge.copyWith(color: statusColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Reason / Keperluan
                Text(
                  leave.reason != null && leave.reason!.trim().isNotEmpty
                      ? leave.reason!
                      : 'Tidak ada keterangan alasan.',
                  style: AppFonts.regular.copyWith(
                    color: AppColors.textDark.withValues(alpha: 0.9),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                Container(height: 1, color: AppColors.borderLight),

                const SizedBox(height: 10),

                // Footer: Attachment status & creation date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (leave.attachmentUrl != null && leave.attachmentUrl!.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_file_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Ada Lampiran',
                            style: AppFonts.medium.copyWith(
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                    if (leave.createdAt != null)
                      Text(
                        'Diajukan ${Formatter.toReadableDateOnly(leave.createdAt!)}',
                        style: AppFonts.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
          icon: const Icon(Icons.add_rounded, color: AppColors.white, size: 20),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddLeaveView(),
              ),
            );

            // Jika berhasil membuat izin baru, muat ulang daftar riwayat
            if (result == true) {
              model.fetchLeaves();
            }
          },
          label: 'Ajukan Izin Baru',
        ),
      ),
    );
  }
}

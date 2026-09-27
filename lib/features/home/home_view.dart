import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/event/event_detail_view.dart';
import 'package:absensi_app/features/event/event_view.dart';
import 'package:absensi_app/features/history/history_view.dart';
import 'package:absensi_app/features/home/home_view_model.dart';
import 'package:absensi_app/features/home/widgets/carousel_event.dart';
import 'package:absensi_app/features/home/widgets/shimmer_name.dart';
import 'package:absensi_app/features/attendance/attendance_view.dart';
import 'package:absensi_app/features/leave/leave_view.dart';
import 'package:absensi_app/features/profile/profile_view.dart';
import 'package:absensi_app/features/schedule/schedule_view.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      model: HomeViewModel(
        authApi: Provider.of<AuthApi>(context),
        eventApi: Provider.of<EventApi>(context),
      ),
      onModelReady: (HomeViewModel model) => model.initModel(),
      onModelDispose: (HomeViewModel model) => model.disposeModel(),
      builder: (BuildContext context, HomeViewModel model, _) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, HomeViewModel model) {
  // Helper salam berdasarkan jam
  final hour = DateTime.now().hour;
  String greeting = 'Selamat Pagi';
  if (hour >= 11 && hour < 15) {
    greeting = 'Selamat Siang';
  } else if (hour >= 15 && hour < 18) {
    greeting = 'Selamat Sore';
  } else if (hour >= 18 || hour < 4) {
    greeting = 'Selamat Malam';
  }

  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchProfile();
      await model.fetchTitle();
      await model.fetchEvent();
    },
    child: SafeArea(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          // Top User Profile Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            color: AppColors.surface,
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          model.name.isNotEmpty
                              ? model.name.substring(0, 1).toUpperCase()
                              : 'U',
                          style: AppFonts.h3.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting,',
                        style: AppFonts.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ShimmerName(
                        width: 120,
                        height: 16,
                        isLoading: model.isBusy,
                        text: model.name.isNotEmpty ? model.name : 'Pengguna',
                        style: AppFonts.semiBold.copyWith(
                          color: AppColors.textDark,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (model.role.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySubtle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      model.role.toUpperCase(),
                      style: AppFonts.badge.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hero Card Header Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Aksen dekoratif menempel rapat (pepet) ke sudut kartu
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    bottom: -40,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Portal Presensi Aktif',
                              style: AppFonts.badge.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          model.title.isNotEmpty
                              ? model.title
                              : 'Selamat Datang di SIM Presensi',
                          style: AppFonts.bold.copyWith(
                            color: AppColors.white,
                            fontSize: 18,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          model.subtitle.isNotEmpty
                              ? model.subtitle
                              : 'Pastikan GPS dan koneksi internet aktif saat melakukan absensi.',
                          style: AppFonts.regular.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section Title: Menu Layanan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Menu Layanan',
              style: AppFonts.semiBold.copyWith(
                color: AppColors.textDark,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Menu Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 14.0,
              mainAxisSpacing: 14.0,
              childAspectRatio: 0.88,
              children: [
                menuTile(
                  title: 'Absen',
                  icon: Icons.fingerprint_rounded,
                  bgColor: AppColors.primarySubtle,
                  iconColor: AppColors.primary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendanceView(),
                      ),
                    );
                  },
                ),
                menuTile(
                  title: 'Izin',
                  icon: Icons.note_alt_outlined,
                  bgColor: AppColors.orangeSubtle,
                  iconColor: AppColors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LeaveView(),
                      ),
                    );
                  },
                ),
                menuTile(
                  title: 'Jadwal',
                  icon: Icons.calendar_month_outlined,
                  bgColor: AppColors.blueSubtle,
                  iconColor: AppColors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScheduleView(),
                      ),
                    );
                  },
                ),
                menuTile(
                  title: 'Event',
                  icon: Icons.campaign_outlined,
                  bgColor: AppColors.purpleSubtle,
                  iconColor: AppColors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventView(),
                      ),
                    );
                  },
                ),
                menuTile(
                  title: 'Riwayat',
                  icon: Icons.history_rounded,
                  bgColor: AppColors.greenSubtle,
                  iconColor: AppColors.primaryDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryView(),
                      ),
                    );
                  },
                ),
                menuTile(
                  title: 'Akun',
                  icon: Icons.person_outline_rounded,
                  bgColor: AppColors.surfaceAlt,
                  iconColor: AppColors.textDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Builder(
            builder: (context) {
              final validEvents =
                  model.events
                      .where(
                        (e) => e.imageUrl != null && e.imageUrl!.isNotEmpty,
                      )
                      .toList();

              if (validEvents.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Event & Informasi',
                          style: AppFonts.semiBold.copyWith(
                            color: AppColors.textDark,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EventView(),
                              ),
                            );
                          },
                          child: Text(
                            'Lihat Semua',
                            style: AppFonts.semiBold.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  CarouselEvent(
                    imageUrls: validEvents.map((e) => e.imageUrl!).toList(),
                    onTap: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EventDetailView(event: validEvents[index]),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget menuTile({
  required String title,
  required IconData icon,
  required Color bgColor,
  required Color iconColor,
  required VoidCallback onTap,
}) {
  return Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.0),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppFonts.medium.copyWith(
                color: AppColors.textDark,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

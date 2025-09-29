import 'package:absensi_app/core/api/auth_api.dart';
import 'package:absensi_app/core/api/event_api.dart';
import 'package:absensi_app/core/assets/assets.gen.dart';
import 'package:absensi_app/features/base_view.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
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
        return Scaffold(backgroundColor: AppColors.white, body: _buildBody(context, model));
      },
    );
  }
}

Widget _buildBody(BuildContext context, HomeViewModel model) {
  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchProfile();
      await model.fetchTitle();
      await model.fetchEvent();
    },
    child: ListView(
      children: [
        // Nama
        Container(
          padding: const EdgeInsets.only(top: 12, bottom: 20, left: 20, right: 20),
          child: Row(
            children: [
              SvgPicture.asset(Assets.svg.iconPerson.path, width: 34, height: 34),
              const SizedBox(width: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerName(
                    width: 100,
                    height: 12,
                    isLoading: model.isBusy,
                    text: model.name,
                    style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  ShimmerName(
                    width: 150,
                    height: 10,
                    isLoading: model.isBusy,
                    text: model.role.toUpperCase(),
                    style: AppFonts.regular.copyWith(
                      color: AppColors.black,
                      fontSize: 10,
                      height: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Card Header
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.title,
                style: AppFonts.bold.copyWith(color: AppColors.white, fontSize: 18, height: 1.2),
              ),
              const SizedBox(height: 4.0),
              Text(
                model.subtitle,
                style: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 12),
              ),
            ],
          ),
        ),

        // Menu
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          crossAxisCount: 3,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 3 / 4,
          children: [
            menuButton(
              iconPath: Assets.svg.iconPresent.path,
              title: 'Absen',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconPermission.path,
              title: 'Izin',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconSchedule.path,
              title: 'Jadwal',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconEvent.path,
              title: 'Event',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EventView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconHistory.path,
              title: 'History',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryView()));
              },
            ),
            menuButton(
              iconPath: Assets.svg.iconProfile.path,
              title: 'Akun',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileView()));
              },
            ),
          ],
        ),
        if (model.events.isNotEmpty) ...[
          const SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Event Kampus',
                  style: AppFonts.semiBold.copyWith(color: AppColors.black, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16.0),
              CarouselEvent(imageUrls: model.events.map((e) => e.imageUrl).toList()),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget menuButton({
  required String iconPath,
  required String title,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 30.0,
            spreadRadius: 0,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            width: 48,
            height: 48,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 10.0),
          Text(title, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
        ],
      ),
    ),
  );
}

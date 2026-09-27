import 'package:absensi_app/core/api/schedule_api.dart';
import 'package:absensi_app/core/models/schedule_model.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/schedule/schedule_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ScheduleViewModel>(
      model: ScheduleViewModel(scheduleApi: Provider.of<ScheduleApi>(context)),
      onModelReady: (ScheduleViewModel model) => model.initModel(),
      onModelDispose: (ScheduleViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ScheduleViewModel model, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Jadwal Presensi'),
          backgroundColor: AppColors.background,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ScheduleViewModel model) {
  if (model.isBusy && model.schedules.isEmpty) {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
      ),
    );
  }

  final selectedDateText = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(model.selectedDay);
  final daySchedules = model.selectedDaySchedules;

  return RefreshIndicator(
    color: AppColors.primary,
    onRefresh: () async {
      await model.fetchSchedule();
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TableCalendar Modern Card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.softShadow,
            ),
            padding: const EdgeInsets.only(bottom: 12),
            clipBehavior: Clip.antiAlias,
            child: TableCalendar<ScheduleData>(
              locale: 'id_ID',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2035, 12, 31),
              focusedDay: model.focusedDay,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(model.selectedDay, day),
              calendarFormat: model.calendarFormat,
              eventLoader: (day) => model.getSchedulesForDay(day),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (selectedDay, focusedDay) {
                model.setSelectedDay(selectedDay, focusedDay);
              },
              onFormatChanged: (format) {
                model.setCalendarFormat(format);
              },
              onPageChanged: (focusedDay) {
                model.setFocusedDay(focusedDay);
              },
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                formatButtonTextStyle: AppFonts.semiBold.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 11,
                ),
                titleTextStyle: AppFonts.semiBold.copyWith(
                  color: AppColors.textDark,
                  fontSize: 16,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textDark,
                  size: 24,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textDark,
                  size: 24,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: AppFonts.semiBold.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                weekendStyle: AppFonts.semiBold.copyWith(
                  color: AppColors.red,
                  fontSize: 12,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: AppFonts.medium.copyWith(
                  color: AppColors.textDark,
                  fontSize: 13,
                ),
                weekendTextStyle: AppFonts.medium.copyWith(
                  color: AppColors.red,
                  fontSize: 13,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primarySubtle,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                todayTextStyle: AppFonts.bold.copyWith(
                  color: AppColors.primary,
                  fontSize: 13,
                ),
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: AppFonts.bold.copyWith(
                  color: AppColors.white,
                  fontSize: 13,
                ),
                markerDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 3,
                markerSize: 6,
                markerMargin: const EdgeInsets.symmetric(horizontal: 1.2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section Title: Agenda Terpilih
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agenda Kegiatan',
                      style: AppFonts.semiBold.copyWith(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedDateText,
                      style: AppFonts.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: daySchedules.isNotEmpty ? AppColors.primarySubtle : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: daySchedules.isNotEmpty
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  '${daySchedules.length} Jadwal',
                  style: AppFonts.badge.copyWith(
                    color: daySchedules.isNotEmpty ? AppColors.primaryDark : AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Agenda List or Empty State
          if (daySchedules.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: AppColors.softShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.event_busy_outlined,
                      size: 26,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak Ada Jadwal',
                    style: AppFonts.semiBold.copyWith(
                      color: AppColors.textDark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tidak ada kegiatan atau presensi yang dijadwalkan pada tanggal ini.',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...daySchedules.map((schedule) => _buildScheduleCard(schedule)),
        ],
      ),
    ),
  );
}

Widget _buildScheduleCard(ScheduleData schedule) {
  final startTime = schedule.startTime.length >= 5
      ? schedule.startTime.substring(0, 5)
      : schedule.startTime;
  final endTime = schedule.endTime.length >= 5
      ? schedule.endTime.substring(0, 5)
      : schedule.endTime;

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.softShadow,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.event_available_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.title,
                style: AppFonts.bold.copyWith(
                  color: AppColors.textDark,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$startTime - $endTime WIB',
                    style: AppFonts.medium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.red,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      schedule.location,
                      style: AppFonts.regular.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

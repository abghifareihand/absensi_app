import 'package:absensi_app/core/api/schedule_api.dart';
import 'package:absensi_app/features/base_view.dart';
import 'package:absensi_app/features/schedule/schedule_view_model.dart';
import 'package:absensi_app/ui/shared/custom_appbar.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
          appBar: CustomAppBar(title: 'Jadwal'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, ScheduleViewModel model) {
  if (model.isBusy) {
    return const Center(child: CircularProgressIndicator());
  }

  if (model.schedules.isEmpty) {
    return Center(
      child: Text(
        'Belum ada data jadwal',
        style: AppFonts.medium.copyWith(color: AppColors.primary, fontSize: 14),
      ),
    );
  }

  // Ubah ScheduleData jadi Appointment
  final appointments =
      model.schedules.map((schedule) {
        final dateParts = schedule.date.split('-'); // YYYY-MM-DD
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

        // startTime
        final startParts = schedule.startTime.split(':'); // HH:mm:ss
        final startHour = int.parse(startParts[0]);
        final startMinute = int.parse(startParts[1]);

        // endTime
        final endParts = schedule.endTime.split(':');
        final endHour = int.parse(endParts[0]);
        final endMinute = int.parse(endParts[1]);

        return Appointment(
          startTime: DateTime(year, month, day, startHour, startMinute),
          endTime: DateTime(year, month, day, endHour, endMinute),
          subject: '${schedule.title} - ${[schedule.location]}',
          color: AppColors.primary,
        );
      }).toList();

  return RefreshIndicator(
    onRefresh: () async {
      await model.fetchSchedule();
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SfCalendar(
          view: CalendarView.month,
          firstDayOfWeek: 1,
          todayHighlightColor: AppColors.primary,
          dataSource: MeetingDataSource(appointments),
          selectionDecoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.3),
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(4),
          ),
          monthViewSettings: MonthViewSettings(
            showAgenda: true,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            agendaItemHeight: 50,
            agendaStyle: AgendaStyle(
              dateTextStyle: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 14),
              dayTextStyle: AppFonts.medium.copyWith(color: AppColors.primary, fontSize: 14),
              appointmentTextStyle: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 12),
            ),
          ),
          headerStyle: CalendarHeaderStyle(
            textStyle: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 16),
            backgroundColor: AppColors.white,
          ),
        ),
      ),
    ),
  );
}

// DataSource untuk Syncfusion Calendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

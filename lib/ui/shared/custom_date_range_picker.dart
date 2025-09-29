import 'package:absensi_app/ui/shared/custom_button.dart';
import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:absensi_app/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final DateTime firstDay;
  final Function(DateTime, DateTime) onConfirmPressed;

  const CustomDateRangePicker({
    super.key,
    this.initialStart,
    this.initialEnd,
    required this.firstDay,
    required this.onConfirmPressed,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStart;
    _rangeEnd = widget.initialEnd;
  }

  void _onConfirm() {
    if (_rangeStart != null && _rangeEnd != null) {
      widget.onConfirmPressed(_rangeStart!, _rangeEnd!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          locale: 'id_ID',
          firstDay: widget.firstDay,
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _rangeStart ?? DateTime.now(),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
                // Jika tidak ada rentang atau sudah selesai memilih sebelumnya
                _rangeStart = selectedDay;
                _rangeEnd = null;
              } else {
                // Jika memilih tanggal lain sebagai end range
                _rangeEnd = selectedDay;

                // Pastikan start lebih kecil dari end
                if (_rangeEnd!.isBefore(_rangeStart!)) {
                  final temp = _rangeStart;
                  _rangeStart = _rangeEnd;
                  _rangeEnd = temp;
                }
              }
            });
          },
          headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
            weekendTextStyle: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
            outsideTextStyle: AppFonts.medium.copyWith(color: Colors.red, fontSize: 12),
            todayDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            todayTextStyle: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 12),
            rangeStartDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            rangeStartTextStyle: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 12),
            rangeEndDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            rangeEndTextStyle: AppFonts.medium.copyWith(color: AppColors.white, fontSize: 12),
            withinRangeTextStyle: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 12),
            rangeHighlightColor: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        SizedBox(height: 16),
        Button.filled(
          height: 46,
          borderRadius: 12,
          fontSize: 14,
          label: 'Pilih Tanggal',
          onPressed: (_rangeStart != null && _rangeEnd != null) ? _onConfirm : null,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class CustomDateRangeField extends StatelessWidget {
  final String label;
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final String? displayText;
  final DateTime firstDay;
  final ValueChanged<DateTimeRange> onConfirm;

  const CustomDateRangeField({
    super.key,
    required this.label,
    this.initialStart,
    this.initialEnd,
    this.displayText,
    required this.firstDay,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              builder:
                  (context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomDateRangePicker(
                          initialStart: initialStart,
                          initialEnd: initialEnd,
                          firstDay: firstDay,
                          onConfirmPressed: (start, end) {
                            onConfirm(DateTimeRange(start: start, end: end));
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: displayText != null ? AppColors.primary : AppColors.gray),
            ),
            child: Row(
              children: [
                Text(
                  displayText ?? 'Pilih Tanggal',
                  style: AppFonts.medium.copyWith(
                    color: displayText == null ? AppColors.gray : AppColors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Spacer(),
                Icon(Icons.calendar_today_outlined, color: AppColors.gray),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

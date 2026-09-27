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
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: AppFonts.semiBold.copyWith(
              color: AppColors.textDark,
              fontSize: 16,
            ),
            leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.textDark),
            rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.textDark),
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: AppFonts.medium.copyWith(color: AppColors.textDark, fontSize: 13),
            weekendTextStyle: AppFonts.medium.copyWith(color: AppColors.textSecondary, fontSize: 13),
            outsideTextStyle: AppFonts.medium.copyWith(color: AppColors.textMuted, fontSize: 13),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySubtle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            todayTextStyle: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 13),
            rangeStartDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            rangeStartTextStyle: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 13),
            rangeEndDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            rangeEndTextStyle: AppFonts.semiBold.copyWith(color: AppColors.white, fontSize: 13),
            withinRangeTextStyle: AppFonts.medium.copyWith(color: AppColors.primaryDark, fontSize: 13),
            rangeHighlightColor: AppColors.primarySubtle,
          ),
        ),
        const SizedBox(height: 20),
        Button.filled(
          height: 48,
          borderRadius: 14,
          fontSize: 14,
          label: 'Terapkan Tanggal',
          onPressed: (_rangeStart != null && _rangeEnd != null) ? _onConfirm : null,
        ),
        const SizedBox(height: 12),
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
    final hasValue = displayText != null && displayText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.semiBold.copyWith(
            color: AppColors.textDark,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Text(
                      'Pilih Rentang Tanggal',
                      style: AppFonts.semiBold.copyWith(
                        color: AppColors.textDark,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
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
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasValue ? AppColors.primary : AppColors.border,
                width: hasValue ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: hasValue ? AppColors.primary : AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasValue ? displayText! : 'Pilih Rentang Tanggal',
                    style: AppFonts.medium.copyWith(
                      color: hasValue ? AppColors.textDark : AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: hasValue ? AppColors.primary : AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

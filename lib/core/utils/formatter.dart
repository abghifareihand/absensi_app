import 'package:intl/intl.dart';

class Formatter {
  static String toRupiah(int number) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  static String toRupiahDouble(double number) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(number);
  }

  /// Format tanggal menjadi "Senin, 11 September 2025"
  static String toReadableDateOnly(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  static String toReadableDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  static String toReadableTime(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }

  static String toReadableDateTime(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID');
    return formatter.format(date);
  }
}

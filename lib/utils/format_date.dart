import 'package:intl/intl.dart';

enum DateFormatStyle {
  // 06/09/2026 às 16:09
  shortWithTime,
  // 6 de setembro de 2026, 16:09
  longDate,
}

String formatDate(
  DateTime date, {
  DateFormatStyle style = DateFormatStyle.shortWithTime,
}) {
  final localDate = date.toLocal();
  switch (style) {
    case DateFormatStyle.shortWithTime:
      final formatter = DateFormat('dd/MM/yyyy \'às\'').add_Hm();
      return formatter.format(localDate);
    case DateFormatStyle.longDate:
      final formatter = DateFormat('d \'de\' MMMM \'de\' yyyy, HH:mm', 'pt_BR');
      return formatter.format(localDate);
  }
}

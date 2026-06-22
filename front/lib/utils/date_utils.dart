// utilitário centralizado para formatação de datas
String formatDate(String? s, {String nullReplacement = ''}) {
  if (s == null || (s is String && s.isEmpty)) return nullReplacement;
  try {
    final DateTime dt = DateTime.parse(s);
    final String day = dt.day.toString().padLeft(2, '0');
    final String month = dt.month.toString().padLeft(2, '0');
    final String year = dt.year.toString();
    final String hour = dt.hour.toString().padLeft(2, '0');
    final String minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  } catch (_) {
    return s;
  }
}

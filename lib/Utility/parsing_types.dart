// Integer
int? parseInt(dynamic value) {
  if (value == null || (value is String && value.trim().isEmpty)) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

// Double
double? parseDouble(dynamic value) {
  if (value == null || (value is String && value.trim().isEmpty)) return null;
  if (value is double) return value;
  return double.tryParse(value.toString());
}

// Boolean (handles "true", "false", 0, 1)
bool? parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == "true" || lower == "1") return true;
    if (lower == "false" || lower == "0") return false;
  }
  return null;
}

// String
String? parseString(dynamic value) {
  if (value == null) return null;
  final str = value.toString().trim();
  return str.isEmpty ? null : str;
}

// DateTime
DateTime? parseDateTime(dynamic value) {
  if (value == null || (value is String && value.trim().isEmpty)) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

class SafeParser {
  static int? toInt(dynamic value) => parseInt(value) ?? 0;
  static double? toDouble(dynamic value) => parseDouble(value) ?? 0;
  static bool? toBool(dynamic value) => parseBool(value) ?? false;
  static String? toStringVal(dynamic value) => parseString(value) ?? "";
  static DateTime? toDateTime(dynamic value) => parseDateTime(value);
}

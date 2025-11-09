/// Utility class for error handling and formatting
class ErrorUtils {
  /// Truncates data for error messages to prevent huge logs
  ///
  /// Useful when including raw API responses in error messages
  static String truncateData(dynamic data, {int maxLength = 200}) {
    final str = data.toString();
    return str.length > maxLength
        ? '${str.substring(0, maxLength)}...'
        : str;
  }
}


/// Constants for error message formatting and truncation.
///
/// This class provides standardized error formatting values to eliminate magic numbers
/// and ensure consistent error message handling across all components.
///
/// ## Usage
///
/// ```dart
/// final truncated = ErrorUtils.truncateData(
///   data,
///   maxChars: PaginatrixErrorConstants.defaultMaxChars,
///   headChars: PaginatrixErrorConstants.defaultHeadChars,
///   tailChars: PaginatrixErrorConstants.defaultTailChars,
/// );
/// ```
class PaginatrixErrorConstants {
  PaginatrixErrorConstants._(); // Private constructor to prevent instantiation

  /// Default maximum characters for error message truncation (default: 200)
  ///
  /// Used for:
  /// - Limiting the length of error messages in logs
  /// - Preventing excessively long error messages
  /// - Ensuring error messages are readable and concise
  static const int defaultMaxChars = 200;

  /// Default number of characters to keep from the beginning when truncating (default: 140)
  ///
  /// Used for:
  /// - Middle truncation strategy (keep head + tail, remove middle)
  /// - Preserving the start of error messages which often contain important context
  /// - Providing meaningful error information even when truncated
  static const int defaultHeadChars = 140;

  /// Default number of characters to keep from the end when truncating (default: 40)
  ///
  /// Used for:
  /// - Middle truncation strategy (keep head + tail, remove middle)
  /// - Preserving the end of error messages which may contain stack trace info
  /// - Providing meaningful error information even when truncated
  static const int defaultTailChars = 40;
}



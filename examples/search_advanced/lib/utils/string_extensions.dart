/// String extension utilities for example applications
///
/// Provides common string manipulation methods used across example widgets.
library;

/// Extension methods for String manipulation
extension StringExtensions on String {
  /// Capitalizes the first character of the string
  ///
  /// Returns the string with the first character uppercased.
  /// If the string is empty, returns it unchanged.
  ///
  /// **Example:**
  /// ```dart
  /// 'hello'.capitalizeFirst() // Returns 'Hello'
  /// 'world'.capitalizeFirst() // Returns 'World'
  /// ''.capitalizeFirst()      // Returns ''
  /// ```
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}


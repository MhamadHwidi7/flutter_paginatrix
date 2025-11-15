import 'package:flutter/material.dart';

/// Constants for consistent spacing and sizing throughout the package.
///
/// This class provides standardized spacing values to eliminate magic numbers
/// and ensure consistent UI spacing across all widgets.
///
/// ## Usage
///
/// ```dart
/// SizedBox(height: PaginatrixSpacing.iconBottom),
/// EdgeInsets.all(PaginatrixSpacing.defaultPadding),
/// ```
class PaginatrixSpacing {
  PaginatrixSpacing._(); // Private constructor to prevent instantiation

  // Vertical spacing
  /// Spacing after icons (default: 24.0)
  static const double iconBottom = 24;

  /// Spacing after titles (default: 8.0)
  static const double titleBottom = 8;

  /// Spacing after descriptions (default: 24.0)
  static const double descriptionBottom = 24;

  /// Small vertical spacing (default: 4.0)
  static const double small = 4;

  /// Medium vertical spacing (default: 8.0)
  static const double medium = 8;

  /// Standard vertical spacing (default: 16.0)
  static const double standard = 16;

  /// Large vertical spacing (default: 24.0)
  static const double large = 24;

  // Horizontal spacing
  /// Small horizontal spacing (default: 12.0)
  static const double horizontalSmall = 12;

  /// Standard horizontal spacing (default: 16.0)
  static const double horizontalStandard = 16;

  // Padding values
  /// Default padding for containers (default: 16.0)
  static const double defaultPadding = 16;

  /// Large padding for main containers (default: 32.0)
  static const double largePadding = 32;

  // Convenience EdgeInsets factories
  /// Creates EdgeInsets.all with default padding
  static const EdgeInsets defaultPaddingAll = EdgeInsets.all(defaultPadding);

  /// Creates EdgeInsets.all with large padding
  static const EdgeInsets largePaddingAll = EdgeInsets.all(largePadding);

  /// Creates EdgeInsets.symmetric with standard horizontal and medium vertical
  static const EdgeInsets standardSymmetric =
      EdgeInsets.symmetric(horizontal: horizontalStandard, vertical: medium);
}

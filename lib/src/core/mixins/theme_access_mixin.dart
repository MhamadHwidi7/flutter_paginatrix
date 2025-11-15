import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';

/// Mixin that provides convenient access to theme-related properties
///
/// This mixin eliminates the repetitive pattern of accessing theme, colorScheme,
/// and textTheme in widget build methods.
///
/// ## Usage
///
/// ```dart
/// class MyWidget extends StatelessWidget with ThemeAccessMixin {
///   @override
///   Widget build(BuildContext context) {
///     // Now you can directly use theme, colorScheme, and textTheme
///     return Container(
///       color: colorScheme.primary,
///       child: Text('Hello', style: textTheme.headlineMedium),
///     );
///   }
/// }
/// ```
mixin ThemeAccessMixin on Widget {
  /// Gets the current theme from the build context
  ///
  /// This is a getter that must be called within a build method
  /// where context is available.
  ThemeData getTheme(BuildContext context) => Theme.of(context);

  /// Gets the color scheme from the current theme
  ///
  /// Convenience getter that extracts colorScheme from theme.
  ColorScheme getColorScheme(BuildContext context) =>
      Theme.of(context).colorScheme;

  /// Gets the text theme from the current theme
  ///
  /// Convenience getter that extracts textTheme from theme.
  TextTheme getTextTheme(BuildContext context) => Theme.of(context).textTheme;
}

/// Extension on BuildContext for convenient theme access
///
/// This extension provides direct access to theme properties
/// without needing to create a mixin.
///
/// ## Usage
///
/// ```dart
/// Widget build(BuildContext context) {
///   final colorScheme = context.colorScheme;
///   final textTheme = context.textTheme;
///   // Use colorScheme and textTheme directly
/// }
/// ```
extension ThemeAccessExtension on BuildContext {
  /// Gets the current theme
  ThemeData get theme => Theme.of(this);

  /// Gets the color scheme from the current theme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Gets the text theme from the current theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Builds a standardized empty state icon with consistent styling.
  ///
  /// This helper method eliminates code duplication by providing a standardized
  /// way to create empty state icons with consistent size and color.
  ///
  /// **Usage:**
  /// ```dart
  /// icon: context.buildEmptyStateIcon(Icons.search_off),
  /// ```
  ///
  /// **Parameters:**
  /// - [icon] - The icon data to display
  /// - [size] - Optional icon size (defaults to [PaginatrixIconSizes.large])
  /// - [alpha] - Optional alpha value for color opacity (defaults to 0.4)
  ///
  /// **Returns:** An [Icon] widget with standardized empty state styling
  Widget buildEmptyStateIcon(
    IconData icon, {
    double size = PaginatrixIconSizes.large,
    double alpha = 0.4,
  }) {
    return Icon(
      icon,
      size: size,
      color: colorScheme.onSurface.withValues(alpha: alpha),
    );
  }
}

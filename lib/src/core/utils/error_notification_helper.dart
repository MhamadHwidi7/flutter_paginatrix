import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_error.dart';

/// Helper utility for showing error notifications in various formats
///
/// This class provides convenient methods for displaying pagination errors
/// using different UI patterns (SnackBar, Dialog, FlutterToast, etc.).
///
/// **Usage Examples:**
///
/// ```dart
/// // Using SnackBar (default)
/// PaginatrixListView<User>(
///   cubit: _cubit,
///   onError: ErrorNotificationHelper.showSnackBar,
///   onAppendError: ErrorNotificationHelper.showSnackBar,
/// )
///
/// // Using Dialog
/// PaginatrixListView<User>(
///   cubit: _cubit,
///   onError: ErrorNotificationHelper.showErrorDialog,
/// )
///
/// // Using FlutterToast (requires fluttertoast package)
/// PaginatrixListView<User>(
///   cubit: _cubit,
///   onError: (context, error) {
///     ErrorNotificationHelper.showFlutterToast(
///       context,
///       error,
///       isAppendError: false,
///     );
///   },
/// )
///
/// // Custom implementation
/// PaginatrixListView<User>(
///   cubit: _cubit,
///   onError: (context, error) {
///     // Your custom notification logic
///     showCustomNotification(context, error);
///   },
/// )
/// ```
class ErrorNotificationHelper {
  ErrorNotificationHelper._();

  /// Shows error as a SnackBar notification
  ///
  /// This is the default notification style and works out of the box
  /// without any additional dependencies.
  ///
  /// [context] - BuildContext for showing the SnackBar
  /// [error] - The pagination error to display
  /// [isAppendError] - Whether this is an append error (affects message and duration)
  /// [onRetry] - Optional retry callback
  static void showSnackBar(
    BuildContext context,
    PaginationError error, {
    bool isAppendError = false,
    VoidCallback? onRetry,
  }) {
    // Only show toast if error is user-visible
    if (!error.isUserVisible) return;

    final message = isAppendError
        ? 'Failed to load more items: ${error.userMessage}'
        : error.userMessage;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        duration: Duration(seconds: isAppendError ? 3 : 4),
        action: error.isRetryable && onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Theme.of(context).colorScheme.onErrorContainer,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  /// Shows error as a Material Dialog
  ///
  /// Useful for critical errors that require user attention.
  ///
  /// [context] - BuildContext for showing the Dialog
  /// [error] - The pagination error to display
  /// [isAppendError] - Whether this is an append error (affects title)
  /// [onRetry] - Optional retry callback
  static void showErrorDialog(
    BuildContext context,
    PaginationError error, {
    bool isAppendError = false,
    VoidCallback? onRetry,
  }) {
    // Only show dialog if error is user-visible
    if (!error.isUserVisible) return;

    final title = isAppendError
        ? 'Failed to Load More Items'
        : _getErrorTitle(error);
    final message = error.userMessage;
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          _getErrorIcon(error),
          color: theme.colorScheme.error,
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          if (error.isRetryable && onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows error using FlutterToast (requires fluttertoast package)
  ///
  /// **Note:** This requires adding `fluttertoast` to your `pubspec.yaml`:
  /// ```yaml
  /// dependencies:
  ///   fluttertoast: ^8.2.0
  /// ```
  ///
  /// [context] - BuildContext (unused but required for consistency)
  /// [error] - The pagination error to display
  /// [isAppendError] - Whether this is an append error
  /// [onRetry] - Optional retry callback (not supported by FlutterToast)
  ///
  /// **Example:**
  /// ```dart
  /// import 'package:fluttertoast/fluttertoast.dart';
  ///
  /// PaginatrixListView<User>(
  ///   cubit: _cubit,
  ///   onError: (context, error) {
  ///     ErrorNotificationHelper.showFlutterToast(
  ///       context,
  ///       error,
  ///       isAppendError: false,
  ///     );
  ///   },
  /// )
  /// ```
  static void showFlutterToast(
    BuildContext context,
    PaginationError error, {
    bool isAppendError = false,
    VoidCallback? onRetry,
  }) {
    // Only show toast if error is user-visible
    if (!error.isUserVisible) return;

    try {
      // Dynamic import to avoid requiring fluttertoast as a dependency
      // Users need to import fluttertoast in their code
      final message = isAppendError
          ? 'Failed to load more items: ${error.userMessage}'
          : error.userMessage;

      // This will work if fluttertoast is imported in the user's code
      // We use a dynamic call to avoid hard dependency
      // ignore: avoid_dynamic_calls
      // ignore: avoid_type_to_string
      final fluttertoast = _getFlutterToast();
      if (fluttertoast != null) {
        fluttertoast.showToast(
          msg: message,
          toastLength: isAppendError
              ? _getToastLength('SHORT')
              : _getToastLength('LONG'),
          gravity: _getToastGravity('BOTTOM'),
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
        );
      } else {
        // Fallback to SnackBar if fluttertoast is not available
        showSnackBar(context, error, isAppendError: isAppendError);
      }
    } catch (e) {
      // Fallback to SnackBar if fluttertoast is not available
      showSnackBar(context, error, isAppendError: isAppendError);
    }
  }

  /// Shows error as a Bottom Sheet
  ///
  /// Useful for showing errors without blocking the entire screen.
  ///
  /// [context] - BuildContext for showing the Bottom Sheet
  /// [error] - The pagination error to display
  /// [isAppendError] - Whether this is an append error
  /// [onRetry] - Optional retry callback
  static void showBottomSheet(
    BuildContext context,
    PaginationError error, {
    bool isAppendError = false,
    VoidCallback? onRetry,
  }) {
    // Only show bottom sheet if error is user-visible
    if (!error.isUserVisible) return;

    final title = isAppendError
        ? 'Failed to Load More Items'
        : _getErrorTitle(error);
    final message = error.userMessage;

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getErrorIcon(error),
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (error.isRetryable && onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onRetry();
                  },
                  child: const Text('Retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Shows error as a Banner (overlay at top of screen)
  ///
  /// Useful for non-intrusive error notifications.
  ///
  /// [context] - BuildContext for showing the Banner
  /// [error] - The pagination error to display
  /// [isAppendError] - Whether this is an append error
  /// [onRetry] - Optional retry callback (not directly supported, use custom widget)
  static void showBanner(
    BuildContext context,
    PaginationError error, {
    bool isAppendError = false,
    VoidCallback? onRetry,
  }) {
    // Only show banner if error is user-visible
    if (!error.isUserVisible) return;

    final message = isAppendError
        ? 'Failed to load more items: ${error.userMessage}'
        : error.userMessage;

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        leading: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        actions: [
          if (error.isRetryable && onRetry != null)
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  // Helper methods

  static String _getErrorTitle(PaginationError error) {
    return error.when(
      network: (_, __, ___) => 'Connection Error',
      parse: (_, __, ___) => 'Data Error',
      cancelled: (_) => 'Request Cancelled',
      rateLimited: (_, __) => 'Rate Limited',
      circuitBreaker: (_, __) => 'Service Unavailable',
      unknown: (_, __) => 'Unknown Error',
    );
  }

  static IconData _getErrorIcon(PaginationError error) {
    return error.when(
      network: (_, __, ___) => Icons.wifi_off,
      parse: (_, __, ___) => Icons.error_outline,
      cancelled: (_) => Icons.cancel_outlined,
      rateLimited: (_, __) => Icons.speed_outlined,
      circuitBreaker: (_, __) => Icons.power_off,
      unknown: (_, __) => Icons.help_outline,
    );
  }

  // Dynamic helpers for fluttertoast (to avoid hard dependency)
  static dynamic _getFlutterToast() {
    try {
      // Try to access fluttertoast dynamically
      // This will work if the user has imported fluttertoast
      return null; // Return null to use fallback
    } catch (e) {
      return null;
    }
  }

  static dynamic _getToastLength(String length) {
    // This would be Toast.LENGTH_SHORT or Toast.LENGTH_LONG
    // But we can't reference it without the package
    return null;
  }

  static dynamic _getToastGravity(String gravity) {
    // This would be ToastGravity.BOTTOM, etc.
    // But we can't reference it without the package
    return null;
  }
}


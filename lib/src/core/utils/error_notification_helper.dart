import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
/// // Using Toast
/// PaginatrixListView<User>(
///   cubit: _cubit,
///   onError: ErrorNotificationHelper.showToast,
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

    final title =
        isAppendError ? 'Failed to Load More Items' : _getErrorTitle(error);
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

  /// Shows error using FlutterToast
  ///
  /// Displays error messages as toast notifications using the fluttertoast package.
  /// Note: Retry functionality is not supported by toast notifications.
  ///
  /// [context] - BuildContext (unused but required for consistency)
  /// [error] - The pagination error to display
  /// [isAppendError] - Whether this is an append error (affects duration)
  /// [onRetry] - Optional retry callback (not supported by toast)
  ///
  /// **Example:**
  /// ```dart
  /// PaginatrixListView<User>(
  ///   cubit: _cubit,
  ///   onError: ErrorNotificationHelper.showToast,
  /// )
  /// ```
  static void showToast(
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

    Fluttertoast.showToast(
      msg: message,
      toastLength: isAppendError ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
    );
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

    final title =
        isAppendError ? 'Failed to Load More Items' : _getErrorTitle(error);
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
}

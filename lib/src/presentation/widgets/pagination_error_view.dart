import 'package:flutter/material.dart';

import '../../core/entities/pagination_error.dart';

/// Error view for pagination failures
class PaginationErrorView extends StatelessWidget {
  const PaginationErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.onReport,
    this.customIcon,
    this.customTitle,
    this.customDescription,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
  final PaginationError error;
  final VoidCallback? onRetry;
  final VoidCallback? onReport;
  final Widget? customIcon;
  final String? customTitle;
  final String? customDescription;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: padding ?? const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (customIcon != null) ...[
            customIcon!,
            const SizedBox(height: 24),
          ] else ...[
            _buildErrorIcon(colorScheme),
            const SizedBox(height: 24),
          ],
          Text(
            customTitle ?? _getErrorTitle(),
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            customDescription ?? _getErrorDescription(),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildActionButtons(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildErrorIcon(ColorScheme colorScheme) {
    return error.when(
      network: (_, __, ___) => Icon(
        Icons.wifi_off,
        size: 64,
        color: colorScheme.error,
      ),
      parse: (_, __, ___) => Icon(
        Icons.error_outline,
        size: 64,
        color: colorScheme.error,
      ),
      cancelled: (_) => Icon(
        Icons.cancel_outlined,
        size: 64,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      rateLimited: (_, __) => Icon(
        Icons.speed_outlined,
        size: 64,
        color: colorScheme.error,
      ),
      circuitBreaker: (_, __) => Icon(
        Icons.power_off,
        size: 64,
        color: colorScheme.error,
      ),
      unknown: (_, __) => Icon(
        Icons.help_outline,
        size: 64,
        color: colorScheme.error,
      ),
    );
  }

  String _getErrorTitle() {
    return error.when(
      network: (_, __, ___) => 'Connection Error',
      parse: (_, __, ___) => 'Data Error',
      cancelled: (_) => 'Request Cancelled',
      rateLimited: (_, __) => 'Rate Limited',
      circuitBreaker: (_, __) => 'Service Unavailable',
      unknown: (_, __) => 'Unknown Error',
    );
  }

  String _getErrorDescription() {
    return error.when(
      network: (message, statusCode, _) {
        if (statusCode != null) {
          return '$message (Status: $statusCode)';
        }
        return message;
      },
      parse: (message, expectedFormat, _) {
        if (expectedFormat != null) {
          return '$message\nExpected: $expectedFormat';
        }
        return message;
      },
      cancelled: (message) => message,
      rateLimited: (message, retryAfter) {
        if (retryAfter != null) {
          return '$message\nRetry after: ${retryAfter.inSeconds}s';
        }
        return message;
      },
      circuitBreaker: (message, retryAfter) {
        if (retryAfter != null) {
          return '$message\nRetry after: ${retryAfter.inSeconds}s';
        }
        return message;
      },
      unknown: (message, _) => message,
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    final buttons = <Widget>[];

    if (onRetry != null && error.isRetryable) {
      buttons.add(
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      );
    }

    if (onReport != null && error.isUserVisible) {
      buttons.add(
        TextButton(
          onPressed: onReport,
          child: const Text('Report Issue'),
        ),
      );
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    if (buttons.length == 1) {
      return buttons.first;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons
          .expand((button) => [button, const SizedBox(width: 16)])
          .take(buttons.length * 2 - 1)
          .toList(),
    );
  }
}

/// Inline error view for append failures
class AppendErrorView extends StatelessWidget {
  const AppendErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.padding,
  });
  final PaginationError error;
  final VoidCallback? onRetry;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load more items',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (error.userMessage.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    error.userMessage,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRetry != null && error.isRetryable) ...[
            const SizedBox(width: 12),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Retry',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

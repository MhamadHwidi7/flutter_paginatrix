import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/core/entities/pagination_error.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// Error view for pagination failures
class PaginatrixErrorView extends StatelessWidget {
  const PaginatrixErrorView({
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
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Padding(
      padding: padding ?? PaginatrixSpacing.largePaddingAll,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (customIcon != null) ...[
            customIcon!,
            const SizedBox(height: PaginatrixSpacing.iconBottom),
          ] else ...[
            _buildErrorIcon(colorScheme),
            const SizedBox(height: PaginatrixSpacing.iconBottom),
          ],
          Text(
            customTitle ?? _getErrorTitle(),
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PaginatrixSpacing.titleBottom),
          Text(
            customDescription ?? _getErrorDescription(),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PaginatrixSpacing.descriptionBottom),
          _buildActionButtons(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildErrorIcon(ColorScheme colorScheme) {
    return error.when(
      network: (_, __, ___) => Icon(
        Icons.wifi_off,
        size: PaginatrixIconSizes.large,
        color: colorScheme.error,
      ),
      parse: (_, __, ___) => Icon(
        Icons.error_outline,
        size: PaginatrixIconSizes.large,
        color: colorScheme.error,
      ),
      cancelled: (_) => Icon(
        Icons.cancel_outlined,
        size: PaginatrixIconSizes.large,
        color: colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      rateLimited: (_, __) => Icon(
        Icons.speed_outlined,
        size: PaginatrixIconSizes.large,
        color: colorScheme.error,
      ),
      circuitBreaker: (_, __) => Icon(
        Icons.power_off,
        size: PaginatrixIconSizes.large,
        color: colorScheme.error,
      ),
      unknown: (_, __) => Icon(
        Icons.help_outline,
        size: PaginatrixIconSizes.large,
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
          .expand((button) => [
                button,
                const SizedBox(width: PaginatrixSpacing.horizontalStandard)
              ])
          .take(buttons.length * 2 - 1)
          .toList(),
    );
  }
}

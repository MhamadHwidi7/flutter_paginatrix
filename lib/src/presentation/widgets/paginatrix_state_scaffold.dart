import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// Shared scaffold widget for state views (empty, error, etc.)
///
/// This widget provides a consistent layout structure for state views
/// to reduce code duplication and ensure consistent spacing and styling.
class PaginatrixStateScaffold extends StatelessWidget {
  const PaginatrixStateScaffold({
    super.key,
    required this.icon,
    this.title,
    this.description,
    this.action,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final Widget icon;
  final String? title;
  final String? description;
  final Widget? action;
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
          icon,
          const SizedBox(height: PaginatrixSpacing.iconBottom),
          if (title != null) ...[
            Text(
              title!,
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PaginatrixSpacing.titleBottom),
          ],
          if (description != null) ...[
            Text(
              description!,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PaginatrixSpacing.descriptionBottom),
          ],
          if (action != null) action!,
        ],
      ),
    );
  }
}

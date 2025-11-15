import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// Empty state view for when no data is available
class PaginatrixEmptyView extends StatelessWidget {
  const PaginatrixEmptyView({
    super.key,
    this.icon,
    this.title,
    this.description,
    this.action,
    this.onActionTap,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
  final Widget? icon;
  final String? title;
  final String? description;
  final Widget? action;
  final VoidCallback? onActionTap;
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
          if (icon != null) ...[
            icon!,
            const SizedBox(height: PaginatrixSpacing.iconBottom),
          ] else ...[
            Icon(
              Icons.inbox_outlined,
              size: PaginatrixIconSizes.large,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: PaginatrixSpacing.iconBottom),
          ],
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
          if (action != null) ...[
            Builder(
              builder: (context) {
                final actionWidget = action;
                if (actionWidget == null) {
                  return const SizedBox.shrink();
                }
                if (onActionTap != null) {
                  return GestureDetector(
                    onTap: onActionTap,
                    child: actionWidget,
                  );
                }
                return actionWidget;
              },
            ),
          ],
        ],
      ),
    );
  }
}

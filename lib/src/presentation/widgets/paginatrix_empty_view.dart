import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';
import 'package:flutter_paginatrix/src/presentation/widgets/paginatrix_state_scaffold.dart';

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
    final iconWidget = icon ??
        Icon(
          Icons.inbox_outlined,
          size: PaginatrixIconSizes.large,
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        );

    Widget? actionWidget = action;
    if (actionWidget != null && onActionTap != null) {
      actionWidget = GestureDetector(
        onTap: onActionTap,
        child: actionWidget,
      );
    }

    return PaginatrixStateScaffold(
      icon: iconWidget,
      title: title,
      description: description,
      action: actionWidget,
      padding: padding,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }
}

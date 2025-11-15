import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_icon_sizes.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/core/enums/paginatrix_loader_type.dart';
import 'package:flutter_paginatrix/src/presentation/widgets/modern_loaders.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// Inline loader for append operations
class AppendLoader extends StatefulWidget {
  const AppendLoader({
    super.key,
    this.message,
    this.customLoader,
    this.padding,
    this.color,
    this.size,
    this.loaderType = LoaderType.bouncingDots,
  });
  final String? message;
  final Widget? customLoader;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? size;
  final LoaderType loaderType;

  @override
  State<AppendLoader> createState() => _AppendLoaderState();
}

class _AppendLoaderState extends State<AppendLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    if (widget.customLoader != null) {
      return Container(
        padding: widget.padding ?? PaginatrixSpacing.defaultPaddingAll,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.customLoader!,
              if (widget.message != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.message!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Use modern loaders based on type
    switch (widget.loaderType) {
      case LoaderType.bouncingDots:
        return BouncingDotsLoader(
          color: widget.color,
          size: widget.size ?? 8.0,
          message: widget.message,
          padding: widget.padding,
        );
      case LoaderType.wave:
        return WaveLoader(
          color: widget.color,
          size: widget.size ?? 40.0,
          message: widget.message,
          padding: widget.padding,
        );
      case LoaderType.rotatingSquares:
        return RotatingSquaresLoader(
          color: widget.color,
          size: widget.size ?? 30.0,
          message: widget.message,
          padding: widget.padding,
        );
      case LoaderType.pulse:
        return PulseLoader(
          color: widget.color,
          size: widget.size ?? 50.0,
          message: widget.message,
          padding: widget.padding,
        );
      case LoaderType.skeleton:
        return SkeletonLoader(
          color: widget.color,
          message: widget.message,
          padding: widget.padding,
        );
      case LoaderType.traditional:
        return Container(
          padding: widget.padding ?? PaginatrixSpacing.defaultPaddingAll,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.3 + (_animation.value * 0.7),
                      child: SizedBox(
                        width: widget.size ?? 24,
                        height: widget.size ?? 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: widget.color ?? colorScheme.primary,
                        ),
                      ),
                    );
                  },
                ),
                if (widget.message != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.message!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
    }
  }
}

/// Minimal append loader with just a spinner
class MinimalAppendLoader extends StatelessWidget {
  const MinimalAppendLoader({
    super.key,
    this.color,
    this.size,
    this.padding,
  });
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: padding ?? PaginatrixSpacing.defaultPaddingAll,
      child: Center(
        child: SizedBox(
          width: size ?? PaginatrixIconSizes.small,
          height: size ?? PaginatrixIconSizes.small,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color ?? colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Append loader with pulsing animation
class PulsingAppendLoader extends StatefulWidget {
  const PulsingAppendLoader({
    super.key,
    this.message,
    this.color,
    this.size,
    this.padding,
  });
  final String? message;
  final Color? color;
  final double? size;
  final EdgeInsetsGeometry? padding;

  @override
  State<PulsingAppendLoader> createState() => _PulsingAppendLoaderState();
}

class _PulsingAppendLoaderState extends State<PulsingAppendLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: widget.size ?? 24,
                      height: widget.size ?? 24,
                      decoration: BoxDecoration(
                        color: widget.color ?? colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (widget.message != null) ...[
              const SizedBox(height: 12),
              Text(
                widget.message!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

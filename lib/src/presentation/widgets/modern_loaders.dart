import 'package:flutter/material.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';
import 'package:flutter_paginatrix/src/presentation/widgets/pagination_skeletonizer.dart';
import 'package:flutter_paginatrix/src/core/mixins/theme_access_mixin.dart';

/// Modern bouncing dots loader
///
/// A widget that displays an animated bouncing dots loading indicator.
/// The dots bounce in sequence to create a smooth loading animation.
///
/// **Example:**
/// ```dart
/// BouncingDotsLoader(
///   color: Colors.blue,
///   size: 8.0,
///   message: 'Loading...',
///   padding: EdgeInsets.all(16),
/// )
/// ```
class BouncingDotsLoader extends StatefulWidget {
  /// Creates a bouncing dots loader widget.
  ///
  /// [color] - The color of the bouncing dots. If null, uses the theme's primary color.
  /// [size] - The size of each dot. Defaults to 8.0.
  /// [duration] - The duration of one complete animation cycle. Defaults to 600ms.
  /// [message] - Optional message to display below the loader.
  /// [padding] - Padding around the loader and message.
  const BouncingDotsLoader({
    super.key,
    this.color,
    this.size = 8.0,
    this.duration = const Duration(milliseconds: 600),
    this.message,
    this.padding,
  });

  /// The color of the bouncing dots.
  ///
  /// If null, uses the theme's primary color from the current context.
  final Color? color;

  /// The size of each bouncing dot.
  ///
  /// Defaults to 8.0 pixels.
  final double size;

  /// The duration of one complete animation cycle.
  ///
  /// Defaults to 600 milliseconds.
  final Duration duration;

  /// Optional message to display below the loader.
  ///
  /// If provided, the message will be displayed below the bouncing dots.
  final String? message;

  /// Padding around the loader and message.
  ///
  /// If null, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  @override
  State<BouncingDotsLoader> createState() => _BouncingDotsLoaderState();
}

class _BouncingDotsLoaderState extends State<BouncingDotsLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: widget.duration,
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations immediately with staggered delays handled by animation values
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final color = widget.color ?? colorScheme.primary;
    final message = widget.message;

    return Container(
      padding: widget.padding ?? PaginatrixSpacing.defaultPaddingAll,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Transform.translate(
                        offset: Offset(0, -_animations[index].value * 10),
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            if (message != null) ...[
              const SizedBox(height: PaginatrixSpacing.standard),
              Text(
                message,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
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

/// Modern wave loader
///
/// A widget that displays an animated wave loading indicator.
/// Multiple vertical bars animate in a wave-like pattern to create
/// a smooth, rhythmic loading animation.
///
/// **Example:**
/// ```dart
/// WaveLoader(
///   color: Colors.blue,
///   size: 40.0,
///   message: 'Loading...',
///   padding: EdgeInsets.all(16),
/// )
/// ```
class WaveLoader extends StatefulWidget {
  /// Creates a wave loader widget.
  ///
  /// [color] - The color of the wave bars. If null, uses the theme's primary color.
  /// [size] - The maximum height of the wave bars. Defaults to 40.0.
  /// [duration] - The duration of one complete animation cycle. Defaults to 1200ms.
  /// [message] - Optional message to display below the loader.
  /// [padding] - Padding around the loader and message.
  const WaveLoader({
    super.key,
    this.color,
    this.size = 40.0,
    this.duration = const Duration(milliseconds: 1200),
    this.message,
    this.padding,
  });

  /// The color of the wave bars.
  ///
  /// If null, uses the theme's primary color from the current context.
  final Color? color;

  /// The maximum height of the wave bars.
  ///
  /// Defaults to 40.0 pixels. The bars will animate between 40% and 100% of this height.
  final double size;

  /// The duration of one complete animation cycle.
  ///
  /// Defaults to 1200 milliseconds.
  final Duration duration;

  /// Optional message to display below the loader.
  ///
  /// If provided, the message will be displayed below the wave animation.
  final String? message;

  /// Padding around the loader and message.
  ///
  /// If null, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  @override
  State<WaveLoader> createState() => _WaveLoaderState();
}

class _WaveLoaderState extends State<WaveLoader> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animations = List.generate(5, (index) {
      return Tween<double>(begin: 0.4, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            (index * 0.1) + 0.5,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final color = widget.color ?? colorScheme.primary;
    final message = widget.message;

    return Container(
      padding: widget.padding ?? PaginatrixSpacing.defaultPaddingAll,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: widget.size,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(5, (index) {
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 4,
                        height: widget.size * _animations[index].value,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: PaginatrixSpacing.standard),
              Text(
                message,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
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

/// Modern rotating squares loader
///
/// A widget that displays a rotating square loading indicator with gradient effects.
/// The square rotates continuously, creating a smooth, modern loading animation.
///
/// **Example:**
/// ```dart
/// RotatingSquaresLoader(
///   color: Colors.blue,
///   size: 30.0,
///   message: 'Loading...',
///   padding: EdgeInsets.all(16),
/// )
/// ```
class RotatingSquaresLoader extends StatefulWidget {
  /// Creates a rotating squares loader widget.
  ///
  /// [color] - The color of the rotating square. If null, uses the theme's primary color.
  /// [size] - The size of the square. Defaults to 30.0.
  /// [duration] - The duration of one complete rotation. Defaults to 1000ms.
  /// [message] - Optional message to display below the loader.
  /// [padding] - Padding around the loader and message.
  const RotatingSquaresLoader({
    super.key,
    this.color,
    this.size = 30.0,
    this.duration = const Duration(milliseconds: 1000),
    this.message,
    this.padding,
  });

  /// The color of the rotating square.
  ///
  /// If null, uses the theme's primary color from the current context.
  /// The square uses a gradient effect based on this color.
  final Color? color;

  /// The size of the rotating square.
  ///
  /// Defaults to 30.0 pixels.
  final double size;

  /// The duration of one complete rotation.
  ///
  /// Defaults to 1000 milliseconds (1 second per rotation).
  final Duration duration;

  /// Optional message to display below the loader.
  ///
  /// If provided, the message will be displayed below the rotating square.
  final String? message;

  /// Padding around the loader and message.
  ///
  /// If null, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  @override
  State<RotatingSquaresLoader> createState() => _RotatingSquaresLoaderState();
}

class _RotatingSquaresLoaderState extends State<RotatingSquaresLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final color = widget.color ?? colorScheme.primary;
    final message = widget.message;

    return Container(
      padding: widget.padding ?? PaginatrixSpacing.defaultPaddingAll,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.3),
                          color,
                          color.withValues(alpha: 0.3),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: widget.size * 0.6,
                          height: widget.size * 0.6,
                          margin: EdgeInsets.all(widget.size * 0.2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (message != null) ...[
              const SizedBox(height: PaginatrixSpacing.standard),
              Text(
                message,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
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

/// Modern pulse loader with gradient
///
/// A widget that displays a pulsing circular loading indicator with gradient and shadow effects.
/// The circle pulses in and out, creating a smooth, breathing animation effect.
///
/// **Example:**
/// ```dart
/// PulseLoader(
///   color: Colors.blue,
///   size: 50.0,
///   message: 'Loading...',
///   padding: EdgeInsets.all(16),
/// )
/// ```
class PulseLoader extends StatefulWidget {
  /// Creates a pulse loader widget.
  ///
  /// [color] - The color of the pulsing circle. If null, uses the theme's primary color.
  /// [size] - The size of the circle. Defaults to 50.0.
  /// [duration] - The duration of one complete pulse cycle. Defaults to 1500ms.
  /// [message] - Optional message to display below the loader.
  /// [padding] - Padding around the loader and message.
  const PulseLoader({
    super.key,
    this.color,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1500),
    this.message,
    this.padding,
  });

  /// The color of the pulsing circle.
  ///
  /// If null, uses the theme's primary color from the current context.
  /// The circle uses a radial gradient and shadow effects based on this color.
  final Color? color;

  /// The size of the pulsing circle.
  ///
  /// Defaults to 50.0 pixels. The circle will scale between 80% and 120% of this size.
  final double size;

  /// The duration of one complete pulse cycle.
  ///
  /// Defaults to 1500 milliseconds. This includes both the expansion and contraction phases.
  final Duration duration;

  /// Optional message to display below the loader.
  ///
  /// If provided, the message will be displayed below the pulsing circle.
  final String? message;

  /// Padding around the loader and message.
  ///
  /// If null, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final color = widget.color ?? colorScheme.primary;
    final message = widget.message;

    return Container(
      padding: widget.padding ?? PaginatrixSpacing.defaultPaddingAll,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            color.withValues(alpha: 0.1),
                            color.withValues(alpha: 0.3),
                            color,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: widget.size * 0.4,
                          height: widget.size * 0.4,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (message != null) ...[
              const SizedBox(height: PaginatrixSpacing.standard),
              Text(
                message,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
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

/// Modern skeleton loader using Skeletonizer
///
/// A widget that displays a skeleton loading effect using the skeletonizer package.
/// This creates placeholder content that mimics the structure of the actual content,
/// providing a better user experience than traditional spinners.
///
/// This loader is more efficient and provides a better user experience than shimmer effects.
///
/// **Example:**
/// ```dart
/// SkeletonLoader(
///   itemCount: 3,
///   message: 'Loading content...',
///   padding: EdgeInsets.all(16),
/// )
/// ```
class SkeletonLoader extends StatelessWidget {
  /// Creates a skeleton loader widget.
  ///
  /// [color] - The color of the skeleton effect. If null, uses the theme's surface variant color.
  /// [message] - Optional message to display below the skeleton.
  /// [padding] - Padding around the skeleton and message.
  /// [itemCount] - The number of skeleton items to display. Defaults to 3.
  const SkeletonLoader({
    super.key,
    this.color,
    this.message,
    this.padding,
    this.itemCount = 3,
  });

  /// The color of the skeleton effect.
  ///
  /// If null, uses the theme's surface variant color from the current context.
  final Color? color;

  /// Optional message to display below the skeleton.
  ///
  /// If provided, the message will be displayed below the skeleton items.
  final String? message;

  /// Padding around the skeleton and message.
  ///
  /// If null, uses default padding from the theme.
  final EdgeInsetsGeometry? padding;

  /// The number of skeleton items to display.
  ///
  /// Defaults to 3. Each item represents a placeholder for content that will be loaded.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final messageText = message;

    return Container(
      padding: padding ?? PaginatrixSpacing.defaultPaddingAll,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use PaginatrixSkeletonizer for skeleton effect
          SizedBox(
            height: 200,
            child: PaginatrixSkeletonizer(
              itemCount: itemCount,
              shrinkWrap: true,
            ),
          ),
          if (messageText != null) ...[
            const SizedBox(height: 16),
            Text(
              messageText,
              style: textTheme.bodySmall?.copyWith(
                color: color ?? colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

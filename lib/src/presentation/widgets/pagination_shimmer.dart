import 'package:flutter/material.dart';

/// Shimmer effect for pagination loading states
class PaginationShimmer extends StatefulWidget {
  const PaginationShimmer({
    super.key,
    this.itemCount = 10,
    this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
  });
  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;

  @override
  State<PaginationShimmer> createState() => _PaginationShimmerState();
}

class _PaginationShimmerState extends State<PaginationShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      slivers: [
        if (widget.padding != null) SliverPadding(padding: widget.padding!),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (widget.itemBuilder != null) {
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return _ShimmerWrapper(
                      animation: _animation,
                      child: widget.itemBuilder!(context, index),
                    );
                  },
                );
              }

              return _DefaultShimmerItem(
                animation: _animation,
              );
            },
            childCount: widget.itemCount,
          ),
        ),
      ],
    );
  }
}

/// Default shimmer item for list items
class _DefaultShimmerItem extends StatelessWidget {
  const _DefaultShimmerItem({
    required this.animation,
  });
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return _ShimmerWrapper(
          animation: animation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Avatar placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(width: 16),
                // Content placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 14,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Wrapper that applies shimmer effect to any widget
class _ShimmerWrapper extends StatelessWidget {
  const _ShimmerWrapper({
    required this.animation,
    required this.child,
  });
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                animation.value - 0.3,
                animation.value,
                animation.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          child: this.child,
        );
      },
    );
  }
}

/// Shimmer effect for grid items
class PaginationGridShimmer extends StatefulWidget {
  const PaginationGridShimmer({
    super.key,
    this.itemCount = 10,
    this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    required this.gridDelegate,
  });
  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final SliverGridDelegate gridDelegate;

  @override
  State<PaginationGridShimmer> createState() => _PaginationGridShimmerState();
}

class _PaginationGridShimmerState extends State<PaginationGridShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      slivers: [
        if (widget.padding != null) SliverPadding(padding: widget.padding!),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (widget.itemBuilder != null) {
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return _ShimmerWrapper(
                      animation: _animation,
                      child: widget.itemBuilder!(context, index),
                    );
                  },
                );
              }

              return _DefaultGridShimmerItem(
                animation: _animation,
              );
            },
            childCount: widget.itemCount,
          ),
          gridDelegate: widget.gridDelegate,
        ),
      ],
    );
  }
}

/// Default shimmer item for grid items
class _DefaultGridShimmerItem extends StatelessWidget {
  const _DefaultGridShimmerItem({
    required this.animation,
  });
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return _ShimmerWrapper(
          animation: animation,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

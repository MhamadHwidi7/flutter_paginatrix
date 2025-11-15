import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_skeleton_constants.dart';
import 'package:flutter_paginatrix/src/core/constants/paginatrix_spacing.dart';

/// Creates a CustomScrollView wrapped in Skeletonizer with common properties
/// This helper reduces duplication between PaginatrixSkeletonizer and PaginatrixGridSkeletonizer
Widget _createSkeletonizedScrollView({
  required bool enabled,
  required List<Widget> slivers,
  ScrollPhysics? physics,
  bool shrinkWrap = false,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  EdgeInsetsGeometry? padding,
}) {
  return Skeletonizer(
    enabled: enabled,
    child: CustomScrollView(
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      slivers: [
        if (padding != null) SliverPadding(padding: padding),
        ...slivers,
      ],
    ),
  );
}

/// Skeleton loading effect for pagination loading states using Skeletonizer
class PaginatrixSkeletonizer extends StatelessWidget {
  const PaginatrixSkeletonizer({
    super.key,
    this.itemCount = PaginatrixSkeletonConstants.defaultItemCount,
    this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.enabled = true,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _createSkeletonizedScrollView(
      enabled: enabled,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      slivers: [
        SliverList.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final builder = itemBuilder;
            if (builder != null) {
              return builder(context, index);
            }
            return const _DefaultSkeletonItem();
          },
        ),
      ],
    );
  }
}

/// Default skeleton item for list items
class _DefaultSkeletonItem extends StatelessWidget {
  const _DefaultSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        children: [
          // Avatar placeholder
          Bone.circle(
            size: 48,
          ),
          SizedBox(width: PaginatrixSpacing.horizontalStandard),
          // Content placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(
                  words: 3,
                  fontSize: 16,
                ),
                SizedBox(height: PaginatrixSpacing.medium),
                Bone.text(
                  words: 5,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loading effect for grid items using Skeletonizer
class PaginatrixGridSkeletonizer extends StatelessWidget {
  const PaginatrixGridSkeletonizer({
    super.key,
    this.itemCount = PaginatrixSkeletonConstants.defaultItemCount,
    this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.enabled = true,
    required this.gridDelegate,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool reverse;
  final bool enabled;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    return _createSkeletonizedScrollView(
      enabled: enabled,
      physics: physics,
      shrinkWrap: shrinkWrap,
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      slivers: [
        SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final builder = itemBuilder;
            if (builder != null) {
              return builder(context, index);
            }
            return const _DefaultGridSkeletonItem();
          },
        ),
      ],
    );
  }
}

/// Default skeleton item for grid items
class _DefaultGridSkeletonItem extends StatelessWidget {
  const _DefaultGridSkeletonItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(PaginatrixSpacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Bone.circle(
            size: 60,
          ),
          SizedBox(height: PaginatrixSpacing.horizontalSmall),
          Bone.text(
            words: 2,
            fontSize: 16,
          ),
          SizedBox(height: PaginatrixSpacing.medium),
          Bone.text(
            words: 1,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}

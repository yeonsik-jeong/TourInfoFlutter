import 'package:flutter/material.dart';
import 'dart:math' as math;

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  double minHeight;
  double maxHeight;
  Widget child;

  MySliverPersistentHeaderDelegate({
    required this.minHeight, required this.maxHeight, required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return SizedBox.expand(child: child,);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => math.max(minHeight, maxHeight);

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return maxHeight != oldDelegate.maxExtent ||
      minHeight != oldDelegate.minExtent;
      // child != oldDelegate.getChild;
  }
}
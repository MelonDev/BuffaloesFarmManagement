import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:buffaloes_farm_management/extensions/KotlinScopeFunction.dart';


class MelonStickyListView extends StatelessWidget {
  MelonStickyListView({Key? key,
    @required this.data,
    this.bodyHeaderPinned = false,
    this.bodyHeaderFloating = false,
    this.bodyHeaderMinHeight = 40.0,
    this.bodyHeaderMaxHeight = 50.0,
    @required this.bodyHeaderBuilder,
    @required this.bodyEntryBuilder,
    this.appBar,
    this.header,
    this.footer,
    this.controller,
    this.primary,
    this.physics,
    this.bodyBuilder,
    this.center,
    this.cacheExtent,
    this.semanticChildCount,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.shrinkWrap = false,
    this.anchor = 0.0})
      : super(key: key);

  final double bodyHeaderMinHeight;
  final double bodyHeaderMaxHeight;

  final bool bodyHeaderPinned;

  final bool bodyHeaderFloating;

  final Widget Function(BuildContext context, dynamic value)? bodyHeaderBuilder;

  final Widget Function(BuildContext context, int index, dynamic item)?
  bodyEntryBuilder;

  final Widget Function(BuildContext context, List<dynamic> items)? bodyBuilder;

  final Map<dynamic, List<dynamic>>? data;

  final Widget? appBar;

  final Widget? header;

  final Widget? footer;

  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final Key? center;
  final double? anchor;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior = DragStartBehavior.start;

  @override
  Widget build(BuildContext context) {
    assert(data != null,
    '$runtimeType Data should not be null, please provide valid Data');
    assert(bodyHeaderBuilder != null,
    '$runtimeType headerBuilder should not be null');
    /*assert(bodyEntryBuilder != null,
        '$runtimeType runtimeType should not be null');

     */
    return Builder(builder: (context) {
      var widgetList = <Widget>[];
      appBar?.let((it) {
        widgetList.add(it);
      });
      header?.let((it) {
        widgetList.add(it);
      });
      data?.forEach((key, value) {
        widgetList..add(_MelonGroupedHeader(
            minHeight: bodyHeaderMinHeight,
            maxHeight: bodyHeaderMaxHeight,
            pinned: bodyHeaderPinned,
            floating: bodyHeaderFloating,
            child: bodyHeaderBuilder!(context, key)))
        //..add(_MelonGroupedEntry(data: value, builder: bodyEntryBuilder));
          ..add(bodyBuilder!(context, value));
      });
      footer?.let((it) {
        widgetList.add(it);
      });
      return Scrollbar(
        controller: controller,
        child: CustomScrollView(
          scrollDirection: scrollDirection!,
          reverse: reverse!,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap!,
          center: center,
          anchor: anchor!,
          cacheExtent: cacheExtent,
          slivers: widgetList,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
        ),
      );
    });
  }
}

class _MelonGroupedEntry extends StatelessWidget {
  const _MelonGroupedEntry(
      {Key? key, @required this.data, @required this.builder})
      : super(key: key);

  final List<dynamic>? data;

  final Widget Function(BuildContext context, int index, dynamic item)? builder;

  @override
  Widget build(BuildContext context) {
    assert(data != null,
    '$runtimeType List<Entry> should not be null, please provide valid List<Entry>');
    assert(builder != null,
    '$runtimeType builder should not be null for creating a dynamic grouped list');
    return Container();
  }
}

class _MelonGroupedHeader extends StatelessWidget {
  const _MelonGroupedHeader({Key? key,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
    this.pinned,
    this.floating})
      : super(key: key);

  final double? minHeight;
  final double? maxHeight;
  final Widget? child;
  final bool? pinned;
  final bool? floating;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
        pinned: pinned!,
        floating: floating!,
        delegate: _MelonStickyHeaderDelegate(
          minHeight: minHeight!,
          maxHeight: maxHeight!,
          child: child!,
        ));
  }
}

class _MelonStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double? minHeight;
  final double? maxHeight;
  final Widget? child;

  _MelonStickyHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight!;

  @override
  double get maxExtent => max(maxHeight!, minHeight!);

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_MelonStickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

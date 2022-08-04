library playable_toolbar_flutter;

import 'package:flutter/material.dart';
import 'package:playable_toolbar_flutter/constants.dart';
import 'package:playable_toolbar_flutter/list_item_model.dart';
import 'package:playable_toolbar_flutter/menu_item.dart';

class PlayableToolbarWidget extends StatefulWidget {
  const PlayableToolbarWidget({
    Key? key,
    required this.toolbarItems,
    this.toolbarHeight = 420,
    this.toolbarWidth = 70,
    this.itemsGutter = 10,
    this.itemsOffset = 60,
    this.toolbarHorizontalPadding = 10,
    this.toolbarBackgroundRadius = 15,
    this.toolbarBackgroundColor = Colors.white,
    this.toolbarShadow = Colors.black26,
  }) : super(key: key);

  /// List of items you want to add to toolbar.
  final List<ListItemModel> toolbarItems;

  /// Height of toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// toolbarHeight = 420
  /// ```
  final double toolbarHeight;

  /// Width of toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// toolbarWidth = 70
  /// ```
  final double toolbarWidth;

  /// Gutter for items in toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// itemsGutter = 10
  /// ```
  final double itemsGutter;

  /// Offset for items in toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// itemsOffset = 60
  /// ```
  final double itemsOffset;

  /// Horizontal Padding of toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// toolbarHorizontalPadding = 10
  /// ```
  final double toolbarHorizontalPadding;

  /// Horizontal Padding of toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// toolbarBackgroundColor = Colors.white
  /// ```
  final Color toolbarBackgroundColor;

  /// Background radius of toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// toolbarBackgroundRadius = 15
  /// ```
  final double toolbarBackgroundRadius;

  /// Shadow color under toolbar.
  ///
  /// if not set, default will be :
  /// ```dart
  /// toolbarShadow = Colors.black26
  /// ```
  /// Note: To remove shadow just pass:
  /// ```dart
  /// Colors.transparent
  /// ```
  final Color toolbarShadow;

  // these attributes will be added in future updates
  // final Alignment toolbarAlignment;
  // final Duration longPressAnimationDuration = Duration(milliseconds: 400);
  // final Duration scrollScaleAnimationDuration = Duration(milliseconds: 700);
  // final Curve longPressAnimationCurve = Curves.easeOutSine;
  // final Curve scrollScaleAnimationCurve = Curves.ease;

  @override
  State<PlayableToolbarWidget> createState() => _PlayableToolbarWidgetState();
}

class _PlayableToolbarWidgetState extends State<PlayableToolbarWidget> {
  late ScrollController scrollController;

  double get itemHeight =>
      widget.toolbarWidth - (widget.toolbarHorizontalPadding * 2);

  void scrollListener() {
    if (scrollController.hasClients) {
      _updateItemsScrollData(
        scrollPosition: scrollController.position.pixels,
      );
    }
  }

  List<bool> longPressedItemsFlags = [];

  void _updateLongPressedItemsFlags({double longPressYLocation = 0}) {
    List<bool> _longPressedItemsFlags = [];
    for (int i = 0; i <= widget.toolbarItems.length - 1; i++) {
      bool isLongPressed = itemYPositions[i] >= 0 &&
          longPressYLocation > itemYPositions[i] &&
          longPressYLocation <
              (itemYPositions.length > i + 1
                  ? itemYPositions[i + 1]
                  : widget.toolbarHeight);
      _longPressedItemsFlags.add(isLongPressed);
    }
    setState(() {
      longPressedItemsFlags = _longPressedItemsFlags;
    });
  }

  List<double> itemScrollScaleValues = [];
  List<double> itemYPositions = [];

  void _updateItemsScrollData({double scrollPosition = 0}) {
    List<double> _itemScrollScaleValues = [];
    List<double> _itemYPositions = [];
    for (int i = 0; i <= widget.toolbarItems.length - 1; i++) {
      double itemTopPosition = i * (itemHeight + widget.itemsGutter);
      _itemYPositions.add(itemTopPosition - scrollPosition);

      double itemBottomPosition = (i + 1) * (itemHeight + widget.itemsGutter);
      double distanceToMaxScrollExtent =
          widget.toolbarHeight + scrollPosition - itemTopPosition;
      bool itemIsOutOfView =
          distanceToMaxScrollExtent < 0 || scrollPosition > itemBottomPosition;
      _itemScrollScaleValues.add(itemIsOutOfView ? 0.4 : 1);
    }
    setState(() {
      itemScrollScaleValues = _itemScrollScaleValues;
      itemYPositions = _itemYPositions;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateItemsScrollData();
    _updateLongPressedItemsFlags();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: widget.toolbarHeight,
        margin: EdgeInsets.only(left: widget.toolbarHorizontalPadding),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: widget.toolbarWidth,
                decoration: BoxDecoration(
                  color: widget.toolbarBackgroundColor,
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.toolbarBackgroundRadius)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: widget.toolbarShadow,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onLongPressStart: (details) {
                isLongPressed = true;
                _updateLongPressedItemsFlags(
                  longPressYLocation: details.localPosition.dy,
                );
              },
              onLongPressMoveUpdate: (details) {
                _updateLongPressedItemsFlags(
                  longPressYLocation: details.localPosition.dy,
                );
              },
              onLongPressEnd: (LongPressEndDetails details) {
                isLongPressed = false;
                _updateLongPressedItemsFlags(longPressYLocation: 0);
              },
              onLongPressCancel: () {
                isLongPressed = false;
                _updateLongPressedItemsFlags(longPressYLocation: 0);
              },
              child: AnimatedContainer(
                duration: Constants.longPressAnimationDuration,
                width: isLongPressed
                    ? widget.toolbarWidth * 3.5
                    : widget.toolbarWidth,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.toolbarItems.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return SideBarItem(
                        widget.toolbarItems[index],
                        height: itemHeight,
                        scrollScale: itemScrollScaleValues[index],
                        isLongPressed: longPressedItemsFlags[index],
                        gutter: widget.itemsGutter,
                        itemsOffset: widget.itemsOffset,
                        toolbarWidth: widget.toolbarWidth,
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

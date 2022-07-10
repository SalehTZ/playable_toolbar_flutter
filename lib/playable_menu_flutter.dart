library playable_menu_flutter;

import 'package:flutter/material.dart';
import 'package:playable_menu_flutter/constants.dart';
import 'package:playable_menu_flutter/list_item_model.dart';
import 'package:playable_menu_flutter/menu_item.dart';

class PlayableMenuWidget extends StatefulWidget {
  const PlayableMenuWidget({Key? key, required this.toolbarItems})
      : super(key: key);

  final List<ListItemModel> toolbarItems;
  @override
  State<PlayableMenuWidget> createState() => _PlayableMenuWidgetState();
}

class _PlayableMenuWidgetState extends State<PlayableMenuWidget> {
  late ScrollController scrollController;

  double get itemHeight =>
      Constants.toolbarWidth - (Constants.toolbarHorizontalPadding * 2);

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
                  : Constants.toolbarHeight);
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
      double itemTopPosition = i * (itemHeight + Constants.itemsGutter);
      _itemYPositions.add(itemTopPosition - scrollPosition);

      double itemBottomPosition =
          (i + 1) * (itemHeight + Constants.itemsGutter);
      double distanceToMaxScrollExtent =
          Constants.toolbarHeight + scrollPosition - itemTopPosition;
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
        height: Constants.toolbarHeight,
        margin: const EdgeInsets.only(left: Constants.toolbarHorizontalPadding),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: Constants.toolbarWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.2),
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
                    ? Constants.toolbarWidth * 3
                    : Constants.toolbarWidth,
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
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import 'basics.dart';

import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:forui/forui.dart';

class CollectionPopupMenu extends StatefulWidget {
  final Color iconColor;
  final Color cardColor;
  final List<PopupMenuItemData> items;
  final double iconSize;

  const CollectionPopupMenu({
    Key? key,
    required this.iconColor,
    required this.cardColor,
    required this.items,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  State<CollectionPopupMenu> createState() => _CollectionPopupMenuState();
}

class _CollectionPopupMenuState extends State<CollectionPopupMenu> {
  late final CustomPopupMenuController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomPopupMenuController();
  }

  /// Programmatically open the menu
  void openMenu() {
    _controller.showMenu();
  }

  /// Programmatically close the menu
  void closeMenu() {
    _controller.hideMenu();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: _controller,
      arrowColor: widget.cardColor,
      child: Icon(
        Icons.more_vert,
        color: widget.iconColor,
        size: widget.iconSize,
      ),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          color: widget.cardColor,
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, // all items same width
              children: widget.items
                  .map(
                    (item) => actionRow(
                  onTap: () {
                    closeMenu(); // safely close menu
                    item.onTap(); // run your action
                  },
                  color: item.color,
                  label: item.label,
                  icon: item.icon,
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
    );
  }
}

/// Model to pass menu items
class PopupMenuItemData {
  final VoidCallback onTap;
  final String label;
  final Color color;
  final IconData icon;

  PopupMenuItemData({
    required this.onTap,
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// Single menu row
Widget actionRow({
  required VoidCallback onTap,
  required Color color,
  required String label,
  required IconData icon,
  double verticalPadding = 8.0,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: verticalPadding),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: Text(label, style: TextStyle(color: color)),
          ),
        ],
      ),
    ),
  );
}
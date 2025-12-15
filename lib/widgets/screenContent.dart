import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formbuilder/backend/models/form/screenCustomization.dart';
import 'package:forui/assets.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../backend/models/form/docItem.dart';
import '../data/fonts.dart';
import '../services/themeService.dart';
import 'menu.dart';

class FlatAutoComplete extends StatefulWidget {
  final List<DocItemType> items;
  final String font;
  final Function(String) onSubmit;
  final String? placeholder;
  final theme t;
  final ScreenCustomization screenStyle;
  final VoidCallback? onHover; // 👈 Added hover callback
  final VoidCallback? onClick; // 👈 Added click callback

  const FlatAutoComplete({
    super.key,
    required this.font,
    required this.items,
    required this.onSubmit,
    required this.t,
    this.placeholder = "Type '/' to insert Form items",
    required this.screenStyle,
    this.onHover, // 👈 Optional parameter
    this.onClick, // 👈 Optional parameter
  });

  @override
  State<FlatAutoComplete> createState() => _FlatAutoCompleteState();
}

class _FlatAutoCompleteState extends State<FlatAutoComplete> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<DocItemType> _filteredItems = [];
  int _selectedIndex = -1;
  int _hoveredIndex = -1; // 👈 Added for hover tracking
  late theme t;
  bool isOptionsShown = false;
  bool optionsClicked = false;

  @override
  void initState() {
    super.initState();
    t = widget.t;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;

    if (text.contains('/')) {
      final query = text.split('/').last.toLowerCase();
      setState(() {
        _filteredItems = widget.items
            .where((item) => item.name.toLowerCase().contains(query))
            .toList();
        _selectedIndex = _filteredItems.isEmpty ? -1 : 0;
      });
      _showOverlay();
    } else {
      _removeOverlay();
      setState(() {
        _filteredItems = [];
        _selectedIndex = -1;
        _hoveredIndex = -1; // 👈 Reset hover on close
      });
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getTextFieldWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 45),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = index == _selectedIndex;
                  final isHovered =
                      index == _hoveredIndex; // 👈 Check hover state

                  return MouseRegion(
                    // 👈 Added MouseRegion for hover detection
                    onEnter: (_) {
                      // Use post-frame callback to avoid updating during mouse tracking
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _hoveredIndex = index;
                          });
                        }
                      });
                    },
                    onExit: (_) {
                      // Use post-frame callback to avoid updating during mouse tracking
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _hoveredIndex = -1;
                          });
                        }
                      });
                    },
                    cursor: SystemMouseCursors.click, // 👈 Show pointer cursor
                    child: InkWell(
                      onTap: () => _selectItem(item.name),
                      // 👈 Added splash effect on tap
                      splashColor: t.cardColor.withOpacity(0.3),
                      highlightColor: t.cardColor.withOpacity(0.2),
                      child: AnimatedContainer(
                        // 👈 Smooth transition for background color
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected || isHovered
                              ? t.cardColor
                              : Colors.transparent,
                          // 👈 Optional: Add border radius for smoother look
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            AnimatedSwitcher(
                              // 👈 Smooth icon color transition
                              duration: const Duration(milliseconds: 150),
                              child: Icon(
                                key: ValueKey(
                                  '$index-${isSelected || isHovered}',
                                ),
                                iconBuilder(item),
                                size: 18,
                                color: isSelected || isHovered
                                    ? t.textColor
                                    : t.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedDefaultTextStyle(
                              // 👈 Smooth text style transition
                              duration: const Duration(milliseconds: 150),
                              style: TextStyle(
                                fontSize: 14,
                                color: t.textColor,
                                fontWeight: isSelected || isHovered
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              child: Text(item.name.toLowerCase()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _getTextFieldWidth() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size.width ?? 300;
  }

  void _selectItem(String item) {
    _controller.clear();
    _removeOverlay();
    widget.onSubmit(item);
    setState(() {
      _filteredItems = [];
      _selectedIndex = -1;
      _hoveredIndex = -1; // 👈 Reset hover state
    });
  }

  void _handleSubmit() {
    final text = _controller.text;

    if (_filteredItems.isNotEmpty && _selectedIndex >= 0) {
      _selectItem(_filteredItems[_selectedIndex].name);
    } else if (text.isNotEmpty) {
      _controller.clear();
      _removeOverlay();
      widget.onSubmit(text);
    } else {
      // Enter pressed with empty text, still trigger callback
      widget.onSubmit('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is! KeyDownEvent) return;

          if (event.logicalKey.keyLabel == 'Arrow Down') {
            if (_filteredItems.isNotEmpty) {
              setState(() {
                _selectedIndex = (_selectedIndex + 1) % _filteredItems.length;
              });
              _showOverlay();
            }
          } else if (event.logicalKey.keyLabel == 'Arrow Up') {
            if (_filteredItems.isNotEmpty) {
              setState(() {
                _selectedIndex =
                    (_selectedIndex - 1 + _filteredItems.length) %
                    _filteredItems.length;
              });
              _showOverlay();
            }
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            // Use post-frame callback to avoid MouseTracker assertion
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                widget.onHover?.call();
                setState(() {
                  isOptionsShown = true;
                });
              }
            });
          },
          onExit: (_) {
            // Use post-frame callback to avoid MouseTracker assertion
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                widget.onHover?.call();
                setState(() {
                  isOptionsShown = false;
                });
              }
            });
          },

          child: Row(
            children: [
              if (isOptionsShown)
               Container(
                 decoration: BoxDecoration(
                   color: widget.screenStyle.textColorValue.withOpacity(0.05),
                   borderRadius: BorderRadius.circular(5),
                 ),
                 padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                 child:  Row(
                   children: [
                     GestureDetector(
                         onTap: (){

                     }, child: Icon(
                       HugeIconsStroke.delete03,
                       size: 17,
                       color: t.errorColor,
                     )),
                     SizedBox(width: 8,),
                     CollectionPopupMenu(
                       isFromFormBuilder: true,
                       icon: HugeIconsStroke.plusSign,
                       iconSize: 18,
                       iconColor: widget.screenStyle.textColorValue,
                       cardColor: t.cardColor,
                       items: [
                         PopupMenuItemData(
                           onTap: () {
                             WidgetsBinding.instance.addPostFrameCallback((_) {
                               if (mounted) {
                                 setState(() {
                                   isOptionsShown = false;
                                 });
                               }
                             });
                           },
                           label: "ejfrjt",
                           color: t.textColor,
                           icon: Icons.add_rounded,
                         ),
                       ],
                     ),
                     SizedBox(width: 8,),
                     CollectionPopupMenu(
                       isFromFormBuilder: true,
                       icon: HugeIconsStroke.menuSquare,
                       iconSize: 15,
                       iconColor: widget.screenStyle.textColorValue,
                       cardColor: t.cardColor,
                       items: [
                         PopupMenuItemData(
                           onTap: () {
                             WidgetsBinding.instance.addPostFrameCallback((_) {
                               if (mounted) {
                                 setState(() {
                                   isOptionsShown = false;
                                 });
                               }
                             });
                           },
                           label: "ejfrjt",
                           color: t.textColor,
                           icon: Icons.add_rounded,
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
              Expanded(
                child: GestureDetector(
                  // 👈 Added GestureDetector for click detection
                  onTap: () {
                    widget.onClick?.call(); // 👈 Trigger click callback
                    _focusNode.requestFocus(); // Also focus the text field
                  },
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: AppFonts.getFont(
                      widget.font,
                      base: TextStyle(
                        color: widget.screenStyle.textColorValue,
                        fontSize: widget.screenStyle.fontSize * 1.0,
                      ),
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(
                        12,12,12,12

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData? iconBuilder(DocItemType item) {
    if (item == DocItemType.Text) {
      return HugeIconsStroke.text;
    } else if (item == DocItemType.Checklist) {
      return HugeIconsSolid.solidLine02;
    } else if (item == DocItemType.Input) {
      return HugeIconsStroke.textSquare;
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formbuilder/backend/models/form/screenCustomization.dart';
import 'package:forui/assets.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../backend/models/form/docItem.dart';
import '../services/themeService.dart';

class FlatAutoComplete extends StatefulWidget {
  final List<DocItemType> items;
  final Function(String) onSubmit;
  final String? placeholder;
  final theme t;
  final ScreenCustomization screenStyle;

  const FlatAutoComplete({
    super.key,
    required this.items,
    required this.onSubmit,
    required this.t,
    this.placeholder = "Type '/' to insert Form items",
    required this.screenStyle,
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
  late theme t;

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

                  return InkWell(
                    onTap: () => _selectItem(item.name),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: isSelected ? t.cardColor : null,
                      child: Row(
                        children: [
                          Icon(
                            iconBuilder(item),
                            size: 18,
                              color: isSelected ? t.textColor : t.secondaryTextColor
                          ),
                          SizedBox(width: 10,),
                          Text(
                            item.name,
                            style: TextStyle(
                                fontSize: 14,
                                color: t.textColor
                            ),
                          ),
                        ],
                      )
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
                _selectedIndex = (_selectedIndex - 1 + _filteredItems.length) %
                    _filteredItems.length;
              });
              _showOverlay();
            }
          }
        },
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          maxLines: null, // 👈 allows multiline
          keyboardType: TextInputType.multiline, // 👈 optional but recommended
          style: TextStyle(
            color: widget.screenStyle.textColorValue,
            fontSize: widget.screenStyle.fontSize * 1.0,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),

      ),
    );
  }

  IconData? iconBuilder(DocItemType item) {
    if(item==DocItemType.Image){
      return HugeIconsStroke.image01;
    }else if(item==DocItemType.Text){
      return HugeIconsStroke.text;
    }else if(item==DocItemType.Checklist){
      return HugeIconsSolid.solidLine02;
    }else if(item==DocItemType.Divider){
      return HugeIconsSolid.solidLine01;
    }else if(item==DocItemType.Input){
      return HugeIconsStroke.textSquare;
    }
    return null;
  }
}
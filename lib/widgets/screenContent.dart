import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formbuilder/backend/models/form/screenCustomization.dart';
import 'package:forui/assets.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../backend/models/form/docItem.dart';
import '../data/fonts.dart';
import '../services/themeService.dart';
import 'dialogues.dart';


// Model to represent a line in the document
class DocumentLine {
  final int lineNumber;
  final FormItem? content; // null means empty line

  DocumentLine({
    required this.lineNumber,
    this.content,
  });

  bool get isEmpty => content == null;
}

class FlatAutoComplete extends StatefulWidget {
  final List<DocItemType> items;
  final String font;
  final Function(DocItemType, int, bool) onAction; // itemType, lineNumber, isAdd
  final Function(int) onDelete; // Callback for deleting a line
  final String? placeholder;
  final theme t;
  final ScreenCustomization screenStyle;
  final List<DocumentLine> documentLines; // The tracked list of lines

  const FlatAutoComplete({
    super.key,
    required this.font,
    required this.items,
    required this.onAction,
    required this.onDelete,
    required this.t,
    this.placeholder = "Hover to add or edit items",
    required this.screenStyle,
    required this.documentLines,
  });

  @override
  State<FlatAutoComplete> createState() => _FlatAutoCompleteState();
}

class _FlatAutoCompleteState extends State<FlatAutoComplete> {
  int? _hoveredLineIndex;
  late theme t;

  @override
  void initState() {
    super.initState();
    t = widget.t;
  }

  void _showAddDialog(int lineNumber, bool addBelow) {
    /*
    showDialogAddOrReplaceFormItem(
      context,
      t,
      lineNumber,
      true, // isAdd
          (selectedType) {
        // Callback when user selects an item type
        widget.onAction(selectedType, lineNumber, true);
      },
    );

     */
  }

  void _showReplaceDialog(int lineNumber) {
    /*
    showDialogAddOrReplaceFormItem(
      context,
      t,
      lineNumber,
      false, // isReplace
          (selectedType) {
        // Callback when user selects an item type
        widget.onAction(selectedType, lineNumber, false);
      },
    );

     */
  }

  void _deleteLine(int lineNumber) {
    widget.onDelete(lineNumber);
  }

  Widget _buildLineActions(DocumentLine line, bool isHovered) {
    if (!isHovered) return const SizedBox.shrink();

    if (line.isEmpty) {
      // Empty line: show wide plus button
      return InkWell(
        onTap: () => _showAddDialog(line.lineNumber, false),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            color: widget.screenStyle.textColorValue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                HugeIconsStroke.plusSign,
                size: 18,
                color: t.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Add item',
                style: TextStyle(
                  color: t.textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Line with content: show delete, add above, replace, add below
      return Container(
        decoration: BoxDecoration(
          color: widget.screenStyle.textColorValue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _deleteLine(line.lineNumber),
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: 'Delete',
                  child: Icon(
                    HugeIconsStroke.delete03,
                    size: 17,
                    color: t.errorColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _showAddDialog(line.lineNumber, false),
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: 'Add above',
                  child: Icon(
                    HugeIconsStroke.arrowUp01,
                    size: 17,
                    color: t.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _showReplaceDialog(line.lineNumber),
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: 'Replace',
                  child: Icon(
                    HugeIconsStroke.repeat,
                    size: 17,
                    color: t.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => _showAddDialog(line.lineNumber + 1, true),
              borderRadius: BorderRadius.circular(3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Tooltip(
                  message: 'Add below',
                  child: Icon(
                    HugeIconsStroke.arrowDown01,
                    size: 17,
                    color: t.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildLineContent(DocumentLine line) {
    if (line.isEmpty) {
      return Container(
        constraints: const BoxConstraints(minHeight: 40),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Text(
          widget.placeholder ?? 'Empty line',
          style: AppFonts.getFont(
            widget.font,
            base: TextStyle(
              color: widget.screenStyle.textColorValue.withOpacity(0.4),
              fontSize: widget.screenStyle.fontSize * 1.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else {
      // Render the form item content
      return _renderFormItem(line.content!);
    }
  }

  Widget _renderFormItem(FormItem formItem) {
    final baseStyle = AppFonts.getFont(
      widget.font,
      base: TextStyle(
        color: widget.screenStyle.textColorValue,
        fontSize: widget.screenStyle.fontSize * 1.0,
      ),
    );

    if (formItem is EmptyLineFormItem) {
      return Container(
        height: formItem.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          formItem.getDisplayText(),
          style: baseStyle.copyWith(
            color: widget.screenStyle.textColorValue.withOpacity(0.4),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else if (formItem is TextFormItem) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Text(
          formItem.getDisplayText(),
          style: baseStyle,
          textAlign: formItem.alignment,
        ),
      );
    } else if (formItem is InputFormItem) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formItem.getDisplayText(),
              style: baseStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: formItem.value),
              onChanged: (value) {
                formItem.value = value;
              },
              style: baseStyle,
              decoration: InputDecoration(
                hintText: formItem.placeholder ?? 'Enter value...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: widget.screenStyle.textColorValue.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: widget.screenStyle.textColorValue.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: t.textColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLength: formItem.maxLength,
            ),
          ],
        ),
      );
    } else if (formItem is ChecklistFormItem) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (formItem.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  formItem.title!,
                  style: baseStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ...formItem.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: item.isChecked,
                      onChanged: (value) {
                        setState(() {
                          item.isChecked = value ?? false;
                        });
                      },
                      activeColor: t.textColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.text,
                        style: baseStyle.copyWith(
                          decoration: item.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    }

    // Fallback for unknown types
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Text(
        formItem.getDisplayText(),
        style: baseStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.documentLines.length,
      itemBuilder: (context, index) {
        final line = widget.documentLines[index];
        final isHovered = _hoveredLineIndex == index;

        return MouseRegion(
          onEnter: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hoveredLineIndex = index;
                });
              }
            });
          },
          onExit: (_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hoveredLineIndex = null;
                });
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isHovered
                  ? widget.screenStyle.textColorValue.withOpacity(0.02)
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isHovered
                      ? t.textColor.withOpacity(0.2)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line number indicator
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '${line.lineNumber}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: t.secondaryTextColor.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                // Line content
                Expanded(
                  child: line.isEmpty
                      ? InkWell(
                    onTap: () => _showAddDialog(line.lineNumber, false),
                    child: _buildLineContent(line),
                  )
                      : _buildLineContent(line),
                ),
                // Action buttons (shown on hover)
                if (isHovered)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: _buildLineActions(line, isHovered),
                  ),
              ],
            ),
          ),
        );
      },
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
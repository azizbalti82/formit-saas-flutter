import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../services/themeService.dart';
import 'menu.dart';

class SubmissionsTableWidget extends StatelessWidget {
  final List<List<dynamic>> data;
  final theme t;

  const SubmissionsTableWidget({
    Key? key,
    required this.data,
    required this.t,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
        child: Text(
          "No submissions yet.",
          style: TextStyle(color: t.secondaryTextColor),
        ),
      ));
    }

    final headers = data.first;
    final rows = data.skip(1).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: (t.brightness == Brightness.dark)
            ? null
            : Border.all(color: t.border.withOpacity(0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: DataTable(
                      columnSpacing: 24,
                      dividerThickness: 0.1,
                      headingRowColor: MaterialStateProperty.all(t.cardColor),
                      dataRowColor: (t.brightness == Brightness.dark)
                          ? MaterialStateProperty.all(t.cardColor)
                          : null,
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: t.border, width: 0.6),
                      ),
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: t.textColor,
                      ),
                      dataTextStyle: TextStyle(
                        color: t.secondaryTextColor,
                        fontSize: 14,
                      ),
                      columns: [
                        DataColumn(
                          label: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "",
                              style: TextStyle(color: t.secondaryTextColor),
                            ),
                          ),
                        ),
                        ...headers.map(
                              (h) => DataColumn(
                            label: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(h.toString()),
                            ),
                          ),
                        ),
                      ],
                      rows: List.generate(rows.length, (index) {
                        final row = rows[index];
                        return DataRow(
                          cells: [
                            DataCell(
                              Align(
                                alignment: Alignment.centerRight,
                                child: CollectionPopupMenu(
                                  icon: Icons.more_vert_rounded,
                                  iconColor: t.textColor,
                                  cardColor: t.cardColor,
                                  items: [
                                    PopupMenuItemData(
                                      onTap: () {},
                                      label: "View",
                                      color: t.textColor,
                                      icon: HugeIconsStroke.view,
                                    ),
                                    PopupMenuItemData(
                                      onTap: () {},
                                      label: "Delete Row",
                                      color: t.errorColor,
                                      icon: HugeIconsStroke.delete01,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...row.map(
                                  (c) => DataCell(
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(c.toString()),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

  }
}

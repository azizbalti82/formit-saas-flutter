import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formbuilder/screens/home/widgets/dropList.dart';
import 'package:formbuilder/widgets/messages.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:gradient_glow_border/gradient_glow_border.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../backend/models/form/screen.dart';
import '../../main.dart';
import '../../services/provider.dart';
import '../../services/themeService.dart';
import '../../services/tools.dart';
import '../../widgets/basics.dart';

class RulesEditor extends StatefulWidget {
  RulesEditor({
    super.key,
    required this.t,
    required this.s,
    required this.screenOfConnections,
  });
  final theme t;
  final Screen s;
  final List<Screen> screenOfConnections;

  @override
  State<RulesEditor> createState() => _State();
}

class _State extends State<RulesEditor> {
  // --------------------------------------------------------------------------
  // SERVICES
  // --------------------------------------------------------------------------
  final Provider provider = Get.find<Provider>();
  late theme t;
  late Screen s;
  bool isSavingLoading = false;

  // --------------------------------------------------------------------------
  // LIFECYCLE METHODS
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    t = widget.t;
    s = widget.s;

    final Provider provider = Get.find<Provider>();

    // Create a DEEP COPY of connects, not just a reference!
    provider.connects.value = s.workflow.connects.map((c) => Connect(
      screenId: c.screenId,
      rules: c.rules.map((r) => Rule(
        widgetId: r.widgetId,
        logic: r.logic,
        value: r.value,
      )).toList(),
    )).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return SystemUiStyleWrapper(
      customColor: t.brightness == Brightness.light ? Colors.white : t.bgColor,
      t: t,
      child: Scaffold(
        backgroundColor: t.bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              buildCancelIconButton(t, context, isX: true),
              Spacer(),
              Text(
                isLandscape(context) ? 'Connection Rules' : "Rules",
                style: TextStyle(color: t.textColor),
              ),
              Spacer(),
              FButton.icon(
                onPress: () async {
                  if (isSavingLoading) return;
                  setState(() {
                    isSavingLoading = true;
                  });
                  try {
                    // Save the updated connects back to the screen's workflow
                    s.workflow.connects = provider.connects.value.map((c) => Connect(
                      screenId: c.screenId,
                      rules: c.rules.map((r) => Rule(
                        widgetId: r.widgetId,
                        logic: r.logic,
                        value: r.value,
                      )).toList(),
                    )).toList();

                    // Small delay to simulate save
                    await Future.delayed(const Duration(milliseconds: 500));

                    Navigator.pop(context, true); // Return true to indicate save success
                    showSuccess("Connection Rules Saved", context);
                  } catch (e) {
                    print("Save error: $e");
                    showError("Error while saving: $e", context);
                  } finally {
                    setState(() {
                      isSavingLoading = false; // IMPORTANT: was 'true', should be 'false'
                    });
                  }
                },
                style: FButtonStyle.primary(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 4),
                    if (isSavingLoading)
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: t.bgColor,
                        ),
                      ),
                    SizedBox(width: 10),
                    Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 14,
                        color: t.bgColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    if (s.workflow.connects.isEmpty)
                      Text(
                        "You don't have any connections to this screen yet",
                        style: TextStyle(
                          color: t.secondaryTextColor,
                          fontSize: 16,
                        ),
                      )
                    else
                      _buildConnections(s, t, provider),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildConnections(Screen s, theme t, Provider p) {
    return SingleChildScrollView(
      child: Column(
        children: p.connects
            .map(
              (connect) => SizedBox(
                width: double
                    .infinity, // Takes full available width up to the ConstrainedBox max (800)
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: t.cardColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("Go From  ", style: TextStyle(color: t.textColor)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: t.accentColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          connect.screenId,
                          style: TextStyle(color: t.textColor),
                        ),
                      ),
                      Text(" To ", style: TextStyle(color: t.textColor)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: t.textColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(s.id, style: TextStyle(color: t.bgColor)),
                      ),
                      Text(" Where ", style: TextStyle(color: t.textColor)),
                      ...buildRules(connect.screenId, connect, t, p),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> buildRules(String sId, Connect c, theme t, Provider p) {
    Screen s = widget.screenOfConnections.firstWhere((s) => s.id == sId);
    List<Widget> result = [];
    int i = 0;
    for (Rule r in c.rules) {
      // Add "And" before each rule except the first one
      if (i > 0) {
        result.add(Text(" And ", style: TextStyle(color: t.textColor)));
      }
      result.addAll(getRuleWidget(r, c, p, s));
      i++;
    }

    result.addAll([
      SizedBox(width: 10),
      Material(
        color: t.cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            setState(() {
              // Create a new mutable list and add the new rule
              c.rules = List.from(c.rules)
                ..add(Rule(widgetId: null, logic: null));
              // Update the provider's connects to trigger reactivity
              p.connects.refresh();
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(HugeIconsStroke.add01, color: t.textColor, size: 16),
              SizedBox(width: 5),
              Text(
                'Add Rule',
                style: TextStyle(color: t.textColor, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 10),
    ]);

    return result;
  }

  List<Widget> getRuleWidget(Rule r, Connect c, Provider p, Screen screenFrom) {
    List<Widget> result = [
      // Widget/Item selection dropdown
      RuleDropList(
        items: screenFrom.content
            .map((i) => i.type.name + (i.position + 1).toString())
            .toList(),
        f: (v) {
          setState(() {
            // Find the widget id from the selected value
            var selectedWidget = screenFrom.content.firstWhere(
                  (i) => i.type.name + (i.position + 1).toString() == v,
            );

            // Update the rule
            int ruleIndex = c.rules.indexOf(r);
            if (ruleIndex != -1) {
              List<Rule> newRules = List.from(c.rules);
              newRules[ruleIndex] = Rule(
                widgetId: selectedWidget.id,
                logic: r.logic,
                value: r.value,
              );
              c.rules = newRules;
              p.connects.refresh();
            }
          });
        },
        hint: "Select item",
      ),
      SizedBox(width: 5),

      // Logic/Rule selection dropdown
      RuleDropList(
        items: [], // Empty because isTextRules will populate it
        f: (v) {
          setState(() {
            int ruleIndex = c.rules.indexOf(r);
            if (ruleIndex != -1) {
              List<Rule> newRules = List.from(c.rules);
              newRules[ruleIndex] = Rule(
                widgetId: r.widgetId,
                logic: v,
                value: r.value,
              );
              c.rules = newRules;
              p.connects.refresh();
            }
          });
        },
        isTextRules: true,
        hint: "Select rule",
      ),
      SizedBox(width: 5),

      // Value input field
      SizedBox(
        width: 100,
        child: FTextField(
          enabled: true,
          hint: 'Value',
          initialText: r.value ?? '',
          onChange: (v) {
            // Update the rule value
            int ruleIndex = c.rules.indexOf(r);
            if (ruleIndex != -1) {
              List<Rule> newRules = List.from(c.rules);
              newRules[ruleIndex] = Rule(
                widgetId: r.widgetId,
                logic: r.logic,
                value: v,
              );
              c.rules = newRules;
              p.connects.refresh();
            }
          },
        ),
      ),
      SizedBox(width: 5),

      // Delete button
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: t.errorColor,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              c.rules = List.from(c.rules)..remove(r);
              p.connects.refresh();
            });
          },
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: Icon(Icons.close_rounded, color: t.textColor, size: 14),
          ),
        ),
      ),
    ];
    return result;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../services/provider.dart';
import '../../../services/sharedPreferencesService.dart';

class ItemsViewType extends StatelessWidget {
  ItemsViewType({super.key});

  final Provider provider = Get.find<Provider>();
  final options = ['Grid', 'List'];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: FSelect<String>(
      hint: (provider.isGrid.value) ? "Grid" : "List",
      format: (s) => s,
      children: [for (final v in options) FSelectItem(v, v)],
      onChange: (value) {
        provider.isGrid.value = (value == "Grid");
        SharedPrefService.saveIsGrid(provider.isGrid.value);
      },
    ),
  );
}
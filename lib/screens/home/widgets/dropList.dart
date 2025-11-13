import 'package:flutter/cupertino.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

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

class FontFamilySelector extends StatelessWidget {
  FontFamilySelector({super.key});

  final Provider provider = Get.find<Provider>();
  final fonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Poppins',
    'Raleway',
    'Ubuntu',
    'Nunito',
    'Merriweather',
    'Playfair Display',
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 150,
    child: FSelect<String>(
      hint: "Roboto",//provider.currentFont.value,
      format: (s) => s,
      children: [
        for (final font in fonts)
          FSelectItem(
            font,
            font,
          )
      ],
      onChange: (value) {
        //provider.currentFont.value = value;
        //SharedPrefService.saveFont(value);
      },
    ),
  );
}
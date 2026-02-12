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
  FontFamilySelector({super.key,required this.f, required this.selectedValue});

  final Function(String value) f;
  final String selectedValue;
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
      hint: selectedValue,
      format: (s) => s,
      children: [
        for (final font in fonts)
          FSelectItem(
            font,
            font,
          )
      ],
      onChange: (v){
        if(v!=null){
          f(v);
        }
      },
    ),
  );
}

class RuleDropList extends StatelessWidget {
  RuleDropList({super.key,required this.f,required this.items,this.isTextRules,this.isNumberRules,this.hint="Select item"});

  final Function(String value) f;
  List<String> items;
  final Provider provider = Get.find<Provider>();
  final bool? isTextRules;
  final bool? isNumberRules;
  final String hint;


  final textRules = [
    'Equal',
    'Not Equal',
    'Length Greater Than',
    'Length Less Than',
    'Length Equal',
    'Contains',
    'Starts With',
    'Ends With',
    'Is Empty',
    'Is Not Empty',
  ];
  final numberRules = [
    'Equal',
    'Not Equal',
    'Greater Than',
    'Less Than',
    'Is Empty',
    'Is Not Empty',
  ];

  @override
  Widget build(BuildContext context){
    if(isNumberRules!=null && isNumberRules!){
      items = numberRules;
    }else if(isTextRules!=null && isTextRules!){
      items = textRules;
    }
    return SizedBox(
      width: 150,
      child: FSelect<String>(
        hint: hint,
        format: (s) => s,
        children: [
          for (final item in items)
            FSelectItem(
              item,
              item,
            )
        ],
        onChange: (v){
          if(v!=null){
            f(v);
          }
        },
      ),
    );
  }
}
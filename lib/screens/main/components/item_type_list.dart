// Project: 	   listi_shop
// File:    	   item_type_list
// Path:    	   lib/screens/main/components/item_type_list.dart
// Author:       Ali Akbar
// Date:        04-04-24 20:33:08 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

class ItemTypeList extends StatefulWidget {
  const ItemTypeList(
      {super.key, required this.categories, required this.onSelectedCategory});
  final List<String> categories;
  final Function(String) onSelectedCategory;

  @override
  State<ItemTypeList> createState() => _ItemTypeListState();
}

class _ItemTypeListState extends State<ItemTypeList> {
  int selectedIndex = 0;
  late final List<String> items;

  @override
  void initState() {
    items = widget.categories;
    items.insert(0, "All");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return CustomInkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onSelectedCategory(items[selectedIndex]);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
            decoration: BoxDecoration(
              gradient: selectedIndex == index
                  ? AppTheme.primaryLinearGradient
                  : null,
              border: selectedIndex == index
                  ? null
                  : Border.all(color: Colors.black.withOpacity(0.09)),
              borderRadius: const BorderRadius.all(Radius.circular(27)),
            ),
            child: Center(
              child: Text(
                items[index],
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selectedIndex == index
                      ? Colors.white
                      : AppTheme.subTitleColor2.withOpacity(0.7),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

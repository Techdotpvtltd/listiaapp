// Project: 	   listi_shop
// File:    	   item_type_list
// Path:    	   lib/screens/main/components/item_type_list.dart
// Author:       Ali Akbar
// Date:        04-04-24 20:33:08 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import '../../../blocs/item/item_bloc.dart';
import '../../../blocs/item/item_state.dart';
import '../../../models/category_model.dart';
import '../../../repos/category_repo.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView(
      {super.key, required this.categories, required this.onSelectedCategory});
  final List<String> categories;
  final Function(CategoryModel) onSelectedCategory;

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  int selectedIndex = 0;
  late List<CategoryModel> categories;

  @override
  void initState() {
    categories =
        CategoryRepo().getCategoriesFrom(categoryIds: widget.categories);
    categories.insert(
        0,
        CategoryModel(
            id: "all", item: "All", createdAt: DateTime.now(), createdBy: ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemStateAdded || state is ItemStateUpdated) {
          categories =
              CategoryRepo().getCategoriesFrom(categoryIds: widget.categories);
          categories.insert(
              0,
              CategoryModel(
                  id: "all",
                  item: "All",
                  createdAt: DateTime.now(),
                  createdBy: ""));
        }
      },
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CustomInkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onSelectedCategory(categories[selectedIndex]);
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
                  categories[index].item,
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
      ),
    );
  }
}

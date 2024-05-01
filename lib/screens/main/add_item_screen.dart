// Project: 	   listi_shop
// File:    	   add_item_screen
// Path:    	   lib/screens/main/add_item_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 19:49:30 -- Thursday
// Description:

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_event.dart';
import '../../blocs/item/item_state.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';
import '../../repos/category_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';
import '../components/custom_dropdown.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen(
      {super.key, required this.listId, required this.categories, this.item});
  final String listId;
  final List<String> categories;
  final ItemModel? item;
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;
  String? selectedCategory;
  late final ItemModel? item = widget.item;
  late final List<CategoryModel> categories =
      CategoryRepo().getCategoriesFrom(categoryIds: widget.categories);
  TextEditingController nameController = TextEditingController();
  TextEditingController celeriesController = TextEditingController();
  TextEditingController macrosController = TextEditingController();

  void triggerAddItemEvent(ItemBloc bloc) {
    setState(() {
      errorCode = null;
    });
    int? celeries = int.tryParse(celeriesController.text);
    int? macros = int.tryParse(macrosController.text);

    bloc.add(
      ItemEventAddNew(
        itemName: nameController.text,
        celeries: celeries,
        macros: macros,
        listId: widget.listId,
        category: selectedCategory ?? "",
      ),
    );
  }

  void triggerUpdateItemEvent(ItemBloc bloc, {required String ItemId}) {
    setState(() {
      errorCode = null;
    });
    int? celeries = int.tryParse(celeriesController.text);
    int? macros = int.tryParse(macrosController.text);

    bloc.add(
      ItemEventUpdate(
        itemName: nameController.text,
        celeries: celeries,
        macros: macros,
        itemId: ItemId,
        category: selectedCategory ?? "",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (item != null) {
      nameController.text = item?.itemName ?? "";
      celeriesController.text = item?.celeries.toString() ?? "";
      macrosController.text = item?.macros.toString() ?? "";
      selectedCategory = item?.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemStateAdding ||
            state is ItemStateAddFailure ||
            state is ItemStateAdded ||
            state is ItemStateUpdated ||
            state is ItemStateUpdateFailure ||
            state is ItemStateUpdating) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ItemStateAddFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }

            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ItemStateUpdateFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }

            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ItemStateAdded) {
            CustomDialogs().successBox(
              message: "An item has been successfully added to the list.",
              title: "Item Added",
              positiveTitle: "Back to list",
              onPositivePressed: () {
                NavigationService.back();
              },
              negativeTitle: "Add New",
              onNegativePressed: () {
                /// Reset the screen
                setState(() {
                  nameController.clear();
                  celeriesController.clear();
                  macrosController.clear();
                });
              },
            );
          }

          if (state is ItemStateUpdated) {
            CustomDialogs().successBox(
              message: "An item has been successfully updated",
              title: "Item Updated",
              positiveTitle: "Back to list",
              onPositivePressed: () {
                NavigationService.back();
              },
            );
          }
        }
      },
      child: CustomScaffold(
        title: item != null ? "Update Item" : "Add New Item",
        body: HVPadding(
          verticle: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Create New List Label
              Text(
                item != null ? "Update Item" : "Add New Item",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppTheme.titleColor1,
                ),
              ),
              gapH2,
              Text(
                "Please fill the information to add new item in the list.",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 9,
                  color: AppTheme.subTitleColor2,
                ),
              ),
              gapH32,

              /// Item Name text Filed
              CustomTextFiled(
                controller: nameController,
                errorCode: errorCode,
                errorText: errorMessage,
                fieldId: 1,
                hintText: "Enter Name",
                titleText: "Item name",
              ),

              gapH20,

              /// Select Category Filed
              CustomTextFieldDropdown(
                hintText: "Select Category",
                titleText: "Select Category",
                selectedValue: CategoryRepo()
                    .getCategoryFrom(categoryId: selectedCategory ?? "")
                    ?.item,
                items: categories.map((e) => e.item).toList(),
                onSelectedItem: (category) {
                  if (selectedCategory != "") {
                    selectedCategory = categories
                        .firstWhere((element) =>
                            element.item.toLowerCase() ==
                            category.toLowerCase())
                        .id;
                  }
                },
              ),
              gapH20,

              Row(
                children: [
                  /// Item Name text Filed
                  Expanded(
                    child: CustomTextFiled(
                      controller: celeriesController,
                      hintText: "Enter Value",
                      titleText: "Total Celeries",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  gapW10,
                  Expanded(
                    child: CustomTextFiled(
                      controller: macrosController,
                      hintText: "Enter Value",
                      titleText: "Total Macros",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              /// Add Button
              CustomButton(
                isLoading: isLoading,
                title: item != null ? "Update" : "Add",
                onPressed: () {
                  item != null
                      ? triggerUpdateItemEvent(context.read<ItemBloc>(),
                          ItemId: item!.id)
                      : triggerAddItemEvent(context.read<ItemBloc>());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

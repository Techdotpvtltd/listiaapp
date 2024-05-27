// Project: 	   listi_shop
// File:    	   add_item_screen
// Path:    	   lib/screens/main/add_item_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 19:49:30 -- Thursday
// Description:

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

import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_event.dart';
import '../../blocs/item/item_state.dart';
import '../../models/category_model.dart';
import '../../models/item_model.dart';
import '../../repos/category_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';
import '../components/custom_dropdown.dart';
import '../components/custom_snack_bar.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.listId, this.item});
  final String listId;
  final ItemModel? item;
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;
  String? selectedCategoryId;
  late final ItemModel? item = widget.item;
  late List<CategoryModel> categories = CategoryRepo().categories;
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  List<String> categoryNames = [];

  void triggerAddItemEvent(ItemBloc bloc) {
    setState(() {
      errorCode = null;
    });

    bloc.add(
      ItemEventAddNew(
        itemName: nameController.text,
        listId: widget.listId,
        category: selectedCategoryId ?? "",
        quantity: int.tryParse(quantityController.text) ?? 1,
      ),
    );
  }

  void triggerAddCategoryEvent(CategoryBloc bloc, String categoryName) {
    bloc.add(CategoryEventAdd(category: categoryName));
  }

  void triggerUpdateItemEvent(ItemBloc bloc, {required String itemId}) {
    setState(() {
      errorCode = null;
    });

    bloc.add(
      ItemEventUpdate(
        itemName: nameController.text,
        itemId: itemId,
        category: selectedCategoryId ?? "",
        quantity: int.tryParse(quantityController.text) ?? 1,
      ),
    );
  }

  void updateCatoriesName() {
    categoryNames.clear();
    categoryNames = categories.map((e) => e.item).toList();
    categoryNames.insert(0, "Add New");
  }

  @override
  void initState() {
    super.initState();
    updateCatoriesName();
    quantityController.text = item?.quantity.toString() ?? "1";
    if (item != null) {
      nameController.text = item?.itemName ?? "";
      selectedCategoryId = item?.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Category Listener
        BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryStateAddFailure ||
                state is CategoryStateAdded ||
                state is CategoryStateAdding) {
              if (state is CategoryStateAddFailure) {
                CustomDialogs().errorBox(message: state.exception.message);
              }

              if (state is CategoryStateAdded) {
                setState(() {
                  categories = CategoryRepo().categories;
                  updateCatoriesName();
                });
              }
            }
          },
        ),

        /// Item Listener
        BlocListener<ItemBloc, ItemState>(
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
                CustomSnackBar().success("Added");
                nameController.clear();
                quantityController.text = "1";
                setState(() {
                  selectedCategoryId = null;
                });
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
        ),
      ],
      child: CustomScaffold(
        title: item != null ? "Update Item" : "Add New Item",
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:

            /// Add Button
            HorizontalPadding(
          child: CustomButton(
            isLoading: isLoading,
            title: item != null ? "Update" : "Add",
            onPressed: () {
              item != null
                  ? triggerUpdateItemEvent(context.read<ItemBloc>(),
                      itemId: item!.id)
                  : triggerAddItemEvent(context.read<ItemBloc>());
            },
          ),
        ),
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
                    .getCategoryFrom(categoryId: selectedCategoryId ?? "")
                    ?.item,
                items: categoryNames,
                onSelectedItem: (category) {
                  if (category != "") {
                    if (category.toLowerCase() == "add new") {
                      CustomDialogs().showTextField(
                        title: "Add Category",
                        tfHint: "Enter Category Name:",
                        buttonTitle: "Save",
                        onDone: (value) {
                          triggerAddCategoryEvent(
                              context.read<CategoryBloc>(), value);
                        },
                      );
                      return;
                    }
                    setState(() {
                      selectedCategoryId = categories
                          .firstWhere((element) =>
                              element.item.toLowerCase() ==
                              category.toLowerCase())
                          .id;
                    });
                  }
                },
              ),
              gapH20,

              // Quantity Controller
              CustomTextFiled(
                controller: quantityController,
                hintText: "Enter quantity",
                titleText: "Quantity",
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

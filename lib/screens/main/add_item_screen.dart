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
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen(
      {super.key, required this.listId, required this.categories});
  final String listId;
  final List<String> categories;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;
  String? selectedCategory;
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemStateAdding ||
            state is ItemStateAddFailure ||
            state is ItemStateAdded) {
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
                  selectedCategory = null;
                });
              },
            );
          }
        }
      },
      child: CustomScaffold(
        title: "Add New Item",
        body: HVPadding(
          verticle: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Create New List Label
              Text(
                "Add New List",
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
                title: "Add",
                onPressed: () {
                  triggerAddItemEvent(context.read<ItemBloc>());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

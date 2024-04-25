// Project: 	   listi_shop
// File:    	   create_list_screen
// Path:    	   lib/screens/main/create_list_screen.dart
// Author:       Ali Akbar
// Date:        22-04-24 12:24:17 -- Monday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';

import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/list/list_bloc.dart';
import '../../blocs/list/list_event.dart';
import '../../blocs/list/list_state.dart';
import '../../models/category_model.dart';
import '../../repos/category_repo.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';
import '../components/custom_button.dart';
import '../components/custom_scaffold.dart';
import '../components/custom_title_textfiled.dart';
import '../components/paddings.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key});

  @override
  State<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;
  List<String> selectedCategories = [];
  TextEditingController nameController = TextEditingController();

  void triggerCreateListEvent(ListBloc bloc) {
    bloc.add(ListEventCreate(
        title: nameController.text, categories: selectedCategories));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        if (state is ListStateCreating ||
            state is ListStateCreated ||
            state is ListStateCreateFailure) {
          setState(() {
            isLoading = state.isLoading;
          });
          if (state is ListStateCreateFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ListStateCreated) {
            CustomDialogs().successBox(
              message: "Your list has been successfully created.",
              title: "List Created",
              positiveTitle: "Go back",
              onPositivePressed: () {
                NavigationService.back();
              },
            );
          }
        }
      },
      child: CustomScaffold(
        title: "Create New List",
        body: HVPadding(
          verticle: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Create New List Label
              Text(
                "Create New List",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppTheme.titleColor1,
                ),
              ),
              gapH2,
              Text(
                "Please fill the information to create the list",
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
                fieldId: 1,
                errorText: errorMessage,
                errorCode: errorCode,
                hintText: "Enter Name",
                titleText: "List name",
              ),
              // Select Category Items
              gapH20,
              Text(
                "Select Categories",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: AppTheme.titleColor1,
                ),
              ),
              gapH10,
              _CategoryBubble(
                onItemsUpdated: (items) {
                  selectedCategories = items.map((e) => e.id).toList();
                },
              ),
              const Spacer(),
              CustomButton(
                title: "Create",
                isLoading: isLoading,
                onPressed: () {
                  triggerCreateListEvent(context.read<ListBloc>());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBubble extends StatefulWidget {
  const _CategoryBubble({required this.onItemsUpdated});
  final Function(List<CategoryModel>) onItemsUpdated;
  @override
  State<_CategoryBubble> createState() => _CategoryBubbleState();
}

class _CategoryBubbleState extends State<_CategoryBubble> {
  List<CategoryModel> items = CategoryRepo().categories;
  final selectedItems = <CategoryModel>[];

  void triggerAddCategoryEvent(CategoryBloc bloc, String categoryName) {
    bloc.add(CategoryEventAdd(category: categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryStateAddFailure ||
            state is CategoryStateAdded ||
            state is CategoryStateAdding) {
          if (state is CategoryStateAddFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is CategoryStateAdded) {
            setState(() {
              items = CategoryRepo().categories;
            });
          }
        }
      },
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: [
          for (final CategoryModel item in items)
            Builder(
              builder: (context) {
                final bool isSelected = selectedItems.contains(item);
                return CustomInkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(item);
                        widget.onItemsUpdated(selectedItems);
                        return;
                      }
                      selectedItems.add(item);
                      widget.onItemsUpdated(selectedItems);
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor1 : Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: AppTheme.primaryColor1),
                    ),
                    child: Text(
                      item.item,
                      style: GoogleFonts.plusJakartaSans(
                        color:
                            isSelected ? Colors.white : AppTheme.primaryColor1,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Add More Button
          CustomInkWell(
            onTap: () {
              CustomDialogs().showTextField(
                title: "Add Category",
                tfHint: "Enter Category Name:",
                onDone: (value) {
                  triggerAddCategoryEvent(context.read<CategoryBloc>(), value);
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                "Add Category",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

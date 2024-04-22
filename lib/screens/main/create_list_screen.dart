// Project: 	   listi_shop
// File:    	   create_list_screen
// Path:    	   lib/screens/main/create_list_screen.dart
// Author:       Ali Akbar
// Date:        22-04-24 12:24:17 -- Monday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';

import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
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
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
            const CustomTextFiled(
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
            const _CategoryBubble(),
            const Spacer(),
            CustomButton(title: "Create", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _CategoryBubble extends StatefulWidget {
  const _CategoryBubble();

  @override
  State<_CategoryBubble> createState() => _CategoryBubbleState();
}

class _CategoryBubbleState extends State<_CategoryBubble> {
  final items = <String>[];
  final selectedItems = <String>[];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: [
        for (String item in items)
          Builder(
            builder: (context) {
              final bool isSelected = selectedItems.contains(item);
              return CustomInkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItems.remove(item);
                      return;
                    }
                    selectedItems.add(item);
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
                    item,
                    style: GoogleFonts.plusJakartaSans(
                      color: isSelected ? Colors.white : AppTheme.primaryColor1,
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
            CustomDilaogs().showTextField(
              title: "Add Category",
              tfHint: "Enter Category Name:",
              onDone: (value) {
                final nitems = items.map((e) => e.toLowerCase()).toList();
                if (nitems.contains(value.toLowerCase())) {
                  CustomDilaogs().errorBox(message: "Category Already existed");
                  return;
                }
                setState(() {
                  items.add(value);
                });
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
    );
  }
}

// Project: 	   listi_shop
// File:    	   add_item_screen
// Path:    	   lib/screens/main/add_item_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 19:49:30 -- Thursday
// Description:

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Add New Item",
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
              titleText: "Item name",
            ),

            gapH20,
            const Row(
              children: [
                /// Item Name text Filed
                Expanded(
                  child: CustomTextFiled(
                    hintText: "Enter Value",
                    titleText: "Total Celeries",
                    keyboardType: TextInputType.number,
                  ),
                ),
                gapW10,
                Expanded(
                  child: CustomTextFiled(
                    hintText: "Enter Value",
                    titleText: "Enter Value",
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Spacer(),

            /// Add Button
            CustomButton(title: "Add", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

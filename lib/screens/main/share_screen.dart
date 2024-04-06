// Project: 	   listi_shop
// File:    	   share_screen
// Path:    	   lib/screens/main/share_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 22:06:37 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/components/custom_checkbox.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  List<int> selectedIndex = [];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: HorizontalPadding(
        child: CustomButton(
          title: "Invite Now",
          onPressed: () {},
        ),
      ),
      title: "Share",
      body: HVPadding(
        verticle: 29,
        child: Column(
          children: [
            const CustomTextFiled(
              hintText: "Search",
              prefixWidget: Icon(
                Icons.search,
                color: AppTheme.primaryColor2,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 22, bottom: 100),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final bool isSelected = selectedIndex.contains(index);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: CustomInkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            setState(() {
                              selectedIndex.remove(index);
                            });
                          } else {
                            setState(() {
                              selectedIndex.add(index);
                            });
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              /// Profile Widget
                              const AvatarWidget(
                                width: 38,
                                height: 38,
                                backgroundColor: AppTheme.primaryColor2,
                              ),
                              // Name Widget
                              gapW10,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ali Akbar",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.titleColor1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  gapH6,
                                  Text(
                                    "12345678",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.titleColor1,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          CustomCheckBox(isChecked: isSelected),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

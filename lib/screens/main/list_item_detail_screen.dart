// Project: 	   listi_shop
// File:    	   list_item_detail_screen
// Path:    	   lib/screens/main/list_item_detail_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 20:07:06 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/add_item_screen.dart';
import 'package:listi_shop/screens/main/cart_screen.dart';
import 'package:listi_shop/screens/main/components/custom_checkbox.dart';
import 'package:listi_shop/screens/main/components/item_type_list.dart';
import 'package:listi_shop/screens/main/components/profiles_widget.dart';
import 'package:listi_shop/screens/main/share_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

class ListItemDetailScreen extends StatefulWidget {
  const ListItemDetailScreen({super.key});

  @override
  State<ListItemDetailScreen> createState() => _ListItemDetailScreenState();
}

class _ListItemDetailScreenState extends State<ListItemDetailScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "",
      scaffoldkey: scaffoldKey,
      floatingActionButton: HorizontalPadding(
        child: CustomButton(
          title: "Add new item",
          onPressed: () {
            NavigationService.go(const AddItemScreen());
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      endDrawer: Container(
        width: SCREEN_WIDTH * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xFFFEFEFE).withOpacity(0.87),
        ),
        child: CartScreen(scaffoldKey: scaffoldKey),
      ),
      actions: [
        const ProfilesWidget(
          avatarts: [
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5B6V0mxFbSf25cnxc5QntGStilTtjimuC0N_OnfaHTQ&s",
            "https://wallpapers.com/images/hd/professional-profile-pictures-1427-x-1920-txfewtw6mcg0y6hk.jpg",
          ],
          height: 50,
        ),
        gapW10,

        /// Add User Button
        CustomInkWell(
          onTap: () {
            NavigationService.go(const ShareScreen());
          },
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 12,
            ),
          ),
        ),
        gapW20,
      ],
      body: HVPadding(
        verticle: 19,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// List Title
                    Text(
                      "Aplha List",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.titleColor1,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    gapH4,
                    Row(
                      children: [
                        SvgPicture.asset(AppAssets.menuIcon),
                        gapW4,
                        Text(
                          "List 1/7 Completed",
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF6C6C6C),
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Bucket Button
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFF8F8F8)),
                        padding: MaterialStatePropertyAll(EdgeInsets.all(14)),
                      ),
                      icon: SvgPicture.asset(AppAssets.bucketIcon),
                    );
                  },
                ),
              ],
            ),
            gapH12,

            /// Search Text Field,
            const CustomTextFiled(
              hintText: "Search",
              prefixWidget: Icon(
                Icons.search,
                color: AppTheme.primaryColor2,
              ),
            ),
            gapH20,

            /// Item Type List
            const SizedBox(
              height: 30,
              child: ItemTypeList(),
            ),
            gapH20,
            Text(
              "Meat",
              style: GoogleFonts.plusJakartaSans(
                color: AppTheme.titleColor1,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Expanded(
              child: _ItemList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemList extends StatefulWidget {
  const _ItemList();

  @override
  State<_ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<_ItemList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 14, bottom: 100),
      itemCount: 10,
      itemBuilder: (context, index) {
        final bool isSelected = selectedIndex == index;

        return CustomInkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: const Alignment(0.99, -0.10),
                      end: const Alignment(-0.99, 0.1),
                      colors: [
                        const Color(0xFF30A94A).withOpacity(0.02),
                        const Color(0x002EA346).withOpacity(0.09),
                      ],
                    )
                  : null,
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor2
                    : const Color(0xFFF3F3F3),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    /// Check Box
                    CustomCheckBox(isChecked: isSelected),
                    gapW10,
                    // Title Text
                    Text(
                      "Chicken",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.titleColor1,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                ///
                Row(
                  children: [
                    SvgPicture.asset(AppAssets.fireIcon),
                    gapW4,
                    Text(
                      "23 celeries",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF676767),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        decoration:
                            isSelected ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    gapW10,
                    SvgPicture.asset(AppAssets.electricIcon),
                    gapW4,
                    Text(
                      "64 macros",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF676767),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        decoration:
                            isSelected ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

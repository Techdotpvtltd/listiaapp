// Project: 	   listi_shop
// File:    	   custom_dropdown
// Path:    	   lib/screens/components/custom_dropdown.dart
// Author:       Ali Akbar
// Date:        23-04-24 16:54:23 -- Tuesday
// Description:

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import '../../utils/constants/constants.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    this.titleText,
    required this.hintText,
    required this.items,
    required this.onSelectedItem,
  });
  final String? titleText;
  final String hintText;
  final List<String> items;
  final Function(String) onSelectedItem;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool isShowPassword = true;
  List<String> items = [];
  String? selectedItem;

  @override
  void initState() {
    setState(() {
      items = List.from(widget.items);
    });
    debugPrint(items.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.titleText != null,
          child: Text(
            widget.titleText ?? "",
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.titleColor1,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        gapH10,

        /// Dropdown Buttton
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            items: items
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.titleColor1,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            value: selectedItem,
            onChanged: (value) {
              setState(() {
                selectedItem = value;
              });
              widget.onSelectedItem(value ?? "");
            },
            hint: Text(
              widget.hintText,
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF838383),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.all(
                  Radius.circular(124),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

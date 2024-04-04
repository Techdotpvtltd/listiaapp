// Project: 	   listi_shop
// File:    	   notification_screen
// Path:    	   lib/screens/main/notification_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 18:15:28 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Notifications",
      body: HorizontalPadding(
        child: ListView.builder(
          itemCount: 5,
          padding: const EdgeInsets.symmetric(vertical: 30),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 94.83,
                    color: const Color(0xFF989898).withOpacity(0.15),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// Avatart Profile
                  const AvatarWidget(
                    width: 45,
                    height: 45,
                    backgroundColor: AppTheme.primaryColor2,
                    avatarUrl: "",
                  ),
                  gapW16,

                  /// Text Widgets
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ali Akbar",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.7,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        gapH10,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "Ronaldo Seemd Edit items",
                                maxLines: 2,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF525252),
                                ),
                              ),
                            ),
                            Text(
                              "09:20 AM",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF8F8F8F),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

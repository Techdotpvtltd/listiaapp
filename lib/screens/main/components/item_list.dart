// Project: 	   listi_shop
// File:    	   item_list
// Path:    	   lib/screens/main/components/item_list.dart
// Author:       Ali Akbar
// Date:        04-04-24 13:42:42 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/main/components/profiles_widget.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  Color pointGraphValueColor(dynamic datum, int index) {
    if (datum['value'] < 1) {
      return Colors.transparent;
    }

    if (datum['value'] > 0 && datum['value'] < 25) {
      return const Color(0xFFED4A04);
    }
    if (datum['value'] > 24 && datum['value'] < 40) {
      return const Color(0xFF0474ED);
    }
    if (datum['value'] > 39 && datum['value'] < 50) {
      return const Color(0xFFAE5AD4);
    }
    if (datum['value'] > 49 && datum['value'] < 75) {
      return const Color(0xFF10DADA);
    }
    if (datum['value'] > 74 && datum['value'] < 100) {
      return const Color(0xFFE9D846);
    }
    return const Color(0xFF3DAE83);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 18, bottom: 80),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE).withOpacity(0.88),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(13, 9),
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30.6,
                spreadRadius: 0,
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Graph Chart
              Flexible(
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        centerX: "40%",
                        series: [
                          RadialBarSeries(
                            dataSource: const [
                              {"x": 0, "value": 20}
                            ],
                            xValueMapper: (data, _) => data['x'],
                            yValueMapper: (data, _) => data['value'],
                            pointColorMapper: (datum, index) =>
                                pointGraphValueColor(datum, index),
                            radius: "100%",
                            innerRadius: "70%",
                            maximumValue: 100,
                          )
                        ],
                      ),
                    ),
                    gapW6,

                    /// Text Widgets
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title Text
                          Text(
                            "Aplha List",
                            maxLines: 2,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.titleColor1,
                            ),
                          ),
                          gapH2,

                          /// Number Of items text
                          Text(
                            "1 / 5",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF238A34),
                            ),
                          ),

                          /// Date Label
                          Text(
                            "5 March 2023",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.subTitleColor1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Most Right Widgets
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// Profile Widget
                    const ProfilesWidget(
                      height: 44,
                      avatarts: [
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5B6V0mxFbSf25cnxc5QntGStilTtjimuC0N_OnfaHTQ&s",
                        "https://wallpapers.com/images/hd/professional-profile-pictures-1427-x-1920-txfewtw6mcg0y6hk.jpg",
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5B6V0mxFbSf25cnxc5QntGStilTtjimuC0N_OnfaHTQ&s",
                        "https://static.jobscan.co/blog/uploads/How-To-Write-A-LinkedIn-Summary.png",
                        "https://media.istockphoto.com/id/1317804578/photo/one-businesswoman-headshot-smiling-at-the-camera.jpg?s=612x612&w=0&k=20&c=EqR2Lffp4tkIYzpqYh8aYIPRr-gmZliRHRxcQC5yylY=",
                      ],
                    ),

                    /// Created By Text
                    Text.rich(
                      TextSpan(
                        text: "Created by ",
                        children: [
                          TextSpan(
                            text: "Ali Akbar",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF676767),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.subTitleColor1,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

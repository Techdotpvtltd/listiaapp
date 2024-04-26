// Project: 	   listi_shop
// File:    	   item_list
// Path:    	   lib/screens/main/components/item_list.dart
// Author:       Ali Akbar
// Date:        04-04-24 13:42:42 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/main/components/profiles_widget.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/date_extension.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../blocs/item/item_bloc.dart';
import '../../../blocs/item/item_state.dart';
import '../../../models/list_model.dart';
import '../../../repos/item_repo.dart';

class ItemList extends StatefulWidget {
  const ItemList({
    super.key,
    required this.onItemTap,
    required this.lists,
  });
  final Function(int) onItemTap;
  final List<ListModel> lists;
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late final List<ListModel> items = widget.lists;

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
      itemCount: items.length,
      itemBuilder: (context, index) {
        final ListModel list = items[index];

        return CustomInkWell(
          onTap: () => widget.onItemTap(index),
          child: BlocSelector<ItemBloc, ItemState, List<int>>(
            selector: (state) {
              return [
                ItemRepo().getNumberOfItemsBy(listId: list.id),
                ItemRepo().getNumberOfCompletedItemsBy(listId: list.id)
              ];
            },
            builder: (context, value) {
              final int numberOfItems = value.first;
              final int numberOfCompletedItems = value.last;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                                  dataSource: [
                                    {
                                      "x": 0,
                                      "value": (numberOfCompletedItems /
                                              numberOfItems) *
                                          100
                                    }
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
                                  list.title,
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
                                  "$numberOfCompletedItems / $numberOfItems",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF238A34),
                                  ),
                                ),

                                /// Date Label
                                Text(
                                  list.createdAt.dateToString("dd MMMM yyyy"),
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
                          ProfilesWidget(
                            height: 44,
                            avatarts: list.sharedUsers,
                          ),

                          /// Created By Text
                          Text.rich(
                            TextSpan(
                              text: "Created by ",
                              children: [
                                TextSpan(
                                  text: list.createdBy == "admin"
                                      ? "Listia"
                                      : "You",
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
          ),
        );
      },
    );
  }
}

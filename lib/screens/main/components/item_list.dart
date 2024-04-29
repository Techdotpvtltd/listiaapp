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
import '../../../blocs/list/list_bloc.dart';
import '../../../blocs/list/list_event.dart';
import '../../../blocs/list/list_state.dart';
import '../../../models/list_model.dart';
import '../../../repos/item_repo.dart';
import '../../components/custom_button.dart';

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

class ItemList extends StatefulWidget {
  const ItemList({
    super.key,
    required this.onItemTap,
    required this.lists,
    required this.adminLists,
  });
  final Function(int, bool isAdminList) onItemTap;
  final List<ListModel> lists;
  final List<ListModel> adminLists;
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late final List<ListModel> items = widget.lists;
  late final List<ListModel> adminLists = widget.adminLists;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 30, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// user created lists
          for (int index = 0; index < items.length; index++)
            Builder(
              builder: (context) {
                final ListModel list = items[index];
                return _ItemWidget(
                  list,
                  () {
                    widget.onItemTap(index, false);
                  },
                );
              },
            ),

          /// Admin created lists
          if (adminLists.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH30,
                Text(
                  "For You",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                gapH20,
                for (int index = 0; index < adminLists.length; index++)
                  Builder(
                    builder: (context) {
                      final ListModel list = adminLists[index];
                      return _ItemWidget(
                        list,
                        () {
                          widget.onItemTap(index, true);
                        },
                      );
                    },
                  ),
              ],
            )
        ],
      ),
    );
  }
}

class _ItemWidget extends StatefulWidget {
  const _ItemWidget(this.list, this.onItemTapped);
  final ListModel list;
  final VoidCallback onItemTapped;

  @override
  State<_ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<_ItemWidget> {
  bool isAddingPressed = false;
  String? movingListId;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: widget.onItemTapped,
      child: BlocSelector<ItemBloc, ItemState, List<int>>(
        selector: (state) {
          return [
            ItemRepo().getNumberOfItemsBy(listId: widget.list.id),
            ItemRepo().getNumberOfCompletedItemsBy(listId: widget.list.id)
          ];
        },
        builder: (context, value) {
          final int numberOfItems = value.first;
          final int numberOfCompletedItems = value.last;

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
                              dataSource: [
                                {
                                  "x": 0,
                                  "value":
                                      (numberOfCompletedItems / numberOfItems) *
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
                              widget.list.title,
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
                              widget.list.createdAt
                                  .dateToString("dd MMMM yyyy"),
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
                  child: widget.list.createdBy == "admin"
                      ? BlocListener<ListBloc, ListState>(
                          listener: (context, state) {
                            if (state is ListStateMoveFailure ||
                                state is ListStateMoved ||
                                state is ListStateMoving) {
                              if (state is ListStateMoving) {
                                setState(() {
                                  movingListId = state.listId;
                                });
                              }
                              setState(() {
                                isAddingPressed = state.isLoading;
                              });
                            }
                          },
                          child: CustomButton(
                            isLoading: movingListId == widget.list.id &&
                                isAddingPressed,
                            width: 100,
                            height: 40,
                            title: "Add",
                            onPressed: () {
                              context
                                  .read<ListBloc>()
                                  .add(ListEventMove(listId: widget.list.id));
                            },
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// Profile Widget
                            ProfilesWidget(
                              height: 44,
                              avatarts: widget.list.sharedUsers,
                            ),

                            /// Created By Text
                            Text.rich(
                              TextSpan(
                                text: "Created by ",
                                children: [
                                  TextSpan(
                                    text: widget.list.referBy == "admin"
                                        ? "ListiShop"
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
  }
}

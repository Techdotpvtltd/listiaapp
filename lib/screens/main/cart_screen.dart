// Project: 	   listi_shop
// File:    	   cart_screen
// Path:    	   lib/screens/main/cart_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 21:45:42 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/paddings.dart';

import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_event.dart';
import '../../blocs/item/item_state.dart';
import '../../models/item_model.dart';
import '../../repos/item_repo.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
import 'components/custom_checkbox.dart';

class CartScreen extends StatefulWidget {
  const CartScreen(
      {super.key, required this.scaffoldKey, required this.listId});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String listId;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<ItemModel> items =
      ItemRepo().getCompletedItemsBy(listId: widget.listId);
  List<String> itemsToBeBought = [];
  bool isLoading = false;

  void triggerRemoveItemEvent(ItemBloc bloc, {required String itemId}) {
    bloc.add(ItemEventRemoveItemComplete(itemId: itemId));
    bloc.add(ItemEventUpdateIsReadyToBuy(itemId: itemId, isReadyToBuy: false));
  }

  void addItemsToBoughtList() {
    itemsToBeBought = items
        .where((element) => element.isReadyToBuy)
        .map((e) => e.id)
        .toList();
  }

  void triggerMarkItemsBought(ItemBloc bloc) {
    bloc.add(
      ItemEventMarkItemsBought(
        items: itemsToBeBought,
        listId: widget.listId,
      ),
    );
  }

  void checkCartListCompleted() {
    if (itemsToBeBought.length >= items.length) {
      CustomDialogs().alertBox(
        title: "Shopping Completed",
        message: "Did you finish your shopping?",
        positiveTitle: "Yes",
        negativeTitle: "No",
        onPositivePressed: () {
          triggerMarkItemsBought(context.read<ItemBloc>());
        },
      );
    }
  }

  void triggerMarkIsReadyToBuyStatus(
      ItemBloc bloc, String itemId, bool isReadyToBuy) {
    bloc.add(
      ItemEventUpdateIsReadyToBuy(
        itemId: itemId,
        isReadyToBuy: isReadyToBuy,
      ),
    );
  }

  @override
  void initState() {
    addItemsToBoughtList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemStateMarkItemBoughtFailure ||
            state is ItemStateMarkedItemBought ||
            state is ItemStateMarkingItemBought) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ItemStateMarkedItemBought) {
            setState(() {
              items = ItemRepo().getCompletedItemsBy(listId: widget.listId);
              addItemsToBoughtList();
            });
          }
        }

        if (state is ItemStateUpdated) {
          setState(() {
            items = ItemRepo().getCompletedItemsBy(listId: widget.listId);
            addItemsToBoughtList();
          });
        }

        if (state is ItemStateItemRemoveFromCompleted) {
          setState(() {
            items.removeWhere((element) => element.id == state.itemId);
            addItemsToBoughtList();
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: HVPadding(
          horizontal: 12,
          verticle: 0,
          child: CustomButton(
            isEnabled: itemsToBeBought.isNotEmpty,
            isLoading: isLoading,
            title: "Mark as Bought",
            onPressed: () {
              CustomDialogs().alertBox(
                title: "Buy Confirmation",
                message:
                    "Are you sure to mark ${itemsToBeBought.length} items as bought? You'll not able to remove them from cart list.",
                onPositivePressed: () {
                  triggerMarkItemsBought(context.read<ItemBloc>());
                },
                positiveTitle: "Yes, I'm sure",
                negativeTitle: "No",
              );
            },
          ),
        ),
        body: SafeArea(
          child: HVPadding(
            verticle: 27,
            horizontal: 13,
            child: Column(
              children: [
                /// Title Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cart",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.titleColor1,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomInkWell(
                      onTap: () {
                        widget.scaffoldKey.currentState!.closeEndDrawer();
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppTheme.titleColor1,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 40, bottom: 100),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final ItemModel item = items[index];
                      final bool isChecked = itemsToBeBought.contains(item.id);

                      return CustomInkWell(
                        onTap: () {
                          setState(() {
                            if (isChecked) {
                              itemsToBeBought.remove(item.id);
                              triggerMarkIsReadyToBuyStatus(
                                  context.read<ItemBloc>(), item.id, false);
                            } else {
                              itemsToBeBought.add(item.id);
                              triggerMarkIsReadyToBuyStatus(
                                  context.read<ItemBloc>(), item.id, true);
                              checkCartListCompleted();
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 9),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF0474ED).withOpacity(0.19),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomCheckBox(
                                    isChecked: isChecked,
                                  ),
                                  gapW10,
                                  Text(
                                    item.itemName,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.titleColor1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      decoration: isChecked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  gapW6,
                                  Text(
                                    "x${item.quantity.toString()}",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.subTitleColor2,
                                      fontSize: 12,
                                      decoration: isChecked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                              /// Delete Button
                              // if (item.boughtBy == null)
                              //   CustomInkWell(
                              //     onTap: () {
                              //       CustomDialogs().deleteBox(
                              //         title: "Remove Item",
                              //         message:
                              //             "Are you sure to remove ${item.itemName} item from the cart?",
                              //         onPositivePressed: () {
                              //           triggerRemoveItemEvent(
                              //               context.read<ItemBloc>(),
                              //               itemId: item.id);
                              //         },
                              //       );
                              //     },
                              //     child: Container(
                              //       width: 22,
                              //       height: 22,
                              //       decoration: BoxDecoration(
                              //         color: const Color(0xFFB82D2D)
                              //             .withOpacity(0.14),
                              //         shape: BoxShape.circle,
                              //       ),
                              //       child: const Center(
                              //         child: Icon(
                              //           Icons.delete,
                              //           color: Color(0xFFB82D2D),
                              //           size: 14,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Project: 	   listi_shop
// File:    	   cart_screen
// Path:    	   lib/screens/main/cart_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 21:45:42 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/paddings.dart';

import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_event.dart';
import '../../blocs/item/item_state.dart';
import '../../models/item_model.dart';
import '../../repos/item_repo.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';

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

  void addItemsToBoughtList() {
    itemsToBeBought.clear();
    itemsToBeBought = items
        .where((element) => element.boughtBy == null)
        .map((e) => e.id)
        .toList();
  }

  void triggerRemoveItemEvent(ItemBloc bloc, {required String itemId}) {
    bloc.add(ItemEventRemoveItemComplete(itemId: itemId));
  }

  void triggerMarkItemsBought(ItemBloc bloc) {
    bloc.add(ItemEventMarkItemsBought(
        items: itemsToBeBought, listId: widget.listId));
  }

  @override
  void initState() {
    super.initState();
    addItemsToBoughtList();
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
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF0474ED).withOpacity(0.19)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppTheme.titleColor1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (item.celeries != null)
                                      SvgPicture.asset(AppAssets.fireIcon),
                                    if (item.celeries != null) gapW4,
                                    if (item.celeries != null)
                                      Text(
                                        "${item.celeries} ${(item.celeries ?? 0) > 1 ? "celeries" : "celery"}",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF676767),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    if (item.macros != null) gapW10,
                                    if (item.macros != null)
                                      SvgPicture.asset(AppAssets.electricIcon),
                                    if (item.macros != null) gapW4,
                                    if (item.macros != null)
                                      Text(
                                        "${item.macros} ${(item.macros ?? 0) > 1 ? "macros" : "macro"}",
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF676767),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),

                            /// Delete Button
                            if (item.boughtBy == null)
                              CustomInkWell(
                                onTap: () {
                                  CustomDialogs().deleteBox(
                                    title: "Remove Item",
                                    message:
                                        "Are you sure to remove ${item.itemName} item from the cart?",
                                    onPositivePressed: () {
                                      triggerRemoveItemEvent(
                                          context.read<ItemBloc>(),
                                          itemId: item.id);
                                    },
                                  );
                                },
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB82D2D)
                                        .withOpacity(0.14),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.delete,
                                      color: Color(0xFFB82D2D),
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
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

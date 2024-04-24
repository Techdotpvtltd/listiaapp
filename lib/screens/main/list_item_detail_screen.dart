// Project: 	   listi_shop
// File:    	   list_item_detail_screen
// Path:    	   lib/screens/main/list_item_detail_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 20:07:06 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:listi_shop/utils/extensions/string_extension.dart';

import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_event.dart';
import '../../blocs/item/item_state.dart';
import '../../models/item_model.dart';
import '../../models/list_model.dart';
import '../../repos/item_repo.dart';

class ListItemDetailScreen extends StatefulWidget {
  const ListItemDetailScreen({super.key, required this.list});
  final ListModel list;
  @override
  State<ListItemDetailScreen> createState() => _ListItemDetailScreenState();
}

class _ListItemDetailScreenState extends State<ListItemDetailScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late ListModel list = widget.list;
  late List<CategorizeItemsModel> categoryItems = [];
  String selectedCategory = "All";

  void filteredItems({String? searchText}) {
    categoryItems = ItemRepo().filteredItems(
        searchText: searchText,
        categories: selectedCategory.toLowerCase() == "all"
            ? widget.list.categories
            : [selectedCategory],
        listId: widget.list.id);
  }

  void triggerMarkCompleteItemEvent(ItemBloc bloc,
      {required String selectedItemId}) {
    bloc.add(ItemEventMarkComplete(itemId: selectedItemId));
  }

  @override
  void initState() {
    super.initState();
    filteredItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        if (state is ItemStateAdded || state is ItemStateFetchedAll) {
          setState(() {
            filteredItems();
          });
        }
      },
      child: CustomScaffold(
        title: list.title,
        scaffoldkey: scaffoldKey,
        floatingActionButton: HorizontalPadding(
          child: CustomButton(
            title: "Add new item",
            onPressed: () {
              NavigationService.go(
                AddItemScreen(
                  listId: widget.list.id,
                  categories: List.from(widget.list.categories),
                ),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        endDrawer: Container(
          width: SCREEN_WIDTH * 0.7,
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE).withOpacity(0.87),
          ),
          child: CartScreen(
            scaffoldKey: scaffoldKey,
            listId: widget.list.id,
          ),
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
                        list.title,
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
                          BlocSelector<ItemBloc, ItemState, bool?>(
                              selector: (state) {
                            return state is ItemStateFetched ||
                                state is ItemStateFetchedAll;
                          }, builder: (context, _) {
                            return Text(
                              "List ${ItemRepo().getNumberOfCompletedItemsBy(listId: list.id)}/${ItemRepo().getNumberOfItemsBy(listId: list.id)} Completed",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF6C6C6C),
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }),
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
              CustomTextFiled(
                hintText: "Search",
                onChange: (value) {
                  setState(() {
                    filteredItems(searchText: value);
                  });
                },
                prefixWidget: const Icon(
                  Icons.search,
                  color: AppTheme.primaryColor2,
                ),
              ),
              gapH20,

              /// Item Type List
              SizedBox(
                height: 30,
                child: CategoryListView(
                  categories: List.from(list.categories),
                  onSelectedCategory: (category) {
                    setState(() {
                      selectedCategory = category;
                      filteredItems();
                    });
                  },
                ),
              ),
              gapH20,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      for (final CategorizeItemsModel categoryItem
                          in categoryItems)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryItem.category.capitalizeFirstCharacter(),
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.titleColor1,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            gapH10,
                            _ItemList(
                              categoryItem.items,
                              (selectedItem) {
                                triggerMarkCompleteItemEvent(
                                    context.read<ItemBloc>(),
                                    selectedItemId: selectedItem.id);
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemList extends StatefulWidget {
  const _ItemList(this.items, this.onItemSelected);
  final List<ItemModel> items;
  final Function(ItemModel) onItemSelected;

  @override
  State<_ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<_ItemList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < widget.items.length; index++)
          Builder(builder: (context) {
            final ItemModel item = widget.items[index];
            bool isSelected = item.completedBy != null;
            bool isBought = item.boughtBy != null;

            return CustomInkWell(
              onTap: () {
                setState(() {
                  if (!isSelected) {
                    widget.onItemSelected(item);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          begin: const Alignment(0.99, -0.10),
                          end: const Alignment(-0.99, 0.1),
                          colors: [
                            const Color(0xFF30A94A).withOpacity(0.02),
                            const Color(0x002EA346)
                                .withOpacity(isBought ? 0.3 : 0.09),
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
                          item.itemName,
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
                              decoration: isSelected
                                  ? TextDecoration.lineThrough
                                  : null,
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
                              decoration: isSelected
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          })
      ],
    );
  }
}

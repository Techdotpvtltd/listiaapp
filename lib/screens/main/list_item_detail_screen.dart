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
import 'package:listi_shop/screens/main/components/item_type_list.dart';
import 'package:listi_shop/screens/main/components/profiles_widget.dart';
import 'package:listi_shop/screens/main/share_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/item/item_bloc.dart';
import '../../blocs/item/item_event.dart';
import '../../blocs/item/item_state.dart';
import '../../blocs/list/list_bloc.dart';
import '../../blocs/list/list_state.dart';
import '../../models/item_model.dart';
import '../../models/list_model.dart';
import '../../repos/category_repo.dart';
import '../../repos/item_repo.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import '../components/custom_dropdown.dart';
import 'create_list_screen.dart';

class ListItemDetailScreen extends StatefulWidget {
  const ListItemDetailScreen(
      {super.key,
      required this.list,
      this.isBoughtScreen = false,
      this.onAddListPressed,
      this.onDeleteListPressed});
  final ListModel list;
  final bool isBoughtScreen;
  final Function(ListModel)? onAddListPressed;
  final Function(ListModel)? onDeleteListPressed;
  @override
  State<ListItemDetailScreen> createState() => _ListItemDetailScreenState();
}

class _ListItemDetailScreenState extends State<ListItemDetailScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late ListModel list = widget.list;
  late List<CategorizeItemsModel> categoryItems = [];
  String selectedCategory = "All";
  late final bool isAdminList = list.createdBy == "admin";
  late final bool isListCreater =
      UserRepo().currentUser.uid == widget.list.createdBy;
  bool isAddListLoading = false;
  late List<String> categories = ItemRepo().getCategories(listId: list.id);

  List<DropdownMenuModel> getMenuItems() {
    final items = [
      DropdownMenuModel(title: 'Add Person', icon: Icons.add),
    ];

    if (isListCreater) {
      items.add(DropdownMenuModel(title: "Edit", icon: Icons.edit));
      items.add(DropdownMenuModel(title: "Delete", icon: Icons.delete));
    }
    return items;
  }

  void triggerDeleteListEvent() {
    CustomDialogs().deleteBox(
        title: "Delete List",
        message:
            "Are you sure to delete this list? This will delete all the items and shared user data. This process will not be undo.",
        onPositivePressed: () {
          if (widget.onDeleteListPressed != null) {
            widget.onDeleteListPressed!(list);
          }
        });
  }

  void navigateToShareScreen() {
    NavigationService.go(ShareScreen(list: list));
  }

  void navigateToUpdateList() {
    NavigationService.go(CreateListScreen(updatedList: list));
  }

  void onMenuPressed({required String selectedMenu}) {
    switch (selectedMenu.toLowerCase()) {
      case 'add person':
        navigateToShareScreen();
        break;
      case 'edit':
        navigateToUpdateList();
        break;
      case 'delete':
        triggerDeleteListEvent();
        break;
    }
  }

  void filteredItems({String? searchText}) {
    setState(() {
      categories = ItemRepo().getCategories(listId: list.id);
    });
    categoryItems = ItemRepo().filteredItems(
      searchText: searchText,
      categories: selectedCategory.toLowerCase() == "all"
          ? categories
          : [selectedCategory],
      listId: widget.list.id,
      isShowBoughtItemsOnly: widget.isBoughtScreen,
    );
  }

  void triggerMarkCompleteItemEvent(ItemBloc bloc,
      {required String selectedItemId}) {
    bloc.add(ItemEventMarkComplete(itemId: selectedItemId));
  }

  void triggerMarkUnCompleteItemEvent(ItemBloc bloc, {required String itemId}) {
    bloc.add(ItemEventRemoveItemComplete(itemId: itemId));
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
        if (state is ItemStateAdded ||
            state is ItemStateFetchedAll ||
            state is ItemStateDeleted) {
          setState(() {
            filteredItems();
          });
        }
      },
      child: CustomScaffold(
        title: list.title,
        scaffoldkey: scaffoldKey,
        floatingActionButton: Visibility(
          visible: !widget.isBoughtScreen,
          child: HorizontalPadding(
            child: BlocListener<ListBloc, ListState>(
              listener: (context, state) {
                if (state is ListStateMoveFailure ||
                    state is ListStateMoved ||
                    state is ListStateMoving) {
                  setState(() {
                    isAddListLoading = state.isLoading;
                  });
                }
              },
              child: CustomButton(
                isLoading: isAddListLoading,
                title: isAdminList ? "Add List" : "Add new item",
                onPressed: () {
                  if (isAdminList) {
                    if (widget.onAddListPressed != null) {
                      widget.onAddListPressed!(widget.list);
                    }
                    return;
                  }

                  NavigationService.go(
                    AddItemScreen(
                      listId: widget.list.id,
                    ),
                  );
                },
              ),
            ),
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
          if (!isAdminList)
            ProfilesWidget(
              invitedUsers: widget.list.sharedUsers,
              height: 50,
            ),
          gapW10,

          /// Menu Button
          if (!widget.isBoughtScreen && !isAdminList)
            CustomMenuDropdown(
              items: getMenuItems(),
              onSelectedItem: (selectedMenu, index) {
                onMenuPressed(selectedMenu: selectedMenu);
              },
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
                      if (!widget.isBoughtScreen)
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.menuIcon),
                            gapW4,
                            BlocSelector<ItemBloc, ItemState, bool?>(
                              selector: (state) {
                                return state is ItemStateFetched ||
                                    state is ItemStateFetchedAll;
                              },
                              builder: (context, _) {
                                return Text(
                                  "List ${ItemRepo().getNumberOfCompletedItemsBy(listId: list.id)}/${ItemRepo().getNumberOfItemsBy(listId: list.id)} Completed",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF6C6C6C),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),

                  /// Bucket Button
                  if (!widget.isBoughtScreen && !isAdminList)
                    Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: () {
                            scaffoldKey.currentState!.openEndDrawer();
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFFF8F8F8)),
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(14)),
                          ),
                          icon: SvgPicture.asset(
                            AppAssets.bucketIcon,
                            width: 25,
                            colorFilter: const ColorFilter.mode(
                              AppTheme.primaryColor2,
                              BlendMode.srcIn,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              gapH12,

              /// Search Text Field,
              CustomTextFiled(
                hintText: "Search",
                isFirstCapitalizeLetter: true,
                onChange: (value) {
                  setState(
                    () {
                      filteredItems(searchText: value);
                    },
                  );
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
                  categories: categories,
                  onSelectedCategory: (category) {
                    setState(
                      () {
                        selectedCategory = category.id;
                        filteredItems();
                      },
                    );
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
                              CategoryRepo()
                                      .getCategoryFrom(
                                          categoryId: categoryItem.category)
                                      ?.item ??
                                  "Deleted",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.titleColor1,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            gapH10,
                            _ItemList(
                              items: categoryItem.items,
                              categories: categories,
                              onItemSelected: (selectedItem) {
                                if (!isAdminList && !widget.isBoughtScreen) {
                                  triggerMarkCompleteItemEvent(
                                      context.read<ItemBloc>(),
                                      selectedItemId: selectedItem.id);
                                }
                              },
                              onItemDeselected: (selectedItem) {
                                if (!isAdminList && !widget.isBoughtScreen) {
                                  triggerMarkUnCompleteItemEvent(
                                      context.read<ItemBloc>(),
                                      itemId: selectedItem.id);
                                }
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
  const _ItemList(
      {required this.items,
      required this.onItemSelected,
      required this.onItemDeselected,
      required this.categories});
  final List<ItemModel> items;
  final Function(ItemModel) onItemSelected;
  final Function(ItemModel) onItemDeselected;
  final List<String> categories;
  @override
  State<_ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<_ItemList> {
  void onEditMenuPressed(ItemModel model) {
    NavigationService.go(
      AddItemScreen(
        listId: model.listId,
        item: model,
      ),
    );
  }

  void onDeleteMenuPressed(ItemModel model) {
    CustomDialogs().deleteBox(
        title: "Item Deletion",
        message: "Are you sure to delete this ${model.itemName} item?.",
        onPositivePressed: () {
          context.read<ItemBloc>().add(ItemEventDeleted(itemId: model.id));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int index = 0; index < widget.items.length; index++)
          Builder(
            builder: (context) {
              final ItemModel item = widget.items[index];
              bool isSelected = item.completedBy != null;
              bool isBought = item.boughtBy != null;

              return Row(
                children: [
                  Expanded(
                    child: CustomInkWell(
                      onTap: () {
                        setState(() {
                          if (!isSelected) {
                            widget.onItemSelected(item);
                          } else {
                            widget.onItemDeselected(item);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.itemName,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.titleColor1,
                                fontSize: 14,
                                decoration: isSelected
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "x${item.quantity.toString()}",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.subTitleColor2,
                                fontSize: 12,
                                decoration: isSelected
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            ///
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: item.createdBy == UserRepo().currentUser.uid &&
                        !isBought,
                    child: CustomMenuDropdown(
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        color: Colors.black,
                      ),
                      items: [
                        DropdownMenuModel(icon: Icons.edit, title: "Edit"),
                        DropdownMenuModel(icon: Icons.delete, title: "Delete"),
                      ],
                      onSelectedItem: (value, index) {
                        if (value.toLowerCase() == "edit") {
                          onEditMenuPressed(item);
                        }

                        if (value.toLowerCase() == "delete") {
                          onDeleteMenuPressed(item);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          )
      ],
    );
  }
}

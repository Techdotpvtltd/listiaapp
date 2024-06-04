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

import '../../../blocs/item/item_bloc.dart';
import '../../../blocs/item/item_state.dart';
import '../../../blocs/list/list_bloc.dart';
import '../../../blocs/list/list_event.dart';
import '../../../blocs/list/list_state.dart';
import '../../../models/list_model.dart';
import '../../../models/user_model.dart';
import '../../../repos/item_repo.dart';
import '../../../repos/user_repo.dart';
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
    this.isBoughtScreen = false,
  });
  final Function(int, bool isAdminList) onItemTap;
  final List<ListModel> lists;
  final List<ListModel> adminLists;
  final bool isBoughtScreen;
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late final List<ListModel> items = widget.lists;
  late final List<ListModel> adminLists = widget.adminLists;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          top: widget.lists.isNotEmpty ? 30 : 0,
          bottom: 100,
          left: 30,
          right: 30),
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
                  (list) {
                    items.removeWhere((element) => element.id == list.id);
                  },
                  widget.isBoughtScreen,
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
                        (list) {
                          items.removeWhere((element) => element.id == list.id);
                        },
                        widget.isBoughtScreen,
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
  const _ItemWidget(
      this.list, this.onItemTapped, this.onListDeleted, this.isBoughtScreen);
  final ListModel list;
  final VoidCallback onItemTapped;
  final Function(ListModel) onListDeleted;
  final bool isBoughtScreen;

  @override
  State<_ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<_ItemWidget> {
  bool isAddingPressed = false;
  String? movingListId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.list.id),
      direction: widget.isBoughtScreen
          ? DismissDirection.none
          : (widget.list.createdBy == "admin" &&
                  widget.list.createdBy != UserRepo().currentUser.uid)
              ? DismissDirection.none
              : DismissDirection.endToStart,
      secondaryBackground: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      background: Container(
        color: Colors.green,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.edit, color: Colors.white),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
                TextButton(
                    onPressed: () {
                      widget.onListDeleted(widget.list);
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("DELETE")),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Implement delete functionality here
        // Call the method to delete the item

        context
            .read<ListBloc>()
            .add(ListEventDelete(listId: widget.list.id, itemsIds: []));
      },
      child: CustomInkWell(
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
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Text(
                                "$numberOfCompletedItems / $numberOfItems",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF238A34),
                                ),
                              ),
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
                              ProfilesWidget(
                                height: 44,
                                invitedUsers: widget.list.sharedUsers,
                              ),
                              FutureBuilder<UserModel?>(
                                future: UserRepo().fetchUser(
                                    profileId: widget.list.createdBy),
                                builder: (context, snapshot) {
                                  return Text.rich(
                                    TextSpan(
                                      text: "Created by ",
                                      children: [
                                        TextSpan(
                                          text: widget.list.referBy == "admin"
                                              ? "ListiShop"
                                              : snapshot.data?.uid ==
                                                      UserRepo().currentUser.uid
                                                  ? "You"
                                                  : snapshot.data?.name,
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
                                  );
                                },
                              )
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

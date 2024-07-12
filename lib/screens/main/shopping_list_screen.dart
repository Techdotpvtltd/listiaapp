// Project: 	   listi_shop
// File:    	   complete_list_screen
// Path:    	   lib/screens/main/complete_list_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 16:36:54 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/components/item_list.dart';

import '../../blocs/list/list_bloc.dart';
import '../../blocs/list/list_state.dart';
import '../../models/list_model.dart';
import '../../repos/list_repo.dart';
import '../../utils/extensions/navigation_service.dart';
import 'list_item_detail_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<ListModel> lists = ListRepo().completedLists();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {},
      child: CustomScaffold(
        title: "Shopping Lists",
        backButtonIcon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        backButtonPressed: () {
          context.read<DrawerCubit>().openDrawer();
        },
        body: HorizontalPadding(
          child: ItemList(
            key: GlobalKey(),
            onItemTap: (index, _) {
              NavigationService.go(
                ListItemDetailScreen(
                  list: lists[index],
                  isBoughtScreen: true,
                ),
              );
            },
            isBoughtScreen: true,
            adminLists: const [],
            lists: lists,
          ),
        ),
      ),
    );
  }
}

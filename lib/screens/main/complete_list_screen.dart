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

class CompleteListScreen extends StatelessWidget {
  const CompleteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Complete List",
      backButtonIcon: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      backButtonPressed: () {
        context.read<DrawerCubit>().openDrawer();
      },
      body: HorizontalPadding(
        child: ItemList(
          onItemTap: (index) {},
        ),
      ),
    );
  }
}

// Project: 	   listi_shop
// File:    	   home_screen
// Path:    	   lib/screens/main/home_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 19:11:54 -- Wednesday
// Description:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              context.read<DrawerCubit>().openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

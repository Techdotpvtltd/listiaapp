// Project: 	   listi_shop
// File:    	   drawer_cubit
// Path:    	   lib/blocs/drawer_cubit/drawer_cubit.dart
// Author:       Ali Akbar
// Date:        03-04-24 19:24:12 -- Wednesday
// Description:

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_state.dart';

class DrawerCubit extends Cubit<HomeDrawerState> {
  DrawerCubit() : super(DrawerStateInitial());

  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  bool isOpen = false;

  void openDrawer() {
    Timer(const Duration(milliseconds: 40), () {
      isOpen = true;
      emit(DrawerStateOpen());
    });
    zoomDrawerController.toggle?.call();
    emit(DrawerStateOpen());
  }

  void closeDrawer() {
    Timer(const Duration(milliseconds: 40), () {
      isOpen = false;
      emit(DrawerStateClose());
    });
    zoomDrawerController.close?.call();
    emit(DrawerStateClose());
  }
}

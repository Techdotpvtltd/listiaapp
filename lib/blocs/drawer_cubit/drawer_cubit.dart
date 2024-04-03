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
  Timer? timer;

  void openDrawer() {
    timer ??= Timer(const Duration(milliseconds: 40), () {
      isOpen = true;
    });
    zoomDrawerController.toggle?.call();
    emit(DrawerStateOpen());
  }

  void closeDrawer() {
    timer ??= Timer(const Duration(milliseconds: 40), () {
      isOpen = false;
    });
    zoomDrawerController.close?.call();
    emit(DrawerStateClose());
  }

  @override
  Future<void> close() {
    timer = null;
    return super.close();
  }
}

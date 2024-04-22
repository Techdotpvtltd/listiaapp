// Project: 	   listi_shop
// File:    	   home_screen
// Path:    	   lib/screens/main/home_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 19:11:54 -- Wednesday
// Description:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/components/round_button.dart';
import 'package:listi_shop/screens/main/components/item_list.dart';
import 'package:listi_shop/screens/main/list_item_detail_screen.dart';
import 'package:listi_shop/screens/main/notification_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';
import 'package:skeletons/skeletons.dart';

import '../../blocs/list/list_bloc.dart';
import '../../blocs/list/list_event.dart';
import '../../blocs/list/list_state.dart';
import '../../models/list_model.dart';
import '../../repos/list_repo.dart';
import '../../repos/user_repo.dart';
import '../../utils/dialogs/dialogs.dart';
import 'create_list_screen.dart';
import 'skeletons/list_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<ListModel> lists = ListRepo().lists;

  @override
  void initState() {
    super.initState();
    context
        .read<ListBloc>()
        .add(ListEventFetch(forUser: UserRepo().currentUser.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        if (state is ListStateFetchFailure ||
            state is ListStateFetched ||
            state is ListStateFetching ||
            state is ListStateNewAdded) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ListStateNewAdded) {
            setState(() {
              lists = ListRepo().lists;
            });
          }

          if (state is ListStateFetched) {
            setState(() {});
          }

          if (state is ListStateFetchFailure) {
            CustomDilaogs().errorBox(message: state.exception.message);
          }
        }
      },
      child: Scaffold(
        floatingActionButton: Container(
          width: SCREEN_WIDTH * 0.16,
          height: SCREEN_WIDTH * 0.16,
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryLinearGradient,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              NavigationService.go(const CreateListScreen());
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              visualDensity: VisualDensity.compact,
              backgroundColor: MaterialStatePropertyAll(Colors.transparent),
            ),
          ),
        ),

        /// Custom App Bar
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: LayoutBuilder(
            builder: (context, constrains) {
              return Container(
                padding: EdgeInsets.only(
                    left: 34, right: 34, top: constrains.maxHeight * 0.2),
                width: SCREEN_WIDTH,
                height: constrains.maxHeight,
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryLinearGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Profile Button
                    Row(
                      children: [
                        RoundButton(
                          onTap: () {
                            context.read<DrawerCubit>().openDrawer();
                          },
                          icon: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        gapW12,

                        /// Text Widgets
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "1 of 5",
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Product in 9 lists",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFD3D3D3),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// Notification Button
                    RoundButton(
                      onTap: () {
                        NavigationService.go(const NotificationScreen());
                      },
                      icon: SvgPicture.asset(AppAssets.notificationDotIcon),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: HorizontalPadding(
            child: Skeleton(
              isLoading: isLoading,
              skeleton: const ListSkeleton(),
              child: lists.isEmpty
                  ? const Center(
                      child: Text("No Lists."),
                    )
                  : ItemList(
                      onItemTap: (index) {
                        NavigationService.go(const ListItemDetailScreen());
                      },
                      lists: lists,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

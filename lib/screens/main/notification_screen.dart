// Project: 	   listi_shop
// File:    	   notification_screen
// Path:    	   lib/screens/main/notification_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 18:15:28 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/blocs/notification/notification_bloc.dart';
import 'package:listi_shop/blocs/notification/notification_states.dart';
import 'package:listi_shop/blocs/share_user/share_user_bloc.dart';
import 'package:listi_shop/blocs/share_user/share_user_event.dart';
import 'package:listi_shop/blocs/share_user/share_user_state.dart';
import 'package:listi_shop/models/request.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/dialogs/dialogs.dart';
import 'package:listi_shop/utils/extensions/date_extension.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc()..fetch(),
      child: BlocBuilder<NotificationBloc, NotificationStates>(
          builder: (context, states) {
        return CustomScaffold(
          title: "Notifications",
          body: HorizontalPadding(
            child: states.isLoading
                ? const Center(child: CircularProgressIndicator())
                : states.notifications.isEmpty || states.error != null
                    ? const Center(child: Text("No notifications to read."))
                    : ListView.builder(
                        itemCount: states.notifications.length,
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        itemBuilder: (context, index) {
                          return states.notifications[index] is RequestModel
                              ? _RequestNotification(
                                  states.notifications[index])
                              : const _UserNotification();
                        },
                      ),
          ),
        );
      }),
    );
  }
}

class _RequestNotification extends StatefulWidget {
  const _RequestNotification(this.request);
  final RequestModel request;

  @override
  State<_RequestNotification> createState() => _RequestNotificationState();
}

class _RequestNotificationState extends State<_RequestNotification> {
  String? selectedId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareUserBloc, ShareUserState>(
      listener: (context, state) {
        if (state is ShareUserStateAcceptFailure) {
          CustomDialogs().errorBox(message: state.exception.message);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 94.83,
              color: const Color(0xFF989898).withValues(alpha: 0.15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Join List Request",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.7,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  widget.request.createdAt.formatDateToString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8F8F8F),
                  ),
                ),
              ],
            ),
            Text.rich(
              TextSpan(
                text: widget.request.sharedBy.name,
                children: [
                  TextSpan(
                    text: " has requested to join the list ",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF525252),
                    ),
                  ),
                  TextSpan(text: widget.request.listTitle)
                ],
              ),
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            if (selectedId != widget.request.uid)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: CustomButton(
                      title: "Accept",
                      onPressed: () {
                        setState(() {
                          selectedId = widget.request.uid;
                        });
                        context.read<ShareUserBloc>().add(ShareUserEventAddUser(
                              requestId: widget.request.uid,
                              listId: widget.request.listId,
                            ));
                      },
                      textSize: 12,
                      height: 30,
                      width: 110,
                    ),
                  ),
                  Flexible(
                    child: CustomButton(
                      title: "Reject",
                      onPressed: () {
                        setState(() {
                          selectedId = widget.request.uid;
                        });

                        context.read<ShareUserBloc>().add(
                            ShareUserEventRemoveRequest(
                                requestId: widget.request.uid));
                      },
                      backgroundColor: Colors.redAccent,
                      textSize: 12,
                      height: 30,
                      width: 110,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class _UserNotification extends StatelessWidget {
  const _UserNotification();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 94.83,
            color: const Color(0xFF989898).withValues(alpha: 0.15),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Avatart Profile
          const AvatarWidget(
            width: 45,
            height: 45,
            backgroundColor: AppTheme.primaryColor2,
            avatarUrl: "",
          ),
          gapW16,

          /// Text Widgets
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ali Akbar",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.7,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                gapH10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "Ronaldo Seemd Edit items",
                        maxLines: 2,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF525252),
                        ),
                      ),
                    ),
                    Text(
                      "09:20 AM",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8F8F8F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

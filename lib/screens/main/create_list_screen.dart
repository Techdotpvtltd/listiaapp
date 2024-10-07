// Project: 	   listi_shop
// File:    	   create_list_screen
// Path:    	   lib/screens/main/create_list_screen.dart
// Author:       Ali Akbar
// Date:        22-04-24 12:24:17 -- Monday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/list/list_bloc.dart';
import '../../blocs/list/list_event.dart';
import '../../blocs/list/list_state.dart';
import '../../models/list_model.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';
import '../components/custom_button.dart';
import '../components/custom_scaffold.dart';
import '../components/custom_title_textfiled.dart';
import '../components/paddings.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({super.key, this.updatedList});
  final ListModel? updatedList;
  @override
  State<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;
  TextEditingController nameController = TextEditingController();
  late final ListModel? updatedList = widget.updatedList;

  void triggerCreateListEvent(ListBloc bloc) {
    bloc.add(
      ListEventCreate(title: nameController.text),
    );
  }

  void triggerUpdateEvent(ListBloc bloc) {
    bloc.add(ListEventUpdate(
      listId: widget.updatedList!.id,
      title: nameController.text,
    ));
  }

  @override
  void initState() {
    if (updatedList != null) {
      nameController.text = updatedList?.title ?? "";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        if (state is ListStateCreating ||
            state is ListStateCreated ||
            state is ListStateCreateFailure ||
            state is ListStateUpdateFailure ||
            state is ListStateUpdated ||
            state is ListStateUpdating) {
          setState(() {
            isLoading = state.isLoading;
          });
          if (state is ListStateCreateFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ListStateUpdateFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is ListStateCreated) {
            CustomDialogs().successBox(
              message: "Your list has been successfully created.",
              title: "List Created",
              positiveTitle: "Go back",
              onPositivePressed: () {
                NavigationService.back();
              },
            );
          }

          if (state is ListStateUpdated) {
            CustomDialogs().successBox(
              message: "Your list has been successfully updated.",
              title: "List Updated",
              positiveTitle: "Go to Home",
              onPositivePressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          }
        }
      },
      child: CustomScaffold(
        title: updatedList != null ? "Update List" : "Create New List",
        floatingActionButton: HorizontalPadding(
          child: CustomButton(
            title: updatedList != null ? "Update" : "Create",
            isLoading: isLoading,
            onPressed: () {
              if (updatedList != null) {
                triggerUpdateEvent(context.read<ListBloc>());
                return;
              }
              triggerCreateListEvent(context.read<ListBloc>());
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        body: HVPadding(
          verticle: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Create New List Label
              Text(
                updatedList != null ? "Update List" : "Create New List",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: AppTheme.titleColor1,
                ),
              ),
              gapH2,
              Text(
                "Please fill the information to create the list",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 9,
                  color: AppTheme.subTitleColor2,
                ),
              ),
              gapH32,

              /// Item Name text Filed
              CustomTextFiled(
                controller: nameController,
                fieldId: 1,
                errorText: errorMessage,
                errorCode: errorCode,
                hintText: "Enter Name",
                titleText: "List name",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Project: 	   listi_shop
// File:    	   edit_profile_screen
// Path:    	   lib/screens/main/edit_profile_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 17:49:45 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listi_shop/blocs/user/user_state.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/dialogs/dialogs.dart';
import '../components/avatar_widget.dart';
import '../components/my_image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserModel user = UserRepo().currentUser;
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;
  String? selctedAvatar;

  void selectImage() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            selctedAvatar = data.path;
          });
        }
      },
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void setProfileData() {
    emailController.text = user.email;
    nameController.text = user.name;
    phoneController.text = user.phoneNumber;
    selctedAvatar = user.avatar;
  }

  void triggerUpdateProfileEvent(UserBloc bloc) {
    bloc.add(
      UserEventUpdateProfile(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        avatarUrl: selctedAvatar,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateAvatarUploading ||
            state is UserStateAvatarUploaded ||
            state is UserStateProfileUpdated ||
            state is UserStateProfileUpdating ||
            state is UserStateProfileUpdatingFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is UserStateProfileUpdatingFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }
            CustomDilaogs().errorBox(message: state.exception.message);
          }

          if (state is UserStateProfileUpdated) {
            CustomDilaogs()
                .successBox(message: "Profiled updated.", title: "Congrats");
          }
        }
      },
      child: CustomScaffold(
        title: "Edit Profile",
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 31, right: 31, top: 80, bottom: 30),
                child: Column(
                  children: [
                    /// Profile
                    SizedBox(
                      width: 125,
                      height: 112,
                      child: AvatarWidget(
                        avatarUrl: selctedAvatar ?? "",
                        placeholderChar:
                            user.name.isNotEmpty ? user.name[0] : 'U',
                        width: 112,
                        height: 112,
                        backgroundColor: AppTheme.primaryColor2,
                        onEditPressed: () {
                          selectImage();
                        },
                      ),
                    ),

                    /// Name Text Filed
                    gapH50,
                    CustomTextFiled(
                      controller: nameController,
                      errorCode: errorCode,
                      errorText: errorMessage,
                      fieldId: 3,
                      hintText: "Name",
                      keyboardType: TextInputType.name,
                    ),
                    gapH10,
                    CustomTextFiled(
                      controller: emailController,
                      errorCode: errorCode,
                      errorText: errorMessage,
                      fieldId: 1,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    gapH10,
                    CustomTextFiled(
                      controller: phoneController,
                      errorCode: errorCode,
                      errorText: errorMessage,
                      fieldId: 1012,
                      hintText: "Phone",
                      keyboardType: TextInputType.phone,
                    ),
                    const Spacer(),
                    CustomButton(
                      title: "Save",
                      isLoading: isLoading,
                      onPressed: () {
                        triggerUpdateProfileEvent(context.read<UserBloc>());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

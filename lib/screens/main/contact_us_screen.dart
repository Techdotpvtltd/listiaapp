import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../blocs/drawer_cubit/drawer_cubit.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key, this.isShowMenu = false});
  final bool isShowMenu;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Contact Us',
      resizeToAvoidBottomInset: false,
      backButtonIcon: isShowMenu
          ? const Icon(
              Icons.menu,
              color: Colors.white,
            )
          : null,
      backButtonPressed: isShowMenu
          ? () {
              context.read<DrawerCubit>().openDrawer();
            }
          : null,
      body: Padding(
        padding: const EdgeInsets.only(left: 31, right: 31),
        child: ListView(
          padding: EdgeInsets.only(top: SCREEN_HEIGHT * 0.08, bottom: 30),
          children: [
            SvgPicture.asset(AppAssets.phoneMessageIcon),
            gapH20,
            const CustomTextFiled(
              titleText: "Email",
              hintText: "Enter Email Address",
              keyboardType: TextInputType.emailAddress,
            ),
            gapH20,
            const CustomTextFiled(
              titleText: "Phone number",
              hintText: "Enter Phone number",
              keyboardType: TextInputType.phone,
            ),
            gapH20,
            const CustomTextFiled(
              titleText: "Name",
              hintText: "Enter Name",
              keyboardType: TextInputType.name,
            ),
            gapH10,
            const CustomTextFiled(
              titleText: "Message",
              hintText: "Enter mesage",
              maxLines: 6,
            ),
            gapH50,
            CustomButton(title: "Submit", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });
  final VoidCallback onPressed;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.expand(width: 72, height: 48),
      onPressed: onPressed,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xFFF6F6F6)),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      icon: SvgPicture.asset(
        icon,
        width: 24,
        height: 24,
      ),
    );
  }
}

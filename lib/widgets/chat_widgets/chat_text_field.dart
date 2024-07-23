import 'package:flutter/material.dart';
import '../../ui/helpers/theme.dart';

class ChatTextField extends StatelessWidget {
  final String hintText;
  final Icon? prefixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;

  const ChatTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.controller,
    this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: FunnyChatTheme.chatInputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import '../../blocs/chat_bloc.dart';
import 'icon_container.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key});

  @override
  MessageInputFieldState createState() => MessageInputFieldState();
}

class MessageInputFieldState extends State<MessageInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ChatBloc>().messageController;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppNumbers.symmetricVertical),
      child: IconContainer(
        attachIconPath: AppStrings.iconAttach,
        audioIconPath: AppStrings.iconAudio,
        sendIconPath: AppStrings.iconSend,
      ),
    );
  }
}

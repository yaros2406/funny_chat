import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import '../../blocs/chat_bloc.dart';
import '../../ui/constants/app_numbers.dart';
import '../../ui/helpers/theme.dart';

class IconContainer extends StatefulWidget {
  final String attachIconPath;
  final String audioIconPath;
  final String sendIconPath;

  const IconContainer({
    super.key,
    required this.attachIconPath,
    required this.audioIconPath,
    required this.sendIconPath,
  });

  @override
  IconContainerState createState() => IconContainerState();
}

class IconContainerState extends State<IconContainer> {
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
    const double containerSize = AppNumbers.searchFieldHeight;
    const double marginSize = AppNumbers.edgeInsetsPadding;
    const double borderRadius = AppNumbers.buttonBorderRadius;

    return Row(
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          margin: const EdgeInsets.only(right: marginSize),
          decoration: FunnyChatTheme.iconContainerDecoration(),
          child: IconButton(
            icon: Image.asset(widget.attachIconPath, color: Colors.black),
            onPressed: () {
              context.read<ChatBloc>().add(PickFile());
            },
          ),
        ),
        Expanded(
          child: Container(
            height: containerSize,
            decoration: FunnyChatTheme.iconContainerDecoration(),
            child: TextField(
              textAlign: TextAlign.start,
              controller: _controller,
              decoration: InputDecoration(
                hintText: AppStrings.messageLabel,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: marginSize),
              ),
              onSubmitted: (text) {
                context.read<ChatBloc>().add(SendMessage(text: text));
              },
            ),
          ),
        ),
        Container(
          width: containerSize,
          height: containerSize,
          margin: const EdgeInsets.only(left: marginSize),
          decoration: FunnyChatTheme.iconContainerDecoration(),
          child: IconButton(
            icon: Image.asset(widget.audioIconPath, color: Colors.black),
            onPressed: () {
              context.read<ChatBloc>().add(StartRecordingAudio());
            },
          ),
        ),
      ],
    );
  }
}
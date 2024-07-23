import 'package:flutter/material.dart';
import '../../ui/constants/app_numbers.dart';
import '../../ui/constants/app_strings.dart';
import '../../ui/helpers/chat_manager.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isMe;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.data,
    required this.isMe,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    var borderRadius = AppNumbers.borderRadius;
    var zero = AppNumbers.zero;

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * AppNumbers.mediaQueryWidth),
      padding: const EdgeInsets.symmetric(vertical: AppNumbers.verticalPadding, horizontal: AppNumbers.margin),
      margin: const EdgeInsets.symmetric(vertical: AppNumbers.verticalMargin, horizontal: AppNumbers.horizontalMargin),
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).colorScheme.surfaceContainer : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMe ? borderRadius : borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(isMe ? borderRadius : zero),
          bottomRight: Radius.circular(isMe ? zero : borderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ChatManager.buildMessageItem(data, isMe, context),
              ),
              const SizedBox(width: AppNumbers.verticalMargin),
              Text(
                data[AppStrings.timeStamp] != null
                    ? DateTime.fromMillisecondsSinceEpoch(data[AppStrings.timeStamp]).
                toLocal().toString().
                substring(AppNumbers.subStringStart, AppNumbers.subStringEnd)
                    : '',
                style: isMe ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.headlineLarge
              ),
              const SizedBox(width: AppNumbers.verticalMargin),
              Icon(
                isRead ? Icons.done_all : Icons.check,
                size: AppNumbers.iconSize,
                color: isMe ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.onSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
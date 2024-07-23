import 'package:flutter/material.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import '../chat_widgets/avatar.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final String senderId;
  final VoidCallback onTap;
  final bool isCurrentUser;
  final bool isLast;

  const ChatItem({
    super.key,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.time,
    required this.senderId,
    required this.onTap,
    required this.isCurrentUser,
    required this.isLast
  });

  @override
  Widget build(BuildContext context) {
    final String displayMessage = isCurrentUser ? '${AppStrings.isMe}$lastMessage' : lastMessage;
    const limit = AppNumbers.limitSingleDouble;
    const spacing = AppNumbers.horizontalMargin;
    const horizontalMargin = AppNumbers.symmetricMargin;

    return Container(
      padding: const EdgeInsets.fromLTRB(horizontalMargin, spacing, horizontalMargin, spacing),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide( color: Theme.of(context).colorScheme.secondary, width: limit),
          bottom: isLast ? BorderSide(color: Theme.of(context).colorScheme.secondary, width: limit) : BorderSide.none,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Avatar(name: name),
            const SizedBox(width: AppNumbers.verticalPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: limit),
                  Text(
                    displayMessage,
                    maxLines: AppNumbers.limitSingle,
                    overflow: TextOverflow.ellipsis,
                    style: isCurrentUser
                        ? Theme.of(context).textTheme.headlineSmall
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

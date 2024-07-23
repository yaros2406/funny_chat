import 'package:flutter/material.dart';
import '../../ui/constants/app_numbers.dart';
import '../../ui/helpers/chat_manager.dart';

class Avatar extends StatelessWidget {
  final String name;

  const Avatar({super.key, required this.name});

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= AppNumbers.half) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.length == AppNumbers.limitSingle) {
      return nameParts[0][0];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: AppNumbers.avatarRadius,
      backgroundColor: ChatManager.getAvatarColor(name),
      child: Text(
        getInitials(name),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

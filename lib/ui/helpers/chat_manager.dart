import 'dart:math';
import 'package:flutter/material.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/helpers/datetime_manager.dart';
import 'package:funny_chat/widgets/audio_widgets/audio_player.dart';
import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

class ChatManager {

  static List<Map<String, dynamic>> groupMessagesByDate(
      List<Map<String, dynamic>> messages) {
    messages.sort((a, b) => a[AppStrings.timeStamp].compareTo(b[AppStrings.timeStamp]));

    Map<String, List<Map<String, dynamic>>> groupedMessages = {};

    for (var data in messages) {
      if (data[AppStrings.timeStamp] == null) {
        continue;
      }
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          data[AppStrings.timeStamp]);
      String date = DateTimeManager.formatDate(dateTime);

      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(data);
    }

    List<Map<String, dynamic>> messageGroups = groupedMessages.keys.map((date) {
      return {
        AppStrings.date: date,
        AppStrings.messages: groupedMessages[date]!
      };
    }).toList();

    messageGroups.sort((a, b) => b[AppStrings.date].compareTo(a[AppStrings.date]));

    return messageGroups;
  }

  static DateTime parseDate(String date) {
    if (date == AppStrings.today) {
      return DateTime.now();
    } else if (date == AppStrings.yesterday) {
      return DateTime.now().subtract(const Duration(days: AppNumbers.limitSingle));
    } else {
      return DateFormat(AppStrings.dateFormat).parse(date);
    }
  }

  static Color getAvatarColor(String name) {
    final random = Random(name.hashCode);
    return Color.fromARGB(
      AppNumbers.colorHighRange,
      random.nextInt(AppNumbers.colorMiddleRange),
      random.nextInt(AppNumbers.colorLowRange),
      random.nextInt(AppNumbers.colorUpperRange),
    );
  }

  static Widget buildMessageItem(Map<String, dynamic> data, bool isMe, BuildContext context) {
    if (data[AppStrings.fileUrl] != null && data[AppStrings.fileType] != AppStrings.audio) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(data[AppStrings.fileUrl]),
          if (data[AppStrings.text] != null && data[AppStrings.text].isNotEmpty)
            Text(
              data[AppStrings.text],
              style: isMe ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.displaySmall
            ),
        ],
      );
    } else if (data[AppStrings.fileType] == AppStrings.audio) {
      return AudioPlayerWidget(fileUrl: data[AppStrings.fileUrl], isMe: isMe);
    }
    else {
      return Text(
        data[AppStrings.text] ?? '',
        style: isMe ? Theme.of(context).textTheme.displayMedium : Theme.of(context).textTheme.displaySmall
      );
    }
  }
}
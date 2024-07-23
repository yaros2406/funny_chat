import 'package:funny_chat/ui/constants/app_numbers.dart';

import '../constants/app_strings.dart';

class DateTimeManager{

  static String padLeftWithZero(int number) {
    return number.toString().padLeft(AppNumbers.half, AppStrings.zero);
  }

  static String formatTimestamp(int timestamp) {
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now = DateTime.now();

    Duration diff = now.difference(messageTime);

    if (diff.inMinutes < AppNumbers.hour) {
      return '${diff.inMinutes} ${declineMinutes(diff.inMinutes)} ${AppStrings.back}';
    } else if (diff.inHours < AppNumbers.dayNight && messageTime.day == now.day) {
      return '${padLeftWithZero(messageTime.hour)}:'
          '${padLeftWithZero(messageTime.minute)}';
    } else if (diff.inHours < AppNumbers.previousDayNight && messageTime.day == now.day - AppNumbers.limitSingle) {
      return AppStrings.yesterday;
    } else {
      return '${padLeftWithZero(messageTime.day)}.${padLeftWithZero(messageTime.month)}.'
          '${messageTime.year.toString().substring(AppNumbers.half)}';
    }
  }

  static String declineMinutes(int minutes) {
    if (minutes % AppNumbers.tenPercent == AppNumbers.limitSingle && minutes % AppNumbers.hundredPercent != AppNumbers.plainNumber) {
      return AppStrings.minutu;
    } else if (minutes % AppNumbers.tenPercent >= AppNumbers.half && minutes % AppNumbers.tenPercent <= AppNumbers.quart &&
        (minutes % AppNumbers.hundredPercent < AppNumbers.tenPercent || minutes % AppNumbers.hundredPercent >= AppNumbers.quarter)) {
      return AppStrings.minuty;
    } else {
      return AppStrings.minut;
    }
  }

  static String formatDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: AppNumbers.limitSingle));

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return AppStrings.today;
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return AppStrings.yesterday;
    } else {
      return '${padLeftWithZero(dateTime.day)}.${padLeftWithZero(dateTime.month)}.${dateTime.year}';
    }
  }
}
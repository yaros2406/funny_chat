import 'package:flutter/material.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';

class DateDivider extends StatelessWidget {
  final String date;

  const DateDivider({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const dividerHeight = AppNumbers.dividerHeight;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppNumbers.symmetricVertical),
      child: Row(
        children: [
           Expanded(
            child: Divider(
              thickness: dividerHeight,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Text(
            date,
              style: Theme.of(context).textTheme.labelMedium,
          ),
           Expanded(
            child: Divider(
              thickness: dividerHeight,
                color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import '../../ui/helpers/theme.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppNumbers.searchFieldWidth,
      height: AppNumbers.searchFieldHeight,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: FunnyChatTheme.searchInputDecoration(
          hintText: AppStrings.searchLabel,
          prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.tertiary),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

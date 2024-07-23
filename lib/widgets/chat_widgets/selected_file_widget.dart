import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import '../../blocs/chat_bloc.dart';

class SelectedFileWidget extends StatelessWidget {
  const SelectedFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppNumbers.edgeInsetsPadding),
      child: Row(
        children: [
          const Icon(Icons.attachment),
          const SizedBox(width: AppNumbers.horizontalMargin),
          Text(context.watch<ChatBloc>().selectedFile!.path.split('/').last),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<ChatBloc>().add(ResetFileSelection());
            },
          ),
        ],
      ),
    );
  }
}

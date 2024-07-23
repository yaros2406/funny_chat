import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funny_chat/widgets/chat_widgets/selected_file_widget.dart';
import '../../blocs/chat_bloc.dart';
import '../../ui/constants/app_strings.dart';
import '../../ui/helpers/chat_manager.dart';
import 'chat_bubble.dart';
import 'date_divider.dart';
import 'message_input_field.dart';
import '../audio_widgets/record_audio_to_firebase.dart';

class ChatBody extends StatelessWidget {
  final String userId;
  final String chatId;

  const ChatBody({super.key, required this.userId, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded || state is MessageSentState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ChatBloc>().scrollController.animateTo(
              context.read<ChatBloc>().scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          });
        }
      },
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded || state is MessageSentState) {
            var messages = (state is ChatLoaded) ? state.messages : (state as MessageSentState).messages;
            var messageGroups = ChatManager.groupMessagesByDate(messages);

            return Column(
              children: [
                Expanded(
                  child: messageGroups.isNotEmpty
                      ? ListView.builder(
                    controller: context.read<ChatBloc>().scrollController,
                    reverse: true,
                    itemCount: messageGroups.length,
                    itemBuilder: (context, index) {
                      var group = messageGroups[index];
                      return Column(
                        children: [
                          DateDivider(date: group[AppStrings.date]),
                          ...group[AppStrings.messages].map<Widget>((message) {
                            var data = message as Map<String, dynamic>;
                            bool isMe = data[AppStrings.sender] == userId;
                            bool isRead = data[AppStrings.read] ?? false;

                            if (!isMe && !isRead) {
                              context.read<ChatBloc>().chatRepository.markMessageAsRead(chatId, data[AppStrings.key]);
                            }

                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: ChatBubble(data: data, isMe: isMe, isRead: isRead),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  )
                      : Center(child: Text(AppStrings.emptyMessageList, style: Theme.of(context).textTheme.labelMedium)),
                ),
                if (context.watch<ChatBloc>().selectedFile != null) ...[
                  const SelectedFileWidget(),
                ],
                if (context.watch<ChatBloc>().isRecordingAudio) ...[
                  RecordAudioToFirebase(
                    chatId: chatId,
                    userId: userId,
                    onRecordingComplete: () {
                      context.read<ChatBloc>().add(LoadChatMessages());
                    },
                    onRemoveWidget: () {
                      context.read<ChatBloc>().add(StopRecordingAudio());
                      context.read<ChatBloc>().isRecordingAudio = false;
                    },
                  ),
                ],
                const MessageInputField(),
              ],
            );
          } else {
            return Column(
              children: [
                Expanded(child: Center(child: Text(AppStrings.emptyMessageList, style: Theme.of(context).textTheme.bodyLarge))),
                const MessageInputField(),
              ],
            );
          }
        },
      ),
    );
  }
}

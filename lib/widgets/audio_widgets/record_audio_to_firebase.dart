import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:funny_chat/ui/constants/app_numbers.dart';
import 'package:funny_chat/ui/constants/app_strings.dart';
import 'package:funny_chat/ui/constants/firebase_paths.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class RecordAudioToFirebase extends StatefulWidget {
  final String chatId;
  final String userId;
  final VoidCallback onRecordingComplete;
  final VoidCallback onRemoveWidget;

  const RecordAudioToFirebase({
    super.key,
    required this.chatId,
    required this.userId,
    required this.onRecordingComplete,
    required this.onRemoveWidget,
  });

  @override
  RecordAudioToFirebaseState createState() => RecordAudioToFirebaseState();
}

class RecordAudioToFirebaseState extends State<RecordAudioToFirebase> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder!.openRecorder();
    if (await Permission.microphone.request().isGranted) {
    } else {
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}${AppStrings.audioFormat}';
    setState(() {
      _audioFilePath = tempPath;
    });
    await _recorder!.startRecorder(toFile: _audioFilePath);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    if (_audioFilePath != null) {
      File audioFile = File(_audioFilePath!);
      String fileName = audioFile.path.split('/').last;

      try {
        UploadTask uploadTask = FirebasePaths.getUploadReference(fileName).putFile(audioFile);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebasePaths.getChatMessagesPath(widget.chatId).push().set({
          AppStrings.text: '',
          AppStrings.fileUrl: downloadUrl,
          AppStrings.fileType: AppStrings.audio,
          AppStrings.sender: widget.userId,
          AppStrings.timeStamp: DateTime.now().millisecondsSinceEpoch,
        });

        setState(() {
          _audioFilePath = null;
        });
        widget.onRecordingComplete();
      } catch (e) {
        if (kDebugMode) {
          print('Error uploading file: $e');
        }
      } finally {
        widget.onRemoveWidget();
      }
    } else {
      widget.onRemoveWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppNumbers.edgeInsetsPadding),
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRecording ? AppStrings.recordInProcess : AppStrings.tapForStartRecord,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppNumbers.buttonBorderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppNumbers.horizontalPadding, vertical: AppNumbers.verticalPadding),
              ),
              child: Text(
                _isRecording ? AppStrings.stopRecord : AppStrings.startRecord,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/chat_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

typedef _Fn = void Function();

class VoiceRecorderWidget extends StatefulWidget {
  const VoiceRecorderWidget({super.key});

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  bool _mRecorderIsInited = false;

  bool _mplaybackReady = false;
  bool _mPlayerIsInited = false;

  /// Our player
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();

  /// Our recorder
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();

  bool _somethingRecorded = false;

  File? _mFile;

  /// Request permission to record something and open the recorder
  Future<void> openTheRecorder() async {
    try {
      // var basePath = Platform.isIOS
      //     ? (await getApplicationDocumentsDirectory()).path
      //     : (await getExternalStorageDirectory())!.path;
      // _mPath = '$basePath/${DateTime.now().millisecondsSinceEpoch}.wav';
      _mPath = 'recorded_file.mp4';
    } catch (e) {
      print(e.toString());
    }

    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    _mRecorderIsInited = true;
  }

  /// Begin to record.
  /// This is our main function.
  /// We ask Flutter Sound to record to a File.
  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: AudioSource.microphone,
    )
        .then((value) {
      setState(() {});
    });
  }

  /// Stop the recorder
  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        _mFile = File(value!);
        // print("STOPPED RECORDING");
        // print(value);
        //var url = value;
        _mplaybackReady = true;
        _somethingRecorded = true;
      });
    });
  }

  /// Begin to play the recorded sound
  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            // codec: _codec,
            fromURI: _mPath,
            // fromDataBuffer: File(_mPath).readAsBytesSync(),
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  /// Stop the player
  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  // ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Container(
      padding: const EdgeInsets.only(
        bottom: 40,
        left: 10,
        right: 10,
        top: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: (chatProvider.isVoiceRecorderOpen &&
              !chatProvider.isVoiceRecorderRecording)
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        chatProvider.setIsVoiceRecorderRecording(true);
                      },
                      child: Text(
                        AppLocale.tap_to_record_label.getString(
                          context,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        chatProvider.setIsVoiceRecorderOpen(false);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(3),
                  // height: 80,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: const Color(0xFFFAF0E6),
                    border: Border.all(
                      color: Colors.indigo,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Row(children: [
                    ElevatedButton(
                      onPressed: getRecorderFn(),
                      //color: Colors.white,
                      //disabledColor: Colors.grey,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blueGrey,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        elevation: WidgetStatePropertyAll(
                          3,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        _mRecorder!.isRecording
                            ? AppLocale.stop_label.getString(context)
                            : AppLocale.record_label.getString(context),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      _mRecorder!.isRecording
                          ? AppLocale.recording_in_progress_label.getString(
                              context,
                            )
                          : AppLocale.recorder_is_stopped_label.getString(
                              context,
                            ),
                    ),
                  ]),
                ),
                if (_somethingRecorded)
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    // height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: const Color(0xFFFAF0E6),
                      border: Border.all(
                        color: Colors.indigo,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Row(children: [
                      ElevatedButton(
                        onPressed: getPlaybackFn(),
                        //color: Colors.white,
                        //disabledColor: Colors.grey,
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.blueGrey,
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          elevation: WidgetStatePropertyAll(
                            3,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Text(
                          _mPlayer!.isPlaying
                              ? AppLocale.stop_label.getString(context)
                              : AppLocale.play_label.getString(context),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        _mPlayer!.isPlaying
                            ? AppLocale.playback_in_progress_label.getString(
                                context,
                              )
                            : AppLocale.player_is_stopped_label.getString(
                                context,
                              ),
                      ),
                    ]),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_somethingRecorded)
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            chatProvider.setIsVoiceRecorderRecording(false);
                            chatProvider.setIsVoiceRecorderOpen(false);

                            await SingleChatsController.uploadChatAudio(
                              chatProvider.chatId,
                              _mFile!,
                            );

                            _mRecorder!.stopRecorder();
                            _mPlayer!.stopPlayer();
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        label: Text(
                          AppLocale.send_label.getString(
                            context,
                          ),
                        ),
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.green,
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            Colors.white,
                          ),
                          elevation: WidgetStatePropertyAll(
                            3,
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () {
                        chatProvider.setIsVoiceRecorderRecording(false);
                        chatProvider.setIsVoiceRecorderOpen(false);
                        _mRecorder!.stopRecorder();
                        _mPlayer!.stopPlayer();
                      },
                      label: Text(
                        AppLocale.cancel_label.getString(
                          context,
                        ),
                      ),
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.red,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        elevation: WidgetStatePropertyAll(
                          3,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

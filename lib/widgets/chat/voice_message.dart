import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/chat_provider.dart';
import 'package:merhaba_app/utils/file_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

typedef _Fn = void Function();

class VoiceMessage extends StatefulWidget {
  final String url;
  final String filename;

  const VoiceMessage({
    super.key,
    required this.url,
    required this.filename,
  });

  @override
  _VoiceMessageState createState() => _VoiceMessageState();
}

class _VoiceMessageState extends State<VoiceMessage> {
  // bool _mplaybackReady = false;
  bool _mPlayerIsInited = false;

  /// Our player
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();

  /// Begin to play the recorded sound
  void play() {
    assert(_mPlayerIsInited && _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            // codec: _codec,
            fromURI: widget.url,
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

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  void initState() {
    super.initState();

    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        5,
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(3),
        // height: 80,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: const Color(0xFFFAF0E6),
          border: Border.all(
            color: Colors.indigo,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Row(children: [
          IconButton(
            // label: Container(),
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
            // label: Text(
            //   _mPlayer!.isPlaying
            //       ? AppLocale.stop_label.getString(context)
            //       : AppLocale.play_label.getString(context),
            // ),
            icon: Icon(
              _mPlayer!.isPlaying ? Icons.stop : Icons.play_arrow,
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
    );
  }
}

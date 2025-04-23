import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/chat_provider.dart';
import 'package:merhaba_app/utils/file_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class FileMessage extends StatefulWidget {
  final String url;
  final String filename;

  const FileMessage({
    super.key,
    required this.url,
    required this.filename,
  });

  @override
  _FileMessageState createState() => _FileMessageState();
}

class _FileMessageState extends State<FileMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                child: Text(
                  widget.filename,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final chatProvider =
                  Provider.of<ChatProvider>(context, listen: false);

              chatProvider.setIsLoading(true);

              try {
                await FileUtils.startDownloading(
                  widget.url,
                  widget.filename,
                  context,
                  (recivedBytes, totalBytes) {
                    print(recivedBytes);
                    print(totalBytes);
                  },
                );
              } catch (e) {
                print(e.toString());
              }

              chatProvider.setIsLoading(false);
            },
            label: Text(
              AppLocale.download_label.getString(
                context,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(
              Icons.download,
              size: 18,
            ),
          )
        ],
      ),
    );
  }
}

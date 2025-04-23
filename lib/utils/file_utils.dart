import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Dio dio = Dio();
  static bool isSuccess = false;

  static Future<void> startDownloading(
    String baseUrl,
    String fileName,
    BuildContext context,
    final Function okCallback,
  ) async {
    // String baseUrl =
    //     "https://file-examples.com/wp-content/uploads/2017/10/file-example_PDF_1MB.pdf";

    String path = await _getFilePath(fileName);

    try {
      await dio.download(
        baseUrl,
        path,
        onReceiveProgress: (recivedBytes, totalBytes) {
          okCallback(recivedBytes, totalBytes);
        },
        deleteOnError: true,
      ).then((_) {
        isSuccess = true;

        OpenFilex.open(
          path,
        );
      });
    } catch (e) {
      print("Exception$e");
    }

    // if (isSuccess) {
    //   Navigator.pop(context);
    // }
  }

  static Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }
}

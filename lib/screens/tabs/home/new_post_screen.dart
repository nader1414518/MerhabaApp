import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merhaba_app/controllers/posts_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/new_post_provider.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileTabProvider = Provider.of<ProfileTabProvider>(
      context,
      listen: false,
    );

    final newPostProvider = Provider.of<NewPostProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocale.new_post_label.getString(context),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: Text(
                AppLocale.save_label.getString(
                  context,
                ),
              ),
            ),
          ],
        ),
        body: newPostProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      profileTabProvider.photoUrl == ""
                          ? Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  60,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    AssetsUtils.profileAvatar,
                                  ),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: profileTabProvider.photoUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    60,
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 65) * 0.4,
                        child: Text(
                          profileTabProvider.username,
                          // textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 65) * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DropdownButton<String>(
                              isDense: true,
                              underline: Container(),
                              value: newPostProvider.currentPostMode,
                              onChanged: (String? value) {
                                if (value == null) return;

                                newPostProvider.setCurrentPostMode(
                                  value,
                                );
                              },
                              items: newPostProvider
                                  .getVisibilityOptions(context)
                                  .map<DropdownMenuItem<String>>(
                                      (Map<String, dynamic> value) {
                                return DropdownMenuItem<String>(
                                  value: value["value"],
                                  child: Row(
                                    children: [
                                      value["icon"],
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        value["label"],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppLocale.type_something_label.getString(
                          context,
                        ),
                      ),
                      minLines: 3,
                      maxLines: 20,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(
                        0.1,
                      ),
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ListTile(
                          dense: true,
                          title: Text(
                            AppLocale.photo_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.photo,
                          ),
                          onTap: () {
                            showDialog<String>(
                              context: context,
                              builder: (context) => fluent.ContentDialog(
                                // title: const Text('Delete file permanently?'),
                                // content: const Text(
                                //   'If you delete this file, you won\'t be able to recover it. Do you want to delete it?',
                                // ),
                                actions: [
                                  fluent.Button(
                                    child: Text(
                                      AppLocale.camera_label.getString(
                                        context,
                                      ),
                                    ),
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();

                                      var file = await imagePicker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 50,
                                      );

                                      if (file == null) {
                                        Navigator.of(context).pop();
                                        return;
                                      }

                                      // print("Photo >>>>>>>> " + file.name);
                                      var uploadRes =
                                          await PostsController.uploadPostMedia(
                                        File(
                                          file.path,
                                        ),
                                      );

                                      print(uploadRes);

                                      if (uploadRes["result"] == true) {
                                        var url = uploadRes["url"];
                                        var filename = uploadRes["filename"];

                                        newPostProvider.addNewPhoto({
                                          "url": url,
                                          "filename": filename,
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: uploadRes["message"].toString(),
                                        );
                                      }

                                      Navigator.of(context).pop();

                                      // Navigator.pop(
                                      //     context, 'User deleted file');
                                      // Delete file here
                                    },
                                  ),
                                  fluent.Button(
                                    child: Text(
                                      AppLocale.gallery_label.getString(
                                        context,
                                      ),
                                    ),
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();

                                      var files =
                                          await imagePicker.pickMultiImage(
                                        imageQuality: 50,
                                      );

                                      for (var file in files) {
                                        var uploadRes = await PostsController
                                            .uploadPostMedia(
                                          File(
                                            file.path,
                                          ),
                                        );

                                        print(uploadRes);

                                        if (uploadRes["result"] == true) {
                                          var url = uploadRes["url"];
                                          var filename = uploadRes["filename"];

                                          newPostProvider.addNewPhoto({
                                            "url": url,
                                            "filename": filename,
                                          });
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                uploadRes["message"].toString(),
                                          );
                                        }
                                      }

                                      Navigator.of(context).pop();

                                      // Navigator.pop(
                                      //     context, 'User deleted file');
                                      // Delete file here
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            AppLocale.video_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.video_camera_back,
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            AppLocale.location_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.location_pin,
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            AppLocale.occasion_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.announcement,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

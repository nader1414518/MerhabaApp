import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/providers/stories_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:image_picker/image_picker.dart';

class NewStoryScreen extends StatelessWidget {
  const NewStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileTabProvider = Provider.of<ProfileTabProvider>(
      context,
      listen: false,
    );

    final storiesProvider = Provider.of<StoriesProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocale.new_story_label.getString(
              context,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: storiesProvider.validateAddFields()
                  ? () {
                      storiesProvider.addStory();
                    }
                  : null,
              child: Text(
                AppLocale.save_label.getString(
                  context,
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
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
                        imageBuilder: (context, imageProvider) => Container(
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
              ],
            ),
            const SizedBox(
              height: 20,
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
                controller: storiesProvider.addStoryTextController,
              ),
            ),
            const SizedBox(
              height: 10,
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

                                Navigator.of(context).pop();
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

                                var files = await imagePicker.pickMultiImage(
                                  imageQuality: 50,
                                );

                                for (var file in files) {}

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
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (context) => fluent.ContentDialog(
                          actions: [
                            fluent.Button(
                              child: Text(
                                AppLocale.camera_label.getString(
                                  context,
                                ),
                              ),
                              onPressed: () async {
                                ImagePicker imagePicker = ImagePicker();

                                var file = await imagePicker.pickVideo(
                                  source: ImageSource.camera,
                                );

                                if (file == null) {
                                  Navigator.of(context).pop();
                                  return;
                                }

                                Navigator.of(context).pop();
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

                                var file = await imagePicker.pickVideo(
                                  source: ImageSource.gallery,
                                );

                                if (file == null) {
                                  Navigator.of(context).pop();
                                  return;
                                }

                                Navigator.of(context).pop();
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
                      AppLocale.voice_label.getString(
                        context,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.music_note,
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

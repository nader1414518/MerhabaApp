import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_localization/flutter_localization.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileTabProvider = Provider.of<ProfileTabProvider>(context);

    return SafeArea(
      child: Directionality(
        textDirection: localization.currentLocale.localeIdentifier == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profileTabProvider.photoUrl == ""
                        ? Container(
                            height: 100,
                            width: 100,
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
                              height: 100,
                              width: 100,
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
                  ],
                ),
                onTap: () async {
                  await showDialog<String>(
                    context: context,
                    builder: (context) => fluent.ContentDialog(
                      title: const Text('Change Profile Picture?'),
                      content: const Text(
                        'Choose the source that you want to get the new picture from',
                      ),
                      actions: [
                        FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.purple,
                            ),
                          ),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();

                            var file = await imagePicker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                            );

                            if (file != null) {
                              // profileTabProvider.toggleLoading();

                              try {
                                String original_filename =
                                    path.basename(file.path);
                                // String extension = path.extension(file.path);
                                String fileName =
                                    "${DateTime.now().toIso8601String().replaceAll('.', '').replaceAll(' ', '')}_$original_filename";

                                // print(fileName);

                                final String fullPath = await Supabase
                                    .instance.client.storage
                                    .from('Users')
                                    .upload(
                                      fileName,
                                      File(
                                        file.path,
                                      ),
                                    );

                                final String url = await Supabase
                                    .instance.client.storage
                                    .from("Users")
                                    .getPublicUrl(
                                      fileName,
                                    );

                                await profileTabProvider
                                    .updateUserProfilePicture(
                                  url,
                                );

                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e.toString());
                              }

                              // profileTabProvider.toggleLoading();
                            }
                          },
                          child: const Text('Camera'),
                        ),
                        FilledButton(
                          child: const Text('Gallery'),
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();

                            var file = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                            );

                            if (file != null) {
                              // profileTabProvider.toggleLoading();

                              try {
                                String original_filename =
                                    path.basename(file.path);
                                // String extension = path.extension(file.path);
                                String fileName =
                                    "${DateTime.now().toIso8601String().replaceAll('.', '').replaceAll(' ', '')}_$original_filename";

                                // print(fileName);

                                final String fullPath = await Supabase
                                    .instance.client.storage
                                    .from('Users')
                                    .upload(
                                      fileName,
                                      File(
                                        file.path,
                                      ),
                                    );

                                final String url = await Supabase
                                    .instance.client.storage
                                    .from("Users")
                                    .getPublicUrl(
                                      fileName,
                                    );

                                await profileTabProvider
                                    .updateUserProfilePicture(
                                  url,
                                );

                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e.toString());
                              }

                              // profileTabProvider.toggleLoading();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: Text(
                      profileTabProvider.username,
                      textAlign: TextAlign.center,
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: Text(
                      profileTabProvider.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: Text(
                      profileTabProvider.phone,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: Colors.blueGrey.withOpacity(
                      0.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
                        child: Text(
                          AppLocale.account_settings_label.getString(
                            context,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed("/account_settings");
                },
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: Colors.blueGrey.withOpacity(
                      0.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
                        child: Text(
                          AppLocale.app_settings_label.getString(
                            context,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  final appSettingsProvider = Provider.of<AppSettingsProvider>(
                    context,
                    listen: false,
                  );

                  await appSettingsProvider.getCurrentLanguage();

                  appSettingsProvider.setIsDark(
                    Globals.theme == "Dark",
                  );

                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed("/app_settings");
                },
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: Colors.blueGrey.withOpacity(
                      0.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
                        child: Text(
                          AppLocale.preferences_label.getString(
                            context,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: Colors.blueGrey.withOpacity(
                      0.2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
                        child: Text(
                          AppLocale.privacy_label.getString(
                            context,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: Colors.red.withOpacity(
                      0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
                        child: Text(
                          AppLocale.logout_label.getString(
                            context,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  try {
                    await AuthController.logOut();
                  } catch (e) {
                    print(e.toString());
                  }

                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushReplacementNamed("/login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

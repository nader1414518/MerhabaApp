import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatelessWidget {
  List<String> list = <String>["Friends", "Public", "Only Me"];

  @override
  Widget build(BuildContext context) {
    final profileTabProvider = Provider.of<ProfileTabProvider>(
      context,
      listen: false,
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
        body: ListView(
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
                        height: 40,
                        width: 40,
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
                          height: 40,
                          width: 40,
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
                      DropdownMenu<String>(
                        initialSelection: list.first,
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          // setState(() {
                          //   dropdownValue = value!;
                          // });
                        },
                        dropdownMenuEntries:
                            list.map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                        inputDecorationTheme: const InputDecorationTheme(
                          isDense: true,
                          contentPadding: EdgeInsets.all(
                            10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
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
                    onTap: () {},
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

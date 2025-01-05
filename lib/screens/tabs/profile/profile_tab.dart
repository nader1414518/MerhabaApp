import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileTabProvider = Provider.of<ProfileTabProvider>(context);

    return SafeArea(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profileTabProvider.photoUrl == ""
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            30,
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
                              30,
                            ),
                            image: DecorationImage(
                              image: imageProvider,
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
                      child: const Text(
                        "Account Settings",
                        style: TextStyle(
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
                      child: const Text(
                        "App Settings",
                        style: TextStyle(
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
                      child: const Text(
                        "Preferences",
                        style: TextStyle(
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
                      child: const Text(
                        "Privacy",
                        style: TextStyle(
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
                      child: const Text(
                        "Log Out",
                        style: TextStyle(
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
    );
  }
}

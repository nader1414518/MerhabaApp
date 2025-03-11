import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:merhaba_app/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocale.post_label.getString(
              context,
            ),
          ),
        ),
        body: Stack(
          children: [
            PostWidget(
              post: postProvider.currentPost,
              showActions: true,
              canNavigate: false,
            ),
            const SizedBox(
              height: 10,
            ),
            // TODO: comments here
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: (MediaQuery.sizeOf(context).width),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      15,
                    ),
                    topRight: Radius.circular(
                      15,
                    ),
                  ),
                  color: Colors.blueGrey.withOpacity(
                    0.25,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: fluent.TextBox(
                        placeholder: AppLocale.comment_label.getString(
                          context,
                        ),
                        expands: false,
                        controller: postProvider.newCommentController,
                        focusNode: postProvider.newCommentFocusNode,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.photo_camera_outlined,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

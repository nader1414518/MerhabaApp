import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/block_list_provider.dart';
import 'package:merhaba_app/widgets/friends/blocked_user_card.dart';
import 'package:provider/provider.dart';

class BlockListScreen extends StatelessWidget {
  const BlockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blockListProvider = Provider.of<BlockListProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocale.block_list_label.getString(
              context,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: blockListProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : blockListProvider.blockList.isEmpty
                ? Center(
                    child: Text(
                      AppLocale.no_data_found_label.getString(
                        context,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ...blockListProvider.blockList.map(
                        (element) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: BlockedUserCard(
                            user: element,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

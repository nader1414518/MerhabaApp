import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  Map<String, dynamic> post = {};

  PostWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width - 10,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(
                    0.25,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                padding: const EdgeInsets.all(
                  10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 20) * 0.7,
                          child: Text(
                            "Username",
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

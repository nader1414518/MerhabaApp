import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  String text;
  TextStyle? style;
  TextOverflow? overflow;
  TextAlign? alignment;
  int? maxLines;

  TextWidget({
    super.key,
    required this.text,
    this.style,
    this.overflow,
    this.alignment,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style != null
          ? style!.copyWith(
              // fontFamily: "KingsguardCalligraphy",
              )
          : const TextStyle(
              // fontFamily: "KingsguardCalligraphy",
              ),
      overflow: overflow,
      textAlign: alignment,
      maxLines: maxLines,
    );
  }
}

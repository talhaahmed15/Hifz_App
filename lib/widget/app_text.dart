import 'package:flutter/material.dart';
import 'package:hafiz_diary/constants.dart';
import 'package:translator/translator.dart';

class AppText extends StatefulWidget {
  String text;
  final Color? clr;
  final double? size;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final TextAlign? textAlign;

  AppText(
      {Key? key,
      required this.text,
      this.clr,
      this.size,
      this.fontWeight,
      this.maxLines,
      this.textDecoration,
      this.textAlign})
      : super(key: key);

  @override
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  void initState() {
    translate();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: lang == "en" ? TextDirection.ltr : TextDirection.rtl,
        child: Text(
          widget.text,
          maxLines: widget.maxLines,
          textAlign: widget.textAlign,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.clr,
            fontSize: widget.size,
            fontWeight: widget.fontWeight,
            overflow: TextOverflow.ellipsis,
            fontFamily: "Roboto",
            decoration: widget.textDecoration,
          ),
        ));
  }

  String translate() {
    final translator = GoogleTranslator();
    String temp = '';

    translator.translate(widget.text, to: lang).then((value) {
      setState(() {
        widget.text = value.toString();
        temp = value.toString();
      });
    });
    return temp;
  }
}

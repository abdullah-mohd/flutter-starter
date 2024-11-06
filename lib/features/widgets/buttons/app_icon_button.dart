import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class AppIconButton extends ConsumerWidget {
  final Function()? onPressed;
  final String text;
  final IconData btnIcon;
  final Widget? prefix;
  final bool disabled;
  final EdgeInsets padding;
  final Color backgroundColor;
  final double borderRadius;
  final double height;
  final bool downloading;
  final double downloadProgress;

  const AppIconButton({
    required this.onPressed,
    required this.text,
    required this.btnIcon,
    this.prefix,
    this.backgroundColor = Colors.black,
    this.padding = EdgeInsets.zero,
    this.borderRadius = 100,
    this.downloading = false,
    this.downloadProgress = 0,
    this.height = 52,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: padding,
      height: height,
      width: context.layout.maxWidth,
      child: Tooltip(
        message: text,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            elevation: 1,
            backgroundColor: disabled
                ? Color.fromARGB(255, 18, 99, 143)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              // side: BorderSide(
              //   color: disabled
              //       ? Colors.grey
              //       : backgroundColor == Colors.black
              //           ? Colors.white70
              //           : Colors.black54,
              // width: 2,
              // ),
              borderRadius: BorderRadius.circular(
                100.0,
              ),
            ),
          ),
          onPressed: disabled || downloading ? null : onPressed,
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            alignment: Alignment.center,
            width: context.layout.width,
            height: context.layout.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
              color: disabled ? Colors.grey : backgroundColor,
            ),
            child: downloading
                ? CircularProgressIndicator(
                    value: downloadProgress,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    // color: Colors.green,
                    backgroundColor: Colors.white,
                    // valueColor: <Color>(Colors.green),
                  )
                : Icon(
                    btnIcon,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}

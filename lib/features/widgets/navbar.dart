import 'package:flutter/material.dart';
import 'package:app/core/const/constants.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final double appBarHeight;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final Color color;

  const Navbar({
    super.key,
    required this.appBarHeight,
    this.title,
    this.leading,
    this.bottom,
    this.actions,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      foregroundColor: color,
      shadowColor: color,
      surfaceTintColor: color,
      centerTitle: true,
      backgroundColor: color,
      leading: leading ??
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(Icons.menu, color: Colors.black),
            ),
          ),
      title: Center(
        child: title ??
            Image.asset(
              appLogoURL,
              fit: BoxFit.fitHeight,
              height: 24,
            ),
      ),
      bottom: bottom,
      actions: actions ?? <Widget>[],
    );
  }

  @override
  Size get preferredSize => bottom == null
      ? Size.fromHeight(appBarHeight)
      : Size.fromHeight(appBarHeight + 50);
}

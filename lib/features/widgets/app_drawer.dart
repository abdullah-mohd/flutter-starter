import 'package:app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:layout/layout.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:app/features/dashboard/home/home_view.dart';
import 'package:app/features/dashboard/profile/profile_view.dart';
import 'package:app/features/widgets/const_widgets.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Widget _getDrawerTile(
    WidgetRef ref,
    String title,
    IconData iconPath,
    Function() onTap, {
    bool selected = false,
  }) {
    final appTheme = ref.watch(themeProvider).current.themeData;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: selected
              ? Border(
                  right: BorderSide(
                    color: appTheme.colorScheme.primary,
                    width: 3,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: 40,
              child: Text(
                title,
                style: appTheme.textTheme.bodyLarge!.copyWith(
                  color: appTheme.colorScheme.primary,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Icon(
              iconPath,
              color: appTheme.colorScheme.primary,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateTo(Widget scaffoldPage, WidgetRef ref) async {
    final dashboardVM = ref.read(dashboardViewModelProvider);
    Scaffold.of(ref.context).closeEndDrawer();
    await Future.delayed(const Duration(milliseconds: 300));
    dashboardVM.setActivePage(
      scaffoldPage,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardVM = ref.watch(dashboardViewModelProvider);
    final userImage = Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: 60,
      child: ClipOval(
        child: dashboardVM.getUserImage(
          60,
        ),
      ),
    );
    final appTheme = ref.watch(themeProvider).current.themeData;
    return Drawer(
      backgroundColor: appTheme.scaffoldBackgroundColor,
      child: ListView(
        children: [
          sized(
            h: 44,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).closeEndDrawer();
                  Navigator.of(context).pop();
                },
                icon: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  child: Icon(
                    FontAwesomeIcons.xmark,
                    color: appTheme.colorScheme.primary,
                  ),
                ),
              ),
              sized(
                w: 20,
              ),
            ],
          ),
          sized(
            h: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              userImage,
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              indent: 15,
              endIndent: 15,
              color: appTheme.colorScheme.primary,
              thickness: 0.5,
            ),
          ),
          SizedBox(
            width: context.layout.maxWidth,
            height: context.layout.height * 0.6,
            child: ListView(
              children: [
                _getDrawerTile(
                  ref,
                  'Dashboard',
                  Icons.dashboard,
                  () {
                    if (dashboardVM.activePage is! HomeView) {
                      _navigateTo(const HomeView(), ref);
                    } else {
                      Scaffold.of(context).closeEndDrawer();
                    }
                  },
                  selected: dashboardVM.activePage is HomeView,
                ),
                _getDrawerTile(
                  ref,
                  'Profile',
                  Icons.account_circle,
                  () {
                    if (dashboardVM.activePage is! ProfilePage) {
                      _navigateTo(const ProfilePage(), ref);
                    } else {
                      Scaffold.of(context).closeEndDrawer();
                    }
                  },
                  selected: dashboardVM.activePage is ProfilePage,
                ),

                const SizedBox(
                  height: 40,
                ),
                Divider(
                  indent: 15,
                  endIndent: 15,
                  color: appTheme.colorScheme.primary,
                  thickness: 0.5,
                ),
                _getDrawerTile(
                  ref,
                  'Logout',
                  Icons.logout,
                  () async {
                    await dashboardVM.logoutUser();
                  },
                  selected: false,
                ),

                // Spacer(),
                sized(h: 30),

                // Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

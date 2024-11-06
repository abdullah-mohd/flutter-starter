import 'package:app/features/dashboard/profile/profile_view.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/services/app_state/app_state_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/authentication/forgot_password/forgot_page.dart';
import 'package:app/features/authentication/login/login_page.dart';
import 'package:app/features/authentication/register/register_page.dart';
import 'package:app/features/dashboard/dashboard_root.dart';

final routerProvider = Provider<GoRouter>(
  (ref) {
    final appState = ref.watch(appStateServiceProvider);
    final currentRoute = ref.watch(appState.routeProvider);
    logInfo('-------- IN ROUTER');
    logInfo(currentRoute);
    return GoRouter(
      initialLocation: currentRoute,
      onException: (context, state, router) {
        logInfo('>>>>>>>>>>>>>>>>>>>>>>>> ROUTER EXCEPTION!!!');
        logInfo(state.error);
        logInfo(state.error.runtimeType);
      },
      redirect: (context, state) {
        logInfo('>>>>>>>>>>>>>>>>>>>>>>>> ROUTER REDIRECT!!!');
        return null;
      },
      restorationScopeId: 'app_router',
      routes: [
        GoRoute(
          path: ProfilePage.path,
          pageBuilder: (context, state) => _getCustomTransitionPage(
            name: ProfilePage.name,
            state: state,
            child: const ProfilePage(),
          ),
        ),
        GoRoute(
          path: DashboardRoot.path,
          pageBuilder: (context, state) {
            return _getCustomTransitionPage(
              name: DashboardRoot.name,
              state: state,
              child: const DashboardRoot(),
            );
          },
          routes: [],
        ),
        GoRoute(
          name: LoginPage.name,
          path: LoginPage.path,
          pageBuilder: (context, state) => _getCustomTransitionPage(
            name: LoginPage.name,
            state: state,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          name: ForgotPassword.name,
          path: ForgotPassword.path,
          pageBuilder: (context, state) => _getCustomTransitionPage(
            name: ForgotPassword.name,
            state: state,
            child: const ForgotPassword(),
          ),
        ),
        GoRoute(
          name: RegisterPage.name,
          path: RegisterPage.path,
          pageBuilder: (context, state) => _getCustomTransitionPage(
            name: RegisterPage.name,
            state: state,
            child: const RegisterPage(),
          ),
        ),
      ], // All the routes can be found there
    );
  },
);

CustomTransitionPage _getCustomTransitionPage({
  required GoRouterState state,
  required String name,
  Duration duration = const Duration(milliseconds: 700),
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    name: name,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
    child: child,
  );
}

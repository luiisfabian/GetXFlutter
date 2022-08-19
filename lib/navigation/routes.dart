import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../ui/intro_page.dart';
import '../ui/splash_page.dart';


class Routes {
  static const splash = '/';
  static const intro = '/intro';
  static const createAccount = '/createAccount';
  static const signInEmail = '/signInEmail';
  static const home = '/home';

  static Route routes(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(settings, page:  SplashPage());
      case intro:
        return _buildRoute(settings, page:  IntroPage());
      default:
        throw Exception("this route not exist");
    }
  }

  static GetPageRoute _buildRoute(RouteSettings settings,
          {required Widget page}) =>
      GetPageRoute(settings: settings, page: () => page);
}
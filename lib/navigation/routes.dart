import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/email_create_page.dart';
import 'package:getx_flutter/ui/email_signIn_page.dart';
import 'package:getx_flutter/ui/home_page.dart';

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
        return _buildRoute(settings, page: SplashPage());
      case intro:
        return _buildRoute(settings, page: IntroPage());
      case home:
        return _buildRoute(settings, page: HomePage());
      case createAccount:
        return _buildRoute(settings, page: EmailCreatePage());
      case signInEmail:
        return _buildRoute(settings, page: EmailSignInPage());
      default:
        throw Exception("this route not exist");
    }
  }

  static GetPageRoute _buildRoute(RouteSettings settings,
          {required Widget page}) =>
      GetPageRoute(settings: settings, page: () => page);
}

import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

class Routes {
  static const splash = '/';
  static const intro = '/intro';
  static const createAccount = '/createAccount';
  static const signInEmail = '/signInEmail';
  static const home = '/home';

  static Route routes(RouteSettings settings) {
    switch (settings.name) {
      case 'splash':
      default:
        throw Exception("this route not exist");
    }
  }

  static GetPageRoute _buildRoute(RouteSettings settings,
          {required Widget page}) =>
      GetPageRoute(settings: settings, page: () => page);
}

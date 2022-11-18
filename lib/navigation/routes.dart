import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/email_create_page.dart';
import 'package:getx_flutter/ui/email_signIn_page.dart';
import 'package:getx_flutter/ui/food_menu/food_menu_List_page.dart';
import 'package:getx_flutter/ui/home_page.dart';
import 'package:getx_flutter/ui/main_page.dart';
import 'package:getx_flutter/ui/menu/menu_form.dart';
import 'package:getx_flutter/ui/menu/menu_list.dart';
import 'package:getx_flutter/ui/orders/order_form_page.dart';
import 'package:getx_flutter/ui/orders/order_list_page.dart';

import '../ui/intro_page.dart';
import '../ui/splash_page.dart';

class Routes {
  static const splash = '/';
  static const intro = '/intro';
  static const createAccount = '/createAccount';
  static const signInEmail = '/signInEmail';
  static const home = '/home';
  static const main = '/main';
  static const menu_types_list = '/menu_types_list';
  static const menu_types_form = '/menu_types_form';
  static const orders_list = '/order_list';
  static const orders_form = '/order_form';
  static const food_menu = '/food_menu';

  static Route routes(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(settings, page: SplashPage());
      case intro:
        return _buildRoute(settings, page: IntroPage());
      case home:
        return _buildRoute(settings, page: HomePage());
      case main:
        return _buildRoute(settings, page: MainPage());
      case food_menu:
        return _buildRoute(settings, page: FoodMenuLisPage());
      case menu_types_list:
        return _buildRoute(settings, page: MenuList());
      case menu_types_form:
        return _buildRoute(settings, page: MenuForm());
      case orders_list:
        return _buildRoute(settings, page: OrdersListPage());
      case orders_form:
        return _buildRoute(settings, page: OrdersFormPage());
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

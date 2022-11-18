import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../navigation/routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.home);
          },
          icon: Icon(Icons.person),
        ),
      ]),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.5, //<-- SEE HERE
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 94, 108, 187)),
                accountName: null,
                accountEmail: null,
                currentAccountPicture: FlutterLogo(),
              ),
              ListTile(
                leading: Icon(
                  Icons.house,
                ),
                title: const Text('Menú de Comidas'),
                onTap: () {
                  Get.offAllNamed(Routes.food_menu);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.fastfood_outlined,
                ),
                title: const Text('Menus'),
                onTap: () {
                  Get.offAllNamed(Routes.menu_types_list);
                },
              ),
               ListTile(
                leading: Icon(
                  Icons.list_alt_outlined,
                ),
                title: const Text('Pedidos'),
                onTap: () {
                  Get.offAllNamed(Routes.orders_list);
                },
              ),
              const AboutListTile(
                // <-- SEE HERE
                icon: Icon(
                  Icons.info,
                ),
                child: Text('About app'),
                applicationIcon: Icon(
                  Icons.local_play,
                ),
                applicationName: 'U De Caldas APP',
                applicationLegalese: '© 2022 Fabian Company',
                aboutBoxChildren: [
                  Icon(Icons.event_note_sharp),

                  ///Content goes here...
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: _height,
          width: _width,
          child: null,
          color: Colors.red,
        ),
      ),
    );
  }
}

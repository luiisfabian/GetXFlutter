import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/menu/menu_form.dart';
import 'package:getx_flutter/ui/menu/menu_service.dart';
import 'package:getx_flutter/ui/menu/model/menuModel.dart';

import '../../navigation/routes.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  MenuService _menuService = new MenuService();
  List<MenuModel> _menuList = [];
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final MenuService menuService = new MenuService();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.home);
            },
            icon: Icon(Icons.person),
          ),
        ],
        title: Text("Lista de Menus"),
      ),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("MenuColection")
            .where("isDeleted", isEqualTo: false)
            .snapshots(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              _menuList = [];
              snapshot.data!.docs.forEach((doc) {
                _menuList
                    .add(MenuModel.fromSnapshot(data: doc.data(), id: doc.id));
              });
              return ListView.builder(
                itemCount: _menuList.length,
                itemBuilder: (context, index) {
                  final item = _menuList[index].key;

                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmación"),
                            content: const Text(
                                "Estas seguro de eliminar este Item?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    menuService.deleteMenu(
                                        context,
                                        new MenuModel(
                                            photoUrl: _menuList[index].photoUrl,
                                            type: _menuList[index].type,
                                            key: _menuList[index].key,
                                            name: _menuList[index].name,
                                            description:
                                                _menuList[index].description,
                                            price: _menuList[index].price,
                                            isDeleted: true));
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("SI")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("NO"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        color: Color.fromARGB(255, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              MenuForm(
                                menuModel: _menuList[index],
                              ),
                            );
                          },
                          child: Ink(
                            width: _width * 0.5,
                            height: _height * 0.5,
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                // Image.asset(
                                //   'assets/intro_1.png',
                                //   width: _width * 0.2,
                                //   height: _height * 0.2,
                                // ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Center(
                                  child: Column(
                                    children: [
                                      _menuList[index].photoUrl != null
                                          ? Container(
                                              width: _width * 0.2,
                                              height: _height * 0.2,
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: CircleAvatar(
                                                    radius: 80,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      _menuList[index]
                                                          .photoUrl!,
                                                    ),
                                                  )),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.blue
                                                      .withOpacity(0.80),
                                                  width: 3,
                                                ),
                                              ),
                                            )
                                          : _menuList[index].photoUrl != null
                                              ? Container(
                                                  width: _width * 0.2,
                                                  height: _height * 0.2,
                                                  child: FittedBox(
                                                      fit: BoxFit.contain,
                                                      child: CircleAvatar(
                                                        radius: 80,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          _menuList[index]
                                                              .photoUrl!,
                                                        ),
                                                      )),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.blue
                                                          .withOpacity(0.80),
                                                      width: 3,
                                                    ),
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/intro_1.png',
                                                  width: _width * 0.2,
                                                  height: _height * 0.2,
                                                ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _menuList[index].name,
                                        style: TextStyle(
                                            fontFamily: "Sans Serif",
                                            fontSize: 30,
                                            color: Colors.red),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _menuList[index].description,
                                        style: TextStyle(
                                            fontFamily: "ArialBlack",
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 0, 191, 255)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _menuList[index].type,
                                        style: TextStyle(
                                            fontFamily: "ArialBlack",
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "\$ " +
                                            _menuList[index].price.toString(),
                                        style: TextStyle(
                                            fontFamily: "ArialBlack",
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAllNamed(Routes.menu_types_form);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

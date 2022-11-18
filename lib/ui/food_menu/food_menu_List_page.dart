import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/menu/menu_service.dart';

import '../../navigation/routes.dart';
import '../menu/model/menuModel.dart';

class FoodMenuLisPage extends StatefulWidget {
  const FoodMenuLisPage({super.key});

  @override
  State<FoodMenuLisPage> createState() => _FoodMenuLisPageState();
}

class _FoodMenuLisPageState extends State<FoodMenuLisPage> {
  List<MenuModel> _bebidaList = [];
  List<MenuModel> _alimentoList = [];
  List<MenuModel> _snackList = [];

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

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
        title: Text("Menú de Comidas"),
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
                title: const Text('Menu de Comida'),
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
      body: Container(
        width: _width,
        height: _height,
        child: ListView(children: [
          Column(
            children: [
              Text(
                "Bebidas",
                style: TextStyle(fontSize: 48),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MenuColection")
                    .where("isDeleted", isEqualTo: false)
                    .where("type", isEqualTo: "Bebida")
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    default:
                      _bebidaList = [];

                      snapshot.data!.docs.forEach((doc) {
                        _bebidaList.add(MenuModel.fromSnapshot(
                            data: doc.data(), id: doc.id));
                      });
                      // return _bebidaList.length > 0
                      //     ? mainView(_bebidaList, _height, _width)
                      //     : Container();
                      return _bebidaList.length > 0
                          ? CarouselSlider.builder(
                              itemCount: _bebidaList.length,
                              itemBuilder: (context, index, realIndex) {
                                return Card(
                                  // color: Color.fromARGB(255, 68, 107, 197),
                                  elevation: 10,
                                  child: Container(
                                    width: double.infinity,
                                    height: _height * 0.15,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 68, 107, 197),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),

                                    // color: Colors.red,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            _bebidaList[index].name,
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            height: _height * 0.3,
                                            width: _width * 0.5,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(120),
                                              ),
                                            ),
                                            child: _bebidaList[index]
                                                        .photoUrl !=
                                                    null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            _bebidaList[index]
                                                                .photoUrl!),
                                                  )
                                                : Image.asset(
                                                    'assets/intro_1.png',
                                                    width: _width * 0.2,
                                                    height: _height * 0.2,
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          _bebidaList[index].description,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " \$" +
                                              _bebidaList[index]
                                                  .price
                                                  .toString(),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: _height * 0.7,

                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 4),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                //onPageChanged: callbackFunction,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : Container();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Alimentos",
                style: TextStyle(fontSize: 48),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MenuColection")
                    .where("isDeleted", isEqualTo: false)
                    .where("type", isEqualTo: "Alimento")
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    default:
                      _alimentoList = [];
                      snapshot.data!.docs.forEach((doc) {
                        print(doc.data());
                        _alimentoList.add(MenuModel.fromSnapshot(
                            data: doc.data(), id: doc.id));
                      });
                      return _alimentoList.length > 0
                          ? CarouselSlider.builder(
                              itemCount: _alimentoList.length,
                              itemBuilder: (context, index, realIndex) {
                                return Card(
                                  // color: Color.fromARGB(255, 68, 107, 197),
                                  elevation: 10,
                                  child: Container(
                                    width: double.infinity,
                                    height: _height * 0.15,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 68, 107, 197),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),

                                    // color: Colors.red,
                                    child: Column(
                                      
                                      children: [
                                        Center(
                                          child: Text(
                                            _alimentoList[index].name,
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            height: _height * 0.3,
                                            width: _width * 0.5,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(120),
                                              ),
                                            ),
                                            child: _alimentoList[index]
                                                        .photoUrl !=
                                                    null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            _alimentoList[index]
                                                                .photoUrl!),
                                                  )
                                                : Image.asset(
                                                    'assets/intro_1.png',
                                                    width: _width * 0.2,
                                                    height: _height * 0.2,
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          _alimentoList[index].description,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " \$" +
                                              _alimentoList[index]
                                                  .price
                                                  .toString(),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: _height * 0.7,

                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 4),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                //onPageChanged: callbackFunction,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : Container();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Snacks",
                style: TextStyle(fontSize: 48),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("MenuColection")
                    .where("isDeleted", isEqualTo: false)
                    .where("type", isEqualTo: "Snack")
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    default:
                      _snackList = [];

                      snapshot.data!.docs.forEach((doc) {
                        _snackList.add(MenuModel.fromSnapshot(
                            data: doc.data(), id: doc.id));
                      });

                      return _snackList.length > 0
                          ? CarouselSlider.builder(
                              itemCount: _snackList.length,
                              itemBuilder: (context, index, realIndex) {
                                return Card(
                                  // color: Color.fromARGB(255, 68, 107, 197),
                                  elevation: 10,
                                  child: Container(
                                    width: double.infinity,
                                    height: _height * 0.15,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 68, 107, 197),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),

                                    // color: Colors.red,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            _snackList[index].name,
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            height: _height * 0.3,
                                            width: _width * 0.5,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(120),
                                              ),
                                            ),
                                            child: _snackList[index]
                                                        .photoUrl !=
                                                    null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            _snackList[index]
                                                                .photoUrl!),
                                                  )
                                                : Image.asset(
                                                    'assets/intro_1.png',
                                                    width: _width * 0.2,
                                                    height: _height * 0.2,
                                                  ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          _snackList[index].description,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          " \$" +
                                              _snackList[index]
                                                  .price
                                                  .toString(),
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: _height * 0.7,

                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 4),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 1000),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                //onPageChanged: callbackFunction,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : Container();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget mainView(_list, _height, _width) {
    return CarouselSlider.builder(
      itemCount: _list.length,
      itemBuilder: (context, index, realIndex) {
        return Card(
          color: Color.fromARGB(255, 68, 107, 197),
          elevation: 10,
          child: Container(
              width: _width,
              height: _height * 0.1,
              padding: EdgeInsets.all(8),

              // color: Colors.red,
              child: Column(
                children: [
                  Center(
                    child: Text("nombre"),
                  ),
                  Row()
                ],
              )),
        );
      },
      options: CarouselOptions(
        height: _height * 0.3,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        //onPageChanged: callbackFunction,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

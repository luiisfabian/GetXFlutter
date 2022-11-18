import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../navigation/routes.dart';
import 'model/orderModel.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  List<OrderModel> _orderList = [];

  @override
  Widget build(BuildContext context) {
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
        title: Text("Lista de Pedidos"),
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
                title: const Text('Menu de Comidas'),
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
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            default:
              _orderList = [];
              snapshot.data!.docs.forEach((doc) {
                _orderList.add(
                  OrderModel.fromSnapshot(data: doc.data(), id: doc.id),
                );
              });
              return ListView.builder(
                itemCount: _orderList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Pedido Juan Carlos"),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAllNamed(Routes.orders_form);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

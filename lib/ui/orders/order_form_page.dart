import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/menu/model/menuModel.dart';
import 'package:getx_flutter/ui/orders/model/orderModel.dart';
import 'package:getx_flutter/ui/orders/order_service.dart';

import '../../navigation/routes.dart';

class OrdersFormPage extends StatefulWidget {
  OrderModel? orderModel;
  OrdersFormPage({this.orderModel});

  @override
  State<OrdersFormPage> createState() => _OrdersFormPageState();
}

class _OrdersFormPageState extends State<OrdersFormPage> {
  OrderService _orderService = new OrderService();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  var _tableNumber = ['Mesa #1', 'Mesa #2', 'Mesa #3'];
  String dropdownValue = 'Mesa #1';

  List _menuList = [];
  List<int> _counter = [];

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // if (widget.orderModel?.key != null) {
    //   _nameController.text = widget.menuModel!.name.toString();
    //   dropdownValue = widget.menuModel!.type.toString();
    //   _descriptionController.text = widget.menuModel!.description.toString();
    //   _priceController.text = widget.menuModel!.price.toString();
    //   // if (widget.menuModel!.photoUrl != null) {
    //   //   link = widget.menuModel!.photoUrl.toString();
    //   // }
    // } else {
    //   _nameController.text = '';
    //   _descriptionController.text = '';
    //   dropdownValue = dropdownValue;
    //   _priceController.text = 0.toString();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.orders_list);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Añadir Productos Al Menú"),
      ),
      body: Container(
        width: _width,
        height: _height,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButton<String>(
                isExpanded: true,
                icon: Icon(Icons.line_axis_sharp),
                value: dropdownValue,
                style: const TextStyle(color: Colors.black),
                items:
                    _tableNumber.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Nombre del Cliente"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por Favor complete el campo";
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 300,
                width: 100,
                color: Color.fromARGB(255, 110, 171, 221),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("MenuColection")
                      .where("isDeleted", isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      default:
                        _menuList = [];
                        snapshot.data!.docs.forEach((doc) {
                          _menuList.add(MenuModel.fromSnapshot(
                              data: doc.data(), id: doc.id));
                        });

                        return ListView.builder(
                          itemCount: _menuList.length,
                          itemBuilder: (context, index) {
                            if (_counter.length < _menuList.length) {
                              _counter.add(0);
                            }
                            return ListTile(
                              title: Text(_menuList[index].name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Text(
                                      "34",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: IconButton(
                                      icon: new Icon(Icons.remove,
                                          color: Colors.black),
                                      onPressed: () {
                                        _decrementCounter(index);
                                        // productos.count -= 1;
                                        // updateCount(productos, position);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: IconButton(
                                      icon: new Icon(Icons.add,
                                          color: Colors.black),
                                      onPressed: () {
                                        _incrementCounter(index);
                                        // productos.count -= 1;
                                        // updateCount(productos, position);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: 150,
                child: TextButton.icon(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    // UploadTask? task = await uploadFile(file!);
                    // if (task != null) {
                    //   setState(() {
                    //     _uploadTasks = [..._uploadTasks, task];
                    //   });
                    // }
                    // await _downloadLink(ref!);

                    // if (!_formKey.currentState!.validate()) {
                    //   return;
                    // } else {
                    //   if (widget.menuModel?.key != null) {
                    //     _menuService.updateMenu(
                    //       context,
                    //       MenuModel(
                    //         isDeleted: false,
                    //         key: widget.menuModel!.key,
                    //         type: dropdownValue,
                    //         name: _nameController.text,
                    //         description: _descriptionController.text,
                    //         price: int.parse(_priceController.text),
                    //       ),
                    //     );
                    //     //  Navigator.pop(context);
                    //   } else {
                    //     _menuService.addMenu(
                    //       context,
                    //       MenuModel(
                    //         isDeleted: false,
                    //         type: dropdownValue,
                    //         name: _nameController.text,
                    //         description: _descriptionController.text,
                    //         price: int.parse(_priceController.text),
                    //       ),
                    //     );
                    //     //  Navigator.pop(context);
                    //   }
                    // }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Guardar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _incrementCounter(int i) {
    _counter[i]++;
    //_event.add(_counter[i]);
  }

  _decrementCounter(int i) {
    if (_counter[i] <= 0) {
      _counter[i] = 0;
    } else {
      _counter[i]--;
    }
    //_event.add(_counter[i]);
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_flutter/ui/menu/menu_service.dart';
import 'package:getx_flutter/ui/menu/model/menuModel.dart';
import 'package:image_picker/image_picker.dart';

import '../../navigation/routes.dart';

class MenuForm extends StatefulWidget {
  MenuForm({this.menuModel});
  MenuModel? menuModel;
  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final ImagePicker _picker = ImagePicker();
  bool _load = false;

  MenuService _menuService = new MenuService();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  var _foodType = ['Bebida', 'Alimento', 'Snack'];
  String dropdownValue = 'Bebida';
  List<UploadTask> _uploadTasks = [];

  String? link;
  PickedFile? file;
  Reference? ref;
  dynamic _pickImageError;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.menuModel?.key != null) {
      _nameController.text = widget.menuModel!.name.toString();
      dropdownValue = widget.menuModel!.type.toString();
      _descriptionController.text = widget.menuModel!.description.toString();
      _priceController.text = widget.menuModel!.price.toString();
      if (widget.menuModel!.photoUrl != null) {
        link = widget.menuModel!.photoUrl.toString();
      }
    } else {
      _nameController.text = '';
      _descriptionController.text = '';
      dropdownValue = dropdownValue;
      _priceController.text = '';
      link = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.menu_types_list);
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
              link != null
                  ? Container(
                      height: 150,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(
                              link!,
                            ),
                          )),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.80),
                          width: 3,
                        ),
                      ),
                    )
                  : file != null
                      ? Container(
                          height: 100,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: CircleAvatar(
                                radius: 80,
                                backgroundImage: FileImage(File(file!.path)),
                              )),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.80),
                              width: 3,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 20.0,
                        ),
              Center(
                child: ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.blue)),
                        ),
                      ),
                      onPressed: () {
                        selectLocationImage(context);
                      },
                      child: widget.menuModel?.key == null
                          ? Text("Subir Imagen")
                          : Text("Cambiar Imagen"),
                    ),
                    Spacer(),
                    TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.red)),
                          ),
                        ),
                        onPressed: () {
                          deleteImage(context);
                        },
                        child: Text(
                          "Eliminar Imagen",
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
              DropdownButton<String>(
                isExpanded: true,
                icon: Icon(Icons.line_axis_sharp),
                value: dropdownValue,
                style: const TextStyle(color: Colors.black),
                items: _foodType.map<DropdownMenuItem<String>>((String value) {
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
                decoration: InputDecoration(labelText: "Nombre del Producto"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por Favor complete el campo";
                  }
                },
              ),
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Precio del Producto"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por Favor complete el campo";
                  }
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration:
                    InputDecoration(labelText: "Descripción del Producto"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por Favor complete el campo";
                  }
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 50,
                width: 130,
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
                    UploadTask? task = await uploadFile(file);
                    if (task != null) {
                      setState(() {
                        _uploadTasks = [..._uploadTasks, task];
                      });
                    }
                    await _downloadLink(ref!);

                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      if (widget.menuModel?.key != null) {
                        _menuService.updateMenu(
                          context,
                          MenuModel(
                            photoUrl: link,
                            isDeleted: false,
                            key: widget.menuModel!.key,
                            type: dropdownValue,
                            name: _nameController.text,
                            description: _descriptionController.text,
                            price: int.parse(_priceController.text),
                          ),
                        );
                        //  Navigator.pop(context);
                      } else {
                        _menuService.addMenu(
                          context,
                          MenuModel(
                            photoUrl: link,
                            isDeleted: false,
                            type: dropdownValue,
                            name: _nameController.text,
                            description: _descriptionController.text,
                            price: int.parse(_priceController.text),
                          ),
                        );
                        //  Navigator.pop(context);
                      }
                    }
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

  Future<void> _downloadLink(Reference ref) async {

 var lll = (await ref.getDownloadURL()).toString();

    setState(() {
     link = lll;

     print(link);
    });

    await Clipboard.setData(ClipboardData(
      text: link,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Success!\n Copied download URL to Clipboard!',
        ),
      ),
    );
  }

  Future<void> getImageCamera() async {
    file = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {});
    Navigator.pop(context);
  }

  Future<void> getImageGallery() async {
    file = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {});
    Navigator.pop(context);
  }

  Future<UploadTask?> uploadFile(PickedFile? file) async {
    if (file == null || file == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }

    UploadTask uploadTask;

    String fileName = file.path.split('/').last;
    ref = FirebaseStorage.instance.ref().child('menus').child(fileName);
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});
    uploadTask = ref!.putFile(File(file.path), metadata);

    setState(() {

    });

    // if (kIsWeb) {
    //   uploadTask = ref.putData(await file.readAsBytes(), metadata);
    // } else {
    //   uploadTask = ref.putFile(io.File(file.path), metadata);
    // }

    return Future.value(uploadTask);
  }

  selectLocationImage(BuildContext context) {
    // set up the buttons
    Widget cameraButton = TextButton(
      child: Text("Camara"),
      onPressed: () {
        getImageCamera();
      },
    );
    Widget galerryButton = TextButton(
      child: Text("Galeria"),
      onPressed: () {
        getImageGallery();
      },
    );

    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Seleccion de Fotografia"),
      content: Text("De donde desea la fotografia?"),
      actions: [cameraButton, galerryButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteImage(BuildContext context) {
    if (link != null || file != null) {
      link = "";
      file = null;
    }
    setState(() {});
  }
}

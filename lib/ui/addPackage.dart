import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:videolib/extension/Methods.dart';
import 'package:videolib/ui/packages.dart';

class AddPackageUi extends StatefulWidget {
  final int id;
  AddPackageUi({this.id});
  @override
  _AddPackageUiState createState() => _AddPackageUiState(id: id);
}

class _AddPackageUiState extends State<AddPackageUi> {
  int id;
  _AddPackageUiState({this.id});
  File _image;
  final picker = ImagePicker();
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: _image != null
                  ? GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      }, // handle your image tap here
                      child: Image.file(
                        _image,
                        fit: BoxFit.cover, // this is the solution for border
                        width: 300,
                        height: 450,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      width: 300,
                      height: 450,
                      child: IconButton(
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.grey[800],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: 'Name',
                  )),
            ),
            TextButton(
                onPressed: () {
                  if (_image != null && _textFieldController.text.isNotEmpty) {
                    w8Method();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Tester(
                                  value: id,
                                )),
                        (route) => false);
                  } else {
                    print("wrong input");
                  }
                },
                child: Text('Done')),
          ],
        ),
      ),
    ));
  }

  w8Method() async {
    await addPackage(
        text: _textFieldController.text, imageUrl: _image.path, catID: id);
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}

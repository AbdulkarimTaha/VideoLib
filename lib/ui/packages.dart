
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:videolib/db/mainDb.dart';
import 'package:videolib/model/tableModel.dart';
import 'package:videolib/ui/addPackage.dart';
import 'addVideoUi.dart';
import 'openPage.dart';

class Tester extends StatefulWidget {
  final int value;
  Tester({this.value});
  @override
  _TesterState createState() => _TesterState(value);
}

class _TesterState extends State<Tester> {
  int value;
  ScrollController _hideButtonController;
  var _isVisible;
  _TesterState(this.value);

  @override
  initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back , color: Colors.black,),
          onPressed:(){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OpenPage()), (route) => false) ;
          },),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: FutureBuilder(
                  future: DBProvider.db.getPackageData("Package", value),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final orientation = MediaQuery.of(context).orientation;
                      return GridView.builder(
                          controller: _hideButtonController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 3
                                          : 4,
                                  childAspectRatio: 5 / 8),
                          itemBuilder: (BuildContext context, int index) {
                            ItemModel item = snapshot.data[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoUi(
                                              id: value,
                                              path: item.path,
                                              name: item.name,
                                              serId: item.id,
                                            )));
                              },
                              child: Card(
                                margin: EdgeInsets.all(5.0),
                                child: GridTile(
                                  footer: Container(
                                      color: Colors.white,
                                      child: Text(item.name,
                                          textAlign: TextAlign.center)),
                                  child: Container(
                                      child: Image.file(File(item.path),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton.extended(
          heroTag: 'btn1',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPackageUi(
                          id: value,
                        )));

            setState(() {});
          },
          label: Text(
            'Add',
            style: TextStyle(color: Colors.blue),
          ),
          icon: Icon(
            Icons.add,
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
        ),
        visible: _isVisible,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

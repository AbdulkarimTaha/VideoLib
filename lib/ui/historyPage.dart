import 'dart:io';


import 'package:flutter/material.dart';

import 'package:videolib/db/mainDb.dart';
import 'package:videolib/model/history.dart';
import 'package:videolib/model/tableModel.dart';

import 'addVideoUi.dart';

class HistoryPage extends StatefulWidget {
  @override
  _TesterState createState() => _TesterState();
}

class _TesterState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: FutureBuilder(
                  future: DBProvider.db.getHistoryData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      final orientation = MediaQuery.of(context).orientation;
                      return GridView.builder(
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
                            HistoryModel item = snapshot.data[index];
                            return FutureBuilder(
                                future: DBProvider.db.getHData(item.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {

                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              int reverseIndex = snapshot.data.length - 1 - index;
                                          ItemModel itemMo =
                                              snapshot.data[reverseIndex];

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoUi(
                                                            id: itemMo
                                                                .categoryID,
                                                            path: itemMo.path,
                                                            name: itemMo.name,
                                                            serId: itemMo.id,
                                                          )));
                                            },
                                            child: Container(
                                                margin: EdgeInsets.all(5.0),
                                                child: Card(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Image.file(
                                                        File(itemMo.path),
                                                        fit: BoxFit.cover,
                                                        height: 150.0,
                                                        width: 100,
                                                      ),
                                                      Text('${itemMo.name}'),
                                                    ],
                                                  ),
                                                )),
                                          );
                                        });
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                });
                          });
                    } else {

                      return Center(
                        child: Text('no recent file'),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
// GestureDetector(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => VideoUi(
// id: itemMo.categoryID,
// path: itemMo.path,
// name: itemMo.name,
// serId: itemMo.id,
// )));
// },
// child: Card(
// margin: EdgeInsets.all(5.0),
// child: GridTile(
// footer: Container(
// color: Colors.white,
// child: Text(itemMo.name,
// textAlign:
// TextAlign.center)),
// child: Container(
//
// height: 150.0,
// child: Image.file(
// File(itemMo.path),
// fit: BoxFit.cover)),
// ),
// ),
// );

//
//
// Image.file(File(itemMo.path), fit: BoxFit.cover, height: 150.0, width: 100,)

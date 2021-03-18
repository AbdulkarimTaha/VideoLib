
import 'package:flutter/material.dart';
import 'package:videolib/extension/Methods.dart';

import 'package:videolib/extension/helper.dart';


import 'package:videolib/ui/packages.dart';
import '../db/mainDb.dart';

import '../model/model.dart';
import 'historyPage.dart';

class OpenPage extends StatefulWidget {
  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  DeviceUtil _deviceUtil;
  bool _isDrawerOpen = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    _deviceUtil = DeviceUtil(context);
    return Stack(
      children: <Widget>[
        _Drawer(),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: _deviceUtil.screenHeight(),
          width: _deviceUtil.screenWidth(),
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(0.0),
          ),
          transform: _isDrawerOpen
              ? Helpers.shadowMatrix4(context)
              : Matrix4.identity(),
        ),
        GestureDetector(
          onTap: () => setState(
                () => _isDrawerOpen = false,
          ),
          child: AnimatedContainer(

            duration: Duration(milliseconds: 500),
            transform: _isDrawerOpen
                ? Helpers.dashboardMatrix4(context)
                : Matrix4.identity(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: AbsorbPointer(
                absorbing: _isDrawerOpen ? true : false,
                child: Scaffold(
                  appBar: _currentIndex == 0
                      ? AppBar(
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: InkWell(
                        onTap: () {
                          setState(
                                () => _isDrawerOpen = true,
                          );
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    title: Text('Recent Movie',style: TextStyle(color: Colors.black),),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    actions: [
                      Padding(
                        padding:
                        EdgeInsets.only(right: 10.0),
                        child: IconButton(color:Colors.black ,icon:Icon(Icons.delete)  , onPressed: (){
                          setState(() {
                            DBProvider.db.deleteTable();
                          });

                        },)
                      ),
                    ],
                    brightness: _isDrawerOpen
                        ? Brightness.dark
                        : Brightness.light,
                  )
                      : null,
                 body: HistoryPage() ,
                ),
              ),
            ),
          ),
        )

      ],

    );
  }
}

class _Drawer extends StatefulWidget {
  @override
  __DrawerState createState() => __DrawerState();
}

class __DrawerState extends State<_Drawer> {

  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btn2',
        onPressed: () {
          displayDialog(context: context , textFieldController: _textFieldController );
          setState(() {});
        },

        label: Text('Add' , style: TextStyle(color: Colors.blue),),
        icon: Icon(Icons.add , color: Colors.blue,),
        backgroundColor: Colors.white ,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Material(
        color: Colors.blue,
        child: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ).add(
              EdgeInsets.only(
                top: 100.0,
              ),
            ),
            children: [
              _DrawerEntry(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerEntry extends StatefulWidget {
  const _DrawerEntry({Key key}) : super(key: key);

  @override
  __DrawerEntryState createState() => __DrawerEntryState();
}

class __DrawerEntryState extends State<_DrawerEntry> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 300.0,
          child: FutureBuilder(
              future: DBProvider.db.getCategoryData('Category'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext c, int index) {
                      CategoryModel item = snapshot.data[index];
                      return ListTile(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Tester(value: item.id))) ;
                        },

                        title: Transform.translate(
                          offset: Offset(20, 0),
                          child: Text(
                            item.name ,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      );
                    },
                    separatorBuilder:  (context, index) {
                      return  Divider(
                        color: Colors.white,
                        height: 15,
                        endIndent: 170,
                        indent: 10,
                      );
                    },
                  );
                } else {
                  return Text('no data yet');
                }
              }),
        ),


      ],
    );

  }
}


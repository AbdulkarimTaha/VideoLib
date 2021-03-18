import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:videolib/db/mainDb.dart';
import 'package:videolib/extension/Methods.dart';
import 'package:videolib/model/history.dart';
import 'package:videolib/model/videoModel.dart';

import '../db/mainDb.dart';
import 'openPage.dart';

class VideoUi extends StatefulWidget {
  final int id;
  final String path;
  final String name;
  final int serId;

  VideoUi({this.id, this.path, this.serId, this.name});
  @override
  _VideoUiState createState() => _VideoUiState(id, path, serId, name);
}

class _VideoUiState extends State<VideoUi> {
  int id;
  int serId;
  String path;
  String name;
  _VideoUiState(this.id, this.path, this.serId, this.name);
  var i;
  File _image;
  File _video;

  final picker = ImagePicker();

  TextEditingController _textFieldController = TextEditingController();

  @override
  initState() {
    super.initState();
    addToHistory();
    _textFieldController.text = name;

  }
  addToHistory(){
   
    DBProvider.db.deleteValue(serId);
    HistoryModel h = HistoryModel(id: serId  );
    DBProvider.db.newValue(model: h , tableName: 'History') ;
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

  Future getVideoGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        addVideo(videoUrl: _video.path, seriesID: serId);
      } else {
        print('No Video selected.');
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        actions: [
          IconButton(icon: Icon(Icons.delete, color: Colors.black,) , onPressed:
          (){
            DBProvider.db.deletePackage(serId);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OpenPage()), (route) => false) ;
          },)
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
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
                ),
                Column(
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
                                width: 100.0,
                                height: 150.0,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              width: 100.0,
                              height: 150.0,
                              child: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child:
                                    Image.file(File(path), fit: BoxFit.cover),
                              ),
                            ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Divider(
                color: Colors.grey,
                height: 1.0,
              ),
            ),
            TextButton(
                onPressed: () {
                  getVideoGallery();
                },
                child: Text(
                  'Add Episode',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            Expanded(
              child: FutureBuilder(
                future: DBProvider.db.getVideoData("Video", serId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext c, int index) {
                        VideoModel item = snapshot.data[index];
                        return ListTile(
                          onTap: () {},
                          leading: IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              openFile(item.path);
                            },
                          ),
                          title: Transform.translate(
                            offset: Offset(20, 0),
                            child: Text(
                              "Episode ${index + 1}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                DBProvider.db.deleteVideo(item.id);
                              });

                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.white,
                          height: 15,
                          endIndent: 170,
                          indent: 10,
                        );
                      },
                    );
                  } else {

                    return Container(
                        child: Text('No Video Yet',
                            style: TextStyle(color: Colors.black)));
                  }
                },
              ),
            ),
            //   Container( child: Text('No Video Yet' , style: TextStyle(color: Colors.black)))
          ],
        ),
      ),
    );
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

  Future<void> openFile(vid) async {
    await OpenFile.open(vid);

  }
}

import 'package:flutter/material.dart';

import 'package:videolib/db/mainDb.dart';
import 'package:videolib/extension/sharedPreferences.dart';
import 'package:videolib/model/model.dart';
import 'package:videolib/model/tableModel.dart';
import 'package:videolib/model/videoModel.dart';





Pref pref = Pref() ;
var generatedCatID;


Future<String>getPrefValue()async{

  var idIsExists = await pref.getValues();
  if(idIsExists == null ){
    await pref.setValue(0);
    return "0" ;
  }else{
    return idIsExists ;
  }
}



addCategory({text}) async {
    var intValue = int.parse(await getPrefValue());
    CategoryModel data = CategoryModel(id: intValue, name: text );
    DBProvider.db.newValue(model: data , tableName: 'Category');
    await pref.setValue(intValue +1 );

}
addPackage({text , imageUrl , catID}) async {
  var intValue = int.parse(await getPrefValue());
  ItemModel data = ItemModel(id: intValue, name: text , path: imageUrl , categoryID: catID);
  DBProvider.db.newValue(model: data , tableName: 'Package');
  await pref.setValue(intValue +1 );

}
addVideo({videoUrl,seriesID }) async {
  var intValue = int.parse(await getPrefValue());
  VideoModel data = VideoModel(id: intValue ,path: videoUrl , seriesID: seriesID );
  DBProvider.db.newValue(model: data , tableName: 'Video');
  await pref.setValue(intValue +1 );

}

displayDialog({ context, textFieldController }) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Category Name'),
          content: TextField(
            controller: textFieldController,
            textInputAction: TextInputAction.go,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "Enter Category"),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text('Ok'),
              onPressed: () {
                if(textFieldController.text == null || textFieldController.text == ''){
                  print('wrong');
                }else{
                  addCategory( text:  textFieldController.text);
                  Navigator.of(context).pop();
                  textFieldController.clear();
                }

              },
            )
          ],
        );
      });
}


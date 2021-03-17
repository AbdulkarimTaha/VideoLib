class ItemModel {
  final int id;
  final String path;
  final String name;
  final int categoryID;
  ItemModel({this.id, this.path, this.name,this.categoryID});

  Map<String, dynamic> toMap() => {
    'id': id,
    'path': path,
    'name' : name ,
    'categoryID' : categoryID ,
  };
  factory ItemModel.fromMap(Map<String, dynamic> data) => ItemModel(
    id: data['id'],
    path: data['path'],
    name: data['name'],
    categoryID: data['categoryID'],
  );
}
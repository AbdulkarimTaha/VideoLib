class CategoryModel {
  final int id;
  final String name;

  CategoryModel({this.id, this.name});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,

  };
  factory CategoryModel.fromMap(Map<String, dynamic> data) => CategoryModel(
    id: data['id'],
    name: data['name'],

  );
}
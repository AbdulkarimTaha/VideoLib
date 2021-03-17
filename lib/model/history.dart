class HistoryModel {
  final int id;


  HistoryModel({this.id});



  Map<String, dynamic> toMap() => {
    'id': id,


  };
  factory HistoryModel.fromMap(Map<String, dynamic> data) => HistoryModel(
    id: data['id'],


  );
}
class VideoModel {
  final int id;
  final String path;
  final int seriesID;
  VideoModel({this.id, this.path, this.seriesID});

  Map<String, dynamic> toMap() => {
    'id': id,
    'path': path,

    'seriesID' : seriesID ,

  };
  factory VideoModel.fromMap(Map<String, dynamic> data) => VideoModel(
    id: data['id'],
    path: data['path'],
    seriesID: data['seriesID'],
  );
}
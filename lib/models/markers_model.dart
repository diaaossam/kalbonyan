class MarkerModel {
  String? id;
  String? userId;
  String? title;
  dynamic lat;
  dynamic lon;

  MarkerModel({
    required this.id,
    required this.title,
    required this.lat,
    required this.lon,
    required this.userId,
  });

  MarkerModel.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    title = map["title"];
    userId = map["userId"];
    lat = map['lat'];
    lon = map['lon'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "userId": userId,
      "lat":lat,
      "lon":lon,
    };
  }
}

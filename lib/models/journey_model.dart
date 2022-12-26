class JourneyModel {

  String? id;
  String? userId;
  String? title;
  bool ? isDone;


  JourneyModel({
    required this.id,
    required this.userId,
    required this.title,
    this.isDone = false,

  });

  JourneyModel.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    userId = map["userId"];
    title = map["title"];
    isDone = map["isDone"];

  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "isDone": isDone,

    };
  }
}

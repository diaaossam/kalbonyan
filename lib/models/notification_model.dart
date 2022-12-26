import 'package:kalbonyan/shared/helper/mangers/constants.dart';

class NotificationModel {
  String? id;
  String? title;
  String? body;
  String? date;
  String? time;
  List<String>  seenList=[];

  NotificationModel({
      this.id = ConstantsManger.DEFULT,
      required this.title,
      required this.body,
      required this.date,
      required this.time,
      this.seenList =const[ConstantsManger.DEFULT],
      });

  NotificationModel.fromJson({required Map<String, dynamic> json}) {
    id = json["id"];
    title = json["title"];
    body = json["body"];
    date = json["date"];
    time = json["time"];
    if(json["seenList"] !=null){
      seenList.clear();
      json["seenList"].forEach((element){
        seenList.add(element);
      });
    }
  }

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "title":title,
      "body":body,
      "date":date,
      "time":time,
      "seenList":seenList,

    };
  }
}

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {

  String? userId;
  String? name;
  String? id;
  String? phone;
  String? joinNumber;
  String? companyName;
  String? permitNumber;
  bool? isAdmin;
  String? token;
  dynamic lat;
  dynamic lon;

  UserModel({required this.userId,
    required this.name,
    required this.id,
    required this.phone,
    required this.joinNumber,
    required this.companyName,
    required this.permitNumber,
    required this.token,
    this.lat = 0.0,
    this.lon = 0.0,
    required this.isAdmin});




  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    id = json['id'];
    token = json["token"];
    phone = json['phone'];
    joinNumber = json['joinNumber'];
    companyName = json['companyName'];
    permitNumber = json['permitNumber'];
    isAdmin = json['isAdmin'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "name": name,
      "id": id,
      "phone": phone,
      "joinNumber": joinNumber,
      "companyName": companyName,
      "permitNumber": permitNumber,
      "isAdmin": isAdmin,
      "token": token,
      "lat": lat,
      "lon": lon,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [lon,lat,token,isAdmin,permitNumber,companyName,joinNumber,phone,id,name,userId];
}

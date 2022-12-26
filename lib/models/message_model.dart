class MessageModel {
  String? sender;
  String? receiver;
  String? message;
  String? time;



  MessageModel({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.time,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    receiver = json['receiver'];
    message = json['message'];
    time = json['time'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'time': time,
    };
  }
}

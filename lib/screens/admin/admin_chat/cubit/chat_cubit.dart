import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kalbonyan/models/message_model.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context)=>BlocProvider.of(context);

  void sendMessage({
    required String receiver,
    required String message,
  }) {
    MessageModel messageModel = MessageModel(
        sender: getCurrentUserUid(),
        receiver: receiver,
        time: '${DateFormat.jms().format(DateTime.now())}',
        message: message);

    //send Message
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(getCurrentUserUid())
        .collection(ConstantsManger.CHATS)
        .doc(receiver)
        .collection(ConstantsManger.CHATS)
        .add(messageModel.toMap());

    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(receiver)
        .collection(ConstantsManger.CHATS)
        .doc(getCurrentUserUid())
        .collection(ConstantsManger.CHATS)
        .add(messageModel.toMap());

    DocumentReference doc2 = FirebaseFirestore.instance
        .collection(ConstantsManger.CHATLIST)
        .doc(ConstantsManger.CHATLIST)
        .collection("${receiver}")
        .doc(getCurrentUserUid());
    doc2.get().then((value) {
      if (!value.exists) {
        doc2.set({"id": getCurrentUserUid()});
      }
    });
  }

  String formatTime({required String time}) {
    List list = time.split(':');
    String ma = time.substring(time.length - 2, time.length);
    String messageTime = '${list[0]}:${list[1]} $ma';

    return messageTime;
  }

  List<MessageModel> userMessageList = [];

  void readMessages({required String receverId }) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(ConstantsManger.CHATS)
        .doc(receverId)
        .collection(ConstantsManger.CHATS)
        .orderBy('time')
        .snapshots()
        .listen((event) {
      userMessageList.clear();
      event.docs.forEach((element) {
        print("message");
        userMessageList.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }

  String? getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}

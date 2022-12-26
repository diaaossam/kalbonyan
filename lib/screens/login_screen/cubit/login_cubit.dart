import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  void checkIsInfoCorrect({required String phone , required String id}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .where("phone", isEqualTo: phone)
        .get()
        .then((value) {
          UserModel userModel = UserModel.fromJson(value.docs.first.data());
          if(userModel.id == id){
            emit(SuccessIdState());
          }else{
            emit(FailureIdState());
          }
    });
  }

  var pageController = PageController(initialPage: 0);

  int groupValue = -1;

  void changeRadioButtonState({required int value}) {
    this.groupValue = value;
    emit(ChangeGroupValueState());
  }

  Future<void> submitPhoneNumber(String phone) async {
    emit(LoadingPhoneState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+20$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error) {
    print('verificationFailed : ${error.toString()}');
    emit(ErrorOccurred(error.toString()));
  }

  String? verificationId;

  void codeSent(String verifyId, int? resendToken) {
    this.verificationId = verifyId;
    emit(PhoneNumberSubmited());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOTP(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId!, smsCode: otpCode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential).then((cred) {
       emit(SuccessVerfingState());
      });
    } catch (error) {
      emit(ErrorOccurred(error.toString()));
    }
  }
}

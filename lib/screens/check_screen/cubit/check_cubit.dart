import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:meta/meta.dart';

part 'check_state.dart';

class CheckCubit extends Cubit<CheckState> {
  CheckCubit() : super(CheckInitial());

  static CheckCubit get(context)=>BlocProvider.of(context);

  void checkPhoneInFireStore({required String phone}) {
    emit(LoadingCheckPhoneState());
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .where("phone", isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        emit(UserNotExistsState());
      } else {
        emit(UserExistsState());
      }
    });
  }
}

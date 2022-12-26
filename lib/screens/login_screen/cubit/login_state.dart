part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class ChangeGroupValueState extends LoginState {}
class LoadingPhoneState extends LoginState {}
class PhoneNumberSubmited extends LoginState {}
class ErrorOccurred extends LoginState {
  String errogMsg;

  ErrorOccurred(this.errogMsg);
}

class SuccessVerfingState extends LoginState {}
class FailureVerfingState extends LoginState {}
class SuccessIdState extends LoginState {}
class FailureIdState extends LoginState {}



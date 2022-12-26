part of 'check_cubit.dart';

@immutable
abstract class CheckState {}

class CheckInitial extends CheckState {}
class UserNotExistsState extends CheckState {}
class UserExistsState extends CheckState {}
class LoadingCheckPhoneState extends CheckState {}

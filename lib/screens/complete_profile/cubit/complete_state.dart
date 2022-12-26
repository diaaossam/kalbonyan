part of 'complete_cubit.dart';

@immutable
abstract class CompleteState {}

class CompleteInitial extends CompleteState {}
class ChooseCompanyState extends CompleteState {}


class GetUserInfoLoading extends CompleteState {}
class GetUserInfoSuccess extends CompleteState {}
class GetUserInfoFailure extends CompleteState {}
class SuccessRequestPermmsion extends CompleteState {}

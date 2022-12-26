part of 'main_cubit.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}
class ChangeBottomNavBarIndexState extends MainState {}
class GetMessageSuccessState extends MainState {}
class InitAppState extends MainState {}
class SetUpLocationState extends MainState {}


class GetMainUserInfoSuccess extends MainState {}
class GetMainUserInfoFailure extends MainState {}
class GetMainUserInfoLoading extends MainState {}
class DeleteAccountSuccess extends MainState {}
class ChooseCompanyMainState extends MainState {}

class UpdateUserDataSuccess extends MainState {}

class GetAllNotificationLoading extends MainState {}
class GetAllNotificationSuccess extends MainState {}


class GetUserLocationSuccess extends MainState {}
class MapControllerSuccess extends MainState {}

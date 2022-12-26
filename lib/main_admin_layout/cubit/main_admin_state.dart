part of 'main_admin_cubit.dart';

@immutable
abstract class MainAdminState {}

class MainAdminInitial extends MainAdminState {}
class ChangeBottomNavBarIndexState extends MainAdminState {}
class InitAppState extends MainAdminState {}
class SetUpLocationState extends MainAdminState {}


class GetMainUserInfoLoading extends MainAdminState {}
class GetMainUserInfoSuccess extends MainAdminState {}
class ChooseCompanyMainState extends MainAdminState {}
class DeleteAccountSuccess extends MainAdminState {}
class UpdateUserDataSuccess extends MainAdminState {}
class AddMarkers extends MainAdminState {}
class TapMarkerState extends MainAdminState {
  final String title;

  TapMarkerState({required this.title});

}


class GetAllUsersLoading extends MainAdminState {}
class GetAllUsersSuccess extends MainAdminState {}

class GetAllNotificationLoading extends MainAdminState {}
class GetAllNotificationSuccess extends MainAdminState {}
class SendNotificationSuccess extends MainAdminState {}


class SetUpHomeState extends MainAdminState {}

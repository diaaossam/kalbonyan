part of 'picker_cubit.dart';

@immutable
abstract class PickerState {}

class PickerInitial extends PickerState {}
class InitAppState extends PickerState {}
class SetUpLocationState extends PickerState {}
class AddMarkerSuccess extends PickerState {
  bool isDone;
  AddMarkerSuccess(this.isDone);
}
class AddMarkerFailure extends PickerState {}

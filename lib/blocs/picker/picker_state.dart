part of 'picker_bloc.dart';

abstract class PickerState {
  String thumpnailFilePath;
  String videoFilePath;
  String type;
  String title;

  PickerState({required this.thumpnailFilePath, required this.videoFilePath, required this.type, required this.title});
}

class PickerInitial extends PickerState {
  PickerInitial({required String thumpnailFilePath, required String videoFilePath, required String type, required String title}) : super(thumpnailFilePath: thumpnailFilePath, videoFilePath: videoFilePath, type: type, title: title);
}

class PickerStateUpdate extends PickerState {
  PickerStateUpdate({required String thumpnailFilePath, required String videoFilePath, required String type, required String title}) : super(thumpnailFilePath: thumpnailFilePath, videoFilePath: videoFilePath, type: type, title: title);
}

class PickerLoading extends PickerState {
  PickerLoading() : super(thumpnailFilePath: '', videoFilePath: '', type: '', title: '');
}
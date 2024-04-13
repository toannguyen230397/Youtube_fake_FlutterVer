part of 'picker_bloc.dart';

abstract class PickerEvent {}

class PickThumpnail extends PickerEvent {}

class PickVideo extends PickerEvent {}

class PickType extends PickerEvent {
  final String type;

  PickType({required this.type});
}

class PickTitle extends PickerEvent {
  final String title;

  PickTitle({required this.title});
}

class PickDefaultThumpnail extends PickerEvent {
  File video;

  PickDefaultThumpnail({required this.video});
}

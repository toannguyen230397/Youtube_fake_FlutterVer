part of 'button_press_bloc.dart';

abstract class ButtonPressEvent {}

class onPress extends ButtonPressEvent {
  final String buttonTile;

  onPress({required this.buttonTile});
}
part of 'button_press_bloc.dart';

abstract class ButtonPressState {
  String buttonTile;
  ButtonPressState({required this.buttonTile});
}

class ButtonPressInitial extends ButtonPressState {
  ButtonPressInitial({required String buttonTile}) : super(buttonTile: buttonTile);
}

class ButtonPressUpdate extends ButtonPressState {
  ButtonPressUpdate({required String buttonTile}) : super(buttonTile: buttonTile);
}
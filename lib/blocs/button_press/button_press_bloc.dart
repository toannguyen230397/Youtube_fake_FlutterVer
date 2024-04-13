import 'package:flutter_bloc/flutter_bloc.dart';
part 'button_press_event.dart';
part 'button_press_state.dart';

class ButtonPressBloc extends Bloc<ButtonPressEvent, ButtonPressState> {
  ButtonPressBloc() : super(ButtonPressInitial(buttonTile: '')) {
    on<onPress>(_onPress);
  }

  void _onPress(onPress event, Emitter<ButtonPressState> emit) async {
    state.buttonTile = event.buttonTile;
    emit(ButtonPressUpdate(buttonTile: state.buttonTile));
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_fake/api/api_helper.dart';
part 'login_register_state.dart';
part 'login_register_event.dart';

class LoginRegisterBloc extends Bloc<LoginRegisterEvent, LoginRegisterState> {
  LoginRegisterBloc() : super(LoginRegisterInitial()) {
    on<Register>(_Register);
    on<Login>(_Login);
    on<Logout>(_Logout);
    on<ClearMessege>(_ClearMessege);
  }
  
  void _Register(Register event, Emitter<LoginRegisterState> emit) async {
    emit(LoadingState());
    final reponse = await ApiHelper().userRegister(event.username, event.password);
    if(reponse == 'success') {
      String token = event.username;
      emit(TokenStateUpdate(token: token));
    } else {
      emit(LoginRegisterAlertMessege(alertMessege: reponse));
    }
  }

  void _Login(Login event, Emitter<LoginRegisterState> emit) async {
    emit(LoadingState());
    final reponse = await ApiHelper().userLogin(event.username, event.password);
    if(reponse == 'success') {
      String token = event.username;
      emit(TokenStateUpdate(token: token));
    } else {
      emit(LoginRegisterAlertMessege(alertMessege: reponse));
    }
  }

  void _Logout(Logout event, Emitter<LoginRegisterState> emit) async {
    String token = '';
    emit(TokenStateUpdate(token: token));
  }

  void _ClearMessege(ClearMessege event, Emitter<LoginRegisterState> emit) async {
    emit(LoginRegisterAlertMessege(alertMessege: ''));
  }
}
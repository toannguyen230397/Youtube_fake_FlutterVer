part of 'login_register_bloc.dart';
abstract class LoginRegisterState {
  String token;
  String alertMessege;
  LoginRegisterState({required this.token, required this.alertMessege});
}

class LoginRegisterInitial extends LoginRegisterState {
  LoginRegisterInitial() : super(token: '', alertMessege: '');
}

class TokenStateUpdate extends LoginRegisterState {
  TokenStateUpdate({required token}) : super(token: token, alertMessege: '');
}

class LoginRegisterAlertMessege extends LoginRegisterState {
  LoginRegisterAlertMessege({required alertMessege}) : super(token: '', alertMessege: alertMessege);
}

class LoadingState extends LoginRegisterState {
  LoadingState() : super(token: '', alertMessege: '');
}
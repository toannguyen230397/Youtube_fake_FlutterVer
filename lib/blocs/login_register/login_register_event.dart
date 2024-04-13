part of 'login_register_bloc.dart';
abstract class LoginRegisterEvent{}

class Register extends LoginRegisterEvent {
  String username;
  String password;
  Register({required this.username, required this.password});
}

class Login extends LoginRegisterEvent {
  String username;
  String password;
  Login({required this.username, required this.password});
}

class Logout extends LoginRegisterEvent {}

class ClearMessege extends LoginRegisterEvent {}
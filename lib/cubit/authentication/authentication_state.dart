part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class UnauthenticationState extends AuthenticationState {}

class AuthenticatingState extends AuthenticationState {
  bool loading;

  AuthenticatingState({this.loading = false});
}

class WaitSMSState extends AuthenticatingState {
  String verificationId;
  int? resendToken;

  WaitSMSState(
      {required this.verificationId,
      required this.resendToken,
      bool loading = false})
      : super(loading: loading);
}

class ErrorSMSState extends AuthenticatingState {
  String verificationId;
  int? resendToken;
  String message;
  String timestamp;

  ErrorSMSState(
      {required this.timestamp,
      required this.verificationId,
      this.resendToken,
      required this.message,
      bool loading = false})
      : super(loading: loading);
}

class AuthenticatedState extends AuthenticationState {}

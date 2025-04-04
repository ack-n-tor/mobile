part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable{

  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChange extends LoginEvent{

   final String email;

   const LoginEmailChange({required this.email});

   @override
   List<Object?> get props => [email];
}

class LoginPasswordChange extends LoginEvent{

  final String password;

  const LoginPasswordChange({required this.password});

  @override
  List<Object?> get props => [password];
}

class OnObscureEvent extends LoginEvent{
  const OnObscureEvent();
}

class LoginSubmit extends LoginEvent{
  const LoginSubmit();
}
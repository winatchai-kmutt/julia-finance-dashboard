/* 

Auth States

*/

import 'package:financial_dashboard/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

// initial
class AuthInitial extends AuthState {}

// loading
class AuthLoading extends AuthState {}

// authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated({required this.user});
}

// unauthenticated
class Unauthenticated extends AuthState {}

// error
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String token;
  final String username;

  const LoggedIn({required this.token, required this.username});

  @override
  List<Object> get props => [token, username];

  @override
  String toString() => 'LoggedIn { token: $token, username: $username }';
}

class LoggedOut extends AuthEvent {}

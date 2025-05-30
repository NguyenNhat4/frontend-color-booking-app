import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;

  const AuthAuthenticated({required this.username});

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'AuthAuthenticated { username: $username }';
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AuthFailure { message: $message }';
}

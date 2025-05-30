import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/auth/bloc/auth_event.dart';
import 'package:mobile/auth/bloc/auth_state.dart';
import 'package:mobile/auth/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final bool hasToken = await authRepository.hasToken();
    if (hasToken) {
      final username = await authRepository.getUsername();
      emit(AuthAuthenticated(username: username ?? 'User'));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.persistToken(event.token);
    await authRepository.persistUsername(event.username);
    emit(AuthAuthenticated(username: event.username));
  }

  Future<void> _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.deleteToken();
    await authRepository.deleteUsername();
    emit(AuthUnauthenticated());
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poke_app/logic/models/user.dart';
import 'package:poke_app/logic/repositories/auth/iauth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  late final StreamSubscription _authSub;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    _authSub = authRepository.authStateChanges().listen((rawUser) {
      if (rawUser == null) {
        add(AuthLoggedOut());
      } else {
        add(AuthLoggedIn(user: User.fromRaw(rawUser)));
      }
    });

    on<AuthSignInRequested>(_onSignRequested);
    on<AuthLoggedIn>(_onSignInCompleted);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  void _onSignRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWith(event.email, event.password);
    } catch (e, st) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignInCompleted(AuthLoggedIn event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(user: event.user));
  }

  void _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  @override
  Future<void> close() {
    _authSub.cancel();
    return super.close();
  }
}

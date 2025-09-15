import 'dart:async';
import 'package:flutter/material.dart';
import 'package:poke_app/logic/cubit/bloc/auth/auth_bloc.dart';
import 'package:poke_app/logic/cubit/profile/bloc/profile_bloc.dart';

class BlocRouterNotifier extends ChangeNotifier {
  final AuthBloc authBloc;
  final ProfileBloc profileBloc;
  late final StreamSubscription _authSubscription;
  late final StreamSubscription _profileSubscription;

  BlocRouterNotifier(this.authBloc, this.profileBloc) {
    _authSubscription = authBloc.stream.listen((_) {
      notifyListeners();
    });
    _profileSubscription = profileBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _profileSubscription.cancel();
    super.dispose();
  }
}
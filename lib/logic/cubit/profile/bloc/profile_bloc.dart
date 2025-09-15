import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:poke_app/logic/repositories/profile/iprofile_repository.dart';
import 'package:poke_app/user/model/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository _profileRepository;

  ProfileBloc({required IProfileRepository profileRepository}) 
      : _profileRepository = profileRepository, 
        super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getProfile(event.uid);

      if (profile == null) {
        emit(ProfileNotCompleted());
      } else {
        emit(ProfileLoaded(profile: Profile.fromJson(profile)));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
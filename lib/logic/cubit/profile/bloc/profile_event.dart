part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String uid;

  const ProfileLoadRequested({required this.uid});

  @override
  List<Object> get props => [uid];
}
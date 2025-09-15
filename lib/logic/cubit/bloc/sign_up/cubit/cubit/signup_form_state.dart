part of 'signup_form_cubit.dart';

 class SignupFormState extends Equatable {
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  SignupFormState({
    Email? email,
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  }) : email = email ?? Email.pure();

  bool get isValid => Formz.validate([email, password]);

  SignupFormState withEmail(String email) {
    return copyWith(email: Email.dirty(email));
  }

  SignupFormState withPassword(String password) {
    return copyWith(password: Password.dirty(password));
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  SignupFormState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return SignupFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

final class SignupFormInitial extends SignupFormState {}

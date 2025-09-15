part of 'signin_form_cubit.dart';

class SignInFormState extends Equatable {
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  SignInFormState({
    Email? email,
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  }) : email = email ?? Email.pure();

  bool get isValid => Formz.validate([email, password]);

  SignInFormState withEmail(String email) {
    return copyWith(email: Email.dirty(email));
  }

  SignInFormState withPassword(String password) {
    return copyWith(password: Password.dirty(password));
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  SignInFormState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return SignInFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

final class SignInFormInitial extends SignInFormState {}

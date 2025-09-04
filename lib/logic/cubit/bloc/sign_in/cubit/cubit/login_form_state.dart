// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_form_cubit.dart';

class LoginFormState extends Equatable {
  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  LoginFormState({
    Email? email,
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  }) : email = email ?? Email.pure();

  bool get isValid => Formz.validate([email, password]);

  LoginFormState withEmail(String email) {
    return copyWith(email: Email.dirty(email));
  }

  LoginFormState withPassword(String password) {
    return copyWith(password: Password.dirty(password));
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];

  LoginFormState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}

final class LoginFormInitial extends LoginFormState {}

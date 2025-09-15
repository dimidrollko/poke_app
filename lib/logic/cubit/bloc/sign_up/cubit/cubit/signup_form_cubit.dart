import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:poke_app/logic/formz/email_form.dart';
import 'package:poke_app/logic/formz/password_form.dart';

part 'signup_form_state.dart';

class SignupFormCubit extends Cubit<SignupFormState> {
  SignupFormCubit() : super(SignupFormInitial());

  void emailChanged(String email) => emit(state.withEmail(email));
  void passwordChanged(String password) => emit(state.withPassword(password));
}

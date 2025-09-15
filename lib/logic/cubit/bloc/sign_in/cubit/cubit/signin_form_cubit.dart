import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:poke_app/logic/formz/email_form.dart';
import 'package:poke_app/logic/formz/password_form.dart';

part 'signin_form_state.dart';

class SignInFormCubit extends Cubit<SignInFormState> {
  SignInFormCubit() : super(SignInFormInitial());

  void emailChanged(String email) => emit(state.withEmail(email));
  void passwordChanged(String password) => emit(state.withPassword(password));
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:poke_app/logic/formz/email_form.dart';
import 'package:poke_app/logic/formz/password_form.dart';

part 'login_form_state.dart';

class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(LoginFormInitial());

  void emailChanged(String email) => emit(state.withEmail(email));
  void passwordChanged(String password) => emit(state.withPassword(password));
  
}

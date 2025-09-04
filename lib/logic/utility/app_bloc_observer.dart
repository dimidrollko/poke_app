import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    print('Change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    print('Create: $bloc'); 
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    print('Close: $bloc');
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    print('Event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Transition: $transition');
    super.onTransition(bloc, transition);
  }
}

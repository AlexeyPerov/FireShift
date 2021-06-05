import 'package:bloc/bloc.dart';
import 'package:fireshift/shift/app/app.dart';

class LoggableBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    logger.i(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.i(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('error', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}

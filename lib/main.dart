import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'bloc/app/app.dart';
import 'bloc/authentication/authentication_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  build();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US')],
      path: GameConstants.LANGS_PATH,
      child: BlocProvider(
        create: (BuildContext context) {
          return AuthenticationBloc()..add(AppStarted());
        },
        child: App(),
      ),
    ),
  );
}

import 'package:GM_Nav/screen/main/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:GM_Nav/bloc/app/routes.dart';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/bloc/login/login_bloc.dart';
import 'package:GM_Nav/bloc/theme/theme_bloc.dart';
import 'package:GM_Nav/screen/login/login_screen.dart';
import 'package:GM_Nav/screen/splash/splash_screen.dart';
import 'package:GM_Nav/theme/style.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ThemeBloc()..add(StartedThem()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildAppWithThem,
      ),
    );
  }

  Widget _buildAppWithThem(BuildContext context, ThemeState state) {
    return MaterialApp(
      darkTheme: appThemeData[AppTheme.Light],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      debugShowCheckedModeBanner: false,
      title: "GM-Nav",
      theme: (state as ThemeInitial).themeData,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationUninitialized) {
            return SplashScreen();
          }
          if (state is AuthenticationAuthenticated) {
            return MainScreen();
          }
          if (state is AuthenticationUnauthenticated) {
            return BlocProvider(
              create: (context) {
                return LoginBloc(
                  authenticationBloc:
                      BlocProvider.of<AuthenticationBloc>(context),
                );
              },
              child: LoginScreen(),
            );
          }
          if (state is AuthenticationLoading) {
            return CircularProgressIndicator();
          }
          return SplashScreen();
        },
      ),
      routes: routes,
    );
  }
}

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ThemeUninitial extends ThemeState {}

class ThemeInitial extends ThemeState {
  final ThemeData themeData;
  final bool isDark;
  ThemeInitial({@required this.themeData, @required this.isDark});

  @override
  List<Object> get props => [
        themeData,
        isDark,
      ];
}

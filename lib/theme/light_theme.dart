import 'package:flutter/material.dart';
import 'package:lab40/theme/colors.dart';

final lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.green.shade200);
final lightCustomColors = CustomColor(
  cardTextColor: Colors.white,
  cardBackgroundColor: Colors.green.shade400,
  screenBackgroundColor: Colors.grey.shade100,
);
final lightTheme = ThemeData.light().copyWith(
  colorScheme: lightColorScheme,
  extensions: [lightCustomColors],
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: lightColorScheme.primaryContainer,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.onSecondary,
    ),
  ),
);

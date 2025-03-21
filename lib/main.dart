import 'package:flutter/material.dart';
import 'package:lab40/theme/light_theme.dart';

import 'chat_app.dart';

void main() {
  runApp(
    MaterialApp(
      themeMode: ThemeMode.system,
      theme: lightTheme,
      home: ChatApp(),
    ),
  );
}

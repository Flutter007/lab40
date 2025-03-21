import 'package:flutter/material.dart';

class CustomColor extends ThemeExtension<CustomColor> {
  final Color cardTextColor;
  final Color cardBackgroundColor;
  final Color screenBackgroundColor;

  CustomColor({
    required this.cardTextColor,
    required this.cardBackgroundColor,
    required this.screenBackgroundColor,
  });

  @override
  ThemeExtension<CustomColor> copyWith({
    Color? cardTextColor,
    Color? cardBackgroundColor,
    Color? screenBackgroundColor,
  }) {
    return CustomColor(
      cardTextColor: cardTextColor ?? this.cardTextColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      screenBackgroundColor:
          screenBackgroundColor ?? this.screenBackgroundColor,
    );
  }

  @override
  ThemeExtension<CustomColor> lerp(
    covariant ThemeExtension<CustomColor>? other,
    double t,
  ) {
    if (other is! CustomColor) return this;
    return CustomColor(
      cardTextColor: Color.lerp(cardTextColor, other.cardTextColor, t)!,
      cardBackgroundColor:
          Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t)!,
      screenBackgroundColor:
          Color.lerp(screenBackgroundColor, other.screenBackgroundColor, t)!,
    );
  }
}

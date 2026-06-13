import 'package:flutter/material.dart';
import '../app_colors.dart';

class Latte implements AppColors {
  @override Color get primary    => const Color(0xFF8839ef);
  @override Color get secondary  => const Color(0xFF1e66f5);
  @override Color get surface    => const Color(0xFFccd0da);
  @override Color get background => const Color(0xFFeff1f5);
  @override Color get error      => const Color(0xFFd20f39);
  @override Color get text       => const Color(0xFF4c4f69);
  @override bool  get isDark     => false;
}

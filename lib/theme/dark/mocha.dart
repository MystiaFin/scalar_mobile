import 'package:flutter/material.dart';
import '../app_colors.dart';

class Mocha implements AppColors {
  @override Color get primary    => const Color(0xFFcba6f7);
  @override Color get secondary  => const Color(0xFF89b4fa);
  @override Color get surface    => const Color(0xFF313244);
  @override Color get background => const Color(0xFF1e1e2e);
  @override Color get error      => const Color(0xFFf38ba8);
  @override Color get text       => const Color(0xFFcdd6f4);
  @override bool  get isDark     => true;
}

import 'package:flutter/material.dart';

// Owned by ShellPage — controls which tab is active
final tabNotifier = ValueNotifier<int>(0);

// Shared between HomePage and ChartPage
final categoryFilterNotifier = ValueNotifier<Set<String>>({});

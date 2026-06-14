import 'package:flutter/material.dart';
import '../theme/theme_notifier.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(context, 'Color Scheme'),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: 'catppuccin',
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: const [
            DropdownMenuItem(value: 'catppuccin', child: Text('Catppuccin')),
          ],
          onChanged: (_) {}, // no-op until more themes are added
        ),
      ],
    );
  }

  Widget _buildModeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(context, 'Mode'),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, mode, _) {
            final isDark = mode == ThemeMode.dark;
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              ),
              title: const Text('Dark mode'),
              subtitle: Text(isDark ? 'Mocha' : 'Latte'),
              value: isDark,
              onChanged: (_) => toggleTheme(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Themes')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildThemeSection(context),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          _buildModeSection(context),
        ],
      ),
    );
  }
}

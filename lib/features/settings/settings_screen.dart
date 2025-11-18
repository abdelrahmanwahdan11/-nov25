import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  final LocaleController localeController;
  final ThemeController themeController;
  const SettingsScreen({super.key, required this.localeController, required this.themeController});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(title: Text(t('settings'))),
      body: ListView(
        children: [
          ListTile(
            title: Text(t('language')),
            trailing: DropdownButton<Locale>(
              value: localeController.locale,
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
              ],
              onChanged: (v) {
                if (v != null) localeController.setLocale(v);
              },
            ),
          ),
          SwitchListTile(
            value: themeController.themeMode == ThemeMode.dark,
            title: Text(t('dark_mode')),
            onChanged: (_) => themeController.toggleThemeMode(),
          ),
          ListTile(
            title: Text(t('primary_color')),
            subtitle: Row(
              children: [
                _colorDot(context, const Color(0xFFF2C3A5)),
                _colorDot(context, Colors.blue),
                _colorDot(context, Colors.green),
                _colorDot(context, Colors.purple),
              ],
            ),
          ),
          const ListTile(
            title: Text('Units'),
            subtitle: Text('kg'),
          ),
          const ListTile(
            title: Text('About'),
            subtitle: Text('PawAdopt soft UI demo'),
          ),
        ],
      ),
    );
  }

  Widget _colorDot(BuildContext context, Color color) {
    return GestureDetector(
      onTap: () => themeController.setPrimaryColor(color),
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.only(right: 8, top: 8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: themeController.primaryColor == color ? Theme.of(context).colorScheme.onBackground : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

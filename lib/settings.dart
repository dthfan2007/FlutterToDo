/// settings.dart
///
/// Author: Matteo Cipriani
/// Created: 2025-02-18
/// Description: This file is the settings tab for the Flutter application.
/// It contains the settings for Theme and Language
///
/// Version: Beta 2.5.2
/// Latest Change: Added more locales

//# region [Section 1] Imports
// MARK: Imports
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_todo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

//# endregion
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _selectedThemeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  //# region [Section 2] Setup
  // MARK: Setup
  // Return saved theme mode
  ThemeMode _getThemeModeFromString(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode') ??
        'system'; // Load previously saved theme mode, return system in case it returns 'null'
    setState(() {
      _selectedThemeMode = _getThemeModeFromString(savedThemeMode);
    });
  }

  void _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }

  //# endregion
  //# region [Section 3] Build Widget
  // MARK: Build Widget
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Title bar
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //# region [Section 4] Theme Setting
          // MARK: Theme Setting
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(
              l10n.theme,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.selectTheme),
                DropdownButtonFormField<ThemeMode>(
                  value: _selectedThemeMode,
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedThemeMode = newValue;
                      });
                      _saveThemeMode(newValue);
                      TodoApp.of(context).changeTheme(newValue);
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n.lightMode),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n.darkMode),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n.systemDefault),
                    ),
                  ],
                  iconSize: 30,
                  iconEnabledColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.tealAccent
                          : Colors.blue,
                  iconDisabledColor: Colors.grey,
                ),
              ],
            ),
          ),
          //# endregion
          //# region [Section 5] Language Setting
          // MARK: Language Setting
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              l10n.language,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.selectLanguage),
                DropdownButtonFormField<Locale>(
                  value: Localizations.localeOf(context),
                  onChanged: (Locale? newValue) {
                    if (newValue != null) {
                      TodoApp.of(context).changeLocale(newValue);
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  ),
                  // Dropdown menu for all supported locales
                  items: const [
                    DropdownMenuItem(
                      value: Locale('cs'),
                      child: Text('Čeština'),
                    ),
                    DropdownMenuItem(
                      value: Locale('da'),
                      child: Text('Dansk'),
                    ),
                    DropdownMenuItem(
                      value: Locale('de'),
                      child: Text('Deutsch'),
                    ),
                    DropdownMenuItem(
                      value: Locale('et'),
                      child: Text('Eesti'),
                    ),
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('es'),
                      child: Text('Español'),
                    ),
                    DropdownMenuItem(
                      value: Locale('fil'),
                      child: Text('Filipino'),
                    ),
                    DropdownMenuItem(
                      value: Locale('hr'),
                      child: Text('Hrvatski'),
                    ),
                    DropdownMenuItem(
                      value: Locale('hu'),
                      child: Text('Magyar'),
                    ),
                    DropdownMenuItem(
                      value: Locale('id'),
                      child: Text('Indonesia'),
                    ),
                    DropdownMenuItem(
                      value: Locale('is'),
                      child: Text('Íslenska'),
                    ),
                    DropdownMenuItem(
                      value: Locale('it'),
                      child: Text('Italiano'),
                    ),
                    DropdownMenuItem(
                      value: Locale('lv'),
                      child: Text('Latviešu'),
                    ),
                    DropdownMenuItem(
                      value: Locale('lt'),
                      child: Text('Lietuvių'),
                    ),
                    DropdownMenuItem(
                      value: Locale('nl'),
                      child: Text('Nederlands'),
                    ),
                    DropdownMenuItem(
                      value: Locale('no'),
                      child: Text('Norsk'),
                    ),
                    DropdownMenuItem(
                      value: Locale('uz'),
                      child: Text('O\'zbek (lotin)'),
                    ),
                    DropdownMenuItem(
                      value: Locale('pl'),
                      child: Text('Polski'),
                    ),
                    DropdownMenuItem(
                      value: Locale('pt'),
                      child: Text('Português'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ro'),
                      child: Text('Română'),
                    ),
                    DropdownMenuItem(
                      value: Locale('sk'),
                      child: Text('Slovenčina'),
                    ),
                    DropdownMenuItem(
                      value: Locale('sl'),
                      child: Text('Slovenščina'),
                    ),
                    DropdownMenuItem(
                      value: Locale('sq'),
                      child: Text('Shqip'),
                    ),
                    DropdownMenuItem(
                      value: Locale('fi'),
                      child: Text('Suomi'),
                    ),
                    DropdownMenuItem(
                      value: Locale('sv'),
                      child: Text('Svenska'),
                    ),
                    DropdownMenuItem(
                      value: Locale('vi'),
                      child: Text('Tiếng Việt'),
                    ),
                    DropdownMenuItem(
                      value: Locale('tr'),
                      child: Text('Türkçe'),
                    ),
                    DropdownMenuItem(
                      value: Locale('te'),
                      child: Text('Vıoŝ\'a'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ja'),
                      child: Text('日本語'),
                    ),
                    DropdownMenuItem(
                      value: Locale('zh', 'CN'),
                      child: Text('简体中文'),
                    ),
                    DropdownMenuItem(
                      value: Locale('zh', 'TW'),
                      child: Text('繁體中文'),
                    ),
                    DropdownMenuItem(
                      value: Locale('el'),
                      child: Text('Eλληνικά'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ru'),
                      child: Text('Русский'),
                    ),
                    DropdownMenuItem(
                      value: Locale('be'),
                      child: Text('Беларуская'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ky'),
                      child: Text('Кыргызча'),
                    ),
                    DropdownMenuItem(
                      value: Locale('uk'),
                      child: Text('Українська'),
                    ),
                    DropdownMenuItem(
                      value: Locale('mn'),
                      child: Text('Монгол'),
                    ),
                    DropdownMenuItem(
                      value: Locale('kk'),
                      child: Text('Қазақ тілі'),
                    ),
                    DropdownMenuItem(
                      value: Locale('sr'),
                      child: Text('Српски (Ћирилица)'),
                    ),
                    DropdownMenuItem(
                      value: Locale('mk'),
                      child: Text('Македонски'),
                    ),
                    DropdownMenuItem(
                      value: Locale('hy'),
                      child: Text('Հայերեն'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ka'),
                      child: Text('ქართული'),
                    ),
                    DropdownMenuItem(
                      value: Locale('he'),
                      child: Text('עִברִית'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ar'),
                      child: Text('العربية'),
                    ),
                    DropdownMenuItem(
                      value: Locale('fa'),
                      child: Text('فارسی'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ur'),
                      child: Text('اردو'),
                    ),
                    DropdownMenuItem(
                      value: Locale('hi'),
                      child: Text('हिन्दी'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ne'),
                      child: Text('नेपाली'),
                    ),
                    DropdownMenuItem(
                      value: Locale('gu'),
                      child: Text('ગુજરાતી'),
                    ),
                    DropdownMenuItem(
                      value: Locale('or'),
                      child: Text('ଓଡ଼ିଆ'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ta'),
                      child: Text('தமிழ்'),
                    ),
                    DropdownMenuItem(
                      value: Locale('bn'),
                      child: Text('বাংলা'),
                    ),
                    DropdownMenuItem(
                      value: Locale('my'),
                      child: Text('မြန်မာ'),
                    ),
                    DropdownMenuItem(
                      value: Locale('th'),
                      child: Text('ไทย'),
                    ),
                    DropdownMenuItem(
                      value: Locale('lo'),
                      child: Text('ພາສາລາວ'),
                    ),
                    DropdownMenuItem(
                      value: Locale('ko'),
                      child: Text('한국어'),
                    ),
                  ],
                  iconSize: 30,
                  iconEnabledColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.tealAccent
                          : Colors.blue,
                  iconDisabledColor: Colors.grey,
                ),
              ],
            ),
          ),
          //# endregion
        ],
      ),
    );
  }
  //# endregion
}

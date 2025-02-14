import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_todo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final savedThemeMode = prefs.getString('themeMode') ?? 'system';
    setState(() {
      _selectedThemeMode = _getThemeModeFromString(savedThemeMode);
    });
  }

  void _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(l10n.theme),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.selectTheme),
                DropdownButton<ThemeMode>(
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
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.selectLanguage),
                DropdownButton<Locale>(
                  value: Localizations.localeOf(context),
                  onChanged: (Locale? newValue) {
                    if (newValue != null) {
                      TodoApp.of(context).changeLocale(newValue);
                    }
                  },
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
                    // Add more languages here
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

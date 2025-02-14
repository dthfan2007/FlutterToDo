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
            subtitle: Text(l10n.selectTheme),
            trailing: DropdownButton<ThemeMode>(
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
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.selectLanguage),
            trailing: DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              onChanged: (Locale? newValue) {
                if (newValue != null) {
                  TodoApp.of(context).changeLocale(newValue);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('te'),
                  child: Text('Vıoŝ\'a'),
                ),
                DropdownMenuItem(
                  value: Locale('ar'),
                  child: Text('عربي'),
                ),
                DropdownMenuItem(
                  value: Locale('be'),
                  child: Text('Belarusian'),
                ),
                DropdownMenuItem(
                  value: Locale('bn'),
                  child: Text('Bengali'),
                ),
                DropdownMenuItem(
                  value: Locale('cs'),
                  child: Text('Czech'),
                ),
                DropdownMenuItem(
                  value: Locale('da'),
                  child: Text('Danish'),
                ),
                DropdownMenuItem(
                  value: Locale('de'),
                  child: Text('German'),
                ),
                DropdownMenuItem(
                  value: Locale('el'),
                  child: Text('Greek'),
                ),
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('es'),
                  child: Text('Spanish'),
                ),
                DropdownMenuItem(
                  value: Locale('et'),
                  child: Text('Estonian'),
                ),
                DropdownMenuItem(
                  value: Locale('fa'),
                  child: Text('Persian'),
                ),
                DropdownMenuItem(
                  value: Locale('fi'),
                  child: Text('Finnish'),
                ),
                DropdownMenuItem(
                  value: Locale('fil'),
                  child: Text('Filipino'),
                ),
                DropdownMenuItem(
                  value: Locale('gu'),
                  child: Text('Gujarati'),
                ),
                DropdownMenuItem(
                  value: Locale('he'),
                  child: Text('Hebrew'),
                ),
                DropdownMenuItem(
                  value: Locale('hi'),
                  child: Text('Hindi'),
                ),
                DropdownMenuItem(
                  value: Locale('hr'),
                  child: Text('Croatian'),
                ),
                DropdownMenuItem(
                  value: Locale('hu'),
                  child: Text('Hungarian'),
                ),
                DropdownMenuItem(
                  value: Locale('hy'),
                  child: Text('Armenian'),
                ),
                DropdownMenuItem(
                  value: Locale('id'),
                  child: Text('Indonesian'),
                ),
                DropdownMenuItem(
                  value: Locale('is'),
                  child: Text('Icelandic'),
                ),
                DropdownMenuItem(
                  value: Locale('it'),
                  child: Text('Italian'),
                ),
                DropdownMenuItem(
                  value: Locale('ja'),
                  child: Text('Japanese'),
                ),
                DropdownMenuItem(
                  value: Locale('ka'),
                  child: Text('Georgian'),
                ),
                DropdownMenuItem(
                  value: Locale('kk'),
                  child: Text('Kazakh'),
                ),
                DropdownMenuItem(
                  value: Locale('ko'),
                  child: Text('Korean'),
                ),
                DropdownMenuItem(
                  value: Locale('ky'),
                  child: Text('Kyrgyz'),
                ),
                DropdownMenuItem(
                  value: Locale('lo'),
                  child: Text('lao'),
                ),
                DropdownMenuItem(
                  value: Locale('lt'),
                  child: Text('lithuanian'),
                ),
                DropdownMenuItem(
                  value: Locale('lv'),
                  child: Text('latvian'),
                ),
                DropdownMenuItem(
                  value: Locale('mk'),
                  child: Text('macedonian'),
                ),
                DropdownMenuItem(
                  value: Locale('mn'),
                  child: Text('mongolian'),
                ),
                DropdownMenuItem(
                  value: Locale('my'),
                  child: Text('burmese'),
                ),
                DropdownMenuItem(
                  value: Locale('ne'),
                  child: Text('nepali'),
                ),
                DropdownMenuItem(
                  value: Locale('nl'),
                  child: Text('dutch'),
                ),
                DropdownMenuItem(
                  value: Locale('no'),
                  child: Text('norwegian'),
                ),
                DropdownMenuItem(
                  value: Locale('or'),
                  child: Text('odia'),
                ),
                DropdownMenuItem(
                  value: Locale('pl'),
                  child: Text('polish'),
                ),
                DropdownMenuItem(
                  value: Locale('pt'),
                  child: Text('portuguese'),
                ),
                DropdownMenuItem(
                  value: Locale('ro'),
                  child: Text('romanian'),
                ),
                DropdownMenuItem(
                  value: Locale('ru'),
                  child: Text('russian'),
                ),
                DropdownMenuItem(
                  value: Locale('sk'),
                  child: Text('slovak'),
                ),
                DropdownMenuItem(
                  value: Locale('sl'),
                  child: Text('slovenian'),
                ),
                DropdownMenuItem(
                  value: Locale('sq'),
                  child: Text('albanian'),
                ),
                DropdownMenuItem(
                  value: Locale('sr'),
                  child: Text('serbian'),
                ),
                DropdownMenuItem(
                  value: Locale('sv'),
                  child: Text('swedish'),
                ),
                DropdownMenuItem(
                  value: Locale('ta'),
                  child: Text('Tamil'),
                ),
                DropdownMenuItem(
                  value: Locale('th'),
                  child: Text('Thai'),
                ),
                DropdownMenuItem(
                  value: Locale('tr'),
                  child: Text('Turkish'),
                ),
                DropdownMenuItem(
                  value: Locale('uk'),
                  child: Text('Ukrainian'),
                ),
                DropdownMenuItem(
                  value: Locale('ur'),
                  child: Text('Urdu'),
                ),
                DropdownMenuItem(
                  value: Locale('uz'),
                  child: Text('Uzbek'),
                ),
                DropdownMenuItem(
                  value: Locale('vi'),
                  child: Text('Vietnamese'),
                ),
                DropdownMenuItem(
                  value: Locale('zh', 'CN'),
                  child: Text('Simplified Chinese'),
                ),
                DropdownMenuItem(
                  value: Locale('zh', 'TW'),
                  child: Text('Traditional Chinese'),
                ),
                // Add more languages here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

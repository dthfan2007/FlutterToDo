import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

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

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('themeMode') ?? 'system';
    setState(() {
      _selectedThemeMode = _getThemeModeFromString(savedThemeMode);
    });
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

  void _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.tealAccent[700]
            : Colors.blue,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme'),
            subtitle: const Text('Select this app\'s theme'),
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
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Mode'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Mode'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Based on System Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

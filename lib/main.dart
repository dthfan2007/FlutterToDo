import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'todo_home.dart';
import 'settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedThemeMode = prefs.getString('themeMode') ?? 'system';
  runApp(TodoApp(initialThemeMode: _getThemeModeFromString(savedThemeMode)));
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

class TodoApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const TodoApp({super.key, required this.initialThemeMode});

  @override
  _TodoAppState createState() => _TodoAppState();

  static _TodoAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_TodoAppState>()!;
}

class _TodoAppState extends State<TodoApp> {
  late ThemeMode _themeMode;
  Locale _locale = Locale('en'); // Default locale

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData.light(useMaterial3: true)
          .copyWith(colorScheme: ColorScheme.light(primary: Colors.blue)),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          surface: Colors.blueGrey,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
        shadowColor: Colors.white24,
      ),
      themeMode: _themeMode,
      locale: _locale, // Set the locale here
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ja', ''), // Japanese
        Locale('es', ''), // Spanish
        // Add more locales here if needed
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const TodoHome(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Correct usage of AppLocalizations
    final l10n = AppLocalizations.of(context); // Get the localized strings

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: l10n!.todo, // Use localized string here
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings, // Use localized string here
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

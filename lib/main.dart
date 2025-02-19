/// main.dart
///
/// Author: Matteo Cipriani
/// Created: 2025-02-18
/// Description: This file contains the main entry point for the Flutter app.
/// It initializes the app and sets up the home screen.
///
/// Version: Beta 2.1.1
/// Latest Change: Added Localization to texts

//# region [Section 1] Imports
// MARK: Imports
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'todo_home.dart';
import 'settings.dart';

//# endregion

//# region [Section 2] Setup
// MARK: Setup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedThemeMode = prefs.getString('themeMode') ??
      'system'; // Load previously saved theme mode, set to default in case it returns 'null'
  runApp(TodoApp(initialThemeMode: _getThemeModeFromString(savedThemeMode)));
}

// Returns the theme mode for other LOC to use it
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

// Initialize the application
class TodoApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const TodoApp({super.key, required this.initialThemeMode});

  @override
  _TodoAppState createState() => _TodoAppState();

  static _TodoAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_TodoAppState>()!;
}

//# endregion
class _TodoAppState extends State<TodoApp> {
  late ThemeMode _themeMode;
  Locale _locale = Locale('te');
  //# region [Section 3] Functions
  // MARK: Functions
  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ??
        'te'; // Load previously saved locale, set to 'te' if it returns 'null'
    setState(() {
      _locale = Locale(savedLocale);
    });
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  // Update locale upon new selection by user
  void changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }
  //# endregion

  //# region [Section 4] Initialization
  // MARK: Init Theme
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      // Initialize themes
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
      // MARK: Init Locales
      locale: _locale,
      // List the codes of supported locales
      supportedLocales: const [
        Locale('te'),
        Locale('ar'),
        Locale('be'),
        Locale('bn'),
        Locale('cs'),
        Locale('da'),
        Locale('de'),
        Locale('el'),
        Locale('en'),
        Locale('es'),
        Locale('et'),
        Locale('fa'),
        Locale('fi'),
        Locale('fil'),
        Locale('gu'),
        Locale('he'),
        Locale('hi'),
        Locale('hr'),
        Locale('hu'),
        Locale('hy'),
        Locale('id'),
        Locale('is'),
        Locale('it'),
        Locale('ja'),
        Locale('ka'),
        Locale('kk'),
        Locale('ko'),
        Locale('ky'),
        Locale('lo'),
        Locale('lt'),
        Locale('lv'),
        Locale('mk'),
        Locale('mn'),
        Locale('my'),
        Locale('ne'),
        Locale('nl'),
        Locale('no'),
        Locale('or'),
        Locale('pl'),
        Locale('pt'),
        Locale('ro'),
        Locale('ru'),
        Locale('sk'),
        Locale('sl'),
        Locale('sq'),
        Locale('sr'),
        Locale('sv'),
        Locale('ta'),
        Locale('th'),
        Locale('tr'),
        Locale('uk'),
        Locale('ur'),
        Locale('uz'),
        Locale('vi'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const MainScreen(),
    );
  }
  //# endregion
}

//# region [Section 5] Build App Widget
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

  // MARK: Build Widget
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Bottom Navigation Bar
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: l10n!.todo,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

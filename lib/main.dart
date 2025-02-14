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
  Locale _locale = Locale('te'); // Default locale

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale =
        prefs.getString('locale') ?? 'te'; // Default to 'en' if not found
    setState(() {
      _locale = Locale(savedLocale);
    });
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'locale', locale.languageCode); // Save the locale code
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

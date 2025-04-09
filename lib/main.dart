import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_weather/core/config/env.dart';
import 'package:todo_weather/providers/theme_provider.dart';
import 'package:todo_weather/data/models/task_model.dart';
import 'core/navigation/app_router.dart';
import 'providers/task_provider.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (_) => ThemeModeNotifier(
    mode: ThemeMode.system,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.initFlutter();
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme_mode');
  final initialTheme = savedTheme == 'dark'
      ? ThemeMode.dark
      : savedTheme == 'light'
          ? ThemeMode.light
          : ThemeMode.system;
  runApp(ProviderScope(
    overrides: [
      themeModeProvider.overrideWith(
        (ref) => ThemeModeNotifier(
          mode: initialTheme,
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(taskProvider.notifier).refreshWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Weather Task App',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.mandyRed,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.mandyRed,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      themeMode: themeMode,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.taskList,
    );
  }
}

import 'views/index.dart';
import 'core/index.dart';
import 'data/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final homeProvider = HomeProvider();

  final favoriteProvider = MangaProvider();
  await favoriteProvider.loadFavorites();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => favoriteProvider),
        ChangeNotifierProvider(create: (_) => homeProvider),
      ],
      child: const MangaApp(),
    ),
  );
}

class MangaApp extends StatelessWidget {
  const MangaApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amberAccent,
        primary: Colors.amber,
        secondary: Colors.amberAccent,
      ),
      textTheme: const TextTheme(),
      appBarTheme: const AppBarTheme(
        // backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MangaHomePage(),
      theme: appTheme,
    );
  }
}

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MangaHomePage(),
    );
  }
}

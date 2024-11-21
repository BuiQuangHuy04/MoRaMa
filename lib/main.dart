import 'views/index.dart';
import 'core/index.dart';
import 'data/index.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MangaProvider()),
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

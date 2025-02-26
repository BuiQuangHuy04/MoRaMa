import '../../index.dart';
import '/core/index.dart';
import '/data/index.dart';

class MangaBookmarkWidget extends StatefulWidget {
  final MangaController controller;

  const MangaBookmarkWidget({
    super.key,
    required this.controller,
  });

  @override
  State<MangaBookmarkWidget> createState() => _MangaBookmarkWidgetState();
}

class _MangaBookmarkWidgetState extends State<MangaBookmarkWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("BOOKMARK"),
        centerTitle: true,
      ),
      body: Consumer<MangaProvider>(
        builder: (context, provider, child) {
          final favoriteMangas = provider.manga[MangaKey.FAVORITE.key];

          debugPrint('manga_bookmark_widget: favorite mangas: '
              '${favoriteMangas!.length}');

          if (favoriteMangas.isEmpty) {
            return const Center(
              child: Text(
                'No favorite mangas yet!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteMangas.length,
            itemBuilder: (context, index) {
              final manga = favoriteMangas[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FavoriteContainer(
                  controller: widget.controller,
                  manga: manga,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

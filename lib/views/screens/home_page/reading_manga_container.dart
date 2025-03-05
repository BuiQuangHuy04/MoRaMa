import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class ReadingMangaContainer extends StatelessWidget {
  final MangaController? controller;

  const ReadingMangaContainer({
    super.key,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('reading_manga_widget: build');
    return controller != null
        ? Consumer<MangaProvider>(
            builder: (context, provider, child) {
              final mangas = provider.manga[MangaKey.FAVORITE.key]!;

              if (mangas.isEmpty) {
                return Container();
              }

              return FavoriteContainer(
                controller: controller!,
                manga: mangas.first,
              );
            },
          )
        : const LoadingWidget();
  }
}

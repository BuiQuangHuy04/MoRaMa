import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class SuggestedMangaWidget extends StatelessWidget {
  final MangaController controller;

  const SuggestedMangaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    debugPrint('suggested_manga_widget: build');
    return Consumer<MangaProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading[MangaKey.SUGGESTED.key]!) {
          return const LoadingWidget();
        } else if (provider.error[MangaKey.SUGGESTED.key] != null) {
          return Center(
            child: Text(
              'Error: ${provider.error[MangaKey.SUGGESTED.key]}',
              overflow: TextOverflow.clip,
            ),
          );
        } else if (provider.manga[MangaKey.SUGGESTED.key]!.isNotEmpty) {
          return Container(
            height: 260,
            margin: const EdgeInsets.only(left: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.manga[MangaKey.SUGGESTED.key]!.length,
              itemBuilder: (context, index) {
                var manga =
                    provider.manga[MangaKey.SUGGESTED.key]!.elementAt(index);

                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingMangaCover(
                        controller: controller,
                        manga: manga,
                        width: 120,
                        height: 180,
                      ),
                      const Gap(8),
                      Text(
                        manga.attributes!.title!.en != null
                            ? manga.attributes!.title!.en.toString()
                            : manga.attributes!.title!.ja.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(4),
                      Text(
                        manga.attributes!.lastChapter != null
                            ? 'Chapter ${manga.attributes!.lastChapter!}'
                            : manga.attributes!.status == 'completed'
                                ? 'Completed'
                                : 'Ongoing',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: LoadingWidget(),
          );
        }
      },
    );
  }
}

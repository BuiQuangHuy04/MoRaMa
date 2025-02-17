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
              if (provider.isLoading[MangaKey.READING.key]!) {
                return const LoadingWidget();
              } else if (provider.error[MangaKey.READING.key] != null) {
                return Center(
                  child: Text(
                    'Error: ${provider.error[MangaKey.READING.key]}',
                    overflow: TextOverflow.clip,
                  ),
                );
              } else if (provider.manga[MangaKey.READING.key]!.isNotEmpty) {
                final manga = provider.manga[MangaKey.READING.key]!.first;

                return Container(
                  height: 182,
                  width: MediaQuery.sizeOf(context).width,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      LoadingMangaCover(
                        width: 120,
                        controller: controller!,
                        manga: manga,
                      ),
                      const Gap(12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manga.attributes!.title!.en!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                manga.attributes!.lastChapter != ''
                                    ? 'Chapter ${manga.attributes!.lastChapter!}'
                                    : 'Ongoing',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(12),
                              Text(
                                manga.relationships!.any((relationship) =>
                                        relationship.type == 'author')
                                    ? manga.relationships!
                                        .where((relationship) =>
                                            relationship.type == 'author')
                                        .first
                                        .attributes!
                                        .name!
                                    : '',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const Gap(24),
                              const Row(
                                children: [
                                  Text(
                                    "78%",
                                    style: TextStyle(
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                  Gap(12),
                                  Text(
                                    "20 min left",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(4),
                              const LinearProgressIndicator(
                                value: .7,
                                color: Colors.amberAccent,
                              ),
                              const Gap(12),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.amberAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                    child: Text(
                                      "Continue Reading",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const LoadingWidget();
              }
            },
          )
        : const LoadingWidget();
  }
}

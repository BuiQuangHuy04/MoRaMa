import '../../core/index.dart';
import '../../data/index.dart';

class ReadingMangaContainer extends StatefulWidget {
  // final Manga? manga;
  final MangaController? controller;

  const ReadingMangaContainer({
    super.key,
    // this.manga,
    this.controller,
  });

  @override
  State<ReadingMangaContainer> createState() => _ReadingMangaContainerState();
}

class _ReadingMangaContainerState extends State<ReadingMangaContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.controller != null
        ? FutureBuilder(
            future: widget.controller!
                .fetchListManga(params: {'title': 'Solo Leveling'}),
            builder: (context, snapshot1) {
              if (snapshot1.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else if (snapshot1.hasError) {
                return Center(
                  child: Text('Error ${snapshot1.error}'),
                );
              } else if (snapshot1.hasData) {
                var listManga = snapshot1.data;
                var manga = listManga!.first;
                print(manga.id);
                return Container(
                  height: 182,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      LoadingMangaCover(
                        width: 120,
                        controller: widget.controller!,
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
                                  ? manga.attributes!.lastChapter!
                                  : manga.attributes!.lastVolume != ''
                                      ? manga.attributes!.lastVolume!
                                      : 'Ongoing',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Gap(12),
                            const Text(
                              'Unknown',
                              style: TextStyle(
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
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        : Container();
  }
}

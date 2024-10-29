import '../../core/index.dart';
import '../../data/index.dart';

class SuggestedMangaWidget extends StatefulWidget {
  final MangaController controller;

  const SuggestedMangaWidget({super.key, required this.controller});

  @override
  State<SuggestedMangaWidget> createState() => _SuggestedMangaWidgetState();
}

class _SuggestedMangaWidgetState extends State<SuggestedMangaWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fetchListManga(params: {
        // "status[]": ["completed"],
        'contentRating[]': ['suggestive','safe']
      }),
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot1.hasError) {
          return Center(
            child: Text('Error: ${snapshot1.error}'),
          );
        } else if (snapshot1.hasData) {
          var listManga = snapshot1.data;

          return Container(
            height: 260,
            margin: const EdgeInsets.only(left: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listManga!.length,
              itemBuilder: (context, index) {
                var manga = listManga.elementAt(index);

                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingMangaCover(
                        controller: widget.controller,
                        manga: manga,
                        width: 120,
                        height: 180,
                      ),
                      const Gap(8),
                      Text(
                        manga.attributes!.title!.en.toString(),
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
            child: Text('No manga found'),
          );
        }
      },
    );
  }
}

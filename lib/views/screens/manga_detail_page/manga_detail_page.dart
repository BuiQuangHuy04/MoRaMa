import '/core/index.dart';
import '/data/index.dart';

class MangaDetailPage extends StatefulWidget {
  final Manga manga;
  final String coverUrl;
  final MangaController controller;

  const MangaDetailPage(
    this.manga, {
    super.key,
    required this.coverUrl,
    required this.controller,
  });

  @override
  State<MangaDetailPage> createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 600,
            title: Text(widget.manga.attributes!.title!.en!),
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black,
            ),
            centerTitle: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: LoadingMangaCover(
                manga: widget.manga,
                coverUrl: widget.coverUrl,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.manga.attributes!.description!.en == null
                            ? ''
                            : 'Overview',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.manga.attributes!.description!.en == null
                          ? Container()
                          : const SizedBox(height: 10.0),
                      Text(
                        widget.manga.attributes!.description!.en ?? '',
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      widget.manga.attributes!.description!.en == null
                          ? Container()
                          : const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Release Date",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.manga.attributes!.createdAt!,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Rating",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.yellow),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    widget.manga.attributes!.contentRating!,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      FutureBuilder(
                        future: widget.controller.fetchListChapter(
                          mangaId: widget.manga.id!,
                          params: {
                            'includeFuturePublishAt': '0',
                            'translatedLanguage[]': ['en']
                          },
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LoadingWidget();
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('${snapshot.error}'),
                            );
                          } else if (snapshot.hasData) {
                            final chapters = snapshot.data;
                            if (chapters!.isNotEmpty) {
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: chapters.length,
                                itemExtent: 60,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return ChapterDetailPage(
                                              mangaTitle: widget.manga.attributes!.title!.en.toString(),
                                              chapter: chapters[index].attributes!.chapter.toString(),
                                              chapterId: chapters[index].id!,
                                              controller: widget.controller,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          '[${chapters[index].attributes!.translatedLanguage}]'
                                          ' Chapter ${chapters[index].attributes!.chapter} ',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Have not any chapters yet!'),
                              );
                            }
                          } else {
                            return const Center(
                              child: Text('Have not any chapters yet!'),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

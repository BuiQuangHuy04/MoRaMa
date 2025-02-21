import '/core/index.dart';
import '/views/index.dart';
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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  bool _checkStatus() {
    return _isFavorite;
  }

  void _updateStatus() {
    _isFavorite = !_isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 600,
            title: Text(widget.manga.attributes!.title!.en != null
                ? widget.manga.attributes!.title!.en.toString()
                : widget.manga.attributes!.title!.ja.toString()),
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
                controller: widget.controller,
              ),
            ),
            actions: [
              IconButton(
                icon: Consumer<MangaProvider>(
                  builder: (context, favoriteProvider, child) {
                    bool isFavorite = favoriteProvider.isFavorite(widget.manga);
                    return Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border);
                  },
                ),
                onPressed: () {
                  final provider = Provider.of<MangaProvider>(
                    context,
                    listen: false,
                  );
                  final isFavorite = provider.isFavorite(widget.manga);

                  provider.toggleFavorite(widget.manga);

                  debugPrint('manga_detail_page: favorite mangas: '
                      '${provider.favoriteMangas.length}');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? "Removed from favorites"
                            : "Added to favorites",
                        style: const TextStyle(fontSize: 16),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: isFavorite ? Colors.grey : Colors.amber,
                    ),
                  );
                },
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
                            : 'Description',
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
                                "Release date",
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
                                "Content rating",
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
                            debugPrint('manga_detail_page: 148: $chapters');
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
                                              mangaTitle: widget
                                                  .manga.attributes!.title!.en
                                                  .toString(),
                                              chapter: chapters.length < 2
                                                  ? chapters[index]
                                                              .attributes!
                                                              .chapter ==
                                                          'null'
                                                      ? 'One Shot'
                                                      : 'Chapter ${chapters[index].attributes!.chapter} '
                                                  : chapters[index]
                                                              .attributes!
                                                              .chapter ==
                                                          'null'
                                                      ? 'Chapter 1'
                                                      : 'Chapter ${chapters[index].attributes!.chapter} ',
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
                                          '[${chapters[index].attributes!.translatedLanguage}] ',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          chapters.length < 2
                                              ? chapters[index]
                                                          .attributes!
                                                          .chapter ==
                                                      'null'
                                                  ? 'One Shot'
                                                  : 'Chapter ${chapters[index].attributes!.chapter} '
                                              : chapters[index]
                                                          .attributes!
                                                          .chapter ==
                                                      'null'
                                                  ? 'Chapter 1'
                                                  : 'Chapter ${chapters[index].attributes!.chapter} ',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                          ),
                                        ),
                                        chapters[index]
                                                .relationships!
                                                .any((relationship) {
                                          return relationship.type! ==
                                                  'scanlation_group' &&
                                              relationship.attributes != null;
                                        })
                                            ? Expanded(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      chapters[index]
                                                          .relationships!
                                                          .firstWhere(
                                                              (relationship) {
                                                            return relationship
                                                                        .type! ==
                                                                    'scanlation_group' &&
                                                                relationship
                                                                        .attributes !=
                                                                    null;
                                                          })
                                                          .attributes!
                                                          .name
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 14,
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const Text(''),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Have not any chapters yet!!'),
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

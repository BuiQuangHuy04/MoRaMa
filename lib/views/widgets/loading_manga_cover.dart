import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class LoadingMangaCover extends StatefulWidget {
  final MangaController? controller;
  final Manga manga;
  final String? coverUrl;
  final double? width;
  final double? height;

  const LoadingMangaCover({
    super.key,
    this.controller,
    required this.manga,
    this.coverUrl,
    this.width,
    this.height,
  });

  @override
  State<LoadingMangaCover> createState() => _LoadingMangaCoverState();
}

class _LoadingMangaCoverState extends State<LoadingMangaCover> {
  @override
  Widget build(BuildContext context) {
    if (widget.coverUrl != null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(widget.coverUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: widget.controller!.fetchFileNameCover(
          mangaId: widget.manga.id!,
        ),
        builder: (context, snapshot2) {
          if (snapshot2.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot2.hasError) {
            return Center(
              child: Text('Error: ${snapshot2.error}'),
            );
          } else if (snapshot2.hasData) {
            final fileName = snapshot2.data;

            var coverUrl =
                '${Constants.mediaAPI}${widget.manga.id!}//$fileName';
            return GestureDetector(
              onTap: () {
                debugPrint('loading_manga_cover: manga: ${widget.manga}');
                debugPrint('loading_manga_cover: coverUrl:${widget.coverUrl}');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MangaDetailPage(
                      widget.manga,
                      coverUrl: coverUrl,
                      controller: widget.controller!,
                    ),
                  ),
                );
              },
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      coverUrl,
                      headers: {
                        'Connection': 'Keep-Alive',
                        'Keep-Alive': 'timeout=5, max=1000'
                      },
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No cover found'),
            );
          }
        },
      );
    }
  }
}

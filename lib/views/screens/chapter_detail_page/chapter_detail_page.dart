import 'package:cached_network_image/cached_network_image.dart';
import 'package:morama/data/index.dart';

import '../../../core/index.dart';

class ChapterDetailPage extends StatefulWidget {
  final String chapterId;
  final String mangaTitle;
  final String chapter;
  final MangaController controller;

  const ChapterDetailPage({
    super.key,
    required this.chapterId,
    required this.controller,
    required this.mangaTitle,
    required this.chapter,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter),
      ),
      body: FutureBuilder<ChapterResource>(
        future: widget.controller.fetchListChapterImg(
          chapterId: widget.chapterId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final chapterRes = snapshot.data!;
            final imageUrls = chapterRes.dataSaver;

            if (imageUrls != null) {
              return ListView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://uploads.mangadex.org/data-saver/${chapterRes.hash!}/${imageUrls[index]}',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        fadeInDuration: Duration.zero,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No images available'));
            }
          } else {
            return const Center(child: Text('No images available'));
          }
        },
      ),
    );
  }
}

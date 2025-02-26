import '/data/index.dart';
import '/core/index.dart';
import '../../index.dart';

class FavoriteContainer extends StatelessWidget {
  final MangaController controller;
  final Manga manga;

  const FavoriteContainer({
    super.key,
    required this.controller,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          LoadingMangaCover(
            width: 120,
            controller: controller,
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
                    manga.relationships!.any(
                            (relationship) => relationship.type == 'author')
                        ? manga.relationships!
                            .where(
                                (relationship) => relationship.type == 'author')
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
                        "20 chapters left",
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
                  // const Gap(10),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 8),
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       color: Colors.amberAccent,
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: Center(
                  //     child: FutureBuilder(
                  //       future: controller.fetchFileNameCover(
                  //         mangaId: manga.id!,
                  //       ),
                  //       builder: (context, snapshot2) {
                  //         if (snapshot2.connectionState ==
                  //             ConnectionState.waiting) {
                  //           return const LoadingWidget();
                  //         } else if (snapshot2.hasError) {
                  //           return Center(
                  //             child: Text('Error: ${snapshot2.error}'),
                  //           );
                  //         } else if (snapshot2.hasData) {
                  //           final fileName = snapshot2.data;
                  //
                  //           var coverUrl =
                  //               '${Constants.mediaAPI}${manga.id!}//$fileName';
                  //           return TextButton(
                  //             child: const Text(
                  //               "Continue Reading",
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Colors.black,
                  //                 // fontSize: 14
                  //               ),
                  //             ),
                  //             onPressed: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => MangaDetailPage(
                  //                     manga,
                  //                     coverUrl: coverUrl,
                  //                     controller: controller,
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //           );
                  //         } else {
                  //           return const Center(
                  //             child: Text('Error'),
                  //           );
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class AllMangaWidget extends StatefulWidget {
  final MangaController controller;
  final Map<String, dynamic>? params;
  final bool canLoadMore;

  const AllMangaWidget({
    super.key,
    required this.controller,
    required this.canLoadMore,
    this.params,
  });

  @override
  State<AllMangaWidget> createState() => _AllMangaWidgetState();
}

class _AllMangaWidgetState extends State<AllMangaWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('all_manga_widget: build');
    return Consumer<MangaProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoading[MangaKey.ALL.key] ?? false;
        final error = provider.error[MangaKey.ALL.key];
        final mangaList = provider.manga[MangaKey.ALL.key] ?? [];

        if (isLoading) {
          return const LoadingWidget();
        } else if (error != null) {
          return Center(
            child: Text('Error: ${provider.error[MangaKey.ALL.key]}'),
          );
        } else if (mangaList.isNotEmpty) {
          var mangaList = provider.manga[MangaKey.ALL.key]!;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: mangaList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    var manga = mangaList.elementAt(index);

                    return LoadingMangaCover(
                      controller: widget.controller,
                      manga: manga,
                    );
                    // return const LoadingWidget();
                  },
                ),
              ),
              // widget.canLoadMore
              //     ? Positioned(
              //         bottom: 10,
              //         right: 10,
              //         child: Column(
              //           children: [
              //             ElevatedButton.icon(
              //               onPressed: provider.nextOffset(param: widget.params),
              //               icon: const Icon(
              //                 Icons.chevron_right_outlined,
              //                 color: Colors.white,
              //               ),
              //               label: Text(
              //                 '${provider.curPage + 2}',
              //                 style: const TextStyle(
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.amberAccent,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20),
              //                 ),
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 16,
              //                   vertical: 10,
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(height: 8),
              //             if (provider.curPage >= 1)
              //               ElevatedButton.icon(
              //                 onPressed: provider.preOffset(param: widget.params),
              //                 icon: const Icon(
              //                   Icons.chevron_left_outlined,
              //                   color: Colors.white,
              //                 ),
              //                 label: Text(
              //                   '${provider.curPage}',
              //                   style: const TextStyle(
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: Colors.amberAccent,
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                   padding: const EdgeInsets.symmetric(
              //                     horizontal: 16,
              //                     vertical: 10,
              //                   ),
              //                 ),
              //               ),
              //           ],
              //         ),
              //       )
              //     : Container(),
            ],
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

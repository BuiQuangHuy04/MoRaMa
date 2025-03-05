import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class AllMangaWidget extends StatefulWidget {
  final MangaController controller;
  final bool canLoadMore;
  final MangaKey mangaKey;

  const AllMangaWidget({
    super.key,
    required this.mangaKey,
    required this.controller,
    required this.canLoadMore,
  });

  @override
  State<AllMangaWidget> createState() => _AllMangaWidgetState();
}

class _AllMangaWidgetState extends State<AllMangaWidget> {
  late MangaProvider _provider;

  @override
  void initState() {
    super.initState();
    debugPrint('all_manga_widget: init');
    _provider = Provider.of<MangaProvider>(
      context,
      listen: false,
    );
  }

  @override
  void dispose() {
    for (var mangaKey in _provider.curPage.keys) {
      if (mangaKey != MangaKey.FAVORITE.key) {
        _provider.curPage[mangaKey] = 0;
        _provider.curOffset[mangaKey] = 0;
      }
    }

      if (mounted) {
        _provider.fetchMangaList(
          context,
          widget.mangaKey,
          addToOld: false,
        );
      }


    debugPrint('all_manga_widget: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('all_manga_widget: build');
    return Consumer<MangaProvider>(
      builder: (context, provider, child) {
        final isLoading = provider.isLoading[widget.mangaKey.key] ?? false;
        final error = provider.error[widget.mangaKey.key];
        final total = provider.total[widget.mangaKey.key];
        List<Manga> mangaList = provider.manga[widget.mangaKey.key] ?? [];

        debugPrint('all_manga_widget: current manga in '
            '${widget.mangaKey.key}: ${mangaList.length}');
        debugPrint('all_manga_widget: total manga in '
            '${widget.mangaKey.key}: $total');

        if (isLoading) {
          return const LoadingWidget();
        } else if (error != null) {
          return Center(
            child: Text('Error: ${provider.error[widget.mangaKey.key]}'),
          );
        } else if (mangaList.isNotEmpty) {
          var mangaList = provider.manga[widget.mangaKey.key]!;
          var length = mangaList.length % 10 == 0 ? 10 : mangaList.length % 10;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              if (widget.canLoadMore) _buildNavigator() else Container(),
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

  Widget _buildNavigator() {
    return Consumer<MangaProvider>(builder: (
      context,
      provider,
      child,
    ) {

      return Positioned(
        right: 10,
        left: 10,
        bottom: 10,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              provider.curPage[widget.mangaKey.key]! >= 1
                  ? ElevatedButton.icon(
                      onPressed: () {
                        provider.preOffset(
                          widget.mangaKey,
                        );
                        provider.fetchMangaList(
                          context,
                          widget.mangaKey,
                          addToOld: false,
                        );
                      },
                      icon: const Icon(
                        Icons.chevron_left_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        '${provider.curPage[widget.mangaKey.key]}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    )
                  : Container(),
              // mangaList.length % 10 >= 0 &&
              //         provider.curPage[widget.mangaKey.key]! * 10 +
              //                 mangaList.length % 10 <
              //             mangaList.length &&
              //         mangaList.length + 10 <=
              //             provider.total[widget.mangaKey.key]!
              provider.curPage[widget.mangaKey.key]! <
                      provider.total[widget.mangaKey.key]! / 10 - 1
                  ? ElevatedButton.icon(
                      onPressed: () {
                        provider.nextOffset(
                          widget.mangaKey,
                        );
                        // if ((provider.manga[widget.mangaKey.key]!.length / 10 ==
                        //     provider.curPage[widget.mangaKey.key])) {
                        provider.fetchMangaList(
                          context,
                          widget.mangaKey,
                          addToOld: false,
                        );
                        // }
                      },
                      icon: const Icon(
                        Icons.chevron_right_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        '${provider.curPage[widget.mangaKey.key]! + 2}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}

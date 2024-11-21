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
    this.params,
    required this.canLoadMore,
  });

  @override
  State<AllMangaWidget> createState() => _AllMangaWidgetState();
}

class _AllMangaWidgetState extends State<AllMangaWidget> {
  var _curOffset = 0;
  var _curPage = 0;
  Map<String, dynamic> _params = {};

  @override
  void initState() {
    super.initState();
    _params = {'offset': '$_curOffset'};
    if (widget.params != null) {
      _params.addAll(widget.params!);
    }
    debugPrint('all_manga_widget: initState: $_params');
  }

  void nextOffset() {
    setState(() {
      _curPage += 1;
      _curOffset = _curPage * 10;
      _params = {
        'offset': '$_curOffset',
      };
      if (widget.params != null) {
        _params.addAll(widget.params!);
      }
    });
  }

  void preOffset() {
    setState(() {
      _curPage -= 1;
      _curOffset = _curPage * 10;
      _params = {
        'offset': '$_curOffset',
      };
      if (widget.params != null) {
        _params.addAll(widget.params!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.params != null) {
      _params.addAll(widget.params!);
    }
    debugPrint('all_manga_widget: build: $_params');
    return FutureBuilder(
      future: widget.controller.fetchListManga(
        params: _params,
      ),
      builder: (context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot1.hasError) {
          return Center(
            child: Text('Error: ${snapshot1.error}'),
          );
        } else if (snapshot1.hasData) {
          final listManga = snapshot1.data;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: listManga!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    var manga = listManga.elementAt(index);

                    return LoadingMangaCover(
                      controller: widget.controller,
                      manga: manga,
                    );
                  },
                ),
              ),
              widget.canLoadMore
                  ? Positioned(
                      bottom: 10,
                      right: 10,
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: nextOffset,
                            icon: const Icon(
                              Icons.chevron_right_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              '${_curPage + 2}',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_curPage >= 1)
                            ElevatedButton.icon(
                              onPressed: preOffset,
                              icon: const Icon(
                                Icons.chevron_left_outlined,
                                color: Colors.white,
                              ),
                              label: Text(
                                '$_curPage',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Container(),
            ],
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

import '../../core/index.dart';
import '../../data/index.dart';

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
  }

  void nextOffset() {
    setState(() {
      _curPage += 1;
      _curOffset = _curPage * 10;
      _params = {'offset': '$_curOffset'};
      if (widget.params != null) {
        _params.addAll(widget.params!);
      }
    });
  }

  void preOffset() {
    setState(() {
      _curPage -= 1;
      _curOffset = _curPage * 10;
      _params = {'offset': '$_curOffset'};
      if (widget.params != null) {
        _params.addAll(widget.params!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fetchListManga(params: _params),
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
                          FloatingActionButton(
                            heroTag: '<next_discover_page_btn>',
                            onPressed: () {
                              nextOffset();
                            },
                            backgroundColor: Colors.amberAccent,
                            child: Icon(Icons.chevron_right_outlined),
                          ),
                          _curPage >= 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: FloatingActionButton(
                                    heroTag: '<pre_discover_page_btn>',
                                    onPressed: () {
                                      preOffset();
                                    },
                                    backgroundColor: Colors.amberAccent,
                                    child: Icon(Icons.chevron_left_outlined),
                                  ),
                                )
                              : Container(),
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

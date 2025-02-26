import 'dart:async';

import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class MangaDiscoverWidget extends StatefulWidget {
  final Map<String, dynamic>? params;
  final MangaController controller;
  final String title;
  final MangaKey mangaKey;
  final bool hasFilter;

  const MangaDiscoverWidget({
    super.key,
    this.params,
    required this.controller,
    required this.title,
    required this.mangaKey,
    this.hasFilter = true,
  });

  @override
  State<MangaDiscoverWidget> createState() => _MangaDiscoverWidgetState();
}

class _MangaDiscoverWidgetState extends State<MangaDiscoverWidget> {
  var filter = [];
  final _params = <String, dynamic>{};

  @override
  void initState() {
    super.initState();

    if (widget.params != null) {
      _params.addAll(widget.params!);
      debugPrint('manga_discover_widget: initState: updated _params: $_params');
    }

    filter.addAll(
      includedTags.map((item) => item.keys.first).toList(),
    );
    filter.addAll(
      publicationDemographic
          .map(
            (item) => item.split('')[0].toUpperCase() + item.substring(1),
          )
          .toList(),
    );

    var provider = Provider.of<MangaProvider>(context, listen: false);

    if (provider.manga[widget.mangaKey.key] != null) {
      provider.manga[widget.mangaKey.key]!.clear();

      provider.curPage[widget.mangaKey.key] = 0;
      provider.curOffset[widget.mangaKey.key] = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        if (mounted) {
          provider.fetchMangaList(
            context,
            widget.mangaKey,
            params: _params,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('manga_discover_widget: build');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: widget.title.contains('searching for')
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              )
            : null,
      ),
      body: Consumer<MangaProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              const Gap(16),
              widget.hasFilter
                  ? Container(
                      height: 52,
                      margin: const EdgeInsets.only(left: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filter.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (provider.curFilter.isEmpty ||
                                  provider.curFilter.keys.first !=
                                      filter[index]) {
                                provider.updateFilter(
                                  filter[index],
                                  widget.mangaKey,
                                );

                                if (widget.params != null) {
                                  _params.addAll(widget.params!);
                                }
                                if (provider.curFilter.values.isNotEmpty &&
                                    publicationDemographic.contains(provider
                                        .curFilter.values.first
                                        .toLowerCase())) {
                                  debugPrint(
                                      'manga_discover_page: onTap: publicationDemographic contain filter str: '
                                      '${publicationDemographic.contains(provider.curFilter.values.first.toLowerCase())}');
                                  _params.addAll({
                                    'publicationDemographic[]': [
                                      provider.curFilter.values.first
                                          .toLowerCase(),
                                    ],
                                  });
                                } else if (includedTags
                                    .contains(provider.curFilter)) {
                                  debugPrint(
                                      'manga_discover_page: onTap: includedTags contain filter str: '
                                      '${includedTags.contains(provider.curFilter)}');
                                  _params.addAll({
                                    'includedTags[]':
                                        provider.curFilter.values.first,
                                  });
                                }
                                debugPrint(
                                    'manga_discover_page: onTap: _params: $_params');
                                provider.updateDiscoverParam(_params);
                                provider.fetchMangaList(
                                  context,
                                  widget.mangaKey,
                                  params: provider
                                      .discoverParam[widget.mangaKey.key],
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: provider.curFilter.keys.isNotEmpty
                                    ? filter[index].toString().toLowerCase() ==
                                            provider.curFilter.keys.first
                                                .toLowerCase()
                                        ? Colors.amberAccent
                                        : Colors.white.withOpacity(.2)
                                    : Colors.white.withOpacity(.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Center(
                                child: Text(
                                  '${filter[index]}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${provider.total[widget.mangaKey.key]} mangas',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "by Popularity",
                      style: TextStyle(color: Colors.white),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: AllMangaWidget(
                  key: widget.key,
                  mangaKey: widget.mangaKey,
                  controller: widget.controller,
                  params: _params,
                  canLoadMore: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

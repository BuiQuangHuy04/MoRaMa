import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class MangaDiscoverWidget extends StatefulWidget {
  final MangaController controller;
  final String title;
  final MangaKey mangaKey;
  final bool hasFilter;

  const MangaDiscoverWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.mangaKey,
    this.hasFilter = true,
  });

  @override
  State<MangaDiscoverWidget> createState() => _MangaDiscoverWidgetState();
}

class _MangaDiscoverWidgetState extends State<MangaDiscoverWidget>
    with SingleTickerProviderStateMixin {
  final _filter = [];

  // final _params = <String, dynamic>{};
  bool _isFilterVisible = false;
  bool _isCategoryExpanded = false;

  @override
  void initState() {
    super.initState();
    _filter.addAll(
      includedTags.map((item) => item.keys.first).toList(),
    );

    _filter.addAll(
      publicationDemographic
          .map(
            (item) => item.split('')[0].toUpperCase() + item.substring(1),
          )
          .toList(),
    );

    var provider = Provider.of<MangaProvider>(context, listen: false);

    if (provider.manga[widget.mangaKey.key] != null) {
      provider.curPage[widget.mangaKey.key] = 0;
      provider.curOffset[widget.mangaKey.key] = 0;
    }

    if (provider.manga[widget.mangaKey.key] != null) {
      if (provider.manga[widget.mangaKey.key]!.isEmpty &&
          provider.manga[widget.mangaKey.key]!.isEmpty) {
        debugPrint('manga_discover_widget: call fetch: '
            'manga.${widget.mangaKey.key}.length: '
            '${provider.manga[widget.mangaKey.key]!.length}');

        if (mounted) {
          provider.fetchMangaList(
            context,
            widget.mangaKey,
          );
        }
        debugPrint('manga_discover_widget: after fetch: '
            'manga.${widget.mangaKey.key}.length: '
            '${provider.manga[widget.mangaKey.key]!.length}');
      }
    }
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isCategoryExpanded = !_isCategoryExpanded;
              });
            },
            icon: const Icon(Icons.filter_list_rounded),
          )
        ],
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
              widget.hasFilter ? _buildCategoryWidget() : Container(),
              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${provider.total[widget.mangaKey.key]} mangas',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isFilterVisible = !_isFilterVisible;
                        });
                      },
                      label: const Text(
                        "Sorting",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _isFilterVisible
                    ? _buildSortingWidget()
                    : const SizedBox.shrink(),
              ),
              AllMangaWidget(
                key: widget.key,
                mangaKey: widget.mangaKey,
                controller: widget.controller,
                canLoadMore: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryWidget() {
    return Consumer<MangaProvider>(builder: (
      context,
      provider,
      child,
    ) {
      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _isCategoryExpanded
            ? Container(
                margin: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    Wrap(
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _filter.map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCategoryItem(
                              context,
                              _filter.indexOf(item),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            : Container(
                height: 52,
                margin: const EdgeInsets.only(left: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filter.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return _buildCategoryItem(context, index);
                  },
                ),
              ),
      );
    });
  }

  Widget _buildCategoryItem(
    BuildContext context,
    int index,
  ) {
    return Consumer<MangaProvider>(builder: (
      context,
      provider,
      child,
    ) {
      return InkWell(
        onTap: () {
          //reset offset
          List<String> keysToRemove = [];

          for (var key in provider.params[widget.mangaKey.key]!.keys) {
            if (key.contains('offset')) {
              keysToRemove.add(key);
            }
          }

          for (var key in keysToRemove) {
            provider.params[widget.mangaKey.key]!.remove(key);
          }

          //handle choosing tag
          if (provider.curFilter.isEmpty ||
              provider.curFilter.keys.first != _filter[index]) {
            provider.updateFilter(
              _filter[index],
              widget.mangaKey,
            );

            if (provider.curFilter.values.isNotEmpty &&
                publicationDemographic
                    .contains(provider.curFilter.values.first.toLowerCase())) {
              debugPrint(
                  'manga_discover_page: onTap: publicationDemographic contain filter str: '
                  '${publicationDemographic.contains(provider.curFilter.values.first.toLowerCase())}');
              provider.params[widget.mangaKey.key]!.addAll({
                'publicationDemographic[]': [
                  provider.curFilter.values.first.toLowerCase(),
                ],
              });
            } else if (includedTags.contains(provider.curFilter)) {
              debugPrint(
                  'manga_discover_page: onTap: includedTags contain filter str: '
                  '${includedTags.contains(provider.curFilter)}');
              provider.params[widget.mangaKey.key]!.addAll({
                'includedTags[]': provider.curFilter.values.first,
              });
            }
            debugPrint('manga_discover_page: onTap: '
                'provider.params[widget.mangaKey.key]!: '
                '${provider.params[widget.mangaKey.key]!}');

            provider.fetchMangaList(
              context,
              widget.mangaKey,
            );
          } else {}
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: provider.curFilter.keys.isNotEmpty
                ? _filter[index].toString().toLowerCase() ==
                        provider.curFilter.keys.first.toLowerCase()
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
              '${_filter[index]}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSortingWidget() {
    return Consumer<MangaProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                children: MangaOrder.values.map(
                  (order) {
                    return ActionChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            order.label,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          provider.order[widget.mangaKey.key]!.keys
                                  .contains(order.value)
                              ? Icon(provider.order[widget.mangaKey.key]!.values
                                          .first ==
                                      Sorting.ASC.value
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded)
                              : Container(),
                        ],
                      ),
                      color: WidgetStatePropertyAll(provider
                              .order[widget.mangaKey.key]!.keys
                              .contains(order.value)
                          ? Colors.amberAccent.withOpacity(.6)
                          : Colors.grey.withOpacity(.6)),
                      onPressed: () {
                        var filter = order.value;
                        if (provider.order[widget.mangaKey.key] != null) {
                          if (provider.order[widget.mangaKey.key]!.isEmpty) {
                            provider.order[widget.mangaKey.key]!
                                .addAll({order.value: Sorting.ASC.value});
                          } else if (provider.order[widget.mangaKey.key]!.keys
                              .contains(filter)) {
                            var status = provider
                                .order[widget.mangaKey.key]!.values.first;

                            switch (status) {
                              case 'asc':
                                provider.order[widget.mangaKey.key]!.update(
                                  filter,
                                  (value) => Sorting.DESC.value,
                                );
                                break;
                              case 'desc':
                                provider.order[widget.mangaKey.key] = {};
                                break;
                              default:
                                break;
                            }
                          } else {
                            provider.order[widget.mangaKey.key] = {};
                            provider.order[widget.mangaKey.key]!
                                .addAll({order.value: Sorting.ASC.value});
                          }
                          provider.listeners();
                          debugPrint(
                              'filter in ${widget.mangaKey.key}: $filter');
                          debugPrint('cur filter in ${widget.mangaKey.key}: '
                              '$filter: ${provider.order[widget.mangaKey.key]}');

                          //
                          provider.curPage.update(
                              widget.mangaKey.key,
                              (value) =>
                                  provider.curPage[widget.mangaKey.key] = 0);
                          provider.curOffset.update(
                              widget.mangaKey.key,
                              (value) =>
                                  provider.curOffset[widget.mangaKey.key] = 0);
                          //
                          if (provider
                              .order[widget.mangaKey.key]!.values.isNotEmpty) {
                            if (provider
                                .params[widget.mangaKey.key]!.keys.isNotEmpty) {
                              List<String> keysToRemove = [];

                              for (var key in provider
                                  .params[widget.mangaKey.key]!.keys) {
                                if (key.contains('order') ||
                                    key.contains('offset')) {
                                  keysToRemove.add(key);
                                }
                              }

                              for (var key in keysToRemove) {
                                provider.params[widget.mangaKey.key]!
                                    .remove(key);
                              }
                            }
                            provider.params[widget.mangaKey.key]!.addAll({
                              'order[$filter]': provider
                                  .order[widget.mangaKey.key]!.values.first
                            });
                          } else {
                            if (provider
                                .params[widget.mangaKey.key]!.keys.isNotEmpty) {
                              List<String> keysToRemove = [];

                              for (var key in provider
                                  .params[widget.mangaKey.key]!.keys) {
                                debugPrint('key: $key');

                                if (key.contains('order') ||
                                    key.contains('offset')) {
                                  keysToRemove.add(key);
                                }
                              }

                              for (var key in keysToRemove) {
                                provider.params[widget.mangaKey.key]!
                                    .remove(key);
                                debugPrint('Removed key: $key');
                              }
                            }
                          }
                          //

                          if (provider.manga[widget.mangaKey.key]!.isNotEmpty) {
                            provider.manga[widget.mangaKey.key]!.clear();
                          }

                          if (mounted) {
                            provider.fetchMangaList(
                              context,
                              widget.mangaKey,
                            );
                          }
                        }
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

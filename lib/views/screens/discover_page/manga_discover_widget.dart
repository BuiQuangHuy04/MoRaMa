import '/views/index.dart';
import '/data/index.dart';
import '/core/index.dart';

class MangaDiscoverWidget extends StatefulWidget {
  final Map<String, dynamic>? params;
  final MangaController controller;
  final String title;

  const MangaDiscoverWidget({
    super.key,
    this.params,
    required this.controller,
    required this.title,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MangaProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              const Gap(16),
              Container(
                height: 52,
                margin: const EdgeInsets.only(left: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filter.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        provider.updateFilter(filter[index]);
                        if (widget.params != null) {
                          _params.addAll(widget.params!);
                        }
                        if (publicationDemographic.contains(
                            provider.curFilter.values.first.toLowerCase())) {
                          debugPrint(
                              'manga_discover_page: onTap: publicationDemographic contain filter str: '
                              '${publicationDemographic.contains(provider.curFilter.values.first.toLowerCase())}');
                          _params.addAll({
                            'publicationDemographic[]': [
                              provider.curFilter.values.first.toLowerCase(),
                            ],
                          });
                        } else if (includedTags.contains(provider.curFilter)) {
                          debugPrint(
                              'manga_discover_page: onTap: includedTags contain filter str: '
                              '${includedTags.contains(provider.curFilter)}');
                          _params.addAll({
                            'includedTags[]': provider.curFilter.values.first,
                          });
                        }
                        debugPrint(
                            'manga_discover_page: onTap: _params: $_params');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: provider.curFilter.keys.isNotEmpty
                              ? filter[index] == provider.curFilter.keys.first
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
              ),
              const Gap(16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "83 books",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "by Popularity",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16.0,
                  16,
                  16,
                  0,
                ),
                child: AllMangaWidget(
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

import '/core/index.dart';
import '/views/index.dart';
import '/data/index.dart';

class MangaHomeWidget extends StatefulWidget {
  final MangaController controller;

  const MangaHomeWidget({super.key, required this.controller});

  @override
  State<MangaHomeWidget> createState() => _MangaHomeWidgetState();
}

class _MangaHomeWidgetState extends State<MangaHomeWidget> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Clear input when closing search
      }
    });
  }

  void _performSearch() {
    String title = _searchController.text.trim();
    Map<String, dynamic> param = {'title': title};
    if (title.isNotEmpty) {
      // Fetch new data with query
      debugPrint("Fetching manga for param: $param");
      Provider.of<MangaProvider>(
        context,
        listen: false,
      ).params[MangaKey.SEARCH.key]!.addAll(param);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangaDiscoverWidget(
            mangaKey: MangaKey.SEARCH,
            controller: widget.controller,
            title: 'searching for "${_searchController.text.trim()}"',
            hasFilter: false,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    debugPrint('manga_home_widget init');
    var provider = Provider.of<MangaProvider>(
      context,
      listen: false,
    );
    for (var mangaKey in provider.manga.keys) {
      if (provider.manga[mangaKey] != null) {
        if (provider.manga[mangaKey]!.length > 10) {
          List<Manga> tempList = provider.manga[mangaKey]!.sublist(0, 10);
          provider.manga[mangaKey]!.clear();
          provider.manga[mangaKey]!.addAll(tempList);

          provider.curPage[mangaKey] = 0;
          provider.curOffset[mangaKey] = 0;
        }
      }
      ;
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('manga_home_widget: build');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _isSearching = false;
      },
      child: Scaffold(
        backgroundColor: MyColor.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: MyColor.scaffoldBackground,
          foregroundColor: MyColor.scaffoldForegroundColor,
          elevation: 0,
          title: _isSearching
              ? TextField(
                  onEditingComplete: () => _performSearch(),
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search by manga title...",
                    border: InputBorder.none,
                    focusColor: Colors.amberAccent,
                  ),
                )
              : const Text(
                  "HOME",
                ),
          centerTitle: true,
          actions: [
            _isSearching
                ? IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _performSearch(),
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _toggleSearch(),
                  ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReadingMangaContainer(controller: widget.controller),
              const Gap(16),
              CategoryTitleWidget(
                context: context,
                title: 'FOR YOU',
                screen: MangaDiscoverWidget(
                  key: Key(MangaKey.SUGGESTED.key),
                  mangaKey: MangaKey.SUGGESTED,
                  title: 'FOR YOU',
                  controller: widget.controller,
                  hasFilter: false,
                ),
              ),
              SuggestedMangaWidget(controller: widget.controller),
              const Gap(16),
              CategoryTitleWidget(
                context: context,
                title: 'ALL MANGA',
                screen: MangaDiscoverWidget(
                  key: Key(MangaKey.ALL.key),
                  mangaKey: MangaKey.ALL,
                  title: 'ALL MANGA',
                  controller: widget.controller,
                  hasFilter: false,
                ),
              ),
              AllMangaWidget(
                mangaKey: MangaKey.ALL,
                controller: widget.controller,
                canLoadMore: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

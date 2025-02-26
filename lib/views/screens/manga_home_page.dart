import '../../core/index.dart';
import '../../data/index.dart';
import 'bookmark_page/manga_bookmark_widget.dart';
import 'home_page/manga_home_widget.dart';
import 'discover_page/manga_discover_widget.dart';

class MangaHomePage extends StatefulWidget {
  const MangaHomePage({super.key});

  @override
  State<MangaHomePage> createState() => _MangaHomePageState();
}

class _MangaHomePageState extends State<MangaHomePage> {
  final _controller = MangaController(MangaRepo());
  final PageController _pageController = PageController();

  final listNavigatorIcon = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.explore_outlined),
      label: "Discover",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark_border),
      label: "Bookmark",
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.person_outline_outlined),
    //   label: "Profile",
    // )
  ];

  late List<Widget> listPageView;

  @override
  void initState() {
    super.initState();

    var provider = Provider.of<MangaProvider>(context, listen: false);

    listPageView = [
      MangaHomeWidget(
        controller: _controller,
      ),
      MangaDiscoverWidget(
        key: Key(MangaKey.DISCOVER.key),
        mangaKey: MangaKey.DISCOVER,
        controller: _controller,
        title: 'DISCOVER MANGA',
        params: provider.discoverParam[MangaKey.DISCOVER.key],
      ),
      MangaBookmarkWidget(
        controller: _controller,
      ),
      // MangaProfileWidget(),
    ];

    Future.microtask(() {
      if (mounted) {
        provider.fetchMangaList(
          context,
          MangaKey.READING,
          params: provider.discoverParam[MangaKey.READING.key],
        );
      }
    });

    Future.microtask(() {
      if (mounted) {
        provider.fetchMangaList(
          context,
          MangaKey.SUGGESTED,
          params: provider.discoverParam[MangaKey.SUGGESTED.key],
        );
      }
    });

    Future.microtask(() {
      if (mounted) {
        provider.fetchMangaList(
          context,
          MangaKey.ALL,
          params: provider.discoverParam[MangaKey.ALL.key],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('manga_home_page: build');
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider provider, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: listPageView,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            showUnselectedLabels: false,
            showSelectedLabels: true,
            selectedItemColor: Colors.amberAccent,
            unselectedItemColor: Colors.grey,
            currentIndex: provider.curPageIdx,
            onTap: (idx) {
              provider.updateCurPage(idx);
              _pageController.jumpToPage(idx);
            },
            items: listNavigatorIcon,
          ),
        );
      },
    );
  }
}

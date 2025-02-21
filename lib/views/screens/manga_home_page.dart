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

    listPageView = [
      MangaHomeWidget(
        controller: _controller,
      ),
      MangaDiscoverWidget(
        controller: _controller,
        title: 'ALL MANGA',
        params: const {
          'limit': '10',
        },
      ),
      MangaBookmarkWidget(
        controller: _controller,
      ),
      // MangaProfileWidget(),
    ];

    var provider = Provider.of<MangaProvider>(context, listen: false);

    Future.microtask(() {
      if (mounted) {
        provider.fetchMangaList(
          context,
          MangaKey.READING.key,
          params: {
            'title': 'solo leveling',
          },
        );
      }
    });

    Future.microtask(() {
      if (mounted) {
        provider.fetchMangaList(
          context,
          MangaKey.SUGGESTED.key,
          params: {
            "status[]": ["completed"],
            'contentRating[]': ['suggestive']
          },
        );
      }
    });

    Future.microtask(() {
      if (mounted) {
        provider.fetchMangaList(
          context,
          MangaKey.ALL.key,
          params: provider.discoverParam,
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

import 'package:flutter/material.dart';
import '../../data/index.dart';
import 'home_page/manga_home_widget.dart';
import 'discover_page/manga_discover_widget.dart';
import 'bookmark_page/manga_bookmark_widget.dart';
import 'profile_page/manga_profile_widget.dart';

class MangaHomePage extends StatefulWidget {
  const MangaHomePage({super.key});

  @override
  State<MangaHomePage> createState() => _MangaHomePageState();
}

class _MangaHomePageState extends State<MangaHomePage> {
  var pageIndex = 0;
  final _controller = MangaController(MangaRepo());

  // final List<Widget> _screens = [
  //   MangaHomeWidget(controller: _controller,),
  //   MangaDiscoverWidget(controller: _controller,),
  //   MangaBookmarkWidget(),
  //   MangaProfileWidget(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(
          index: pageIndex,
          children: [
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
            MangaBookmarkWidget(),
            MangaProfileWidget(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.grey,
        onTap: (idx) {
          setState(() {
            pageIndex = idx;
          });
        },
        currentIndex: pageIndex,
        items: const [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: "Profile",
          )
        ],
      ),
    );
  }
}

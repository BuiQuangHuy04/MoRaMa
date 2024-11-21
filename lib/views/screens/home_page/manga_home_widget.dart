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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: MyColor.scaffoldBackground,
        foregroundColor: MyColor.scaffoldForegroundColor,
        elevation: 0,
        title: const Text("NOW"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
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
                title: 'FOR YOU',
                controller: widget.controller,
                params: const {
                  // "status[]": ["completed"],
                  'contentRating[]': ['suggestive'],
                },
              ),
            ),
            SuggestedMangaWidget(controller: widget.controller),
            const Gap(16),
            CategoryTitleWidget(
              context: context,
              title: 'ALL MANGA',
              screen: MangaDiscoverWidget(
                title: 'ALL MANGA',
                controller: widget.controller,
                params: const {
                  'limit': '10',
                },
              ),
            ),
            AllMangaWidget(
              controller: widget.controller,
              canLoadMore: false,
            ),
          ],
        ),
      ),
    );
  }
}

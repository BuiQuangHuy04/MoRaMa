import '/data/index.dart';
import '/core/index.dart';

class MangaProvider with ChangeNotifier, DiagnosticableTreeMixin {
  static final MangaProvider _instance = MangaProvider._internal();

  MangaProvider._internal();

  factory MangaProvider() {
    return _instance;
  }

  void listeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  var readingManga = Manga();
  var suggestedMangas = <Manga>[];
  var allMangas = <Manga>[];

  Map<String, String> curFilter = <String, String>{};

  void updateFilter(String filter) {
    debugPrint('manga_provider: updateFilter: filter: $filter');
    debugPrint('manga_provider: updateFilter: curFilter: $curFilter');
    debugPrint(
      'manga_provider: updateFilter: includedTags contains filterStr: '
      '${includedTags.any((tag) => tag.keys.contains(filter)).toString()}',
    );

    curFilter.clear();

    if (includedTags.any((tag) => tag.keys.contains(filter))) {
      curFilter = includedTags.firstWhere((tag) => tag.keys.contains(filter));
    } else {
      curFilter.addAll({'publicationDemographic': filter});
    }

    debugPrint('manga_provider: updateFilter: updated curFilter: $curFilter');
    listeners();
  }

  void updateReadingManga(Manga manga) {
    readingManga = manga;
    debugPrint('manga_provider: readingManga.id: ${readingManga.id}');
    listeners();
  }

  void updateSuggestedMangas(List<Manga> mangas) {
    suggestedMangas = mangas;
    debugPrint(
        'suggestedMangas.length: readingManga.id: ${suggestedMangas.length.toString()}');
    listeners();
  }

  void updateAllMangas(List<Manga> mangas) {
    allMangas = mangas;
    debugPrint(
        'allMangas.length: allMangas.id: ${allMangas.length.toString()}');
    listeners();
  }

  void refresh() {
    suggestedMangas.clear();
    allMangas.clear();
    curFilter = <String, String>{};
    listeners();
  }
}

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

  //check if home data is loaded?
  Map<String, bool> isLoading = {
    MangaKey.READING.key: false,
    MangaKey.SUGGESTED.key: false,
    MangaKey.ALL.key: false,
  };

  Map<String, String?> error = {
    MangaKey.READING.key: null,
    MangaKey.SUGGESTED.key: null,
    MangaKey.ALL.key: null,
  };

  Map<String, List<Manga>> manga = {
    MangaKey.READING.key: [],
    MangaKey.SUGGESTED.key: [],
    MangaKey.ALL.key: [],
  };

  Future<void> fetchMangaList(
    BuildContext context,
    String mangaKey, {
    Map<String, dynamic>? params,
  }) async {
    try {
      isLoading[mangaKey] = true;
      error[mangaKey] = null;

      // Fetch data using your controller
      final baseMangaRes = await MangaController(MangaRepo()).fetchListManga(
        context,
        params: params,
      );

      if (baseMangaRes.listManga != null) {
        manga[mangaKey]?.addAll(baseMangaRes.listManga!);
      }

      if (mangaKey == MangaKey.ALL.key) {
        total = baseMangaRes.total!;
      }
    } catch (e) {
      error[mangaKey] = e.toString();
    } finally {
      isLoading[mangaKey] = false;

      debugPrint('isLoading: ${isLoading[mangaKey]}');
      debugPrint('error: ${error[mangaKey]}');
      debugPrint('manga: ${manga[mangaKey]!.length}');

      listeners();
      // notifyListeners();
    }
  }

  //total manga in discover tab
  var total = 0;

  void updateTotalManga(int n) {
    total = n;
    debugPrint('manga_provider: updateTotalManga: $total');
    listeners();
  }

  //filter in discover tab
  Map<String, String> curFilter = <String, String>{};

  void updateFilter(String filter) {


    if (curFilter.keys.isNotEmpty) {
      if (filter != curFilter.keys.first) {
        manga[MangaKey.ALL.key]!.clear();
      }
    } else {
      manga[MangaKey.ALL.key]!.clear();
    }

    var tempFilter = convertFilterStr(filter);

    if (tempFilter != null) {
      curFilter = tempFilter;
    } else {
      debugPrint(
          'manga_provider: updateFilter: Error - Filter not found in includedTags');
      return;
    }

    debugPrint('manga_provider: updateFilter: updated curFilter: $curFilter');
    listeners();
  }

  Map<String, String>? convertFilterStr(String filter) {
    if (includedTags.any((tag) {
      return tag.keys.any((key) {
        return key.toLowerCase() == filter.toLowerCase();
      });
    })) {
      return includedTags.firstWhere((tag) {
        return tag.keys.any((key) {
          return key == filter;
        });
      });
    }
    if (publicationDemographic.contains(filter.toLowerCase())) {
      return {'publicationDemographic': filter};
    }
    return null;
  }

  //paging in all manga tab
  var curOffset = 0;
  var curPage = 0;
  Map<String, dynamic> discoverParam = {};

  void updateDiscoverParam(Map<String, dynamic> param) {
    if (!mapEquals(discoverParam, {...discoverParam, ...param})) {
      discoverParam.addAll(param);
      listeners();
    }
  }

  VoidCallback? nextOffset({Map<String, dynamic>? param}) {
    curPage += 1;
    curOffset = curPage * 10;
    if (discoverParam.containsKey('offset')) {
      discoverParam.update('offset', (value) => curOffset.toString());
    } else {
      discoverParam.addAll({'offset': curOffset.toString()});
    }
    if (param != null) {
      discoverParam.addAll(param);
    }

    listeners();
    return null;
  }

  VoidCallback? preOffset({Map<String, dynamic>? param}) {
    curPage -= 1;
    curOffset = curPage * 10;
    discoverParam.update('offset', (value) => curOffset.toString());
    if (param != null) {
      discoverParam.addAll(param);
    }
    listeners();
    return null;
  }

  //refresh
  void refresh() {
    total = 0;
    curFilter = <String, String>{};
    listeners();
  }
}

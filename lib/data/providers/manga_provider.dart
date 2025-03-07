import 'dart:async';

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

  Map<String, bool> isLoading = {
    MangaKey.READING.key: false,
    MangaKey.SUGGESTED.key: false,
    MangaKey.ALL.key: false,
    MangaKey.SEARCH.key: false,
    MangaKey.DISCOVER.key: false,
    MangaKey.FAVORITE.key: false,
  };

  Map<String, String?> error = {
    MangaKey.READING.key: null,
    MangaKey.SUGGESTED.key: null,
    MangaKey.ALL.key: null,
    MangaKey.SEARCH.key: null,
    MangaKey.DISCOVER.key: null,
    MangaKey.FAVORITE.key: null,
  };

  Map<String, List<Manga>> manga = {
    MangaKey.READING.key: [],
    MangaKey.SUGGESTED.key: [],
    MangaKey.ALL.key: [],
    MangaKey.SEARCH.key: [],
    MangaKey.DISCOVER.key: [],
    MangaKey.FAVORITE.key: [],
  };

  Map<String, int> total = {
    MangaKey.READING.key: 0,
    MangaKey.SUGGESTED.key: 0,
    MangaKey.ALL.key: 0,
    MangaKey.SEARCH.key: 0,
    MangaKey.DISCOVER.key: 0,
    MangaKey.FAVORITE.key: 0,
  };

  Map<String, int> curOffset = {
    MangaKey.READING.key: 0,
    MangaKey.SUGGESTED.key: 0,
    MangaKey.ALL.key: 0,
    MangaKey.SEARCH.key: 0,
    MangaKey.DISCOVER.key: 0,
    MangaKey.FAVORITE.key: 0,
  };

  Map<String, int> curPage = {
    MangaKey.READING.key: 0,
    MangaKey.SUGGESTED.key: 0,
    MangaKey.ALL.key: 0,
    MangaKey.SEARCH.key: 0,
    MangaKey.DISCOVER.key: 0,
    MangaKey.FAVORITE.key: 0,
  };

  Map<String, Map<String, dynamic>> params = {
    MangaKey.READING.key: {},
    MangaKey.SUGGESTED.key: {
      "status[]": ["completed"],
      'contentRating[]': ['suggestive'],
    },
    MangaKey.ALL.key: {
      "status[]": ["completed"],
    },
    MangaKey.SEARCH.key: {
      "status[]": ["completed"],
    },
    MangaKey.DISCOVER.key: {},
    MangaKey.FAVORITE.key: {},
  };

  Map<String, Map<String, String>> order = {
    MangaKey.SUGGESTED.key: {},
    MangaKey.ALL.key: {},
    MangaKey.SEARCH.key: {},
    MangaKey.DISCOVER.key: {},
  };

  //check if home data is loaded?
  Future<void> fetchMangaList(
    BuildContext context,
    MangaKey mangaKey, {
    bool? addToOld,
  }) async {
    try {
      isLoading[mangaKey.key] = true;
      error[mangaKey.key] = null;

      debugPrint('manga_provider: fetch list manga: order in '
          '${mangaKey.key}: ${order[mangaKey.key]}');

      if (order[mangaKey.key] != null) {
        if (order[mangaKey.key]!.isNotEmpty) {
          params[mangaKey.key]!.addAll({
            'order[${order[mangaKey.key]!.keys.first}]':
                order[mangaKey.key]!.values.first
          });
        }
      }

      if (params[mangaKey.key]!.containsKey('offset')) {
        params[mangaKey.key]!
            .update('offset', (value) => curOffset[mangaKey.key].toString());
      } else {
        params[mangaKey.key]!
            .addAll({'offset': curOffset[mangaKey.key].toString()});
      }

      debugPrint('manga_provider: fetch list manga: params in '
          '${mangaKey.key}: ${params[mangaKey.key]}');

      // Fetch data using your controller
      final baseMangaRes = await MangaController(MangaRepo()).fetchListManga(
        context,
        mangaKey,
        params: params[mangaKey.key],
        provider: this,
      );

      if (baseMangaRes.listManga != null) {
        if (addToOld == false) {
          manga[mangaKey.key]?.clear();
        }
        manga[mangaKey.key]?.addAll(baseMangaRes.listManga!);
      }

      updateTotalManga(baseMangaRes.total!, mangaKey);
    } catch (e) {
      error[mangaKey.key] = e.toString();
    } finally {
      isLoading[mangaKey.key] = false;

      debugPrint('manga_provider: fetch list manga: isLoading '
          '${mangaKey.key}: ${isLoading[mangaKey.key]}');
      debugPrint('manga_provider: fetch list manga: error '
          '${mangaKey.key}: ${error[mangaKey.key]}');
      debugPrint('manga_provider: fetch list manga: manga '
          '${mangaKey.key}: ${manga[mangaKey.key]!.length}');

      listeners();
    }
  }

  //total manga in discover tab
  void updateTotalManga(int n, MangaKey mangaKey) {
    total[mangaKey.key] = n;
    debugPrint('manga_provider: updateTotalManga in '
        '${mangaKey.key}: ${total[mangaKey.key]}');
    listeners();
  }

  //filter in discover tab
  Map<String, String> curFilter = <String, String>{};

  void updateFilter(String filter, MangaKey mangaKey) {
    if (curFilter.keys.isNotEmpty) {
      if (filter != curFilter.keys.first) {
        manga[mangaKey.key]!.clear();

        curOffset[mangaKey.key] = 0;
        curPage[mangaKey.key] = 0;
        params[mangaKey.key] = {};
      }
    } else {
      manga[mangaKey.key]!.clear();

      curOffset[mangaKey.key] = 0;
      curPage[mangaKey.key] = 0;
      params[mangaKey.key] = {};
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

  //TODO
  //sorting in discover manga tab

  //paging in discover manga tab
  void updateDiscoverParam(Map<String, dynamic> param) {
    if (!mapEquals(params[MangaKey.DISCOVER.key],
        {...params[MangaKey.DISCOVER.key]!, ...param})) {
      params[MangaKey.DISCOVER.key]!.addAll(param);
      listeners();
    }
  }

  void nextOffset(MangaKey mangaKey, {Map<String, dynamic>? param}) {
    curPage[mangaKey.key] = curPage[mangaKey.key]! + 1;
    curOffset[mangaKey.key] = curPage[mangaKey.key]! * 10;
    if (params[mangaKey.key]!.containsKey('offset')) {
      params[mangaKey.key]!
          .update('offset', (value) => curOffset[mangaKey.key].toString());
    } else {
      params[mangaKey.key]!
          .addAll({'offset': curOffset[mangaKey.key].toString()});
    }
    if (param != null) {
      params[mangaKey.key]!.addAll(param);
    }

    listeners();
  }

  void preOffset(MangaKey mangaKey, {Map<String, dynamic>? param}) {
    curPage[mangaKey.key] = curPage[mangaKey.key]! - 1;
    curOffset[mangaKey.key] = curPage[mangaKey.key]! * 10;
    if (params[mangaKey.key]!.containsKey('offset')) {
      params[mangaKey.key]!
          .update('offset', (value) => curOffset[mangaKey.key].toString());
    } else {
      params[mangaKey.key]!
          .addAll({'offset': curOffset[mangaKey.key].toString()});
    }
    if (param != null) {
      params[mangaKey.key]!.addAll(param);
    }
    listeners();
  }

  //refresh
  void refresh() {
    curFilter = <String, String>{};
    listeners();
  }

  //manga favorite
  void toggleFavorite(Manga favoriteManga) async {
    if (manga[MangaKey.FAVORITE.key]!.any((m) => m.id == favoriteManga.id)) {
      manga[MangaKey.FAVORITE.key]!
          .removeWhere((m) => m.id == favoriteManga.id);
    } else {
      manga[MangaKey.FAVORITE.key]!.add(favoriteManga);
    }
    listeners();
    await _saveFavorites();
  }

  bool isFavorite(Manga favoriteManga) {
    return manga[MangaKey.FAVORITE.key]!.any((m) => m.id == favoriteManga.id);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> idList =
        manga[MangaKey.FAVORITE.key]!.map((manga) => manga.id!).toList();
    await prefs.setStringList('favorite_mangas', idList).whenComplete(() {
      debugPrint('save favorite: saved: $idList');
    });
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? idList = prefs.getStringList('favorite_mangas');

    debugPrint('load favorite: loaded: $idList');
    if (idList != null) {
      for (String id in idList) {
        var _manga = await MangaController(MangaRepo()).fetchManga(
          id,
        );
        manga[MangaKey.FAVORITE.key]!.add(_manga);
      }

      listeners();
    }
  }

//chapters bookmark saving
// click read a chapter
// -> chapter img fetching
// -> save chapter id with manga id as Map in SP
//
// chapters bookmark loading
// app start
// -> load reading manga -> click on that -> show the reading progressing
}

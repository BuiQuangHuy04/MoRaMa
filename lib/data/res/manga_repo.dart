import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../core/index.dart';
import '../../data/index.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MangaRepo implements Repository {
  static final MangaRepo _instance = MangaRepo._internal();

  MangaRepo._internal();

  factory MangaRepo() {
    return _instance;
  }

  // Maximum number of retries
  final int maxRetries = 3;

  // Helper method to handle retries and backoff
  Future<http.Response> _makeRequestWithRetries(
    Uri url, {
    int retries = 0,
    Duration backoff = const Duration(seconds: 2),
  }) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 429) {
        // If rate limited, check retry attempts
        if (retries < maxRetries) {
          await Future.delayed(backoff);
          return _makeRequestWithRetries(
            url,
            retries: retries + 1,
            backoff: backoff * 2, // Exponential backoff
          );
        } else {
          throw Exception('Exceeded max retries due to rate limits');
        }
      }

      return response;
    } catch (e) {
      debugPrint('Error during request: ${e.toString()}');
      rethrow;
    }
  }

  // Parameter validation helper
  void _validateParameter(String name, String? value) {
    if (value == null || value.isEmpty) {
      throw ArgumentError('$name cannot be null or empty');
    }
  }

  @override
  Future<Manga> getManga(
    String id,
  ) async {
    var url = Uri.https(
      Constants.api,
      Constants.mangaEP + id,
      {
        'includes[]': [
          'cover_art',
          'artist',
          'author',
        ],
      },
    );

    debugPrint('manga_repo: getManga url: $url');

    final response = await _makeRequestWithRetries(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Manga.fromJson(json['data']);
    } else {
      throw Exception('Failed to load manga list: ${response.body}');
    }
  }

  @override
  Future<BaseMangaResponse> getListManga(BuildContext context,
      {Map<String, dynamic>? params}) async {
    Map<String, dynamic> params0 = {
      'status[]': ['completed'],
      'includes[]': ['cover_art', 'artist', 'author'],
      // 'limit':'20',
    };

    if (params != null) {
      params0.addAll(params);
      debugPrint('manga_repo: getListManga: _params: $params0');
    }

    var url = Uri.https(
      Constants.api,
      Constants.mangaEP,
      params0,
    );

    debugPrint('manga_repo: getListManga url: $url');

    final response = await _makeRequestWithRetries(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return BaseMangaResponse.fromJson(json);
    } else {
      throw Exception('Failed to load manga list: ${response.body}');
    }
  }

  @override
  Future<String> getFileNameCover({required String mangaId}) async {
    _validateParameter('mangaId', mangaId); // Validate mangaId

    String fileName = '';

    Map<String, dynamic> params = {
      'includes[]': ['cover_art', 'artist', 'author'],
    };

    var url = Uri.https(
      Constants.api,
      Constants.mangaEP + mangaId,
      params,
    );

    // debugPrint('manga_repo: getFileNameCover: url: $url');

    final response = await _makeRequestWithRetries(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final baseCoverRes = BaseCoverRes.fromJson(json);

      if (baseCoverRes.cover != null) {
        for (var relationship in baseCoverRes.cover!.relationships!) {
          if (relationship.type == Relationship.coverArt.value) {
            fileName = relationship.attributes!.fileName!;
            break;
          }
        }
      }
    }

    return fileName;
  }

  @override
  Future<List<Chapter>> getListChapter({
    required String mangaId,
    Map<String, dynamic>? params,
  }) async {
    _validateParameter('mangaId', mangaId); // Validate mangaId

    List<Chapter> ungroupedChapters = [];

    Map<String, dynamic> params0 = {
      'includes[]': ['scanlation_group', 'manga', 'user'],
    };

    if (params != null) {
      params0.addAll(params);
      debugPrint('manga_repo: getListChapter: _params: $params0');
    }

    var url = Uri.https(
      Constants.api,
      Constants.mangaEP + mangaId + Constants.chapterEP,
      params0,
    );

    debugPrint('manga_repo: getListChapter: url: $url');

    final response = await _makeRequestWithRetries(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final baseChapterRes = BaseChapterRes.fromJson(json);

      // debugPrint('manga_repo: getListChapter: baseChapterRes: $baseChapterRes');

      if (baseChapterRes.chapters != null) {
        ungroupedChapters.addAll(baseChapterRes.chapters!);
        try {
          ungroupedChapters.sort((a, b) => int.parse(a.attributes!.chapter!)
              .compareTo(int.parse(b.attributes!.chapter!)));
        } catch (e) {
          ungroupedChapters.sort((a, b) {
            DateTime dateTimeA = DateFormat('dd/MM/yyyy HH:MM')
                .parse(a.attributes!.publishAt.toString());
            DateTime dateTimeB = DateFormat('dd/MM/yyyy HH:MM')
                .parse(b.attributes!.publishAt.toString());

            return dateTimeB.millisecondsSinceEpoch
                .compareTo(dateTimeA.millisecondsSinceEpoch);
          });
        }
      }
    } else {
      debugPrint(
          'manga_repo: getListChapter: response: ${response.body.toString()}');
    }

    debugPrint(
        'manga_repo: getListChapter: chapters length: ${ungroupedChapters.length.toString()}');

    var groupedChapters = groupChaptersByRelationshipName(ungroupedChapters);

    List<Chapter> chapters = [];

    groupedChapters.forEach((key, value) {
      debugPrint("Group: $key");
      for (var chapter in value) {
        // debugPrint(" - ${chapter.attributes?.chapter}: ${chapter.attributes?.title}");
        chapters.add(chapter);
      }
    });

    return chapters;
  }

  Map<String, List<Chapter>> groupChaptersByRelationshipName(
      List<Chapter> chapters) {
    return groupBy(chapters, (Chapter chapter) {
      // return chapter.relationships?.first.attributes?.name ?? "Unknown";
      return chapter.attributes!.chapter ?? 'Unknown';
    });
  }

  @override
  Future<ChapterResource> getListChapterImg({
    required String chapterId,
    Map<String, dynamic>? params,
  }) async {
    _validateParameter('chapterId', chapterId); // Validate chapterId

    ChapterResource chaptersImg = ChapterResource();

    var url = Uri.https(
      Constants.api,
      Constants.chapterMediaEP + chapterId,
      params,
    );

    final response = await _makeRequestWithRetries(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final chapterImgRes = ChapterResourceBaseRes.fromJson(json);

      if (chapterImgRes.chapter != null) {
        chaptersImg = chapterImgRes.chapter!;
      }
    }

    return chaptersImg;
  }
}

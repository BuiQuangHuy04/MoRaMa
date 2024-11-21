import '../../core/index.dart';
import '../../data/index.dart';
import 'package:http/http.dart' as http;

class MangaRepo implements Repository {
  @override
  Future<List<Manga>> getListManga({Map<String, dynamic>? params}) async {
    try {
      List<Manga> listManga = [];

      Map<String, dynamic> params0 = {
        // 'contentRating[]': ['safe'],
        'status[]': ['completed'],
        'includes[]': ['cover_art', 'artist', 'author'],
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

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final baseMangaRes = BaseMangaResponse.fromJson(json);

        final list = baseMangaRes.listManga;
        if (list != null) {
          listManga.addAll(list);
        }

        return listManga;
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<String> getFileNameCover({required String mangaId}) async {
    try {
      String fileName = '';

      Map<String, dynamic> params = {
        'includes[]': ['cover_art', 'artist', 'author'],
      };

      debugPrint('manga_repo: getFileNameCover: _params: $params');

      var url = Uri.https(
        Constants.api,
        Constants.mangaEP + mangaId,
        params,
      );

      // debugPrint('manga_repo: getFileNameCover url: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final baseCoverRes = BaseCoverRes.fromJson(json);

        if (baseCoverRes.cover != null) {
          if (baseCoverRes.cover!.relationships != null) {
            for (var relationship in baseCoverRes.cover!.relationships!) {
              if (relationship.type == Relationship.coverArt.value) {
                fileName = relationship.attributes!.fileName!;
                break;
              }
            }
          }
        }
        return fileName;
      } else {
        return fileName;
      }
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }

  @override
  Future<List<Chapter>> getListChapter({
    required String mangaId,
    Map<String, dynamic>? params,
  }) async {
    try {
      List<Chapter> chapters = [];

      Map<String, dynamic> params0 = {
        'includes[]': ['scanlation_group', 'manga', 'user'],
      };

      if (params != null) {
        params0.addAll(params);
        debugPrint('manga_repo: getListManga: _params: $params0');
      }

      var url = Uri.https(
        Constants.api,
        Constants.mangaEP + mangaId.toString() + Constants.chapterEP,
        params0,
      );

      debugPrint('manga_repo: getListChapter url: $url');

      final response = await http.get(url);

      //https://api.mangadex.org/manga/ade0306c-f4b6-4890-9edb-1ddf04df2039/feed?includeFuturePublishAt=0
      //https://api.mangadex.org/manga/ade0306c-f4b6-4890-9edb-1ddf04df2039/feed/%3FincludeFuturePublishAt=0

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final baseChapterRes = BaseChapterRes.fromJson(json);

        if (baseChapterRes.chapters != null) {
          chapters.addAll(baseChapterRes.chapters!);

          chapters.sort(
            (a, b) => int.parse(a.attributes!.chapter!).compareTo(
              int.parse(b.attributes!.chapter!),
            ),
          );

          // debugPrint('manga_repo: chapter length: ${chapters.length.toString()}');
        }
        return chapters;
      } else {
        return chapters;
      }
    } catch (e) {
      debugPrint('manga_repo: getListChapter: err: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<ChapterResource> getListChapterImg({
    required String chapterId,
    Map<String, dynamic>? params,
  }) async {
    try {
      ChapterResource chaptersImg = ChapterResource();

      var url = Uri.https(
        Constants.api,
        Constants.chapterMediaEP+chapterId,
        params,
      );

      // debugPrint('manga_repo: getListChapterImg url: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final chapterImgRes = ChapterResourceBaseRes.fromJson(json);

        if (chapterImgRes.chapter != null) {
          if (chapterImgRes.chapter!.data != null) {
            chaptersImg = chapterImgRes.chapter!;
          }
        }
      }
      debugPrint(chaptersImg.data!.length.toString());
      return chaptersImg;
    } catch (e) {
      debugPrint('manga_repo: getListChapterImg: err: ${e.toString()}');
      return ChapterResource();
    }
  }
}

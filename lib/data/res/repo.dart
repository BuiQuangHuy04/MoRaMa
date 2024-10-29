import 'package:morama/data/index.dart';

abstract class Repository {
  Future<List<Manga>> getListManga({Map<String, dynamic>? params});

  Future<String> getFileNameCover({required String mangaId});

  Future<List<Chapter>> getListChapter({
    required String mangaId,
    Map<String, dynamic>? params,
  });

  Future<ChapterResource> getListChapterImg({
    required String chapterId,
    Map<String, dynamic>? params,
  });
}

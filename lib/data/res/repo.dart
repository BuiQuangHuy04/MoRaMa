import 'package:flutter/cupertino.dart';
import 'package:morama/data/index.dart';

import '../../core/index.dart';

abstract class Repository {
  Future<Manga> getManga(
    String id,
  );

  Future<BaseMangaResponse> getListManga(
    BuildContext context,
    MangaKey mangaKey, {
    Map<String, dynamic>? params,
    MangaProvider? provider,
  });

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

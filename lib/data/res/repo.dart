import 'package:flutter/cupertino.dart';
import 'package:morama/data/index.dart';

abstract class Repository {
  Future<BaseMangaResponse> getListManga(BuildContext context, {Map<String, dynamic>? params});

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

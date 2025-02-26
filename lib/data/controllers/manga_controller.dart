import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../index.dart';

class MangaController {
  MangaController(this._repo);

  final Repository _repo;

  Future<Object> mockFetch(dynamic object) {
    return Future.delayed(Duration.zero, () => object);
  }

  Future<Manga> fetchManga(String id) {
    return _repo.getManga(id);
  }

  Future<BaseMangaResponse> fetchListManga(BuildContext context,
      {Map<String, dynamic>? params}) {
    return _repo.getListManga(context, params: params);
  }

  Future<String> fetchFileNameCover({required String mangaId}) {
    return _repo.getFileNameCover(mangaId: mangaId);
  }

  Future<List<Chapter>> fetchListChapter({
    required String mangaId,
    Map<String, dynamic>? params,
  }) {
    return _repo.getListChapter(
      mangaId: mangaId,
      params: params,
    );
  }

  Future<ChapterResource> fetchListChapterImg({
    required String chapterId,
    Map<String, dynamic>? params,
  }) {
    return _repo.getListChapterImg(
      chapterId: chapterId,
      params: params,
    );
  }
}

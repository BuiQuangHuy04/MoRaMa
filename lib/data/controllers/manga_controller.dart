import '../index.dart';

class MangaController {
  MangaController(this._repo);

  final Repository _repo;

  Future<List<Manga>> fetchListManga({Map<String, dynamic>? params}) {
    return _repo.getListManga(params: params);
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

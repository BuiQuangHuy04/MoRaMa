import '../../index.dart';

class BaseMangaResponse {
  String? result;
  String? response;
  List<Manga>? listManga;
  int? limit;
  int? offset;
  int? total;

  BaseMangaResponse({
    this.result,
    this.response,
    this.listManga,
    this.limit,
    this.offset,
    this.total,
  });

  BaseMangaResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'];
    if (json['data'] != null) {
      listManga = <Manga>[];
      json['data'].forEach((v) {
        listManga!.add(Manga.fromJson(v));
      });
    }
    limit = json['limit'];
    offset = json['offset'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['response'] = response;
    if (this.listManga != null) {
      data['data'] = this.listManga!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['offset'] = offset;
    data['total'] = total;
    return data;
  }

  @override
  String toString() {
    return 'BaseMangaResponse{result: $result, response: $response, listManga: $listManga, limit: $limit, offset: $offset, total: $total}';
  }
}


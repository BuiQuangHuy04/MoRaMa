class ChapterResourceBaseRes {
  String? result;
  String? baseUrl;
  ChapterResource? chapter;

  ChapterResourceBaseRes({
    this.result,
    this.baseUrl,
    this.chapter,
  });

  ChapterResourceBaseRes.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    baseUrl = json['baseUrl'];
    chapter = json['chapter'] != null
        ? ChapterResource.fromJson(json['chapter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['baseUrl'] = baseUrl;
    if (chapter != null) {
      data['chapter'] = chapter!.toJson();
    }
    return data;
  }
}

class ChapterResource {
  String? hash;
  List<String>? data;
  List<String>? dataSaver;

  ChapterResource({
    this.hash,
    this.data,
    this.dataSaver,
  });

  ChapterResource.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    data = json['data'].cast<String>();
    dataSaver = json['dataSaver'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hash'] = hash;
    data['data'] = this.data;
    data['dataSaver'] = dataSaver;
    return data;
  }
}

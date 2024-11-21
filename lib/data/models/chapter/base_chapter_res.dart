import '../../../core/constant.dart';

class BaseChapterRes {
  String? result;
  String? response;
  List<Chapter>? chapters;
  int? limit;
  int? offset;
  int? total;

  BaseChapterRes({
    this.result,
    this.response,
    this.chapters,
    this.limit,
    this.offset,
    this.total,
  });

  BaseChapterRes.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'];
    if (json['data'] != null) {
      chapters = <Chapter>[];
      json['data'].forEach((v) {
        chapters!.add(Chapter.fromJson(v));
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
    if (chapters != null) {
      data['data'] = chapters!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['offset'] = offset;
    data['total'] = total;
    return data;
  }
}

class Chapter {
  String? id;
  String? type;
  ChapterAttributes? attributes;
  List<ChapterRelationships>? relationships;

  Chapter({
    this.id,
    this.type,
    this.attributes,
    this.relationships,
  });

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? ChapterAttributes.fromJson(json['attributes'])
        : null;
    if (json['relationships'] != null) {
      relationships = <ChapterRelationships>[];
      json['relationships'].forEach((v) {
        relationships!.add(ChapterRelationships.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    if (relationships != null) {
      data['relationships'] = relationships!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChapterAttributes {
  // Null? volume;
  String? chapter;
  String? title;
  String? translatedLanguage;

  // Null? externalUrl;
  String? publishAt;
  String? readableAt;
  String? createdAt;
  String? updatedAt;
  int? pages;
  int? version;

  ChapterAttributes({
    // this.volume,
    this.chapter,
    this.title,
    this.translatedLanguage,
    // this.externalUrl,
    this.publishAt,
    this.readableAt,
    this.createdAt,
    this.updatedAt,
    this.pages,
    this.version,
  });

  ChapterAttributes.fromJson(Map<String, dynamic> json) {
    // volume = json['volume'];
    chapter = json['chapter'].toString().split('.')[0];
    title = json['title'];
    translatedLanguage = json['translatedLanguage'];
    // externalUrl = json['externalUrl'];
    publishAt = getDate(json['publishAt']);
    readableAt = getDate(json['readableAt']);
    createdAt = getDate(json['createdAt']);
    updatedAt = getDate(json['updatedAt']);
    pages = json['pages'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['volume'] = volume;
    data['chapter'] = chapter;
    data['title'] = title;
    data['translatedLanguage'] = translatedLanguage;
    // data['externalUrl'] = externalUrl;
    data['publishAt'] = publishAt;
    data['readableAt'] = readableAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['pages'] = pages;
    data['version'] = version;
    return data;
  }
}

class ChapterRelationships {
  String? id;
  String? type;

  ChapterRelationships({
    this.id,
    this.type,
  });

  ChapterRelationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

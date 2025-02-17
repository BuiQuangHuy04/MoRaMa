import '../../../core/constant.dart';

class BaseChapterRes {
  String? result;
  String? response;
  List<Chapter>? chapters;
  int? limit;
  int? offset;
  int? total;

  @override
  String toString() {
    return 'BaseChapterRes{result: $result, response: $response, chapters: $chapters, limit: $limit, offset: $offset, total: $total}';
  }

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

  @override
  String toString() {
    return 'Chapter{id: $id, type: $type, attributes: $attributes, relationships: $relationships}';
  }

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

  @override
  String toString() {
    return 'ChapterAttributes{chapter: $chapter, title: $title, translatedLanguage: $translatedLanguage, publishAt: $publishAt, readableAt: $readableAt, createdAt: $createdAt, updatedAt: $updatedAt, pages: $pages, version: $version}';
  }

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
  ChapterRelationshipAttributes? attributes;

  ChapterRelationships({
    this.id,
    this.type,
    this.attributes,
  });

  ChapterRelationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = ChapterRelationshipAttributes.fromJson(json['attributes']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['attributes'] = attributes;
    return data;
  }

  @override
  String toString() {
    return 'ChapterRelationships{id: $id, type: $type, attributes: $attributes}';
  }
}

class ChapterRelationshipAttributes {
  String? name;
  List<String>? altNames;
  bool? locked;
  String? website;
  String? ircServer;
  String? ircChannel;
  String? discord;
  String? contactEmail;
  String? description;
  String? twitter;
  String? mangaUpdates;
  List<String>? focusedLanguages;
  bool? official;
  bool? verified;
  bool? inactive;
  String? publishDelay;
  String? createdAt;
  String? updatedAt;
  int? version;
  String? username;
  List<String>? roles;

  ChapterRelationshipAttributes({
    this.name,
    this.altNames,
    this.locked,
    this.website,
    this.ircServer,
    this.ircChannel,
    this.discord,
    this.contactEmail,
    this.description,
    this.twitter,
    this.mangaUpdates,
    this.focusedLanguages,
    this.official,
    this.verified,
    this.inactive,
    this.publishDelay,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.username,
    this.roles,
  });

  ChapterRelationshipAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // if (json['altNames'] != null) {
    //   altNames = <String>[];
    //   json['altNames'].forEach((v) {
    //     altNames!.add(v.toString());
    //   });
    // }
    // locked = json['locked'];
    // website = json['website'];
    // ircServer = json['ircServer'];
    // ircChannel = json['ircChannel'];
    // discord = json['discord'];
    // contactEmail = json['contactEmail'];
    // description = json['description'];
    // twitter = json['twitter'];
    // mangaUpdates = json['mangaUpdates'];
    // if (json['focusedLanguages'] != null) {
    //   focusedLanguages = <String>[];
    //   json['focusedLanguages'].forEach((v) {
    //     focusedLanguages!.add(v.toString());
    //   });
    // }
    // official = json['official'];
    // verified = json['verified'];
    // inactive = json['inactive'];
    publishDelay = json['publishDelay'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // version = json['version'];
    username = json['username'];
    if (json['roles'] != null) {
      roles = <String>[];
      json['roles'].forEach((v) {
        roles!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['altNames'] = altNames!;
    data['locked'] = locked;
    data['website'] = website;
    data['ircServer'] = ircServer;
    data['ircChannel'] = ircChannel;
    data['discord'] = discord;
    data['contactEmail'] = contactEmail;
    data['description'] = description;
    data['twitter'] = twitter;
    data['mangaUpdates'] = mangaUpdates;
    data['focusedLanguages'] = focusedLanguages;
    data['official'] = official;
    data['verified'] = verified;
    data['inactive'] = inactive;
    data['publishDelay'] = publishDelay;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['version'] = version;
    data['username'] = username;
    data['roles'] = roles;
    return data;
  }

  @override
  String toString() {
    return 'ChapterRelationshipAttributes{name: $name, locked: $locked, discord: $discord, description: $description, twitter: $twitter, mangaUpdates: $mangaUpdates, official: $official, verified: $verified, inactive: $inactive, createdAt: $createdAt, updatedAt: $updatedAt, version: $version}';
  }
}

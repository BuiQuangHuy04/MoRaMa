import '../index.dart';

class RelationshipsAttributes {
  String? name;
  Biography? biography;
  String? twitter;
  String? createdAt;
  String? updatedAt;
  int? version;
  String? description;
  String? volume;
  String? fileName;
  String? locale;

  RelationshipsAttributes({
    this.name,
    this.biography,
    this.twitter,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.description,
    this.volume,
    this.fileName,
    this.locale,
  });

  RelationshipsAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    biography = json['biography'] != null
        ? Biography.fromJson(json['biography'])
        : null;
    twitter = json['twitter'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['version'];
    description = json['description'];
    volume = json['volume'];
    fileName = json['fileName'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (biography != null) {
      data['biography'] = biography!.toJson();
    }
    data['twitter'] = twitter;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['version'] = version;
    data['description'] = description;
    data['volume'] = volume;
    data['fileName'] = fileName;
    data['locale'] = locale;
    return data;
  }

  @override
  String toString() {
    return 'RelationshipsAttributes{name: $name, biography: $biography, twitter: $twitter, createdAt: $createdAt, updatedAt: $updatedAt, version: $version, description: $description, volume: $volume, fileName: $fileName, locale: $locale}';
  }
}

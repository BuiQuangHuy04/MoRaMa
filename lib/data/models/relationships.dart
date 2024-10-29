import '../index.dart';

enum Relationship {
  author('author'),
  artist('artist'),
  coverArt('cover_art'),
  manga('manga'),
  tag('tag'),
  chapter('chapter');

  const Relationship(this.value);

  final String value;
}

class Relationships {
  String? id;
  String? type;
  RelationshipsAttributes? attributes;
  String? related;

  Relationships({
    this.id,
    this.type,
    this.related,
    this.attributes,
  });

  Relationships.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    related = json['related'];
    attributes = json['attributes'] != null
        ? RelationshipsAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['related'] = related;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Relationships{id: $id, type: $type, attributes: $attributes, related: $related}';
  }
}

import '../index.dart';

class Tags {
  String? id;
  String? type;
  TagsAttributes? attributes;

  Tags({
    this.id,
    this.type,
    this.attributes,
  });

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? TagsAttributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    if (attributes != null) {
      data['attributes'] = attributes!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Tags{id: $id, type: $type, attributes: $attributes}';
  }
}
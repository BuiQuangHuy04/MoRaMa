import '../index.dart';

class TagsAttributes {
  Title? name;
  Description? description;
  String? group;
  int? version;

  TagsAttributes({
    this.name,
    this.description,
    this.group,
    this.version,
  });

  TagsAttributes.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? Title.fromJson(json['name']) : null;
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    group = json['group'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data['name'] = name!.toJson();
    }
    if (description != null) {
      data['description'] = description!.toJson();
    }
    data['group'] = group;
    data['version'] = version;
    return data;
  }

  @override
  String toString() {
    return 'TagsAttributes{name: $name, description: $description, group: $group, version: $version}';
  }
}
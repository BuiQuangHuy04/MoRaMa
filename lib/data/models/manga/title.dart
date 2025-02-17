class Title {
  String? en;
  String? ja;

  Title({
    this.en,
    this.ja,
  });

  Title.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ja = json['ja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['ja'] = ja;
    return data;
  }

  @override
  String toString() {
    return 'Title{en: $en, ja: $ja}';
  }
}
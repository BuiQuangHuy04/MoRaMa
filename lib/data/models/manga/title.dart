class Title {
  String? en;

  Title({
    this.en,
  });

  Title.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    return data;
  }

  @override
  String toString() {
    return 'Title{en: $en}';
  }
}
class Biography {
  String? en;

  Biography({this.en});

  Biography.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }

  @override
  String toString() {
    return 'Biography{en: $en}';
  }
}
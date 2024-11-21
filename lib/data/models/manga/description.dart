class Description {
  String? en;
  String? ptBr;
  String? pt;
  String? ru;
  String? ja;
  String? vi;
  String? fr;
  String? tl;

  Description({
    this.en,
    this.ptBr,
    this.pt,
    this.ru,
    this.ja,
    this.vi,
    this.fr,
    this.tl,
  });

  Description.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ptBr = json['pt-br'];
    pt = json['pt'];
    ru = json['ru'];
    ja = json['ja'];
    vi = json['vi'];
    fr = json['fr'];
    tl = json['tl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['pt-br'] = ptBr;
    data['pt'] = pt;
    data['ru'] = ru;
    data['ja'] = ja;
    data['vi'] = vi;
    data['fr'] = fr;
    data['tl'] = tl;
    return data;
  }

  @override
  String toString() {
    return 'Description{en: $en, ptBr: $ptBr, pt: $pt, ru: $ru, ja: $ja, vi: $vi, fr: $fr, tl: $tl}';
  }
}

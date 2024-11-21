class AltTitles {
  String? en;
  String? zh;
  String? ja;
  String? fr;
  String? vi;
  String? ru;
  String? ko;
  String? koRo;
  String? th;
  String? zhHk;
  String? id;
  String? jaRo;
  String? uk;
  String? ptBr;
  String? tl;
  String? pt;

  AltTitles({
    this.en,
    this.zh,
    this.ja,
    this.fr,
    this.vi,
    this.ru,
    this.ko,
    this.koRo,
    this.th,
    this.zhHk,
    this.id,
    this.jaRo,
    this.uk,
    this.ptBr,
    this.tl,
    this.pt,
  });

  AltTitles.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    zh = json['zh'];
    ja = json['ja'];
    fr = json['fr'];
    vi = json['vi'];
    ru = json['ru'];
    ko = json['ko'];
    koRo = json['ko-ro'];
    th = json['th'];
    zhHk = json['zh-hk'];
    id = json['id'];
    jaRo = json['ja-ro'];
    uk = json['uk'];
    ptBr = json['pt-br'];
    tl = json['tl'];
    pt = json['pt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['en'] = en;
    data['zh'] = zh;
    data['ja'] = ja;
    data['fr'] = fr;
    data['vi'] = vi;
    data['ru'] = ru;
    data['ko'] = ko;
    data['ko-ro'] = koRo;
    data['th'] = th;
    data['zh-hk'] = zhHk;
    data['id'] = id;
    data['ja-ro'] = jaRo;
    data['uk'] = uk;
    data['pt-br'] = ptBr;
    data['tl'] = tl;
    data['pt'] = pt;
    return data;
  }

  @override
  String toString() {
    return 'AltTitles{en: $en, zh: $zh, ja: $ja, fr: $fr, vi: $vi, ru: $ru, ko: $ko, koRo: $koRo, th: $th, zhHk: $zhHk, id: $id, jaRo: $jaRo, uk: $uk, ptBr: $ptBr, tl: $tl, pt: $pt}';
  }
}
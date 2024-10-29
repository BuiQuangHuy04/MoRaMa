class Links {
  String? al;
  String? ap;
  String? bw;
  String? kt;
  String? mu;
  String? amz;
  String? cdj;
  String? ebj;
  String? mal;
  String? raw;
  String? nu;
  String? engtl;

  Links({
    this.al,
    this.ap,
    this.bw,
    this.kt,
    this.mu,
    this.amz,
    this.cdj,
    this.ebj,
    this.mal,
    this.raw,
    this.nu,
    this.engtl,
  });

  Links.fromJson(Map<String, dynamic> json) {
    al = json['al'];
    ap = json['ap'];
    bw = json['bw'];
    kt = json['kt'];
    mu = json['mu'];
    amz = json['amz'];
    cdj = json['cdj'];
    ebj = json['ebj'];
    mal = json['mal'];
    raw = json['raw'];
    nu = json['nu'];
    engtl = json['engtl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['al'] = al;
    data['ap'] = ap;
    data['bw'] = bw;
    data['kt'] = kt;
    data['mu'] = mu;
    data['amz'] = amz;
    data['cdj'] = cdj;
    data['ebj'] = ebj;
    data['mal'] = mal;
    data['raw'] = raw;
    data['nu'] = nu;
    data['engtl'] = engtl;
    return data;
  }

  @override
  String toString() {
    return 'Links{al: $al, ap: $ap, bw: $bw, kt: $kt, mu: $mu, amz: $amz, cdj: $cdj, ebj: $ebj, mal: $mal, raw: $raw, nu: $nu, engtl: $engtl}';
  }
}
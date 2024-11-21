import '../../index.dart';

//https://uploads.mangadex.org/covers/[BaseCoverRes>data>id]/[BaseCoverRes>data>relationships[2]>]
class BaseCoverRes {
  String? result;
  String? response;
  Cover? cover;

  BaseCoverRes({this.result, this.response, this.cover});

  BaseCoverRes.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    response = json['response'];
    cover = json['data'] != null ? Cover.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = result;
    data['response'] = response;
    if (this.cover != null) {
      data['data'] = this.cover!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'BaseCoverRes{result: $result, response: $response, data: $cover}';
  }
}
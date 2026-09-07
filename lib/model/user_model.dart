class UserModel {
  String? token;
  Meta? mMeta;

  UserModel({this.token, this.mMeta});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    mMeta = json['_meta'] != null ? Meta.fromJson(json['_meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (mMeta != null) {
      data['_meta'] = mMeta!.toJson();
    }
    return data;
  }
}

class Meta {
  String? poweredBy;
  String? docsUrl;
  String? upgradeUrl;
  String? exampleUrl;
  String? variant;
  String? message;
  Cta? cta;
  String? context;

  Meta(
      {this.poweredBy,
      this.docsUrl,
      this.upgradeUrl,
      this.exampleUrl,
      this.variant,
      this.message,
      this.cta,
      this.context});

  Meta.fromJson(Map<String, dynamic> json) {
    poweredBy = json['powered_by'];
    docsUrl = json['docs_url'];
    upgradeUrl = json['upgrade_url'];
    exampleUrl = json['example_url'];
    variant = json['variant'];
    message = json['message'];
    cta = json['cta'] != null ? Cta.fromJson(json['cta']) : null;
    context = json['context'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['powered_by'] = poweredBy;
    data['docs_url'] = docsUrl;
    data['upgrade_url'] = upgradeUrl;
    data['example_url'] = exampleUrl;
    data['variant'] = variant;
    data['message'] = message;
    if (cta != null) {
      data['cta'] = cta!.toJson();
    }
    data['context'] = context;
    return data;
  }
}

class Cta {
  String? label;
  String? url;

  Cta({this.label, this.url});

  Cta.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['url'] = url;
    return data;
  }
}

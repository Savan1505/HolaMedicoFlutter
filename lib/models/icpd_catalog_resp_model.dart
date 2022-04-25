/// jsonrpc : "2.0"
/// id : "d6382e50-2fcd-11ec-a42a-79306d97982f"
/// result : {"status_code":0,"is_success":true,"data":[{"description":false,"banner_url":"https://www.some.com/image.png","stop":"2021-10-14 06:44:07","cost":250,"id":1999,"name":"Event Catalog 2","event_category_name":false,"start":"2021-10-14 04:44:07","score":0},{"description":false,"banner_url":"https://www.some.com/image.png","stop":"2021-10-14 06:44:07","cost":100,"id":1998,"name":"Event Catalog 1","event_category_name":false,"start":"2021-10-14 04:44:07","score":0}],"message":""}

class IcpdCatalogRespModel {
  String? jsonrpc;
  String? id;
  Result? result;

  IcpdCatalogRespModel({this.jsonrpc, this.id, this.result});

  IcpdCatalogRespModel.fromJson(dynamic json) {
    jsonrpc = json["jsonrpc"];
    id = json["id"];
    result = json["result"] != null ? Result.fromJson(json["result"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["jsonrpc"] = jsonrpc;
    map["id"] = id;
    if (result != null) {
      map["result"] = result?.toJson();
    }
    return map;
  }
}

/// status_code : 0
/// is_success : true
/// data : [{"description":false,"banner_url":"https://www.some.com/image.png","stop":"2021-10-14 06:44:07","cost":250,"id":1999,"name":"Event Catalog 2","event_category_name":false,"start":"2021-10-14 04:44:07","score":0},{"description":false,"banner_url":"https://www.some.com/image.png","stop":"2021-10-14 06:44:07","cost":100,"id":1998,"name":"Event Catalog 1","event_category_name":false,"start":"2021-10-14 04:44:07","score":0}]
/// message : ""

class Result {
  int? statusCode;
  bool? isSuccess;
  List<CatalogList>? data;
  String? message;

  Result({this.statusCode, this.isSuccess, this.data, this.message});

  Result.fromJson(dynamic json) {
    statusCode = json["status_code"];
    isSuccess = json["is_success"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(CatalogList.fromJson(v));
      });
    }
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status_code"] = statusCode;
    map["is_success"] = isSuccess;
    if (data != null) {
      map["data"] = data?.map((v) => v.toJson()).toList();
    }
    map["message"] = message;
    return map;
  }
}

/// description : false
/// banner_url : "https://www.some.com/image.png"
/// organizer_url : "https://www.some.com/image.png"
/// target_audience : "Cardio,BP"
/// stop : "2021-10-14 06:44:07"
/// cost : 250
/// id : 1999
/// name : "Event Catalog 2"
/// event_category_name : false
/// start : "2021-10-14 04:44:07"
/// state : "draft"
/// score : 0
/// is_attendee : false
/// organizer_name : "test"
/// score_category : false

class CatalogList {
  String? description;
  String? bannerUrl;
  String? targetAudience;
  bool? isAttendee;
  String? stop;
  double? cost;
  String? organizerUrl;
  int? id;
  String? name;
  String? eventCategoryName;
  String? start;
  String? state;
  double? score;
  String? organizerName;
  String? scoreCategory;

  CatalogList({
    this.description,
    this.bannerUrl,
    this.targetAudience,
    this.isAttendee,
    this.stop,
    this.cost,
    this.organizerUrl,
    this.id,
    this.name,
    this.eventCategoryName,
    this.start,
    this.state,
    this.score,
    this.organizerName,
    this.scoreCategory,
  });

  CatalogList.fromJson(dynamic json) {
    description = json["description"] is bool ? null : json['description'];

    bannerUrl = json["banner_url"] is bool ? null : json['banner_url'];

    targetAudience =
        json["target_audience"] is bool ? null : json['target_audience'];

    isAttendee = json["is_attendee"] is bool ? null : json['is_attendee'];

    stop = json["stop"] is bool ? null : json['stop'];

    cost = json["cost"] is bool ? null : json['cost'];
    organizerUrl = json["organizer_url"] is bool ? null : json['organizer_url'];
    id = json["id"] is bool ? null : json['id'];
    name = json["name"] is bool ? null : json['name'];
    eventCategoryName = json["event_category_name"] is bool
        ? null
        : json['event_category_name'];
    start = json["start"] is bool ? null : json['start'];
    state = json["state"] is bool ? null : json['state'];
    score = json["score"] is bool ? null : json['score'];
    organizerName =
        json["organizer_name"] is bool ? null : json['organizer_name'];
    scoreCategory =
        json["score_category"] is bool ? null : json['score_category'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["description"] = description;
    map["banner_url"] = bannerUrl;
    map["target_audience"] = targetAudience;
    map["is_attendee"] = isAttendee;
    map["stop"] = stop;
    map["cost"] = cost;
    map["organizer_url"] = organizerUrl;
    map["id"] = id;
    map["name"] = name;
    map["event_category_name"] = eventCategoryName;
    map["start"] = start;
    map["state"] = state;
    map["score"] = score;
    map["organizer_name"] = organizerName;
    map["score_category"] = scoreCategory;
    return map;
  }
}

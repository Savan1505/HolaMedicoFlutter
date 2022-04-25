/// jsonrpc : "2.0"
/// id : 385474802
/// result : {"status_code":0,"is_success":true,"data":[{"id":1,"name":"Conference"},{"id":2,"name":"Web Conference"},{"id":3,"name":"Other"}],"message":""}

class IcpdEventCategoryModel {
  String? jsonrpc;
  int? id;
  Result? result;

  IcpdEventCategoryModel({this.jsonrpc, this.id, this.result});

  IcpdEventCategoryModel.fromJson(dynamic json) {
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
/// data : [{"id":1,"name":"Conference"},{"id":2,"name":"Web Conference"},{"id":3,"name":"Other"}]
/// message : ""

class Result {
  int? statusCode;
  bool? isSuccess;
  List<EventCategory>? data;
  String? message;

  Result({this.statusCode, this.isSuccess, this.data, this.message});

  Result.fromJson(dynamic json) {
    statusCode = json["status_code"];
    isSuccess = json["is_success"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(EventCategory.fromJson(v));
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

/// id : 1
/// name : "Conference"

class EventCategory {
  int? id;
  String? name;

  EventCategory({this.id, this.name});

  EventCategory.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}

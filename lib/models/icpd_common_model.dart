/// jsonrpc : "2.0"
/// id : 385474802
/// result : "{"status_code": 0, "is_success": true, "data": null, "message": "Values updated successfully."}"

class ICPDCommonModel {
  String? jsonrpc;
  int? id;
  CommonResultMessage? result;

  ICPDCommonModel({this.jsonrpc, this.id, this.result});

  ICPDCommonModel.fromJson(dynamic json) {
    jsonrpc = json["jsonrpc"];
    id = json["id"];
    result = json["result"] != null
        ? CommonResultMessage.fromJson(json["result"])
        : null;
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
/// data : {"id" : 14}
/// message : "Activity successfully created."

class CommonResultMessage {
  int? statusCode;
  bool? isSuccess;
  Data? data;
  String? message;

  CommonResultMessage(
      {this.statusCode, this.isSuccess, this.data, this.message});

  CommonResultMessage.fromJson(dynamic json) {
    statusCode = json["status_code"];
    isSuccess = json["is_success"];
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status_code"] = statusCode;
    map["is_success"] = isSuccess;
    if (data != null) {
      map["data"] = data?.toJson();
    }
    map["message"] = message;
    return map;
  }
}

/// "id": 14
class Data {
  int? planId;

  Data({this.planId});

  Data.fromJson(dynamic json) {
    planId = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = planId;
    return map;
  }
}

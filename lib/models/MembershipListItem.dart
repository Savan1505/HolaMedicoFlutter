/// jsonrpc : "2.0"
/// id : "f0bfe240-a8ef-11ec-a363-ef8c2497200d"
/// result : {"status_code":0,"is_success":true,"data":{"clubs":[{"id":1,"name":"Cinfa Club"},{"id":2,"name":"Respimar Club"}]},"message":""}

class MembershipListItem {
  String? jsonrpc;
  int? id;
  Result? result;

  MembershipListItem({this.jsonrpc, this.id, this.result});

  MembershipListItem.fromJson(dynamic json) {
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
/// data : {"clubs":[{"id":1,"name":"Cinfa Club"},{"id":2,"name":"Respimar Club"}]}
/// message : ""

class Result {
  int? statusCode;
  bool? isSuccess;
  List<Data>? data;
  String? message;

  Result({this.statusCode, this.isSuccess, this.data, this.message});

  Result.fromJson(dynamic json) {
    statusCode = json["status_code"];
    isSuccess = json["is_success"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(Data.fromJson(v));
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

/// clubs : [{"id":1,"name":"Cinfa Club"},{"id":2,"name":"Respimar Club"}]

class Data {
  List<ClubsListItem>? clubsListItem;

  Data({this.clubsListItem});

  Data.fromJson(dynamic json) {
    if (json["clubs"] != null) {
      clubsListItem = [];
      json["clubs"].forEach((v) {
        clubsListItem?.add(ClubsListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (clubsListItem != null) {
      map["clubs"] = clubsListItem?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// {"id":1,"name":"Cinfa Club"}

class ClubsListItem {
  int? id;
  String? name;

  ClubsListItem({
    this.id,
    this.name,
  });

  ClubsListItem.fromJson(dynamic json) {
    id = json["id"] is bool ? null : json['id'];
    name = json["name"] is bool ? null : json['name'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}

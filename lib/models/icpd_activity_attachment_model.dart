/// jsonrpc : "2.0"
/// id : 385474802
/// result : {"status_code":0,"is_success":true,"data":[{"event_attachment_id":"iVBORw0KGgoAAAANSUhEUgAAA9QAAAPWCAYAAAABHNCPAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCnAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZiS0dEnAP8A/wD/oL2nkwAAAAlwSFlzAAAASAAAAEgARslrPgAAgABJREFUeNrs3Xd0FdX7NfA9N530AKGHnAKH3Kk16ExJ6QOkIRpCmoF+KDRTpijRpAgLSe2ZTk4NzM0MDI5MS5zdmdHmnUCAAAAAElFnTkSuQmCCn"}],"message":"Attachment served."}

class IcpdActivityAttachRespModel {
  String? jsonrpc;
  int? id;
  AttachmentItem? result;

  IcpdActivityAttachRespModel({this.jsonrpc, this.id, this.result});

  IcpdActivityAttachRespModel.fromJson(dynamic json) {
    jsonrpc = json["jsonrpc"];
    id = json["id"];
    result =
        json["result"] != null ? AttachmentItem.fromJson(json["result"]) : null;
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
/// data : [{"event_attachment_id":"iVBORw0KGgoAAAANSUhEUgAAA9QAAAPWCAYAAAABHNCPAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCnAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZiS0dEnAP8A/wD/oL2nkwAAAAlwSFlzAAAASAAAAEgARslrPgAAgABJREFUeNrs3Xd0FdX7NfA9N530AKGHnAKH3Kk16ExJ6QOkIRpCmoF+KDRTpijRpAgLSe2+hh957DzUBQiAhvZ/3j5/yolKSkHvPlP1Zi6UCnMnuid2Z2njMzihACREREZB7JyckiJiYGAJCSkoLo6OgXv5aamoqoqKhM/blubm5QFAUmkwmurq4AnABsbGzg5OSmy95mIiMgorGUHICIiUpO/HB3dj0Qjj8RhCCCRJ4u7iOH4Yy2maIgxDxjEREdEPGNREREQ9ul6v9nQ6wVoLpRQA4Hg84na7nuXc8z0MQBL/+5rdoZgATERH15AMiFSbwqRtI+AAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxNy0wNi0xnMlQwMzozNToxMSswODowMO8SZvIAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTYtMDQtMjNUMDA6NDA6nMDQrMDg6MDDsa+taAAAAVHRFWHRzdmc6YmFzZS11cmkAZmlsZTovLy9ob21lL2RiL3N2Z19pbmZvnL3N2Zy9kMS9hYS9kMWFhZTk5YjVjYjI2M2FiZjExZjExZTk4NzM0MDI5MS5zdmdHmnUCAAAAAElFnTkSuQmCCn"}]
/// message : "Attachment served."

class AttachmentItem {
  int? statusCode;
  bool? isSuccess;
  List<EventAttachment>? data;
  String? message;

  AttachmentItem({
    this.statusCode,
    this.isSuccess,
    this.data,
    this.message,
  });

  AttachmentItem.fromJson(dynamic json) {
    statusCode = json["status_code"];
    isSuccess = json["is_success"];
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data?.add(EventAttachment.fromJson(v));
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

/// event_attachment_id : "iVBORw0KGgoAAAANSUhEUgAAA9QAAAPWCAYAAAABHNCPAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCnAK7OHOkAAAAgY0hSTQAAeiYAAICEAAD6AAAAgOgAAHUwAADqYAAAOpgAABdwnLpRPAAAAAZiS0dEnAP8A/wD/oL2nkwAAAAlwSFlzAAAASAAAAEgARslrPgAAgABJREFUeNrs3Xd0FdX7NfA9N530AKGHnAKH3Kk16ExJ6QOkIRpCmoF+KDRTpijRpAgLSe2+hh957DzUBQiAhvZ/3j5/yolKSkHvPlP1Zi6UCnMnuid2Z2njMzihACREREZB7JyckiJiYGAJCSkoLo6OgXv5aamoqoqKhM"

class EventAttachment {
  String? eventAttachmentId;

  EventAttachment({this.eventAttachmentId});

  EventAttachment.fromJson(dynamic json) {
    eventAttachmentId = json["event_attachment_id"] is bool
        ? null
        : json["event_attachment_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["event_attachment_id"] = eventAttachmentId;
    return map;
  }
}

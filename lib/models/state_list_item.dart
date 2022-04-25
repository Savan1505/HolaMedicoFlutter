/// jsonrpc : "2.0"
/// id : 385474802
/// result : [{"id":546,"name":"Ajman"},{"id":545,"name":"Abu Dhabi"},{"id":547,"name":"Dubai"},{"id":646,"name":"Dubai"},{"id":548,"name":"Fujairah"},{"id":549,"name":"Ras al-Khaimah"},{"id":550,"name":"Sharjah"},{"id":551,"name":"Umm al-Quwain"}]

class StateListItem {
  String? jsonrpc;
  String? id;
  List<StateItem>? result;

  StateListItem({this.jsonrpc, this.id, this.result});

  StateListItem.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result!.add(new StateItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// id : 546
/// name : "Ajman"

class StateItem {
  int? id;
  String? name;

  StateItem({this.id, this.name});

  StateItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

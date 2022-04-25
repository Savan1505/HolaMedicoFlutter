/// jsonrpc : "2.0"
/// id : "a0b29b60-72f0-11ec-8490-77f008ef5759"
/// result : {"status_code":1,"is_success":true,"data":{"address1_street2":"Street 2","address1_state_id":{"id":647,"name":"Doha"},"title":"Hardi Patel","address1_street":"Street 1","address1_zip":"321565","address1_city":"Test City","address1_country_id":{"id":123,"name":"Kuwait"}},"message":""}

class SampleAddressResModel {
  String? jsonrpc;
  String? id;
  List<AddressData>? result;

  SampleAddressResModel({this.jsonrpc, this.id, this.result});

  SampleAddressResModel.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result!.add(new AddressData.fromJson(v));
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

/// status_code : 1
/// is_success : true
/// data : {"address1_street2":"Street 2","address1_state_id":{"id":647,"name":"Doha"},"title":"Hardi Patel","address1_street":"Street 1","address1_zip":"321565","address1_city":"Test City","address1_country_id":{"id":123,"name":"Kuwait"}}
/// message : ""

class AddressData {
  int? statusCode;
  bool? isSuccess;
  AddressItem? data;
  String? message;

  AddressData({this.statusCode, this.isSuccess, this.data, this.message});

  AddressData.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    isSuccess = json['is_success'];
    data = json['data'] != null ? AddressItem.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['status_code'] = this.statusCode;
    map['is_success'] = this.isSuccess;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    map['message'] = this.message;
    return map;
  }
}

/// address1_street2 : "Street 2"
/// address1_state_id : {"id":647,"name":"Doha"}
/// title : "Savan Patel"
/// address1_street : "Street 1"
/// address1_zip : "321565"
/// address1_city : "Test City"
/// address1_country_id : {"id":123,"name":"Kuwait"}

class AddressItem {
  String? address1Street;
  String? address1Street2;
  String? address1City;
  String? title;
  String? address1Zip;
  Address1Country? address1Country;
  Address1State? address1State;

  AddressItem(
      {this.address1Street,
      this.address1Street2,
      this.address1City,
      this.title,
      this.address1Zip,
      this.address1Country,
      this.address1State});

  AddressItem.fromJson(Map<String, dynamic> json) {
    address1Street = json['address1_street'];
    address1Street2 = json['address1_street2'];
    address1City = json['address1_city'];
    title = json['title'];
    address1Zip = json['address1_zip'];
    address1Country = json['address1_country_id'] != null
        ? Address1Country.fromJson(json['address1_country_id'])
        : null;
    address1State = json['address1_state_id'] != null
        ? Address1State.fromJson(json['address1_state_id'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['address1_street'] = this.address1Street;
    map['address1_street2'] = this.address1Street2;
    map['address1_city'] = this.address1City;
    map['title'] = this.title;
    map['address1_zip'] = this.address1Zip;
    if (address1Country != null) {
      map['address1_country_id'] = address1Country!.toJson();
    }
    if (address1State != null) {
      map['address1_state_id'] = address1State!.toJson();
    }
    return map;
  }
}

/// id : 123
/// name : "Kuwait"

class Address1Country {
  int? id;
  String? name;

  Address1Country({this.id, this.name});

  Address1Country.fromJson(Map<String, dynamic> json) {
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

/// id : 647
/// name : "Doha"

class Address1State {
  int? id;
  String? name;

  Address1State({this.id, this.name});

  Address1State.fromJson(Map<String, dynamic> json) {
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

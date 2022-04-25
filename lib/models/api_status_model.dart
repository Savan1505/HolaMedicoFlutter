enum API_STATUS {
  success,
  fail
}
class ApiStatusModel {
  ApiStatusModel({
    this.apiStatus,
    this.message,
  });

  API_STATUS? apiStatus;
  String? message;

  ApiStatusModel.fromJson(Map<String, dynamic> json) {
    this.apiStatus = json.containsKey('message') ?  API_STATUS.success : API_STATUS.fail;
    message = json.containsKey('message') ?  json['message'] : json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.apiStatus;
    data['message'] = this.message;
    return data;
  }

}
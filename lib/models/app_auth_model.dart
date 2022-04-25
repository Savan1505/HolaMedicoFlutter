class AppAuthModel {
  int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? token;
  final int? type;

  //int type = 1 = REGISTERED
  final int REGISTEED=1;
  final int GUEST=2;

  AppAuthModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'] ?? null,
	name = parsedJson['name'] ?? null,
        email = parsedJson['email'] ?? null,
        phone = parsedJson['phone'] ?? null,
        token = parsedJson['token'],
        type = parsedJson['type'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id" : id,
      "type": type,
      "name": name,
      "email": email,
      "phone": phone,
      "token": token,
    };
  }
}

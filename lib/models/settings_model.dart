class SettingModel {
  final int? id;
  final String? category;
  final String? name;
  final String? str_value;
  final String? num_value;
  final int? type;

  SettingModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        category = parsedJson['category'],
	name = parsedJson['name'],
        str_value = parsedJson['str_value'],
        num_value = parsedJson['num_value'],
        type = parsedJson['type'];


  SettingModel.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        category = parsedJson['category'],
	name = parsedJson['name'],
        str_value = parsedJson['str_value'],
        num_value = parsedJson['num_value'],
        type = parsedJson['type'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "category": category,
      "name": name,
      "str_value": str_value,
      "num_value": num_value,
      "type": type
    };
  }
}

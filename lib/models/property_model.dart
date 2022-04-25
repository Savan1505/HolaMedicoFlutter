enum PropertyType {
  Integer,
  String,
}

class PropertyModel {
  int? id;
  String? category;
  int? sequence;
  String? propertyName;
  PropertyType? propertyType;
  int? propertyValueInt;
  String? propertyValueString;

  PropertyModel({
    this.id,
    this.category,
    this.sequence,
    this.propertyName,
    this.propertyType,
    this.propertyValueInt,
    this.propertyValueString
  });

  PropertyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category_name'];
    sequence = json['sequence'];
    propertyName = json['property_name'];
    propertyType = json['property_type'] == 'PropertyType.Integer' ? PropertyType.Integer : PropertyType.String;
    propertyValueInt = json['property_value_int'];
    propertyValueString = json['property_value_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.category;
    data['sequence'] = this.sequence;
    data['property_name'] = this.propertyName;
    data['property_type'] = this.propertyType.toString();
    data['property_value_int'] = this.propertyValueInt;
    data['property_value_string'] = this.propertyValueString;
    return data;
  }

}
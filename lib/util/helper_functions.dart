import 'package:flutter/services.dart';
import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/models/property_model.dart';

hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

String titleCase(String text) {
  if (text.length <= 1) return text.toUpperCase();
  var words = text.split(' ');
  var capitalized = words.map((word) {
    var first = word.substring(0, 1).toUpperCase();
    var rest = word.substring(1);
    return '$first$rest';
  });
  return capitalized.join(' ');
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

Future<List<PropertyModel>> fetchOrInitialize(
    String category, List<String> propertyNames) async {
  var dbProvider = DBProvider();
  List<PropertyModel> properties = await dbProvider.getProperties(category);

  propertyNames.forEach((propertyName) {
    int index = properties
        .indexWhere((element) => element.propertyName == propertyName);
    if (index == -1) {
      //Item not found so create property
      var property = PropertyModel(
        category: category,
        propertyName: propertyName,
        propertyValueInt:
            0, //TODO: params should be map instead of list and should provide default_value, property_type and sequence
        propertyType: PropertyType.Integer,
      );

      switch (property.propertyName) {
        case 'comprehensions':
          property.sequence = 0;
          break;
        case 'number_of_questions':
          property.sequence = 1;
          break;
        case 'correct_answers':
          property.sequence = 2;
          break;
      }
      properties.add(property);
    }
  });
  return properties;
}

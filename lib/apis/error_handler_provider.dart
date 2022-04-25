import 'package:http/http.dart';
import 'package:pharmaaccess/odoo_api/odoo_api_connector.dart';

abstract class ErrorHandlerProvider {
  Future<dynamic> baseApiRepo(
      OdooResponse response, dynamic Function(dynamic) apiCall) async {

    try {
      if (response.getStatusCode() == 200) {
        // success response
        dynamic res = response.getResult();
        return await apiCall(res);
      } else {
        // failure response
        return null;
      }
    } on ClientException catch (e) {
      print(e);
      // failure response
      return null;
    } catch (e) {
      print(e);
      // failure response
      return null;
    }
  }
}

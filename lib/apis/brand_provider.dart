import 'dart:convert';

import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/apis/error_handler_provider.dart';
import 'package:pharmaaccess/models/ProductListResModel.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/brand/brand_availability_model.dart';
import 'package:pharmaaccess/models/brand/brand_model.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/models/sample_address_res_model.dart';
import 'package:pharmaaccess/models/state_list_item.dart';
import 'package:pharmaaccess/odoo_api/odoo_api_connector.dart';
import 'package:pharmaaccess/util/Constants.dart';

import './auth_provider.dart';

class BrandProvider extends ErrorHandlerProvider {
  final AuthProvider authProvider = AuthProvider();

  Future<List<BrandAvailabilityModel>> getBrandsAvailability(
      {String? countryName, String? availability}) async {
    //brandAvailability is list (which can be fetch list by country and then filter and return.
    List<BrandAvailabilityModel>? availabilityList =
        await getBrandsAvailabilityByCountry(countryName);
    return availabilityList!
        .where((i) =>
            i.countryName == countryName && i.availabilityCode == availability)
        .toList();
    //return brandAvailability.where((i) => i.countryName == countryName && i.availabilityCode == availability).toList();
  }

  Future<List<BrandAvailabilityModel>?> getBrandsAvailabilityByCountry(
      String? countryName) async {
    try {
      //brandAvailability is list (which can be fetch list by country and then filter and return.
      var response = await authProvider.client
          .callController("/app/brands/country", {'country_name': countryName});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwError(response);
        }
        var brandAvailability = result.map<BrandAvailabilityModel>((json) {
          return BrandAvailabilityModel.fromJson(json);
        }).toList();
        if (brandAvailability != null && brandAvailability.isNotEmpty) {
          return brandAvailability;
        } else {
          return throwError(response);
        }
      } else {
        return throwError(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }

    //return brandAvailability.where((i) => i.countryName == countryName && i.availabilityCode == availability).toList();
  }

  Future<BrandModel?> getBrand(int? brandId, String? countryName) async {
    try {
      var response = await authProvider.client.callController(
          "/app/v3/brand", {'brand_id': brandId, 'country_name': countryName});

      if (!response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return null;
        }
        var brand = BrandModel.fromJson(result);
        return brand;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<ProductItemModel>?> getProducts(String country) async {
    try {
      var response = await authProvider.client
          .callController("/app/product/country", {'country_name': country});
      if (response == null) {
        return null;
      }
      return await baseApiRepo(
        response,
        (response) {
          var products = response.map<ProductItemModel>(
            (json) {
              return ProductItemModel.fromJson(json);
            },
          ).toList();
          return products;
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<AddressItem?> getSampleRequestAddress(int selectedIndex) async {
    String addressType = "work";
    if (selectedIndex == 0) {
      addressType = "work";
    } else if (selectedIndex == 1) {
      addressType = "personal";
    } else {
      addressType = "other";
    }
    try {
      var response = await authProvider.client.callControllerBackSlash(
          "/app/v4/profile/address", {'address_type': addressType});
      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return null;
        }
        return AddressItem.fromJson(result);
      } else {
        return null;
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return null;
      // return throwErrorString(e.toString());
    }
  }

  Future<List<StateItem>?> getCountryWiseState(int countryId) async {
    try {
      var response = await authProvider.client
          .callController("/app/v4/state_list", {'country_id': countryId});
      if (response.toString().isEmpty) {
        return null;
      }
      return await baseApiRepo(
        response,
        (response) {
          var states = response.map<StateItem>(
            (json) {
              return StateItem.fromJson(json);
            },
          ).toList();
          return states;
        },
      );
    } catch (e) {
      return null;
    }
  }

  Future<ApiStatusModel> requestProductSample(
      int selectedIndex,
      int? productId,
      int quantity,
      String deliveryMethod,
      String address1Street,
      String address1Street2,
      String address1City,
      String address1StateId,
      String address1CountryId,
      String address1Zip) async {
    String addressType = "";
    if (selectedIndex == 0) {
      addressType = "work";
    } else if (selectedIndex == 1) {
      addressType = "personal";
    } else if (selectedIndex == 2) {
      addressType = "other";
    }
    //TODO - Get profile/uid
    try {
      ProfileModel? profile = await this.authProvider.getProfile();
      /*var response =
          await authProvider.client.callController("/app/sample_request", {
        'uid': profile?.uid,
        'token': profile?.token,
        'count_requested': quantity,
        'product_id': productId
      });*/

      var response =
          await authProvider.client.callController("/app/v4/sample_request", {
        'uid': profile?.uid,
        'token': profile?.token,
        'delivery_method': deliveryMethod,
        'address_type': deliveryMethod == "person" ? "" : addressType,
        'count_requested': quantity,
        'product_id': productId,
        'address1_street': address1Street,
        'address1_street2': address1Street2,
        'address1_city': address1City,
        'address1_state_id': address1StateId,
        'address1_country_id': address1CountryId,
        'address1_zip': address1Zip,
      });
      return await baseApiRepo(response, (response) {
        if (response is String) {
          response = json.decode(response);
          return ApiStatusModel.fromJson(response);
        }
        return ApiStatusModel.fromJson(response);
      });
    } catch (e) {
      return ApiStatusModel.fromJson({'error': INTERNAL_SERVER_ERROR});
    }
  }
/*Future<List<BrandModel>> getBrands() async {
    try {
      if (!apiProvider.isLoggedIn()) {
        await apiProvider.autoLogin();
      }
      if (!apiProvider.isLoggedIn()) return [];

      var response = await apiProvider.client.searchRead('product.brand', [], [
        "id",
        "name",
      ]);
      if (!response.hasError()) {
        Map<String, dynamic> records = response.getResult();
        return records['records'].map<BrandModel>((json) {
          return BrandModel.fromJson(json);
        }).toList();
      } else {
        return [];
      }

    } catch (e) {
      return [];
    }
  }*/
}

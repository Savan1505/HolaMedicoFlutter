import 'package:pharmaaccess/apis/brand_provider.dart';
import 'package:pharmaaccess/models/ProductListResModel.dart';
import 'package:pharmaaccess/models/api_status_model.dart';
import 'package:pharmaaccess/models/brand/brand_availability_model.dart';
import 'package:pharmaaccess/models/brand/brand_model.dart';
import 'package:pharmaaccess/models/sample_address_res_model.dart';
import 'package:pharmaaccess/models/state_list_item.dart';

class BrandService {
  final brandProvider = BrandProvider();
  static Map<String?, List<BrandAvailabilityModel>> brandAvailabilityList =
      Map();
  static Map<int?, BrandModel> brandList = Map();

  Future<List<BrandAvailabilityModel>?> getBrandsAvailabilityByCountry(
      String? countryName) async {
    if (brandAvailabilityList.containsKey(countryName)) {
      return brandAvailabilityList[countryName];
    }
    var brands =
        await brandProvider.getBrandsAvailabilityByCountry(countryName);
    if (brands != null) {
      brandAvailabilityList[countryName] = brands;
      return brands;
    }
    return [];
  }

  Future<BrandModel?> getBrand(int? brandId, String? countryName) async {
    if (brandList.containsKey(brandId)) {
      return brandList[brandId];
    }
    var brand = await brandProvider.getBrand(brandId, countryName);
    if (brand != null) {
      brandList[brandId] = brand;
    }
    return brand;
  }

  Future<List<ProductItemModel>?> getProduct(String country) async {
    var brand = await brandProvider.getProducts(country);
    return brand;
  }

  Future<AddressItem?> getSampleRequestAddress(
      int selectedIndex) async {
    var addressData = await brandProvider.getSampleRequestAddress(selectedIndex);
    return addressData;
  }

  Future<List<StateItem>?> getCountryWiseState(int? countryId) async {
    var stateItem = await brandProvider.getCountryWiseState(countryId!);
    return stateItem;
  }

  Future<List<BrandAvailabilityModel>> getBrandsAvailability(
      {String? countryName, String? availability}) async {
    if (!brandAvailabilityList.containsKey(countryName)) {
      await this.getBrandsAvailabilityByCountry(countryName);
    }
    var availabilityList = brandAvailabilityList[countryName]!;
    return availabilityList
        .where((i) =>
            i.countryName == countryName && i.availabilityCode == availability)
        .toList();
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
    return brandProvider.requestProductSample(
        selectedIndex,
        productId,
        quantity,
        deliveryMethod,
        address1Street,
        address1Street2,
        address1City,
        address1StateId,
        address1CountryId,
        address1Zip);
  }
}

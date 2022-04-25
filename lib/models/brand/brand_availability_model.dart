class BrandAvailabilityModel {
  int? cacheId;
  int? id;
  int? brandId;
  String? brandName;
  String? availabilityCode;
  String? availability;
  String? countryName;
  String? thumbnailUrl;

  BrandAvailabilityModel({this.id, this.cacheId, this.brandId, this.brandName, this.availability, this.availabilityCode, this.countryName,this.thumbnailUrl});

  BrandAvailabilityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cacheId = json['cache_id'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
    availabilityCode = json['availabilityCode'];
    availability = json['availability'];
    countryName = json['country_name'];
    thumbnailUrl = json['thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    data['availability'] = this.availability;
    data['availability_code'] = this.availabilityCode;
    data['country_name'] = this.countryName;
    data['thumbnail_url'] = this.thumbnailUrl;
    return data;
  }
}

List<BrandAvailabilityModel> brandAvailability = <BrandAvailabilityModel>[
  BrandAvailabilityModel(id: 1, brandName: 'Atorcor', availability: 'Available', availabilityCode: 'a', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_1_thumbnail.png'),
  BrandAvailabilityModel(id: 1, brandName: 'Atorcor', availability: 'New Launches', availabilityCode: 'c', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_1_thumbnail.png'),
  BrandAvailabilityModel(id: 2, brandName: 'Ziquin', availability: 'Available', availabilityCode: 'a', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_2_thumbnail.png'),
  BrandAvailabilityModel(id: 2, brandName: 'Ziquin', availability: 'New Launches', availabilityCode: 'c', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_2_thumbnail.png'),
  BrandAvailabilityModel(id: 2, brandName: 'Irbea', availability: 'Available', availabilityCode: 'a', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_3_thumbnail.png'),
  BrandAvailabilityModel(id: 2, brandName: 'Irbea', availability: 'New Launches', availabilityCode: 'c', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_3_thumbnail.png'),
  BrandAvailabilityModel(id: 2, brandName: 'XFlox', availability: 'Available', availabilityCode: 'a', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_4_thumbnail.png'),
  BrandAvailabilityModel(id: 2, brandName: 'XFlox', availability: 'New Launches', availabilityCode: 'c', countryName: 'United Arab Emirates',thumbnailUrl: 'https://g3it.me/pa/brand_4_thumbnail.png'),
  BrandAvailabilityModel(id: 3, brandName: 'Atorcor Saudi', availability: 'Available', availabilityCode: 'a', countryName: 'Saudi Arabia',thumbnailUrl: 'https://g3it.me/pa/brand_1_thumbnail.png'),
];
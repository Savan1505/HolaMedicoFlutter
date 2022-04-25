import 'package:pharmaaccess/apis/db_provider.dart';
import 'package:pharmaaccess/models/profile_model.dart';

class ProfileService {
  final DBProvider dbProvider = DBProvider();

  Future<ProfileModel?> getProfile() async {
    return dbProvider.getProfile();
  }

  Future<bool> saveName(String saveName) async {
    return dbProvider.saveName(saveName);
  }

  Future<bool> saveEamil(String saveEamil) async {
    return dbProvider.saveEamil(saveEamil);
  }

  Future<bool> savePhoneNumber(String savePhoneNumber) async {
    return dbProvider.savePhoneNumber(savePhoneNumber);
  }

  Future<bool> saveCountry(String countryName) async {
    return dbProvider.saveCountry(countryName);
  }

  Future<bool> saveProfilePicture(String? base64Image, String title) async {
    return dbProvider.saveProfilePicture(base64Image, title);
  }

  Future<ProfileModel?> createProfile(ProfileModel profile) async {
    return dbProvider.createProfile(profile);
  }

  Future<bool> profileExist() async {
    return dbProvider.profileExist();
  }
}

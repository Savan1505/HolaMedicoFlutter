import 'package:dartz/dartz.dart';
import 'package:pharmaaccess/apis/auth_provider.dart';
import 'package:pharmaaccess/models/FailureModel.dart';
import 'package:pharmaaccess/models/profile_model.dart';
import 'package:pharmaaccess/odoo_api/odoo_user_response.dart';

class AuthService {
  final AuthProvider authProvider = AuthProvider();

  // static bool? activated;

  Future<OdooUser?> login(String username, String password) async {
    return authProvider.login(username, password);
  }

  Future<ProfileModel?> saveProfile(ProfileModel profile) async {
    return authProvider.saveProfile(profile);
  }

  Future<Either<FailureModel, ProfileModel?>> registerProfile(
      ProfileModel profile) async {
    return authProvider.registerProfile(profile);
  }

  Future<Either<FailureModel, ProfileModel>> updateProfile(
      ProfileModel profile) async {
    return authProvider.updateProfile(profile);
  }

  Future<bool> isRegistered() async {
    //TODO: get user profile from database if not found return false else return true
    return await authProvider.isRegistered();
  }

  Future<String?> registratoinData() async {
    //TODO: get user profile from database if not found return false else return true
    return authProvider.getResgistrationData();
  }

  Future<bool?> isActivated() async {
    try {
      //TODO: get user profile from database if not found return false else return true
      // if (activated == null) {
      return await authProvider.isActivated();
      // activated = a;
      // }
      // return activated;
    } catch (e) {
      return false;
    }
  }

  bool isLoggedIn() {
    //TODO: get user profile from database if not found return false else return true
    return authProvider.isLoggedIn();
  }

  Future<ProfileModel?> getProfile() async {
    return authProvider.getProfile();
  }

  /*Future<Map<String, dynamic>?> fetchProfile() async {
    return authProvider.fetchProfile();
  }*/
  Future<dynamic> fetchProfile() async {
    return authProvider.fetchProfile();
  }

  submitContactUs(String description) async {
    return authProvider.submitContactUs(description);
  }
}

class Config {
  //Production URL
  static const STORE = 'p';
  static const SERVER_ADDRESS = "https://portal.pharmaaccess.com";

  //Development URL
  // static const STORE = 'pi';
  // static const SERVER_ADDRESS = "https://pi.g3it.me";

  static const CONTENT_SERVER_ADDRESS = "https://content.pharmaaccess.com";

  //static const PRODUCT_PIC_BASE = "$SERVER_ADDRESS/static/pb/";
  //static const BRAND_PIC_BASE = "$SERVER_ADDRESS/static/pb/";
  //static const PROMO_BASE = "$SERVER_ADDRESS/static/pb/";
  //static const PRIVACY_POLICY = '$SERVER_ADDRESS/static/privacy_policy.html';
  //static const TERMS_CONDITIONS = '$SERVER_ADDRESS/static/terms_conditions.html';

  static const PRODUCT_PIC_BASE = "$CONTENT_SERVER_ADDRESS/static/pb/";
  static const BRAND_PIC_BASE = "$CONTENT_SERVER_ADDRESS/static/pb/";
  static const PROMO_BASE = "$CONTENT_SERVER_ADDRESS/static/pb/";
  static const PRIVACY_POLICY =
      "$CONTENT_SERVER_ADDRESS/static/privacy_policy.html";
  static const TERMS_CONDITIONS =
      "$CONTENT_SERVER_ADDRESS/static/terms_conditions.html";

  static bool isActivated = false;
  static bool isCinfaClub = false;

  static const String HUAWEI_LINK =
      "https://appgallery.huawei.com/#/app/C104181159";
}

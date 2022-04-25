const String VERY_COMMON = "Very Common";
const String COMMON = "Common";
const String UN_COMMON = "Uncommon";
const String RARE = "Rare";
const String VERY_RARE = "Very Rare";

const String FREQUENCY_NOT_KNOWN = "Frequency Not Known";

extension EnumExtensions on String {
  int get sortNumber {
    switch (this) {
      case VERY_COMMON:
        return 1;
      case COMMON:
        return 2;
      case UN_COMMON:
        return 3;
      case RARE:
        return 4;
      case VERY_RARE:
        return 5;
      case FREQUENCY_NOT_KNOWN:
        return 6;
      default:
        return 7;
    }
  }
}

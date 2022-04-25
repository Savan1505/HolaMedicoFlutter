class Country {
  const Country({
    this.countryCode,
    this.countryName,
    this.imageName,
    this.countryId,
  });

  final String? countryCode;
  final String? countryName;
  final String? imageName;
  final int? countryId;
}

const List<Country> countryList = <Country>[
  Country(
    countryCode: 'KWT',
    countryName: 'Kuwait',
    imageName: 'assets/images/kuwait_flag.png',
    countryId: 3,
  ),
  Country(
    countryCode: 'QAT',
    countryName: 'Qatar',
    imageName: 'assets/images/qatar_flag.png',
    countryId: 5,
  ),
  Country(
    countryCode: 'SAU',
    countryName: 'Saudi Arabia',
    imageName: 'assets/images/saudi_arabia_flag.png',
    countryId: 6,
  ),
  Country(
    countryCode: 'ARE',
    countryName: 'United Arab Emirates',
    imageName: 'assets/images/united_arab_emirates_flag.png',
    countryId: 1,
  ),
];

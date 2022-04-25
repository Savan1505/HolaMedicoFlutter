class EducationSupportService {
  final List<String> webinarCategoriesList = [
    'Preparation and Guidance for the MRCP PACES Exam',
    'The Best Practice in Management of Dyslipidemia',
  ];

  Future<List<String>> getEducationSupportWebinarCategories() async {
    return webinarCategoriesList;
  }
}

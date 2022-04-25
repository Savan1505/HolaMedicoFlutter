class ClinicalTrialModel {
  int? id;
  String? title;
  String? description;
  String? url;

  ClinicalTrialModel({this.id,this.title, this.description, this.url});

  ClinicalTrialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['name'] == false ? "" : json['name'];
    description = json['description'] == false ? "" : json["description"];
    url = json['study_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    return data;
  }
}


List<ClinicalTrialModel> clinicalTrialList = <ClinicalTrialModel>[
  ClinicalTrialModel(id: 1, title: 'Dose after stroke', description: "High-dose Atorvastatin After Stroke or Transient Ischemic Attack", url: 'https://pubmed.ncbi.nlm.nih.gov/16899775/'),
  ClinicalTrialModel(id: 2, title: 'Coronary Atherosclerosis', description: "Effect of Intensive Compared With Moderate Lipid-Lowering Therapy on Progression of Coronary Atherosclerosis: A Randomized Controlled Trial ", url: 'https://pubmed.ncbi.nlm.nih.gov/14996776/'),
];
class IndicationModel {
  int? brandId;
  String? indication;
  String? therapyArea;
  String? dosage;

  IndicationModel({this.brandId, this.indication, this.therapyArea, this.dosage});

  IndicationModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    indication = json['indication'];
    therapyArea = json['therapy_area'];
    dosage = json['dosage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_id'] = this.brandId;
    data['indication'] = this.indication;
    data['therapy_area'] = this.therapyArea;
    data['dosage'] = this.dosage;
    return data;
  }
}


List<IndicationModel> indicationList = <IndicationModel>[
  IndicationModel(indication: 'Hypercholesterolaemia', dosage: "Lead to markedly increased concentrations of atorvastatin. (e.g. ciclosporin, telithromycin, clarithromycin, delavirdine, stiripentol, voriconazole, itraconazole, ketoconazole, posaconazole, some antivirals used in the treatment of HCV (e.g. elbasvir/grazoprevir) and HIV protease inhibitors including ritonavir, lopinavir, atazanavir, indinavir, darunavir, etc.) should be avoided if possible."),
  IndicationModel(indication: 'Prevention of Cardiovascular Disease', dosage: "The dose should be individualized according to baseline LDL-C levels, the goal of therapy, and patient response.\r\nThe usual starting dose is 10mg once a day. Adjustment at intervals of 4 weeks or more. The maximum dose is 80mg once a day.", ),
];
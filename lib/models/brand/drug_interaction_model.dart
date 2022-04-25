class DrugInteractionModel {
  String? molecule;
  String? description;
  String? interactionType;

  DrugInteractionModel({this.molecule, this.description, this.interactionType});

  DrugInteractionModel.fromJson(Map<String, dynamic> json) {
    molecule = json['molecule'];
    description = json['description'];
    interactionType = json['interaction_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['molecule'] = this.molecule;
    data['description'] = this.description;
    data['interaction_type'] = this.interactionType;
    return data;
  }
}

List<DrugInteractionModel> drugInteractionList = <DrugInteractionModel>[
  DrugInteractionModel(molecule: 'Cyp3A4 Inhibitor', description: "Lead to markedly increased concentrations of atorvastatin. (e.g. ciclosporin, telithromycin, clarithromycin, delavirdine, stiripentol, voriconazole, itraconazole, ketoconazole, posaconazole, some antivirals used in the treatment of HCV (e.g. elbasvir/grazoprevir) and HIV protease inhibitors including ritonavir, lopinavir, atazanavir, indinavir, darunavir, etc.) should be avoided if possible."),
  DrugInteractionModel(molecule: 'Cyp4A3 Inducers', description: "Lead to variable reductions in plasma concentrations of atorvastatin. (e.g. efavirenz, rifampin, St John's wort) ", ),
];
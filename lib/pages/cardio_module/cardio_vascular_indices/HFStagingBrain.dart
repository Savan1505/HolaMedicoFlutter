import 'CardioVascularBrain.dart';

class HFStagingBrain {
  HFStagingBrain();

  List<HGStagingResultModel> hfStagingResult = [
    HGStagingResultModel(
        description:
            "Patient does not have substantial risk of HF based on ACC/AHA staging guidelines."),
    HGStagingResultModel(
        title: "Stage: A",
        description:
            "At high risk for heart failure without structural heart disease or symptoms of HF.",
        considerations: [
          "Treat hypertension",
          "Encourage smoking cessation",
          "Treat lipid disorders",
          "Encourage regular exercise",
          "Discourage alcohol intake/illicit drug use",
          "ACE inhibitors in appropriate patients"
        ]),
    HGStagingResultModel(
        title: "Stage: B",
        description: "Structural heart disease without symptoms of HF.",
        considerations: [
          "All measures under stage A",
          "ACE inhibitors in appropriate patients",
          "Beta-blockers in appropriate patients",
        ]),
    HGStagingResultModel(
        title: "Stage: C",
        description:
            "Structural heart disease with prior or current symptoms of HF.",
        considerations: [
          "All measures under stage A",
          "Diuretics, ACE inhibitors, beta-blockers, or digitalis for routine use",
          "Dietary salt restriction",
        ]),
    HGStagingResultModel(
        title: "Stage: D",
        description: "Refractory HF requiring specialized interventions.",
        considerations: [
          "All measures under stage A, B and C",
          "Mechanical assist devices",
          "Heart transplantation",
          "Continuous IV inotropic infusions for palliation",
          "Hospice care",
        ]),
  ];

  List<CardioVascularModel> listCardio = [
    CardioVascularModel(
        title: "Patient with family history of cardiomyopathy",
        listOptions: [
          CardioVascularOptions(title: yes, point: 1, index: 11),
          CardioVascularOptions(title: no, point: 0, index: 12),
        ]),
    CardioVascularModel(title: "Patient using cardiotoxins", listOptions: [
      CardioVascularOptions(title: yes, point: 1, index: 21),
      CardioVascularOptions(title: no, point: 0, index: 22),
    ]),
    CardioVascularModel(
        title:
            "Patient with history of hypertension, coronary artery disease, OR diabetes",
        listOptions: [
          CardioVascularOptions(title: yes, point: 1, index: 31),
          CardioVascularOptions(title: no, point: 0, index: 32),
        ]),
    CardioVascularModel(
        title:
            "Patient with previous MI, LV systolic dysfunction, or asymptomatic valvular disease",
        listOptions: [
          CardioVascularOptions(title: yes, point: 1, index: 41),
          CardioVascularOptions(title: no, point: 0, index: 42),
        ]),
    CardioVascularModel(
        title:
            "Patient with known structural heart disease, shortness of breath and fatigue (reduced exercise tolerance)",
        listOptions: [
          CardioVascularOptions(title: yes, point: 1, index: 51),
          CardioVascularOptions(title: no, point: 0, index: 52),
        ]),
    CardioVascularModel(
        title:
            "Patient with marked heart failure symptoms at rest, despite maximum therapy (Those who are recurrently hospitalized or cannot be safely discharged from the hospital without specialized interventions)",
        listOptions: [
          CardioVascularOptions(title: yes, point: 1, index: 61),
          CardioVascularOptions(title: no, point: 0, index: 62),
        ])
  ];
}

class HGStagingResultModel {
  final String? title, description;

  final List<String>? considerations;

  HGStagingResultModel({this.title, this.description, this.considerations});
}

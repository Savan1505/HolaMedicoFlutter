import 'dart:io';

import 'package:share/share.dart';

const MALE_Gender = 1;
const FEMALE_Gender = 0;
const BOY_Gender = 3;
const GIRL_Gender = 4;
const BMI = 1;
const LBM = 2;
const BODY_FAT = 3;
const BASAL_METABOLIC_RATE = 4;
const CALORIE_CALCULATOR = 5;

const MG_L = 0;
const MG_DL = 1;
const UM_OL_L = 2;

const G_DL = 1;
const G_L = 2;
const CHADCS2 = 1;
const CHADCS2_VASC = 2;
const HAS_BLED_SCORE = 3;
const CVD_MORTALITY_RISK = 4;
const DASH_SCORE = 5;
const COLESTROL = 1;
const TRIGYLCYRIDES = 2;

const TITLE_MALE = "Male";
const TITLE_FEMALE = "Female";

const TITLE_A_MALE = "Adult Male";
const TITLE_A_FEMALE = "Adult Female";
const TITLE_GIRL = "Girl (<18 yrs)";
const TITLE_BOY = "Boy (<18 yrs)";
const TITLE_CREATININE = "Creatinine Clearance (CrCl)";

const TITLE_CARDIO_VASCULAR_INDICES = "Cardiovascular Indices ";
const TITLE_CHADSC2 = "CHADS\u2082 Score";
const TITLE_CHADSC2_CLEAR = "CHADSC_2 Score";
const TITLE_HAS_BLED_SCORE = "HAS-BLED  Score";
const TITLE_CHADSC2_VASC = "CHA\u2082DS\u2082-VASc Score";
const TITLE_CHADSC2_VASC_CLEAR = "CHADSC_2-VASc Score";
const TITLE_CVD_MORTALITY_RISK = "CVD Mortality Risk";
const TITLE_HG_STAGING = "ACC/AHA Heart Failure Staging";
const TITLE_DASH_SCORE = "DASH Score";
const TITLE_LIPID_UNIT_CONVERSION = "Lipid Unit Conversion";

const TITLE_COLESTROL = "Cholesterol";
const TITLE_TRIGYLCERIDES = "Triglycerides";

const TITLE_BMI = "BMI";
const TITLE_LEAN_BODY_MASS = "Lean Body Mass";
const TITLE_BODY_FAT_PER = "Body Fat %";
const TITLE_BASAL_META_RATE = "Basal Metabolic Rate";
const TITLE_CALORIE_CALCULATOR = "Calorie Calculator";
const TITLE_DIABETES_RISK_ASSESSMENT = "Diabetes Risk Assessment";

const TITLE_ORTHOPAEDIC_INDICES = "Orthopaedic Indices";
const TITLE_ACR_EULAR_RHEUMATOID_ARTHRITIS_CLASSIFICATION =
    "ACR/EULAR Rheumatoid Arthritis Classification";
const TITLE_ACR_EULAR_GOUT_CLASSIFICATION = "ACR/EULAR Gout Classification";
const TITLE_ANKYLOSING_DISEASE_WITH_CRP =
    "Ankylosing Spondylitis Disease Activity with CRP";
const TITLE_ANKYLOSING_DISEASE_WITH_ESR =
    "Ankylosing Spondylitis Disease Activity with ESR";
const TITLE_NEUROPATHIC_PAIN_DN4_QUESTIONNAIRE =
    "Neuropathic pain DN4 questionnaire";

const TITLE_YES = "Yes";
const TITLE_NO = "No";

const TITLE_CHILD_PUGH = "Child Pugh Score";
const TITLE_CREATININE_MG_DL = "Serum Creatinine \n(mg/dl)";
const TITLE_MGL = "(mg/L)";
const TITLE_MGDL = "(mg/dl)";
const TITLE_UMOL = "(µmol/L)";

const TITLE_MMOL = "(mmol/L)";
const TITLE_GDL = "(g/dL)";
const TITLE_GL = "(g/L)";

const TITLE_CREATININE_UMOL_L = "Serum Creatinine \n(µmol/L)";
const TITLE_SERUM_BILIRUBIN = "Serum bilirubin";
const TITLE_ALBUMIN = "Serum albumin";
const TITLE_INR = "INR";
const TITLE_ASCITES = "Ascites";
const TITLE_HEPATIC_ENCEPHALOPATHY = "Hepatic Encephalopathy";
const TITLE_ABSENT = "absent";
const TITLE_SLIGHT = "slight";
const TITLE_MODERATE = "moderate";

const TITLE_SELECT_ALL_OPTIONS = "Please select an answer first.";
String buttonTitle = "CALCULATE";

// Future<void> shareOption(String filePath, String text) {
//   return Share.shareFiles([filePath], text: text);
//
// }
Future<void> shareOption(String filePath, String text) {
  return Platform.isIOS
      ? Share.shareFiles(
          [filePath],
        )
      : Share.shareFiles([filePath], text: text);
}

const String BMI_REFER_LINK =
    "https://www.nhlbi.nih.gov/health/educational/lose_wt/BMI/bmi-m.htm";
const String LEAN_BODY_MASS_REFER_LINK =
    "https://www.calculator.net/lean-body-mass-calculator.html";
const String BODY_FAT_PER_REFER_LINK =
    "https://www.calculator.net/body-fat-calculator.html";
const String CALORIE_CALC_REFER_LINK =
    "https://www.calculator.net/calorie-calculator.html";
const String BASAL_META_RATE_REFER_LINK =
    "https://www.calculator.net/bmr-calculator.html";
const String DIABETES_RISK_ASSESSMENT_REFER_LINK =
    "https://www.diabetes.fi/files/502/eRiskitestilomake.pdf";
const String CHADS2_SCORE_REFER_LINK =
    "https://www.mdcalc.com/chads2-score-atrial-fibrillation-stroke-risk";
const String CHA2DS2_VASC_SCORE_REFER_LINK =
    "https://www.mdcalc.com/cha2ds2-vasc-score-atrial-fibrillation-stroke-risk";
const String HAS_BLED_REFER_LINK =
    "https://www.mdcalc.com/has-bled-score-major-bleeding-risk";
const String ACC_HF_STAGING_REFER_LINK =
    "https://www.mdcalc.com/acc-aha-heart-failure-staging";
const String DASH_SCORE_REFER_LINK =
    "https://www.mdcalc.com/dash-prediction-score-recurrent-vte";
const String CVD_MORTALITY_RISK_SCORE_REFER_LINK =
    "https://academic.oup.com/eurheartj/article/41/1/111/5556353";
const String LIPID_UNIT_CONVER_REFER_LINK =
    "https://www.omnicalculator.com/health/cholesterol-units";
const String CREATININE_REFER_LINK =
    "https://www.mdcalc.com/creatinine-clearance-cockcroft-gault-equation";
const String CHILD_PUGH_SCORE_REFER_LINK =
    "https://www.mdcalc.com/child-pugh-score-cirrhosis-mortality";
const String RHEUMATOID_ARTHRITIS_REFER_LINK =
    "https://www.mdcalc.com/acr-eular-2010-rheumatoid-arthritis-classification-criteria";
const String GOUT_CLASSIFICATION_REFER_LINK =
    "https://www.mdcalc.com/acr-eular-gout-classification-criteria";
const String INTERNAL_SERVER_ERROR = "Internal Server Error!!!";

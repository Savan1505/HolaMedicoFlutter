import "package:collection/collection.dart";
import 'package:pharmaaccess/models/SideEffectsModel.dart';
import 'package:pharmaaccess/models/brand/product_model.dart';

import 'clinical_trial_model.dart';
import 'drug_interaction_model.dart';
import 'indication_model.dart';

class BrandModel {
  BrandModel({
    this.id,
    this.cacheId,
    this.name,
    this.thumbnailUrl,
    this.videoUrl,
    this.indications,
    this.drugInteractions,
    this.clinicalTrials,
    this.products,
    this.promoAvailable,
    this.slideshowAvailable,
    this.scoreCategoryId,
  });

  int? id;
  int? cacheId;
  String? name;
  String? thumbnailUrl;
  String? videoUrl;
  bool? promoAvailable = false;
  bool? slideshowAvailable = false;
  List<IndicationModel>? indications;
  List<DrugInteractionModel>? drugInteractions;
  List<ClinicalTrialModel>? clinicalTrials;
  List<SideEffectsModel>? sideEffects;
  List<ProductModel>? products;
  List<List<SideEffectsModel>>? groupedSideEffects;
  int? scoreCategoryId;

  BrandModel.fromJson(Map<String, dynamic> jsonModel) {
    id = jsonModel['id'];
    cacheId = jsonModel['cache_id'];
    name = jsonModel['name'];
    thumbnailUrl = jsonModel['thumbnail_url'];
    videoUrl = jsonModel['video_url'];
    slideshowAvailable = jsonModel['slideshow_available'] ?? false;
    promoAvailable = jsonModel['promo_available'] ?? false;

    clinicalTrials =
        jsonModel['clinical_trials'].map<ClinicalTrialModel>((json) {
      return ClinicalTrialModel.fromJson(json);
    }).toList();
    sideEffects = jsonModel['side_effects'].map<SideEffectsModel>((json) {
      return SideEffectsModel.fromJson(json);
    }).toList();
    sideEffects!.sort((a, b) => a.sequence.compareTo(b.sequence));
    drugInteractions =
        jsonModel['drug_interactions'].map<DrugInteractionModel>((json) {
      return DrugInteractionModel.fromJson(json);
    }).toList();
    indications = jsonModel['prescriptions'].map<IndicationModel>((json) {
      return IndicationModel.fromJson(json);
    }).toList();

    products = jsonModel['products'].map<ProductModel>((json) {
      return ProductModel.fromJson(json);
    }).toList();

    groupedSideEffects =
        groupBy(sideEffects!, (SideEffectsModel obj) => obj.occurrence)
            .values
            .toList();
    scoreCategoryId = jsonModel['score_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cache_id'] = this.cacheId;
    data['name'] = this.name;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['slideshow_available'] = this.slideshowAvailable;
    data['promo_available'] = this.promoAvailable;
    data['scoreCategoryId'] = this.scoreCategoryId;
    return data;
  }
}

List<BrandModel> brandsList = <BrandModel>[
  BrandModel(
      id: 1,
      name: 'Atorcor',
      thumbnailUrl: 'https://g3it.me/pa/brand_1_thumbnail.png'),
  BrandModel(
      id: 2,
      name: 'Ziquin',
      thumbnailUrl: 'https://g3it.me/pa/brand_2_thumbnail.png'),
  BrandModel(
      id: 2,
      name: 'Irbea',
      thumbnailUrl: 'https://g3it.me/pa/brand_3_thumbnail.png'),
  BrandModel(
      id: 2,
      name: 'XFlox',
      thumbnailUrl: 'https://g3it.me/pa/brand_4_thumbnail.png'),
];

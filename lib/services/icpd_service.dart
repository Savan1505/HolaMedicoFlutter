import 'package:pharmaaccess/apis/icpd_provider.dart';
import 'package:pharmaaccess/models/MyIcpdACRequest.dart';
import 'package:pharmaaccess/models/MyIcpdCreateActivityRequest.dart';
import 'package:pharmaaccess/models/MyIcpdPaticipateRequest.dart';
import 'package:pharmaaccess/models/MyIcpdRecommendActivityRequest.dart';
import 'package:pharmaaccess/models/MyIcpdTargetRequest.dart';
import 'package:pharmaaccess/models/MyIcpdUpdateACRequest.dart';
import 'package:pharmaaccess/models/MyIcpdUpdateActivityRequest.dart';
import 'package:pharmaaccess/models/MyIcpdUpdateTargetRequest.dart';
import 'package:pharmaaccess/models/icpd_activity_attachment_model.dart';
import 'package:pharmaaccess/models/icpd_activity_resp_model.dart';
import 'package:pharmaaccess/models/icpd_catalog_resp_model.dart';
import 'package:pharmaaccess/models/icpd_cme_plan_model.dart';
import 'package:pharmaaccess/models/icpd_common_model.dart';
import 'package:pharmaaccess/models/icpd_event_category_model.dart';

class IcpdService {
  final IcpdProvider icpdProvider = IcpdProvider();
  static List<EventCategory>? alEventCategoryList = [];
  static List<EventAttachment>? alAttachmentItemList = [];
  static List<PlanList>? alPlanList = [];
  static List<PlanList>? alPreviousPlanList = [];
  static List<CatalogList>? alCatalogList = [];
  static List<ActivityListItem>? alActivityList = [];
  static List<ActivityListItem>? alActivityCompleteList = [];
  static IcpdActivityRespModel? icpdActivityRespModel;

  //Get All Event Category Type List
  Future<List<EventCategory>?> getCMEEventCategoryList() async {
    alEventCategoryList = await icpdProvider.getCMEEventCategoryList();
    return alEventCategoryList;
  }

  //Get All Event item has attachment certificate
  Future<List<EventAttachment>?> getCMEEventAttachmentCertificateList(
      int eventActId) async {
    alAttachmentItemList =
        await icpdProvider.getCMEEventAttachmentCertificateList(eventActId);
    return alAttachmentItemList;
  }

  //Get Plan List
  Future<List<PlanList>?> getCMEPlanList() async {
    alPlanList = await icpdProvider.getCMEPlanList();
    return alPlanList;
  }

  //Archive Plan
  Future<CommonResultMessage?> archiveCurrentPlan(int planId) async {
    return icpdProvider.archiveCurrentPlan(planId);
  }

  //Get Previous Plan List
  Future<List<PlanList>?> getPreviousPlanList() async {
    alPreviousPlanList = await icpdProvider.getPreviousPlanList();
    return alPreviousPlanList;
  }

  //Create Plan
  Future<CommonResultMessage?> createMyPlanIcpdTarget(
      MyIcpdTargetRequest myIcpdTargetRequest,
      MyIcpdACRequest myIcpdACRequest) async {
    return icpdProvider.createMyPlanIcpdTarget(
        myIcpdTargetRequest, myIcpdACRequest);
  }

  //Update Plan
  Future<CommonResultMessage?> updateMyPlanIcpdTarget(
      MyIcpdUpdateTargetRequest myIcpdUpdateTargetRequest,
      MyIcpdUpdateACRequest myIcpdUpdateACRequest) async {
    return icpdProvider.updateMyPlanIcpdTarget(
        myIcpdUpdateTargetRequest, myIcpdUpdateACRequest);
  }

  //Catalog List
  Future<List<CatalogList>?> getCMECatalogList() async {
    alCatalogList = await icpdProvider.getCMECatalogList();
    return alCatalogList;
  }

  //Create Recommend Activity
  Future<CommonResultMessage?> createRecommendActivity(
      MyIcpdRecommendActivityRequest myIcpdRecommendActivityRequest) async {
    return icpdProvider.createRecommendActivity(myIcpdRecommendActivityRequest);
  }

  //Add Catalog event and Plan Using Participate
  Future<CommonResultMessage?> addCatalogEventPlanParticipate(
      MyIcpdPaticipateRequest myIcpdParticipateRequest) async {
    return icpdProvider
        .addCatalogEventPlanParticipate(myIcpdParticipateRequest);
  }

  //Sponsor Me Request
  Future<CommonResultMessage?> sponsorMeRequestEvent(String activityId) async {
    return icpdProvider.sponsorMeRequestEvent(activityId);
  }

  //Get My Activities
  Future<List<ActivityListItem>?> getMyActivityList(int planId) async {
    alActivityList = await icpdProvider.getMyActivityList(planId);
    return alActivityList;
  }

  Future<List<ActivityListItem>?> getMyActivityCompleteList() async {
    alActivityCompleteList = [];
    if (alActivityList != null &&
        alActivityList!.isNotEmpty &&
        alActivityList!.length > 0) {
      for (ActivityListItem activityListItem in alActivityList!) {
        if (activityListItem.state != "draft") {
          alActivityCompleteList!.add(activityListItem);
        }
      }
    }
    return alActivityCompleteList;
  }

  //Create My Activity
  Future<CommonResultMessage?> createMyActivity(
      MyIcpdCreateActivityRequest myIcpdCreateActivityRequest) async {
    return icpdProvider.createMyActivity(myIcpdCreateActivityRequest);
  }

  //Update My Activity
  Future<CommonResultMessage?> updateMyActivity(
      MyIcpdUpdateActivityRequest myIcpdUpdateActivityRequest) async {
    return icpdProvider.updateMyActivity(myIcpdUpdateActivityRequest);
  }

  //Update Mark As Complete My Activity
  Future<CommonResultMessage?> updateMarkAsCompleteMyActivity(
      int activityId) async {
    return icpdProvider.updateMarkAsCompleteMyActivity(activityId);
  }

  //Create My Activity in attachment
  Future<CommonResultMessage?> createMyActivityAttachment(
      int eventId, String base64Attachment) async {
    return icpdProvider.createMyActivityAttachment(eventId, base64Attachment);
  }

  //Delete My Activity
  Future<CommonResultMessage?> deleteMyActivity(int activityId) async {
    return icpdProvider.deleteMyActivity(activityId);
  }
}

import 'dart:convert';
import 'package:pharmaaccess/apis/auth_provider.dart';
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
import 'package:pharmaaccess/odoo_api/odoo_api_connector.dart';

class IcpdProvider {
  final AuthProvider apiProvider = AuthProvider();

  Future<List<EventCategory>?> getCMEEventCategoryList() async {
    try {
      var response = await apiProvider.client.callControllerICPD(
        "/app/v4/cpd/event_category",
        {},
      );
      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return [];
        }
        var eventCategoryResponseList = result.map<EventCategory>((json) {
          return EventCategory.fromJson(json);
        }).toList();

        if (eventCategoryResponseList != null &&
            eventCategoryResponseList.isNotEmpty) {
          return eventCategoryResponseList;
        } else {
          return [];
          // return throwErrorICPD(response);
        }
      } else {
        return [];
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return [];
      // return throwErrorString(e.toString());
    }
  }

  Future<List<EventAttachment>?> getCMEEventAttachmentCertificateList(
      int eventActId) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity/attachment/get",
        {"id": eventActId},
      );
      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return [];
        }
        var eventAttachmentResponseList = result.map<EventAttachment>((json) {
          return EventAttachment.fromJson(json);
        }).toList();

        if (eventAttachmentResponseList != null &&
            eventAttachmentResponseList.isNotEmpty) {
          return eventAttachmentResponseList;
        } else {
          return [];
          // return throwErrorICPD(response);
        }
      } else {
        return [];
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return [];
      // return throwErrorString(e.toString());
    }
  }

  Future<List<PlanList>?> getCMEPlanList() async {
    try {
      var response = await apiProvider.client.callControllerICPD(
        "/app/v4/cpd/partner/plan",
        {},
      );
      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return [];
        }
        var planResponseList = result.map<PlanList>((json) {
          return PlanList.fromJson(json);
        }).toList();

        if (planResponseList != null && planResponseList.isNotEmpty) {
          return planResponseList;
        } else {
          return [];
          // return throwErrorICPD(response);
        }
      } else {
        return [];
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return [];
      // return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> archiveCurrentPlan(int planId) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/partner/plan/archive",
        {"plan_id": planId},
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<List<PlanList>?> getPreviousPlanList() async {
    try {
      var response = await apiProvider.client.callControllerICPD(
        "/app/v4/cpd/partner/plan/archived",
        {},
      );
      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return [];
        }
        var planResponseList = result.map<PlanList>((json) {
          return PlanList.fromJson(json);
        }).toList();

        if (planResponseList != null && planResponseList.isNotEmpty) {
          return planResponseList;
        } else {
          return [];
          // return throwErrorICPD(response);
        }
      } else {
        return [];
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return [];
      // return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> createMyPlanIcpdTarget(
      MyIcpdTargetRequest myIcpdTargetRequest,
      MyIcpdACRequest myIcpdACRequest) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/partner/plan/create",
        myIcpdTargetRequest.toJson().values.first.toString().isNotEmpty &&
                myIcpdTargetRequest.toJson().values.first != null
            ? myIcpdTargetRequest.toJson()
            : myIcpdACRequest.toJson(),
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> updateMyPlanIcpdTarget(
      MyIcpdUpdateTargetRequest myIcpdUpdateTargetRequest,
      MyIcpdUpdateACRequest myIcpdUpdateACRequest) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/partner/plan/update",
        myIcpdUpdateTargetRequest.toJson().values.first.toString().isNotEmpty &&
                myIcpdUpdateTargetRequest.toJson().values.first != null
            ? myIcpdUpdateTargetRequest.toJson()
            : myIcpdUpdateACRequest.toJson(),
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<List<CatalogList>?> getCMECatalogList() async {
    try {
      var response = await apiProvider.client.callControllerICPD(
        "/app/v4/cpd/catalog",
        {},
      );

      if (response.hasError()) {
        var result = response.getData();
        if (result == null) {
          // throwErrorICPD(response);
          return [];
        }
        var catalogResponseList = result.map<CatalogList>((json) {
          return CatalogList.fromJson(json);
        }).toList();
        if (catalogResponseList != null && catalogResponseList.isNotEmpty) {
          return catalogResponseList;
        } else {
          return [];
          // return throwErrorICPD(response);
        }
      } else {
        return [];
        // return throwErrorICPD(response);
      }
    } catch (e) {
      return [];
      // return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> createRecommendActivity(
      MyIcpdRecommendActivityRequest myIcpdRecommendActivityRequest) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/catalog/recommend",
        myIcpdRecommendActivityRequest.toJson(),
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> addCatalogEventPlanParticipate(
      MyIcpdPaticipateRequest myIcpdParticipateRequest) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/catalog/participate",
        myIcpdParticipateRequest.toJson(),
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> sponsorMeRequestEvent(String activityId) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/catalog/sponsorship/request",
        {"activity_id": activityId},
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<List<ActivityListItem>?> getMyActivityList(int planId) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity",
        {"plan_id": planId, "domain": []},
      );

      if (response.hasError()) {
        var result = response.getData();
        if (result.toString().isEmpty) {
          // throwErrorICPD(response);
          return [];
        }

        var activityResponseList = result.map<ActivityListItem>((json) {
          return ActivityListItem.fromJson(json);
        }).toList();
        if (activityResponseList != null && activityResponseList.isNotEmpty) {
          return activityResponseList;
        } else {
          // return throwErrorICPD(response);
          return [];
        }
      } else {
        // return throwErrorICPD(response);
        return [];
      }
    } catch (e) {
      // return throwErrorString(e.toString());
      return [];
    }
  }

  Future<CommonResultMessage?> createMyActivity(
      MyIcpdCreateActivityRequest myIcpdCreateActivityRequest) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity/create",
        myIcpdCreateActivityRequest.toJson(),
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> updateMyActivity(
      MyIcpdUpdateActivityRequest myIcpdUpdateActivityRequest) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity/update",
        myIcpdUpdateActivityRequest.toJson(),
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> updateMarkAsCompleteMyActivity(
      int activityId) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity/completed",
        {"activity_id": activityId},
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> createMyActivityAttachment(
      int eventId, String base64Attachment) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity/attachment/attach",
        {"id": eventId, "event_attachment_id": base64Attachment},
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }

  Future<CommonResultMessage?> deleteMyActivity(int activityId) async {
    try {
      var response = await apiProvider.client.callControllerICPDBackSlash(
        "/app/v4/cpd/activity/remove",
        {"activity_id": activityId},
      );

      if (response.hasError()) {
        var result = response.getResult();
        if (result == null) {
          return throwErrorICPD(response);
        }
        return CommonResultMessage.fromJson(result);
      } else {
        return throwErrorICPD(response);
      }
    } catch (e) {
      return throwErrorString(e.toString());
    }
  }
}

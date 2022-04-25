class MyIcpdPaticipateRequest {
  int? planId;
  int? eventId;

  MyIcpdPaticipateRequest({
    this.planId,
    this.eventId,
  });

  MyIcpdPaticipateRequest.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    eventId = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['event_id'] = this.eventId;
    return data;
  }
}

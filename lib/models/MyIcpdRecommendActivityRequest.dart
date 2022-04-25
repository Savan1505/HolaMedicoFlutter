class MyIcpdRecommendActivityRequest {
  String? name;
  String? description;
  String? start;
  String? stop;
  String? venue;
  String? organizerUrl;
  int? eventCategoryId;

  MyIcpdRecommendActivityRequest({
    this.name,
    this.description,
    this.start,
    this.stop,
    this.venue,
    this.organizerUrl,
    this.eventCategoryId,
  });

  MyIcpdRecommendActivityRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    start = json['start'];
    stop = json['stop'];
    venue = json['location'];
    organizerUrl = json['organizer_url'];
    eventCategoryId = json['event_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['start'] = this.start;
    data['stop'] = this.stop;
    data['location'] = this.venue;
    data['organizer_url'] = this.organizerUrl;
    data['event_category_id'] = this.eventCategoryId;
    return data;
  }
}

class NewsData {
  List<NewsModel>? newsModel;
  int total;

  NewsData(
    this.newsModel,
    this.total,
  );
}

class NewsModel {
  NewsModel(
      {this.newsId,
      this.title,
      this.summary,
      this.imageUrl,
      this.thumbnailUrl,
      this.externalUrl,
      this.category,
      this.publishDate});

  int? newsId;
  String? title;
  String? summary;
  String? imageUrl;
  String? thumbnailUrl;
  String? externalUrl;
  String? category;
  DateTime? publishDate;

  NewsModel.fromJson(Map<String, dynamic> json) {
    newsId = json['id'];
    title = json['name'];
    summary = json['body'];
    imageUrl =
        json['banner_url'] == null || json['banner_url'].runtimeType == bool
            ? ""
            : json['banner_url'];
    thumbnailUrl =
        json['banner_url'] == null || json['banner_url'].runtimeType == bool
            ? ""
            : json['banner_url'];
    externalUrl = json['url'];
    category = json['category'];
    publishDate = DateTime.parse(json['publish_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.newsId;
    data['name'] = this.title;
    data['body'] = this.summary;
    data['banner_url'] = this.imageUrl;
    data['banner_url'] = this.thumbnailUrl;
    data['externalUrl'] = this.externalUrl;
    data['category'] = this.category;
    data['publish_date'] = this.publishDate!.toIso8601String();
    return data;
  }
}

List<NewsModel> newsList = <NewsModel>[
  NewsModel(
    title: 'COVID-9 things will not go normal until a vaccine is found.',
    summary: 'Again put some summary text here',
    thumbnailUrl:
        'https://imagevars.gulfnews.com/2020/04/26/200426-syrian-dancer_171b53a0995_small.jpg',
    externalUrl: 'https://youtube.com',
    category: "Virology",
  ),
  NewsModel(
      title: 'Dubai shops shut down for lax precautionary measures',
      summary: 'some summary text here.',
      thumbnailUrl:
          'https://imagevars.gulfnews.com/2019/01/04/NAT-190102-GUBAIBA2-(Read-Only)_resources1_16a3106a819_thumbnail.jpg',
      externalUrl: 'https://g3it.me',
      category: "GP."),
  NewsModel(
    title: 'Group Three will launch 3D Geo-Mapping app.',
    summary: 'Again put some summary text here',
    thumbnailUrl:
        'https://imagevars.gulfnews.com/2020/04/26/200426-syrian-dancer_171b53a0995_small.jpg',
    externalUrl: 'https://g3it.me',
    category: "Internal Medicine",
  ),
];
